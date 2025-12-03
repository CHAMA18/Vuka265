import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'flutter_flow_widgets.dart';
import 'lat_lng.dart';
import 'place.dart';

class FlutterFlowPlacePicker extends StatefulWidget {
  const FlutterFlowPlacePicker({
    Key? key,
    required this.iOSGoogleMapsApiKey,
    required this.androidGoogleMapsApiKey,
    required this.webGoogleMapsApiKey,
    required this.defaultText,
    this.icon,
    required this.buttonOptions,
    required this.onSelect,
    this.proxyBaseUrl,
  }) : super(key: key);

  final String iOSGoogleMapsApiKey;
  final String androidGoogleMapsApiKey;
  final String webGoogleMapsApiKey;
  final String? defaultText;
  final Widget? icon;
  final FFButtonOptions buttonOptions;
  final Function(FFPlace place) onSelect;
  final String? proxyBaseUrl;

  @override
  _FFPlacePickerState createState() => _FFPlacePickerState();
}

class _FFPlacePickerState extends State<FlutterFlowPlacePicker> {
  String? _selectedPlace;

  String get googleMapsApiKey {
    if (kIsWeb) {
      return widget.webGoogleMapsApiKey;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        return '';
      case TargetPlatform.iOS:
        return widget.iOSGoogleMapsApiKey;
      case TargetPlatform.android:
        return widget.androidGoogleMapsApiKey;
      default:
        return widget.webGoogleMapsApiKey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String? languageCode = Localizations.localeOf(context).languageCode;
    return FFButtonWidget(
      text: _selectedPlace ?? widget.defaultText ?? 'Search places',
      icon: widget.icon,
      onPressed: () async {
        final prediction = await _showPlacesSearchDialog(
          context: context,
          apiKey: googleMapsApiKey,
          languageCode: languageCode,
          proxyBaseUrl: widget.proxyBaseUrl,
        );
        if (prediction == null) return;
        await _handlePlaceSelection(
          prediction,
          languageCode: languageCode,
          apiKey: googleMapsApiKey,
          proxyBaseUrl: widget.proxyBaseUrl,
        );
      },
      options: widget.buttonOptions,
    );
  }

  Future<void> _handlePlaceSelection(
    _PlacePrediction prediction, {
    required String? languageCode,
    required String apiKey,
    required String? proxyBaseUrl,
  }) async {
    final details = await _fetchPlaceDetails(
      placeId: prediction.placeId,
      apiKey: apiKey,
      languageCode: languageCode,
      proxyBaseUrl: proxyBaseUrl,
    );
    if (details == null) return;
    if (mounted) {
      setState(() {
        _selectedPlace = details.name;
      });
    }
    widget.onSelect(
      FFPlace(
        latLng: LatLng(details.lat ?? 0, details.lng ?? 0),
        name: details.name ?? prediction.description,
        address: details.formattedAddress ?? prediction.description,
        city: details.city ?? '',
        state: details.state ?? '',
        country: details.country ?? '',
        zipCode: details.postalCode ?? '',
      ),
    );
  }

  Future<_PlaceDetails?> _fetchPlaceDetails({
    required String placeId,
    required String apiKey,
    required String? languageCode,
    required String? proxyBaseUrl,
  }) async {
    final base = proxyBaseUrl?.isNotEmpty == true
        ? proxyBaseUrl!
        : 'https://maps.googleapis.com';
    final uri = Uri.parse(
      '$base/maps/api/place/details/json?place_id=$placeId&key=$apiKey${languageCode != null ? '&language=$languageCode' : ''}',
    );
    final resp = await http.get(uri);
    if (resp.statusCode != 200) return null;
    final data = jsonDecode(resp.body) as Map<String, dynamic>;
    if (data['status'] != 'OK') return null;
    final result = data['result'] as Map<String, dynamic>;
    final geometry = (result['geometry'] as Map<String, dynamic>?) ?? {};
    final loc = (geometry['location'] as Map<String, dynamic>?) ?? {};
    final comps = (result['address_components'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    String? componentShortName(String type) {
      for (final c in comps) {
        final types = (c['types'] as List?)?.cast<String>() ?? [];
        if (types.contains(type)) return c['short_name'] as String?;
      }
      return null;
    }
    return _PlaceDetails(
      name: result['name'] as String?,
      formattedAddress: result['formatted_address'] as String?,
      lat: (loc['lat'] as num?)?.toDouble(),
      lng: (loc['lng'] as num?)?.toDouble(),
      city: componentShortName('locality') ?? componentShortName('sublocality'),
      state: componentShortName('administrative_area_level_1'),
      country: componentShortName('country'),
      postalCode: componentShortName('postal_code'),
    );
  }

  Future<_PlacePrediction?> _showPlacesSearchDialog({
    required BuildContext context,
    required String apiKey,
    required String? languageCode,
    required String? proxyBaseUrl,
  }) async {
    return showDialog<_PlacePrediction>(
      context: context,
      builder: (ctx) {
        final controller = TextEditingController();
        final predictions = ValueNotifier<List<_PlacePrediction>>([]);
        Timer? debounce;
        Future<void> search(String input) async {
          final list = await _fetchAutocomplete(
            input: input,
            apiKey: apiKey,
            languageCode: languageCode,
            proxyBaseUrl: proxyBaseUrl,
          );
          predictions.value = list;
        }
        return AlertDialog(
          title: const Text('Search places'),
          content: StatefulBuilder(
            builder: (context, setStateSB) {
              return SizedBox(
                width: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: controller,
                      autofocus: true,
                      onChanged: (value) {
                        debounce?.cancel();
                        debounce = Timer(const Duration(milliseconds: 300), () {
                          if (value.trim().isNotEmpty) {
                            search(value.trim());
                          } else {
                            predictions.value = [];
                          }
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: 'Type a place name',
                      ),
                    ),
                    const SizedBox(height: 12),
                    ValueListenableBuilder<List<_PlacePrediction>>(
                      valueListenable: predictions,
                      builder: (context, items, _) {
                        return SizedBox(
                          height: 300,
                          child: ListView.builder(
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final p = items[index];
                              return ListTile(
                                title: Text(p.description),
                                onTap: () => Navigator.of(context).pop(p),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<List<_PlacePrediction>> _fetchAutocomplete({
    required String input,
    required String apiKey,
    required String? languageCode,
    required String? proxyBaseUrl,
  }) async {
    if (input.isEmpty) return [];
    final base = proxyBaseUrl?.isNotEmpty == true
        ? proxyBaseUrl!
        : 'https://maps.googleapis.com';
    final uri = Uri.parse(
      '$base/maps/api/place/autocomplete/json?input=${Uri.encodeComponent(input)}&key=$apiKey${languageCode != null ? '&language=$languageCode' : ''}',
    );
    final resp = await http.get(uri);
    if (resp.statusCode != 200) return [];
    final data = jsonDecode(resp.body) as Map<String, dynamic>;
    if (data['status'] != 'OK') return [];
    final preds = (data['predictions'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    return preds
        .map((e) => _PlacePrediction(
              description: e['description'] as String? ?? '',
              placeId: e['place_id'] as String? ?? '',
            ))
        .where((p) => p.placeId.isNotEmpty)
        .toList();
  }
}

class _PlacePrediction {
  final String description;
  final String placeId;
  _PlacePrediction({required this.description, required this.placeId});
}

class _PlaceDetails {
  final String? name;
  final String? formattedAddress;
  final double? lat;
  final double? lng;
  final String? city;
  final String? state;
  final String? country;
  final String? postalCode;
  _PlaceDetails({
    this.name,
    this.formattedAddress,
    this.lat,
    this.lng,
    this.city,
    this.state,
    this.country,
    this.postalCode,
  });
}
