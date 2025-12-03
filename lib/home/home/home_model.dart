import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_swipeable_stack.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/home/added_to_favorites/added_to_favorites_widget.dart';
import '/home/filters/filters_widget.dart';
import '/home/navbar/navbar_widget.dart';
import '/walkthroughs/walkthrough.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'home_widget.dart' show HomeWidget;
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart'
    show TutorialCoachMark;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomeModel extends FlutterFlowModel<HomeWidget> {
  ///  Local state fields for this page.

  bool isLike = false;

  bool isNope = false;

  bool isReloading = false;

  int currentCardIndex = 0;

  List<UsersRecord> users = [];
  void addToUsers(UsersRecord item) => users.add(item);
  void removeFromUsers(UsersRecord item) => users.remove(item);
  void removeAtIndexFromUsers(int index) => users.removeAt(index);
  void insertAtIndexInUsers(int index, UsersRecord item) =>
      users.insert(index, item);
  void updateUsersAtIndex(int index, Function(UsersRecord) updateFn) =>
      users[index] = updateFn(users[index]);

  ///  State fields for stateful widgets in this page.

  TutorialCoachMark? walkthroughController;
  // Stores action output result for [Firestore Query - Query a collection] action in Home widget.
  int? notificationsCount;
  // Stores action output result for [Firestore Query - Query a collection] action in Home widget.
  List<UsersRecord>? filteredUsers;
  // Stores action output result for [Firestore Query - Query a collection] action in Home widget.
  List<UsersRecord>? defaultUsers;
  // State field(s) for SwipeableStack widget.
  late CardSwiperController swipeableStackController;
  // Stores action output result for [Backend Call - Create Document] action in SwipeableStack widget.
  NotificationsRecord? notification;
  // Model for Navbar component.
  late NavbarModel navbarModel;

  void incrementCardIndex() {
    currentCardIndex++;
  }

  @override
  void initState(BuildContext context) {
    swipeableStackController = CardSwiperController();
    navbarModel = createModel(context, () => NavbarModel());
  }

  @override
  void dispose() {
    walkthroughController?.finish();
    navbarModel.dispose();
  }
}
