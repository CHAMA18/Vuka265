import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/actions/actions.dart' as action_blocks;
import 'single_chat_widget.dart' show SingleChatWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SingleChatModel extends FlutterFlowModel<SingleChatWidget> {
  ///  Local state fields for this page.

  bool other = false;

  String message = ' ';

  bool showEmojiPicker = false;

  bool isRecording = false;

  ///  State fields for stateful widgets in this page.

  // State field(s) for textMessage widget.
  FocusNode? textMessageFocusNode;
  TextEditingController? textMessageTextController;
  String? Function(BuildContext, String?)? textMessageTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textMessageFocusNode?.dispose();
    textMessageTextController?.dispose();
  }
}
