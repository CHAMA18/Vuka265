import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/actions/actions.dart' as action_blocks;
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'filters_widget.dart' show FiltersWidget;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class FiltersModel extends FlutterFlowModel<FiltersWidget> {
  ///  Local state fields for this component.

  int? nbrPhotos;

  int showMe = 1;

  List<String> goals = [];
  void addToGoals(String item) => goals.add(item);
  void removeFromGoals(String item) => goals.remove(item);
  void removeAtIndexFromGoals(int index) => goals.removeAt(index);
  void insertAtIndexInGoals(int index, String item) =>
      goals.insert(index, item);
  void updateGoalsAtIndex(int index, Function(String) updateFn) =>
      goals[index] = updateFn(goals[index]);

  List<String> interests = [];
  void addToInterests(String item) => interests.add(item);
  void removeFromInterests(String item) => interests.remove(item);
  void removeAtIndexFromInterests(int index) => interests.removeAt(index);
  void insertAtIndexInInterests(int index, String item) =>
      interests.insert(index, item);
  void updateInterestsAtIndex(int index, Function(String) updateFn) =>
      interests[index] = updateFn(interests[index]);

  List<String> languages = [];
  void addToLanguages(String item) => languages.add(item);
  void removeFromLanguages(String item) => languages.remove(item);
  void removeAtIndexFromLanguages(int index) => languages.removeAt(index);
  void insertAtIndexInLanguages(int index, String item) =>
      languages.insert(index, item);
  void updateLanguagesAtIndex(int index, Function(String) updateFn) =>
      languages[index] = updateFn(languages[index]);

  List<String> gender = [];
  void addToGender(String item) => gender.add(item);
  void removeFromGender(String item) => gender.remove(item);
  void removeAtIndexFromGender(int index) => gender.removeAt(index);
  void insertAtIndexInGender(int index, String item) =>
      gender.insert(index, item);
  void updateGenderAtIndex(int index, Function(String) updateFn) =>
      gender[index] = updateFn(gender[index]);

  int? maxAge = 99;

  int? minAge = 0;

  double? maxDistance;

  ///  State fields for stateful widgets in this component.

  // State field(s) for DistanceSlider widget.
  double? distanceSliderValue;
  // State field(s) for Checkbox widget.
  bool? checkboxValue;
  // Stores action output result for [Custom Action - algoliaSearch] action in Button widget.
  List<dynamic>? algoliaResults;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
