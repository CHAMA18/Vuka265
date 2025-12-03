import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/matches/user_card/user_card_widget.dart';
import 'dart:ui';
import '/actions/actions.dart' as action_blocks;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'profile_blocked_users_model.dart';
export 'profile_blocked_users_model.dart';

class ProfileBlockedUsersWidget extends StatefulWidget {
  const ProfileBlockedUsersWidget({super.key});

  static String routeName = 'ProfileBlockedUsers';
  static String routePath = '/profileBlockedUsers';

  @override
  State<ProfileBlockedUsersWidget> createState() =>
      _ProfileBlockedUsersWidgetState();
}

class _ProfileBlockedUsersWidgetState extends State<ProfileBlockedUsersWidget> {
  late ProfileBlockedUsersModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProfileBlockedUsersModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          automaticallyImplyLeading: false,
          leading: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(6.0, 6.0, 6.0, 6.0),
            child: FlutterFlowIconButton(
              borderColor: FlutterFlowTheme.of(context).transparent,
              borderRadius: 30.0,
              borderWidth: 0.0,
              buttonSize: 40.0,
              fillColor: FlutterFlowTheme.of(context).transparent,
              icon: Icon(
                FFIcons.karrowLeftMD,
                color: FlutterFlowTheme.of(context).primaryText,
                size: 25.0,
              ),
              onPressed: () async {
                await action_blocks.wait(context);
                context.safePop();
              },
            ),
          ),
          title: StreamBuilder<List<BlockedListRecord>>(
            stream: queryBlockedListRecord(
              queryBuilder: (q) => q.where('Blocker', isEqualTo: currentUserReference),
            ),
            builder: (context, snapshot) {
              final count = snapshot.data?.length ?? 0;
              return Text(
                'Blocked Users ($count)',
                style: FlutterFlowTheme.of(context).titleMedium.override(
                      fontFamily: 'Onest',
                      letterSpacing: 0.0,
                    ),
              );
            },
          ),
          actions: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(6.0, 6.0, 6.0, 6.0),
              child: FlutterFlowIconButton(
                borderColor: FlutterFlowTheme.of(context).transparent,
                borderRadius: 30.0,
                borderWidth: 0.0,
                buttonSize: 40.0,
                fillColor: FlutterFlowTheme.of(context).transparent,
                icon: Icon(
                  FFIcons.kuserPlus,
                  color: FlutterFlowTheme.of(context).primaryText,
                  size: 25.0,
                ),
                onPressed: () {
                  print('IconButton pressed ...');
                },
              ),
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              width: 100.0,
              height: 100.0,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
              ),
            ),
          ),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(12.0, 12.0, 12.0, 12.0),
            child: StreamBuilder<List<BlockedListRecord>>(
              stream: queryBlockedListRecord(
                queryBuilder: (q) => q.where('Blocker', isEqualTo: currentUserReference),
              ),
              builder: (context, snapshot) {
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
                final blockedList = snapshot.data!;
                if (blockedList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.person_off_outlined,
                          color: FlutterFlowTheme.of(context).secondaryText,
                          size: 48.0,
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'No blocked users yet',
                          style: FlutterFlowTheme.of(context).labelLarge.override(
                                fontFamily: 'Onest',
                                letterSpacing: 0.0,
                              ),
                        ),
                      ],
                    ),
                  );
                }
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 11.0,
                    crossAxisSpacing: 11.0,
                    mainAxisExtent: 240.0,
                  ),
                  itemCount: blockedList.length,
                  itemBuilder: (context, index) {
                    final blockedRecord = blockedList[index];
                    final blockedUserRef = blockedRecord.blocked;
                    if (blockedUserRef == null) return SizedBox.shrink();
                    return Stack(
                      children: [
                        UserCardWidget(
                          key: Key('blocked_${blockedUserRef.id}'),
                          userRef: blockedUserRef,
                        ),
                        Positioned(
                          top: 8.0,
                          left: 8.0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).secondaryBackground,
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: InkWell(
                              onTap: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Unblock user?'),
                                    content: Text('They will be able to find your profile and message you.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context, false),
                                        child: Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.pop(context, true),
                                        child: Text('Unblock'),
                                      ),
                                    ],
                                  ),
                                );
                                if (confirm == true) {
                                  try {
                                    await blockedRecord.reference.delete();
                                    await currentUserReference!.update({
                                      'ReportsBlockedUsers': FieldValue.arrayRemove([blockedUserRef]),
                                    });
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Failed to unblock. Please try again.')),
                                    );
                                  }
                                }
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                                child: Text(
                                  'Unblock',
                                  style: FlutterFlowTheme.of(context).labelMedium.override(
                                        fontFamily: 'Onest',
                                        letterSpacing: 0.0,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
