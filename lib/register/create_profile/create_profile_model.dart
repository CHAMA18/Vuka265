import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/firebase_storage/storage.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import '/register/location_permission/location_permission_widget.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'create_profile_widget.dart' show CreateProfileWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

class CreateProfileModel extends FlutterFlowModel<CreateProfileWidget> {
  ///  Local state fields for this page.

  String relationShipGoal = 'Casual';

  List<DocumentReference> hobbies = [];
  void addToHobbies(DocumentReference item) => hobbies.add(item);
  void removeFromHobbies(DocumentReference item) => hobbies.remove(item);
  void removeAtIndexFromHobbies(int index) => hobbies.removeAt(index);
  void insertAtIndexInHobbies(int index, DocumentReference item) =>
      hobbies.insert(index, item);
  void updateHobbiesAtIndex(int index, Function(DocumentReference) updateFn) =>
      hobbies[index] = updateFn(hobbies[index]);

  ///  State fields for stateful widgets in this page.

  // State field(s) for PageView widget.
  PageController? pageViewController;

  int get pageViewCurrentIndex => pageViewController != null &&
          pageViewController!.hasClients &&
          pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 0;
  // State field(s) for userName widget.
  FocusNode? userNameFocusNode;
  TextEditingController? userNameTextController;
  String? Function(BuildContext, String?)? userNameTextControllerValidator;
  DateTime? datePicked;
  bool isDataUploading_images = false;
  List<FFUploadedFile> uploadedLocalFiles_images = [];
  List<String> uploadedFileUrls_images = [];

  // Stores action output result for [Backend Call - Create Document] action in Button widget.
  PreferencesRecord? userPrefereces;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    userNameFocusNode?.dispose();
    userNameTextController?.dispose();
  }
}
