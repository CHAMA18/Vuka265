import '/flutter_flow/flutter_flow_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  bool rememberMe = false;

  static const String _rememberMeKey = 'admin_remember_me';
  static const String _savedEmailKey = 'admin_saved_email';
  static const String _savedPasswordKey = 'admin_saved_password';

  Future<void> loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    rememberMe = prefs.getBool(_rememberMeKey) ?? false;
    if (rememberMe) {
      emailTextController?.text = prefs.getString(_savedEmailKey) ?? '';
      passwordTextController?.text = prefs.getString(_savedPasswordKey) ?? '';
    }
  }

  Future<void> saveCredentials(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    if (rememberMe) {
      await prefs.setBool(_rememberMeKey, true);
      await prefs.setString(_savedEmailKey, email);
      await prefs.setString(_savedPasswordKey, password);
    } else {
      await prefs.remove(_rememberMeKey);
      await prefs.remove(_savedEmailKey);
      await prefs.remove(_savedPasswordKey);
    }
  }

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
