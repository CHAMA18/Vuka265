// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:algolia/algolia.dart';

Future<List<dynamic>> algoliaSearch(
  int? photonum,
  double? maxDistance,
  int? maxAge,
  int? minAge,
  List<String>? gender,
  bool? hasBio,
  List<String>? goals,
  List<String>? interests,
  List<String>? languages,
  LatLng? userLocation,
) async {
  // Replace with your actual Algolia keys
  const String appID = 'NZAOUQIKN0';
  const String searchAPIKey = '33fadc0a7dee04cf7869b05b2f7c8c49';
  const String indexName = 'users';
  const int maxResults = 50;

  final Algolia algolia = Algolia.init(
    applicationId: appID,
    apiKey: searchAPIKey,
  );

  final index = algolia.index(indexName);

  // Numeric and boolean filters
  List<String> filtersList = [];

  if (minAge != null) filtersList.add('age >= $minAge');
  if (maxAge != null) filtersList.add('age <= $maxAge');
  if (photonum != null) filtersList.add('photoCount >= $photonum');
  if (hasBio == true) filtersList.add('hasBio = true');

  // Facet filters (nested lists = OR logic within group, AND between groups)
  List<List<String>> facetFilters = [];

  if (gender != null && gender.isNotEmpty) {
    facetFilters.add(gender.map((g) => 'userGender:$g').toList());
  }
  if (goals != null && goals.isNotEmpty) {
    facetFilters.add(goals.map((g) => 'relationshipGoals:$g').toList());
  }
  if (interests != null && interests.isNotEmpty) {
    facetFilters.add(interests.map((i) => 'interests:$i').toList());
  }
  if (languages != null && languages.isNotEmpty) {
    facetFilters.add(languages.map((l) => 'languages:$l').toList());
  }

  // Create base query (no search term)
  AlgoliaQuery query = index.search('').setHitsPerPage(maxResults);

  if (filtersList.isNotEmpty) {
    query = query.setFilters(filtersList.join(' AND '));
  }

  if (facetFilters.isNotEmpty) {
    query = query.setFacetFilter(facetFilters); // ✅ plural
  }

  // Geo filter
  if (userLocation != null && maxDistance != null) {
    final int radiusMeters = (maxDistance * 1000).round();
    query = query
        .setAroundLatLng('${userLocation.latitude},${userLocation.longitude}')
        .setAroundRadius(radiusMeters);
  }

  // Run query
  final AlgoliaQuerySnapshot snapshot = await query.getObjects();

  // Return results as JSON-safe maps
  return snapshot.hits
      .map((hit) => Map<String, dynamic>.from(hit.data))
      .toList();
}
