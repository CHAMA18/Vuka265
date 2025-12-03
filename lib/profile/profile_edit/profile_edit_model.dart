import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/firebase_storage/storage.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_place_picker.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/place.dart';
import '/flutter_flow/upload_data.dart';
import '/profile/filters_bottom/filters_bottom_widget.dart';
import '/profile/saved_settings/saved_settings_widget.dart';
import 'dart:io';
import 'dart:ui';
import '/actions/actions.dart' as action_blocks;
import 'profile_edit_widget.dart' show ProfileEditWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProfileEditModel extends FlutterFlowModel<ProfileEditWidget> {
  ///  Local state fields for this page.

  List<String> interestsEdit = [];
  void addToInterestsEdit(String item) => interestsEdit.add(item);
  void removeFromInterestsEdit(String item) => interestsEdit.remove(item);
  void removeAtIndexFromInterestsEdit(int index) =>
      interestsEdit.removeAt(index);
  void insertAtIndexInInterestsEdit(int index, String item) =>
      interestsEdit.insert(index, item);
  void updateInterestsEditAtIndex(int index, Function(String) updateFn) =>
      interestsEdit[index] = updateFn(interestsEdit[index]);

  List<String> relationshipGoalsEdit = [];
  void addToRelationshipGoalsEdit(String item) =>
      relationshipGoalsEdit.add(item);
  void removeFromRelationshipGoalsEdit(String item) =>
      relationshipGoalsEdit.remove(item);
  void removeAtIndexFromRelationshipGoalsEdit(int index) =>
      relationshipGoalsEdit.removeAt(index);
  void insertAtIndexInRelationshipGoalsEdit(int index, String item) =>
      relationshipGoalsEdit.insert(index, item);
  void updateRelationshipGoalsEditAtIndex(
          int index, Function(String) updateFn) =>
      relationshipGoalsEdit[index] = updateFn(relationshipGoalsEdit[index]);

  String religionEdit = 'None';

  List<String> languagesEdit = [];
  void addToLanguagesEdit(String item) => languagesEdit.add(item);
  void removeFromLanguagesEdit(String item) => languagesEdit.remove(item);
  void removeAtIndexFromLanguagesEdit(int index) =>
      languagesEdit.removeAt(index);
  void insertAtIndexInLanguagesEdit(int index, String item) =>
      languagesEdit.insert(index, item);
  void updateLanguagesEditAtIndex(int index, Function(String) updateFn) =>
      languagesEdit[index] = updateFn(languagesEdit[index]);

  List<String> musicPref = [];
  void addToMusicPref(String item) => musicPref.add(item);
  void removeFromMusicPref(String item) => musicPref.remove(item);
  void removeAtIndexFromMusicPref(int index) => musicPref.removeAt(index);
  void insertAtIndexInMusicPref(int index, String item) =>
      musicPref.insert(index, item);
  void updateMusicPrefAtIndex(int index, Function(String) updateFn) =>
      musicPref[index] = updateFn(musicPref[index]);

  List<String> travelPref = [];
  void addToTravelPref(String item) => travelPref.add(item);
  void removeFromTravelPref(String item) => travelPref.remove(item);
  void removeAtIndexFromTravelPref(int index) => travelPref.removeAt(index);
  void insertAtIndexInTravelPref(int index, String item) =>
      travelPref.insert(index, item);
  void updateTravelPrefAtIndex(int index, Function(String) updateFn) =>
      travelPref[index] = updateFn(travelPref[index]);

  List<String> moviePref = [];
  void addToMoviePref(String item) => moviePref.add(item);
  void removeFromMoviePref(String item) => moviePref.remove(item);
  void removeAtIndexFromMoviePref(int index) => moviePref.removeAt(index);
  void insertAtIndexInMoviePref(int index, String item) =>
      moviePref.insert(index, item);
  void updateMoviePrefAtIndex(int index, Function(String) updateFn) =>
      moviePref[index] = updateFn(moviePref[index]);

  List<String> bookPrefEdit = [];
  void addToBookPrefEdit(String item) => bookPrefEdit.add(item);
  void removeFromBookPrefEdit(String item) => bookPrefEdit.remove(item);
  void removeAtIndexFromBookPrefEdit(int index) => bookPrefEdit.removeAt(index);
  void insertAtIndexInBookPrefEdit(int index, String item) =>
      bookPrefEdit.insert(index, item);
  void updateBookPrefEditAtIndex(int index, Function(String) updateFn) =>
      bookPrefEdit[index] = updateFn(bookPrefEdit[index]);

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - Read Document] action in ProfileEdit widget.
  UsersRecord? userData;
  bool isDataUploading_editImages = false;
  List<FFUploadedFile> uploadedLocalFiles_editImages = [];
  List<String> uploadedFileUrls_editImages = [];

  // State field(s) for userName widget.
  FocusNode? userNameFocusNode;
  TextEditingController? userNameTextController;
  String? Function(BuildContext, String?)? userNameTextControllerValidator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;
  // State field(s) for GenderDropDown widget.
  String? genderDropDownValue;
  FormFieldController<String>? genderDropDownValueController;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController3;
  String? Function(BuildContext, String?)? textController3Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode3;
  TextEditingController? textController4;
  String? Function(BuildContext, String?)? textController4Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode4;
  TextEditingController? textController5;
  String? Function(BuildContext, String?)? textController5Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode5;
  TextEditingController? textController6;
  String? Function(BuildContext, String?)? textController6Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode6;
  TextEditingController? textController7;
  String? Function(BuildContext, String?)? textController7Validator;
  // State field(s) for educationDropDown widget.
  String? educationDropDownValue;
  FormFieldController<String>? educationDropDownValueController;
  // State field(s) for PlacePicker widget.
  FFPlace placePickerValue = FFPlace();
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode7;
  TextEditingController? textController8;
  String? Function(BuildContext, String?)? textController8Validator;
  // State field(s) for instagram widget.
  FocusNode? instagramFocusNode;
  TextEditingController? instagramTextController;
  String? Function(BuildContext, String?)? instagramTextControllerValidator;
  // State field(s) for facebook widget.
  FocusNode? facebookFocusNode;
  TextEditingController? facebookTextController;
  String? Function(BuildContext, String?)? facebookTextControllerValidator;
  // State field(s) for tiktok widget.
  FocusNode? tiktokFocusNode;
  TextEditingController? tiktokTextController;
  String? Function(BuildContext, String?)? tiktokTextControllerValidator;
  // State field(s) for twitter widget.
  FocusNode? twitterFocusNode;
  TextEditingController? twitterTextController;
  String? Function(BuildContext, String?)? twitterTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    userNameFocusNode?.dispose();
    userNameTextController?.dispose();

    textFieldFocusNode1?.dispose();
    textController2?.dispose();

    textFieldFocusNode2?.dispose();
    textController3?.dispose();

    textFieldFocusNode3?.dispose();
    textController4?.dispose();

    textFieldFocusNode4?.dispose();
    textController5?.dispose();

    textFieldFocusNode5?.dispose();
    textController6?.dispose();

    textFieldFocusNode6?.dispose();
    textController7?.dispose();

    textFieldFocusNode7?.dispose();
    textController8?.dispose();

    instagramFocusNode?.dispose();
    instagramTextController?.dispose();

    facebookFocusNode?.dispose();
    facebookTextController?.dispose();

    tiktokFocusNode?.dispose();
    tiktokTextController?.dispose();

    twitterFocusNode?.dispose();
    twitterTextController?.dispose();
  }
}
