import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/backend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/auth/firebase_auth/auth_util.dart';

int? calculateAge(DateTime? dateOfBirth) {
  // calculates and returns an inter age provided a date of birth
  if (dateOfBirth == null) return null; // Check if dateOfBirth is null
  final today = DateTime.now(); // Get today's date
  int age =
      today.year - dateOfBirth.year; // Calculate age based on year difference
  if (today.month < dateOfBirth.month ||
      (today.month == dateOfBirth.month && today.day < dateOfBirth.day)) {
    age--; // Adjust age if the birthday hasn't occurred yet this year
  }
  return age; // Return the calculated age
}

DocumentReference? userRef(String? path) {
  if (path == null || path.isEmpty) {
    return null;
  }
  return FirebaseFirestore.instance.doc(path);
}

List<DocumentReference> newCustomFunction(
  DocumentReference authUser,
  DocumentReference otherUser,
) {
  return [authUser, otherUser];
}

/// Returns a deterministic chat document ID for two users.
/// Ensures the same two participants always map to the same chat doc id.
String chatDocId(
  DocumentReference userA,
  DocumentReference userB,
) {
  final ids = [userA.id, userB.id]..sort();
  return 'chat_${ids[0]}_${ids[1]}';
}

  /// Returns a deterministic BlockedList document ID for a directional block.
  /// The blocker comes first to ensure uniqueness for a given pair and direction.
  String blockDocId(
    DocumentReference blocker,
    DocumentReference blocked,
  ) {
    return 'block_${blocker.id}_${blocked.id}';
  }

DocumentReference? getOtherUserRef(
  List<DocumentReference> listOfUserRefs,
  DocumentReference authUserRef,
) {
  return authUserRef == listOfUserRefs.first
      ? listOfUserRefs.last
      : listOfUserRefs.first;
}

List<DocumentReference> firebaseFromJson(List<dynamic>? results) {
// returns document references from the json path variable
  if (results == null) return [];
  return results.map((result) {
    return FirebaseFirestore.instance.doc(result['path']);
  }).toList();
}

int? doubleToInteger(double? num) {
  // rounds off double and returns nearest int
  if (num == null) return null; // Check for null
  return num.round(); // Round off and return as int
}

String? metersaway(
  LatLng? userlocation,
  LatLng? otherUser,
) {
  // calculates the distance between users and returns x meters or x kilometers away
  if (userlocation == null || otherUser == null) {
    return null;
  }

  const double earthRadius = 6371e3; // in meters
  double lat1 = userlocation.latitude * math.pi / 180;
  double lat2 = otherUser.latitude * math.pi / 180;
  double deltaLat =
      (otherUser.latitude - userlocation.latitude) * math.pi / 180;
  double deltaLon =
      (otherUser.longitude - userlocation.longitude) * math.pi / 180;

  double a = math.sin(deltaLat / 2) * math.sin(deltaLat / 2) +
      math.cos(lat1) *
          math.cos(lat2) *
          math.sin(deltaLon / 2) *
          math.sin(deltaLon / 2);
  double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

  double distance = earthRadius * c; // distance in meters

  // Format distance appropriately
  if (distance < 1000) {
    return '${distance.round()} m away';
  } else {
    double kilometers = distance / 1000;
    if (kilometers < 10) {
      return '${kilometers.toStringAsFixed(1)} km away';
    } else {
      return '${kilometers.round()} km away';
    }
  }
}

