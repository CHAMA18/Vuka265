import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'filters_bottom_widget.dart' show FiltersBottomWidget;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class FiltersBottomModel extends FlutterFlowModel<FiltersBottomWidget> {
  ///  Local state fields for this component.

  List<String> selecteditems = [];
  void addToSelecteditems(String item) => selecteditems.add(item);
  void removeFromSelecteditems(String item) => selecteditems.remove(item);
  void removeAtIndexFromSelecteditems(int index) =>
      selecteditems.removeAt(index);
  void insertAtIndexInSelecteditems(int index, String item) =>
      selecteditems.insert(index, item);
  void updateSelecteditemsAtIndex(int index, Function(String) updateFn) =>
      selecteditems[index] = updateFn(selecteditems[index]);

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
