import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/home/swiper2/swiper2_widget.dart';
import 'dart:ui';
import 'image_dialog_widget.dart' show ImageDialogWidget;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ImageDialogModel extends FlutterFlowModel<ImageDialogWidget> {
  ///  State fields for stateful widgets in this component.

  // Model for Swiper2 component.
  late Swiper2Model swiper2Model;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  @override
  void initState(BuildContext context) {
    swiper2Model = createModel(context, () => Swiper2Model());
  }

  @override
  void dispose() {
    swiper2Model.dispose();
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