double calculateInterestCompatibility(
  List<String>? currentUserInterests,
  List<String>? otherUserInterests,
) {
  // calculates interest compatibility between users as a percentage
  if (currentUserInterests == null || 
      otherUserInterests == null || 
      currentUserInterests.isEmpty || 
      otherUserInterests.isEmpty) {
    return 20.0; // Base score instead of 0
  }

  // Convert to sets for easier intersection calculation
  Set<String> currentInterests = currentUserInterests.map((s) => s.toLowerCase()).toSet();
  Set<String> otherInterests = otherUserInterests.map((s) => s.toLowerCase()).toSet();
  
  // Find common interests
  Set<String> commonInterests = currentInterests.intersection(otherInterests);
  
  // Use overlap coefficient: |A ∩ B| / min(|A|, |B|)
  // This gives more realistic scores for compatibility
  double compatibility = commonInterests.length / math.min(currentInterests.length, otherInterests.length);
  
  // Scale to 20-80% range for more realistic interest matching
  return 20 + (compatibility * 60);
}

double calculateDistance(
  LatLng? location1,
  LatLng? location2,
) {
  // calculates raw distance in meters between two coordinates
  if (location1 == null || location2 == null) {
    return double.infinity;
  }

  const double earthRadius = 6371e3; // in meters
  double lat1 = location1.latitude * math.pi / 180;
  double lat2 = location2.latitude * math.pi / 180;
  double deltaLat =
      (location2.latitude - location1.latitude) * math.pi / 180;
  double deltaLon =
      (location2.longitude - location1.longitude) * math.pi / 180;

  double a = math.sin(deltaLat / 2) * math.sin(deltaLat / 2) +
      math.cos(lat1) *
          math.cos(lat2) *
          math.sin(deltaLon / 2) *
          math.sin(deltaLon / 2);
  double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

  return earthRadius * c; // distance in meters
}

int calculateCompatibilityScore(
  List<String>? currentUserInterests,
  List<String>? otherUserInterests,
  List<String>? currentUserLanguages,
  List<String>? otherUserLanguages,
  String? currentUserReligion,
  String? otherUserReligion,
  List<String>? currentUserGoals,
  List<String>? otherUserGoals,
) {
  // Enhanced compatibility calculation with baseline scoring and weighted factors
  double totalScore = 30.0; // Baseline score of 30% for all users
  double maxPossibleScore = 100.0;
  
  // Interest compatibility (35% of total possible score)
  if (currentUserInterests != null && otherUserInterests != null &&
      currentUserInterests.isNotEmpty && otherUserInterests.isNotEmpty) {
    Set<String> currentInterests = currentUserInterests.map((s) => s.toLowerCase()).toSet();
    Set<String> otherInterests = otherUserInterests.map((s) => s.toLowerCase()).toSet();
    Set<String> commonInterests = currentInterests.intersection(otherInterests);
    
    // Use overlap coefficient instead of Jaccard: |A ∩ B| / min(|A|, |B|)
    // This is more generous and realistic for matching
    double interestMatch = commonInterests.length / math.min(currentInterests.length, otherInterests.length);
    totalScore += interestMatch * 35;
  }
  
  // Language compatibility (20% of total possible score)
  if (currentUserLanguages != null && otherUserLanguages != null && 
      currentUserLanguages.isNotEmpty && otherUserLanguages.isNotEmpty) {
    Set<String> currentLangs = currentUserLanguages.map((s) => s.toLowerCase()).toSet();
    Set<String> otherLangs = otherUserLanguages.map((s) => s.toLowerCase()).toSet();
    Set<String> commonLangs = currentLangs.intersection(otherLangs);
    
    double langMatch = commonLangs.length / math.min(currentLangs.length, otherLangs.length);
    totalScore += langMatch * 20;
  }
  
  // Relationship goals compatibility (20% of total possible score)
  if (currentUserGoals != null && otherUserGoals != null &&
      currentUserGoals.isNotEmpty && otherUserGoals.isNotEmpty) {
    Set<String> currentGoals = currentUserGoals.map((s) => s.toLowerCase()).toSet();
    Set<String> otherGoals = otherUserGoals.map((s) => s.toLowerCase()).toSet();
    Set<String> commonGoals = currentGoals.intersection(otherGoals);
    
    double goalsMatch = commonGoals.length / math.min(currentGoals.length, otherGoals.length);
    totalScore += goalsMatch * 20;
  }
  
  // Religion compatibility (15% of total possible score)
  if (currentUserReligion != null && otherUserReligion != null &&
      currentUserReligion.isNotEmpty && otherUserReligion.isNotEmpty) {
    bool religionMatch = currentUserReligion.toLowerCase() == otherUserReligion.toLowerCase();
    totalScore += religionMatch ? 15 : 0;
  }
  
  // Profile completeness bonus (up to 10% bonus)
  int completenessFactors = 0;
  if (currentUserInterests != null && currentUserInterests.isNotEmpty) completenessFactors++;
  if (currentUserLanguages != null && currentUserLanguages.isNotEmpty) completenessFactors++;
  if (currentUserGoals != null && currentUserGoals.isNotEmpty) completenessFactors++;
  if (currentUserReligion != null && currentUserReligion.isNotEmpty) completenessFactors++;
  
  double completenessBonus = (completenessFactors / 4.0) * 10;
  totalScore += completenessBonus;
  
  // Ensure score stays within realistic bounds (20-95%)
  return math.max(20, math.min(95, totalScore.round()));
}

