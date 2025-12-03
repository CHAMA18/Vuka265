import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/actions/actions.dart' as action_blocks;
import '/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'notification_model.dart';
export 'notification_model.dart';

class NotificationWidget extends StatefulWidget {
  const NotificationWidget({super.key});

  static String routeName = 'Notification';
  static String routePath = '/notification';

  @override
  State<NotificationWidget> createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  late NotificationModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NotificationModel());

    // Mark all notifications as delivered when user opens notification page
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Get all unread notifications for current user
      final unreadNotifications = await queryNotificationsRecordOnce(
        queryBuilder: (notificationsRecord) => notificationsRecord
            .where('User', isEqualTo: currentUserReference)
            .where('Delivered', isEqualTo: false),
      );

      // Mark each notification as delivered
      for (final notification in unreadNotifications) {
        await notification.reference.update({'Delivered': true});
      }
      
      safeSetState(() {});
    });
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                Icons.arrow_back_ios,
                color: FlutterFlowTheme.of(context).primaryText,
                size: 25.0,
              ),
              onPressed: () async {
                await action_blocks.wait(context);
                context.safePop();
              },
            ),
          ),
          title: Text(
            'Notifications',
            style: FlutterFlowTheme.of(context).titleMedium.override(
                  fontFamily: 'Onest',
                  letterSpacing: 0.0,
                ),
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
                  Icons.settings_sharp,
                  color: FlutterFlowTheme.of(context).primaryText,
                  size: 24.0,
                ),
                onPressed: () async {
                  context.pushNamed(NotificationsWidget.routeName);
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
          child: StreamBuilder<List<NotificationsRecord>>(
            stream: queryNotificationsRecord(
              queryBuilder: (notificationsRecord) => notificationsRecord
                  .where('User', isEqualTo: currentUserReference)
                  .orderBy('TimeDate', descending: true),
              limit: 50,
            ),
            builder: (context, snapshot) {
              // Check if there's a Firestore index error
              if (snapshot.hasError) {
                final errorMessage = snapshot.error.toString();
                final bool isIndexError = errorMessage.contains('requires an index') || 
                                         errorMessage.contains('failed-precondition');
                
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 80.0,
                          height: 80.0,
                          decoration: BoxDecoration(
                            color: isIndexError 
                                ? FlutterFlowTheme.of(context).warning.withValues(alpha: 0.1)
                                : FlutterFlowTheme.of(context).error.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isIndexError ? Icons.build_circle_outlined : Icons.error_outline,
                            color: isIndexError 
                                ? FlutterFlowTheme.of(context).warning
                                : FlutterFlowTheme.of(context).error,
                            size: 40,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          isIndexError 
                              ? 'Setting Up Notifications' 
                              : 'Unable to Load Notifications',
                          style: FlutterFlowTheme.of(context).headlineSmall.override(
                                fontFamily: 'Onest',
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w600,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 12),
                        Text(
                          isIndexError
                              ? 'A one-time database setup is needed.\nPlease create the required index in Firebase Console and try again in a few minutes.'
                              : 'Something went wrong loading your notifications.\nPlease try again later.',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Onest',
                                color: FlutterFlowTheme.of(context).secondaryText,
                                letterSpacing: 0.0,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        if (isIndexError) ...[
                          SizedBox(height: 20),
                          FFButtonWidget(
                            onPressed: () {
                              setState(() {});
                            },
                            text: 'Retry',
                            options: FFButtonOptions(
                              width: 140,
                              height: 44,
                              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                              color: FlutterFlowTheme.of(context).primary,
                              textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                    fontFamily: 'Onest',
                                    color: Colors.white,
                                    letterSpacing: 0.0,
                                  ),
                              elevation: 0,
                              borderSide: BorderSide(
                                color: Colors.transparent,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(22),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }
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
              
              List<NotificationsRecord> notifications = snapshot.data!;
              
              if (notifications.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 120.0,
                          height: 120.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).primary.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.notifications_none_rounded,
                            size: 60.0,
                            color: FlutterFlowTheme.of(context).primary,
                          ),
                        ),
                        SizedBox(height: 24.0),
                        Text(
                          'No Notifications Yet',
                          style: FlutterFlowTheme.of(context).headlineSmall.override(
                            fontFamily: 'Onest',
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 12.0),
                        Text(
                          'We\'ll notify you about new matches, messages,\nand important account updates',
                          textAlign: TextAlign.center,
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Onest',
                            color: FlutterFlowTheme.of(context).secondaryText,
                            letterSpacing: 0.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return ListView.separated(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                itemCount: notifications.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  thickness: 1,
                  indent: 16.0,
                  endIndent: 16.0,
                  color: FlutterFlowTheme.of(context).alternate,
                ),
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  final isUnread = !notification.delivered;
                  
                  return InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      if (isUnread) {
                        await notification.reference.update({
                          'Delivered': true,
                        });
                      }
                      safeSetState(() {});
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isUnread 
                            ? FlutterFlowTheme.of(context).primary.withValues(alpha: 0.05)
                            : Colors.transparent,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 16.0,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (isUnread)
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 12.0, 0.0),
                              child: Container(
                                width: 8.0,
                                height: 8.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  notification.notificationTitle,
                                  style: FlutterFlowTheme.of(context).labelLarge.override(
                                    fontFamily: 'Onest',
                                    letterSpacing: 0.0,
                                    fontWeight: isUnread ? FontWeight.w600 : FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 6.0),
                                Text(
                                  notification.notficationContent,
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Onest',
                                    color: FlutterFlowTheme.of(context).secondaryText,
                                    letterSpacing: 0.0,
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  dateTimeFormat(
                                    "relative",
                                    notification.timeDate,
                                    locale: FFLocalizations.of(context).languageCode,
                                  ),
                                  style: FlutterFlowTheme.of(context).labelSmall.override(
                                    fontFamily: 'Onest',
                                    color: FlutterFlowTheme.of(context).secondaryText,
                                    letterSpacing: 0.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
