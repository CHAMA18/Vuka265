import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'user_card_model.dart';
export 'user_card_model.dart';

class UserCardWidget extends StatefulWidget {
  const UserCardWidget({
    super.key,
    required this.userRef,
  });

  final DocumentReference? userRef;

  @override
  State<UserCardWidget> createState() => _UserCardWidgetState();
}

class _UserCardWidgetState extends State<UserCardWidget> {
  late UserCardModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => UserCardModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  bool _isUserOnline(DateTime? lastSeen) {
    if (lastSeen == null) return false;
    
    final now = DateTime.now();
    final difference = now.difference(lastSeen).inMinutes;
    
    // Consider user online if active within the last 5 minutes
    return difference <= 5;
  }

  Future<bool> _checkUserOnlineStatus(DocumentReference userRef) async {
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

  Widget _buildStatusBadge(bool isOnline) {
    return Container(
      height: 17.0,
      decoration: BoxDecoration(
        color: isOnline 
            ? FlutterFlowTheme.of(context).success 
            : FlutterFlowTheme.of(context).error,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(6.0, 2.0, 6.0, 2.0),
        child: Text(
          isOnline ? 'Active' : 'Offline',
          style: FlutterFlowTheme.of(context).bodyMedium.override(
            fontFamily: 'Onest',
            color: FlutterFlowTheme.of(context).info,
            fontSize: 10.0,
            letterSpacing: 0.0,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UsersRecord>(
      stream: UsersRecord.getDocument(widget!.userRef!),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Center(
            child: SizedBox(
              width: 30.0,
              height: 30.0,
              child: SpinKitFadingCircle(
                color: FlutterFlowTheme.of(context).primary,
                size: 30.0,
              ),
            ),
          );
        }

        final stackUsersRecord = snapshot.data!;

        return Stack(
          alignment: AlignmentDirectional(0.0, 1.0),
          children: [
            // Compatibility Badge - Top Right
            Positioned(
              top: 8.0,
              right: 8.0,
              child: AuthUserStreamWidget(
                builder: (context) {
                  int compatibilityScore = (FFAppState().filterInterests.isNotEmpty || 
                                               FFAppState().filterLanguages.isNotEmpty)
                      ? functions.calculateFilteredCompatibilityScore(
                          currentUserDocument?.interests,
                          stackUsersRecord.interests,
                          currentUserDocument?.languages,
                          stackUsersRecord.languages,
                          currentUserDocument?.religion,
                          stackUsersRecord.religion,
                          currentUserDocument?.relationshipGoals,
                          stackUsersRecord.relationshipGoals,
                          FFAppState().filterInterests,
                          FFAppState().filterLanguages,
                          currentUserDocument?.userGender,
                          stackUsersRecord.userGender,
                          currentUserDocument?.age,
                          stackUsersRecord.age,
                        )
                      : functions.calculateCompatibilityScore(
                          currentUserDocument?.interests,
                          stackUsersRecord.interests,
                          currentUserDocument?.languages,
                          stackUsersRecord.languages,
                          currentUserDocument?.religion,
                          stackUsersRecord.religion,
                          currentUserDocument?.relationshipGoals,
                          stackUsersRecord.relationshipGoals,
                        );
                  
                  if (compatibilityScore <= 0) {
                    return SizedBox.shrink();
                  }
                  
                  return Container(
                    height: 22.0,
                    decoration: BoxDecoration(
                      color: compatibilityScore >= 70 
                          ? FlutterFlowTheme.of(context).success
                          : compatibilityScore >= 40
                              ? FlutterFlowTheme.of(context).warning
                              : FlutterFlowTheme.of(context).error,
                      borderRadius: BorderRadius.circular(11.0),
                    ),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          8.0, 3.0, 8.0, 3.0),
                      child: Text(
                        '$compatibilityScore%',
                        style: FlutterFlowTheme.of(context)
                            .bodySmall
                            .override(
                              fontFamily: 'Onest',
                              color: FlutterFlowTheme.of(context).info,
                              fontSize: 10.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              width: MediaQuery.sizeOf(context).width * 0.44,
              height: 240.0,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).primaryBackground,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: profileImageProvider(
                    stackUsersRecord.photoUrl,
                  ),
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            Container(
              width: MediaQuery.sizeOf(context).width * 0.44,
              height: 80.0,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    FlutterFlowTheme.of(context).transparent,
                    FlutterFlowTheme.of(context).everBlack
                  ],
                  stops: [0.1, 0.9],
                  begin: AlignmentDirectional(0.0, -1.0),
                  end: AlignmentDirectional(0, 1.0),
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8.0),
                  bottomRight: Radius.circular(8.0),
                  topLeft: Radius.circular(0.0),
                  topRight: Radius.circular(0.0),
                ),
              ),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          '${stackUsersRecord.displayName} (${valueOrDefault<String>(
                            stackUsersRecord.age.toString(),
                            '20',
                          )})',
                          style:
                              FlutterFlowTheme.of(context).titleSmall.override(
                                    fontFamily: 'Onest',
                                    color: FlutterFlowTheme.of(context).info,
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              6.0, 0.0, 0.0, 0.0),
                          child: FutureBuilder<bool>(
                            future: _checkUserOnlineStatus(stackUsersRecord.reference),
                            builder: (context, snapshot) {
                              bool isOnline = snapshot.data ?? false;
                              return _buildStatusBadge(isOnline);
                            },
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 2.0, 0.0, 0.0),
                      child: AuthUserStreamWidget(
                        builder: (context) => Text(
                          valueOrDefault<String>(
                            functions.metersaway(
                                currentUserDocument?.location,
                                stackUsersRecord.location),
                            'Location unknown',
                          ),
                          style: FlutterFlowTheme.of(context).labelLarge.override(
                                fontFamily: 'Onest',
                                color: FlutterFlowTheme.of(context).info,
                                fontSize: 14.0,
                                letterSpacing: 0.0,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
