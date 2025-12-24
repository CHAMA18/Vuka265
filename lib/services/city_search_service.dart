import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Lightweight city search.
///
/// Uses Photon (https://photon.komoot.io) on web to avoid CORS issues and
/// falls back to OpenStreetMap Nominatim elsewhere.
class CitySuggestion {
  final String label; // e.g., "New York, United States"
  final String? city;
  final String? state;
  final String? country;
  final double lat;
  final double lon;

  CitySuggestion({
    required this.label,
    required this.lat,
    required this.lon,
    this.city,
    this.state,
    this.country,
  });
}

class CitySearchService {
  static const _nominatim = 'https://nominatim.openstreetmap.org/search';
  static const _photon = 'https://photon.komoot.io/api/';

  /// Searches cities worldwide by text query.
  /// Returns up to [limit] results, filtered to city-like places.
  static Future<List<CitySuggestion>> searchCities(
    String query, {
    int limit = 10,
    String language = 'en',
  }) async {
    if (query.trim().isEmpty) return [];

    // Prefer Photon on web to avoid CORS headaches. Fall back to Nominatim
    // when Photon fails or when not on web.
    if (kIsWeb) {
      try {
        final results = await _searchPhoton(query, limit: limit, language: language);
        if (results.isNotEmpty) return results;
      } catch (e) {
        debugPrint('Photon search failed: $e');
      }
    }

    try {
      return await _searchNominatim(query, limit: limit, language: language);
    } catch (e) {
      debugPrint('Nominatim search failed: $e');
      return [];
    }
  }

  static Future<List<CitySuggestion>> _searchPhoton(
    String query, {
    required int limit,
    required String language,
  }) async {
    final uri = Uri.parse(_photon).replace(queryParameters: {
      'q': query,
      'lang': language,
      'limit': '$limit',
    });

    final resp = await http.get(
      uri,
      headers: const {
        'Accept': 'application/json',
      },
    );
    if (resp.statusCode != 200) {
      debugPrint('Photon HTTP ${resp.statusCode}');
      return [];
    }
    final data = json.decode(resp.body);
    if (data is! Map) return [];
    final features = data['features'];
    if (features is! List) return [];

    const allowedTypes = {
      'city',
      'town',
      'village',
      'hamlet',
      'suburb',
      'municipality',
      'locality',
    };

    return features
        .where((e) => e is Map)
        .cast<Map>()
        .map((f) {
          final props = (f['properties'] as Map?) ?? {};
          final geom = (f['geometry'] as Map?) ?? {};
          final coords = (geom['coordinates'] as List?)?.cast<num>();
          final lon = (coords != null && coords.length >= 2) ? coords[0].toDouble() : 0.0;
          final lat = (coords != null && coords.length >= 2) ? coords[1].toDouble() : 0.0;

          final type = (props['type']?.toString() ?? '').toLowerCase();
          final osmValue = (props['osm_value']?.toString() ?? '').toLowerCase();
          final candidateType = type.isNotEmpty ? type : osmValue;

          final city = (props['city'] ?? props['name'])?.toString();
          final state = props['state']?.toString();
          final country = props['country']?.toString();
          final name = props['name']?.toString() ?? city ?? '';
          final parts = [
            name,
            if (state != null && state.isNotEmpty) state,
            if (country != null && country.isNotEmpty) country,
          ];
          final label = parts.whereType<String>().where((p) => p.isNotEmpty).join(', ');

          return {
            'allowed': allowedTypes.contains(candidateType),
            'suggestion': CitySuggestion(
              label: label.isEmpty ? (props['name']?.toString() ?? '') : label,
              city: city,
              state: state,
              country: country,
              lat: lat,
              lon: lon,
            ),
          };
        })
        .where((m) => (m['allowed'] as bool))
        .map((m) => m['suggestion'] as CitySuggestion)
        .toList();
  }

  static Future<List<CitySuggestion>> _searchNominatim(
    String query, {
    required int limit,
    required String language,
  }) async {
    final uri = Uri.parse(_nominatim).replace(queryParameters: {
      'q': query,
      'format': 'jsonv2',
      'addressdetails': '1',
      'limit': '$limit',
      'accept-language': language,
    });

    final resp = await http.get(
      uri,
      headers: const {
        // Descriptive UA per Nominatim usage policy (can be routed via browser UA on web)
        'Accept': 'application/json',
      },
    );
    if (resp.statusCode != 200) {
      debugPrint('Nominatim HTTP ${resp.statusCode}');
      return [];
    }

    final data = json.decode(resp.body);
    if (data is! List) return [];

    const allowedTypes = {
      'city',
      'town',
      'village',
      'hamlet',
      'suburb',
      'municipality',
      'locality',
    };

    return data
        .where((e) => e is Map)
        .cast<Map>()
        .where((m) {
          final cls = m['class'];
          final type = m['type'];
          return cls == 'place' && allowedTypes.contains(type);
        })
        .map((m) {
          final address = m['address'] as Map? ?? {};
          final city = (address['city'] ?? address['town'] ?? address['village'] ?? address['hamlet']) as String?;
          final state = address['state'] as String?;
          final country = address['country'] as String?;
          final name = (m['name'] as String?) ?? city ?? '';
          final parts = [name, if (state != null && state.isNotEmpty) state, if (country != null && country.isNotEmpty) country];
          final label = parts.where((p) => (p).isNotEmpty).join(', ');
          final lat = double.tryParse(m['lat']?.toString() ?? '') ?? 0.0;
          final lon = double.tryParse(m['lon']?.toString() ?? '') ?? 0.0;

          return CitySuggestion(
            label: label.isEmpty ? (m['display_name']?.toString() ?? '') : label,
            city: city,
            state: state,
            country: country,
            lat: lat,
            lon: lon,
          );
        })
        .toList();
  }
}
