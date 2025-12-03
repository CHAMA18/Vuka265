import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'skeleton_loading_widget.dart' show SkeletonLoadingWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SkeletonLoadingModel extends FlutterFlowModel<SkeletonLoadingWidget> {
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

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
