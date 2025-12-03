import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/chats/new_matches/new_matches_widget.dart';
import '/chats/skeleton_loading_match/skeleton_loading_match_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/home/navbar/navbar_widget.dart';
import '/matches/single_options/single_options_widget.dart';
import 'dart:math';
import 'dart:ui';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'chats_widget.dart' show ChatsWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ChatsModel extends FlutterFlowModel<ChatsWidget> {
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Firestore Query - Query a collection] action in Chats widget.
  int? unreadChats;
  // Stores action output result for [Backend Call - Create Document] action in NewMatches widget.
  ChatsRecord? newchat;
  // Model for Navbar component.
  late NavbarModel navbarModel;

  @override
  void initState(BuildContext context) {
    navbarModel = createModel(context, () => NavbarModel());
  }

  @override
  void dispose() {
    navbarModel.dispose();
  }

  Future<bool> checkUserOnlineStatus(DocumentReference userRef) async {
    try {
      // Check user's lastActiveTime from their profile
      final userDoc = await userRef.get();
      if (!userDoc.exists) return false;
      
      final data = userDoc.data() as Map<String, dynamic>?;
      if (data == null) return false;
      
      final lastActiveTime = data['lastActiveTime'] as Timestamp?;
      if (lastActiveTime != null) {
        return _isUserOnline(lastActiveTime.toDate());
      }
      
      return false;
    } catch (e) {
      return false;
    }
  }

  bool _isUserOnline(DateTime? lastSeen) {
    if (lastSeen == null) return false;
    
    final now = DateTime.now();
    final difference = now.difference(lastSeen).inMinutes;
    
    // Consider user online if active within the last 5 minutes
    return difference <= 5;
  }
}
