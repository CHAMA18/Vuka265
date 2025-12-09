import '/flutter_flow/flutter_flow_model.dart';
import 'package:flutter/material.dart';
import 'admin_login_widget.dart' show AdminLoginWidget;

class AdminLoginModel extends FlutterFlowModel<AdminLoginWidget> {
  final unfocusNode = FocusNode();
  
  FocusNode? emailFocusNode;
  TextEditingController? emailTextController;
  String? Function(BuildContext, String?)? emailTextControllerValidator;
  
  FocusNode? passwordFocusNode;
  TextEditingController? passwordTextController;
  String? Function(BuildContext, String?)? passwordTextControllerValidator;
  
  bool passwordVisibility = false;
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
    emailFocusNode?.dispose();
    emailTextController?.dispose();
    passwordFocusNode?.dispose();
    passwordTextController?.dispose();
  }
}