int calculateFilteredCompatibilityScore(
  List<String>? currentUserInterests,
  List<String>? otherUserInterests,
  List<String>? currentUserLanguages,
  List<String>? otherUserLanguages,
  String? currentUserReligion,
  String? otherUserReligion,
  List<String>? currentUserGoals,
  List<String>? otherUserGoals,
  List<String>? filterInterests,
  List<String>? filterLanguages,
  String? currentUserGender,
  String? otherUserGender,
  int? currentUserAge,
  int? otherUserAge,
) {
  // Start with base compatibility score
  int baseScore = calculateCompatibilityScore(
    currentUserInterests,
    otherUserInterests,
    currentUserLanguages,
    otherUserLanguages,
    currentUserReligion,
    otherUserReligion,
    currentUserGoals,
    otherUserGoals,
  );
  
  double totalScore = baseScore.toDouble();
  
  // Apply filter bonuses for users who match specific search criteria
  double filterBonus = 0.0;
  
  // Interest filter bonus (up to +15 points)
  if (filterInterests != null && filterInterests.isNotEmpty && 
      otherUserInterests != null && otherUserInterests.isNotEmpty) {
    Set<String> filterInterestsSet = filterInterests.map((s) => s.toLowerCase()).toSet();
    Set<String> otherInterestsSet = otherUserInterests.map((s) => s.toLowerCase()).toSet();
    int matchingFilterInterests = filterInterestsSet.intersection(otherInterestsSet).length;
    
    double interestBonus = (matchingFilterInterests / filterInterests.length) * 15;
    filterBonus += interestBonus;
  }
  
  // Language filter bonus (up to +10 points)
  if (filterLanguages != null && filterLanguages.isNotEmpty && 
      otherUserLanguages != null && otherUserLanguages.isNotEmpty) {
    Set<String> filterLangsSet = filterLanguages.map((s) => s.toLowerCase()).toSet();
    Set<String> otherLangsSet = otherUserLanguages.map((s) => s.toLowerCase()).toSet();
    int matchingFilterLangs = filterLangsSet.intersection(otherLangsSet).length;
    
    double langBonus = (matchingFilterLangs / filterLanguages.length) * 10;
    filterBonus += langBonus;
  }
  
  // Age compatibility bonus (up to +5 points for similar ages)
  if (currentUserAge != null && otherUserAge != null) {
    int ageDiff = (currentUserAge - otherUserAge).abs();
    double ageBonus = 0.0;
    if (ageDiff <= 2) ageBonus = 5.0;
    else if (ageDiff <= 5) ageBonus = 3.0;
    else if (ageDiff <= 10) ageBonus = 1.0;
    filterBonus += ageBonus;
  }
  
  totalScore += filterBonus;
  
  // Ensure score stays within realistic bounds (20-98% for filtered results)
  return math.max(20, math.min(98, totalScore.round()));
}
