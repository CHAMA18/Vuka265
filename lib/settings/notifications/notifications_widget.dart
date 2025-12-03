import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/actions/actions.dart' as action_blocks;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'notifications_model.dart';
export 'notifications_model.dart';

class NotificationsWidget extends StatefulWidget {
  const NotificationsWidget({super.key});

  static String routeName = 'Notifications';
  static String routePath = '/notifications';

  @override
  State<NotificationsWidget> createState() => _NotificationsWidgetState();
}

class _NotificationsWidgetState extends State<NotificationsWidget> {
  late NotificationsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NotificationsModel());

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
          title: Text(
            'Notifications',
            style: FlutterFlowTheme.of(context).titleMedium.override(
                  fontFamily: 'Onest',
                  letterSpacing: 0.0,
                ),
          ),
          actions: [],
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
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(15.0, 25.0, 15.0, 12.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              FFAppState().MatchesTab = 0;
                              safeSetState(() {});
                            },
                            child: Container(
                              width: 100.0,
                              height: 42.0,
                              decoration: BoxDecoration(
                                color: FFAppState().MatchesTab == 0
                                    ? FlutterFlowTheme.of(context).primary
                                    : FlutterFlowTheme.of(context)
                                        .primaryBackground,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Align(
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: Text(
                                  'Push Notifications',
                                  style: FlutterFlowTheme.of(context)
                                      .labelLarge
                                      .override(
                                        fontFamily: 'Onest',
                                        color: FFAppState().MatchesTab == 0
                                            ? FlutterFlowTheme.of(context).info
                                            : FlutterFlowTheme.of(context)
                                                .primaryText,
                                        fontSize: 15.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              FFAppState().MatchesTab = 1;
                              safeSetState(() {});
                            },
                            child: Container(
                              width: 100.0,
                              height: 42.0,
                              decoration: BoxDecoration(
                                color: valueOrDefault<Color>(
                                  FFAppState().MatchesTab == 1
                                      ? FlutterFlowTheme.of(context).primary
                                      : FlutterFlowTheme.of(context)
                                          .primaryBackground,
                                  FlutterFlowTheme.of(context)
                                      .primaryBackground,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Align(
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: Text(
                                  'Email Notifications',
                                  style: FlutterFlowTheme.of(context)
                                      .labelLarge
                                      .override(
                                        fontFamily: 'Onest',
                                        color: FFAppState().MatchesTab == 1
                                            ? FlutterFlowTheme.of(context).info
                                            : FlutterFlowTheme.of(context)
                                                .primaryText,
                                        fontSize: 15.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ].divide(SizedBox(width: 6.0)),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(15.0, 15.0, 15.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'New Matches',
                      style: FlutterFlowTheme.of(context).labelLarge.override(
                            fontFamily: 'Onest',
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        if (FFAppState().Switch1) {
                          FFAppState().Switch1 = false;
                          safeSetState(() {});
                        } else {
                          FFAppState().Switch1 = true;
                          safeSetState(() {});
                        }

                        HapticFeedback.lightImpact();
                      },
                      child: Container(
                        width: 50.0,
                        height: 28.0,
                        decoration: BoxDecoration(
                          color: valueOrDefault<Color>(
                            FFAppState().Switch1 == true
                                ? FlutterFlowTheme.of(context).primary
                                : FlutterFlowTheme.of(context).accent1,
                            FlutterFlowTheme.of(context).primary,
                          ),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Align(
                                  alignment: AlignmentDirectional(
                                      valueOrDefault<double>(
                                        FFAppState().Switch1 == true
                                            ? 1.0
                                            : -1.0,
                                        0.0,
                                      ),
                                      0.0),
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 100),
                                    curve: Curves.easeInOut,
                                    width: 25.0,
                                    height: 25.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context).info,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(15.0, 25.0, 15.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'New Messages',
                      style: FlutterFlowTheme.of(context).labelLarge.override(
                            fontFamily: 'Onest',
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        if (FFAppState().Switch2) {
                          FFAppState().Switch2 = false;
                          safeSetState(() {});
                        } else {
                          FFAppState().Switch2 = true;
                          safeSetState(() {});
                        }

                        HapticFeedback.lightImpact();
                      },
                      child: Container(
                        width: 50.0,
                        height: 28.0,
                        decoration: BoxDecoration(
                          color: valueOrDefault<Color>(
                            FFAppState().Switch2 == true
                                ? FlutterFlowTheme.of(context).primary
                                : FlutterFlowTheme.of(context).accent1,
                            FlutterFlowTheme.of(context).primary,
                          ),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Align(
                                  alignment: AlignmentDirectional(
                                      valueOrDefault<double>(
                                        FFAppState().Switch2 == true
                                            ? 1.0
                                            : -1.0,
                                        0.0,
                                      ),
                                      0.0),
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 100),
                                    curve: Curves.easeInOut,
                                    width: 25.0,
                                    height: 25.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context).info,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(15.0, 25.0, 15.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Likes & Super Likes',
                      style: FlutterFlowTheme.of(context).labelLarge.override(
                            fontFamily: 'Onest',
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        if (FFAppState().Switch3) {
                          FFAppState().Switch3 = false;
                          safeSetState(() {});
                        } else {
                          FFAppState().Switch3 = true;
                          safeSetState(() {});
                        }

                        HapticFeedback.lightImpact();
                      },
                      child: Container(
                        width: 50.0,
                        height: 28.0,
                        decoration: BoxDecoration(
                          color: valueOrDefault<Color>(
                            FFAppState().Switch3 == true
                                ? FlutterFlowTheme.of(context).primary
                                : FlutterFlowTheme.of(context).accent1,
                            FlutterFlowTheme.of(context).primary,
                          ),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Align(
                                  alignment: AlignmentDirectional(
                                      valueOrDefault<double>(
                                        FFAppState().Switch3 == true
                                            ? 1.0
                                            : -1.0,
                                        0.0,
                                      ),
                                      0.0),
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 100),
                                    curve: Curves.easeInOut,
                                    width: 25.0,
                                    height: 25.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context).info,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(15.0, 25.0, 15.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Profile Visitors',
                      style: FlutterFlowTheme.of(context).labelLarge.override(
                            fontFamily: 'Onest',
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        if (FFAppState().Switch4) {
                          FFAppState().Switch4 = false;
                          safeSetState(() {});
                        } else {
                          FFAppState().Switch4 = true;
                          safeSetState(() {});
                        }

                        HapticFeedback.lightImpact();
                      },
                      child: Container(
                        width: 50.0,
                        height: 28.0,
                        decoration: BoxDecoration(
                          color: valueOrDefault<Color>(
                            FFAppState().Switch4 == true
                                ? FlutterFlowTheme.of(context).primary
                                : FlutterFlowTheme.of(context).accent1,
                            FlutterFlowTheme.of(context).primary,
                          ),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Align(
                                  alignment: AlignmentDirectional(
                                      valueOrDefault<double>(
                                        FFAppState().Switch4 == true
                                            ? 1.0
                                            : -1.0,
                                        0.0,
                                      ),
                                      0.0),
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 100),
                                    curve: Curves.easeInOut,
                                    width: 25.0,
                                    height: 25.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context).info,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(15.0, 25.0, 15.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Events and Activities',
                      style: FlutterFlowTheme.of(context).labelLarge.override(
                            fontFamily: 'Onest',
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        if (FFAppState().Switch5) {
                          FFAppState().Switch5 = false;
                          safeSetState(() {});
                        } else {
                          FFAppState().Switch5 = true;
                          safeSetState(() {});
                        }

                        HapticFeedback.lightImpact();
                      },
                      child: Container(
                        width: 50.0,
                        height: 28.0,
                        decoration: BoxDecoration(
                          color: valueOrDefault<Color>(
                            FFAppState().Switch5 == true
                                ? FlutterFlowTheme.of(context).primary
                                : FlutterFlowTheme.of(context).accent1,
                            FlutterFlowTheme.of(context).primary,
                          ),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Align(
                                  alignment: AlignmentDirectional(
                                      valueOrDefault<double>(
                                        FFAppState().Switch5 == true
                                            ? 1.0
                                            : -1.0,
                                        0.0,
                                      ),
                                      0.0),
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 100),
                                    curve: Curves.easeInOut,
                                    width: 25.0,
                                    height: 25.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context).info,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(15.0, 25.0, 15.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Matches\' Activity',
                      style: FlutterFlowTheme.of(context).labelLarge.override(
                            fontFamily: 'Onest',
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        if (FFAppState().Switch6) {
                          FFAppState().Switch6 = false;
                          safeSetState(() {});
                        } else {
                          FFAppState().Switch6 = true;
                          safeSetState(() {});
                        }

                        HapticFeedback.lightImpact();
                      },
                      child: Container(
                        width: 50.0,
                        height: 28.0,
                        decoration: BoxDecoration(
                          color: valueOrDefault<Color>(
                            FFAppState().Switch6 == true
                                ? FlutterFlowTheme.of(context).primary
                                : FlutterFlowTheme.of(context).accent1,
                            FlutterFlowTheme.of(context).primary,
                          ),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Align(
                                  alignment: AlignmentDirectional(
                                      valueOrDefault<double>(
                                        FFAppState().Switch6 == true
                                            ? 1.0
                                            : -1.0,
                                        0.0,
                                      ),
                                      0.0),
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 100),
                                    curve: Curves.easeInOut,
                                    width: 25.0,
                                    height: 25.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context).info,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(15.0, 25.0, 15.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Account Alerts',
                      style: FlutterFlowTheme.of(context).labelLarge.override(
                            fontFamily: 'Onest',
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        if (FFAppState().Switch7) {
                          FFAppState().Switch7 = false;
                          safeSetState(() {});
                        } else {
                          FFAppState().Switch7 = true;
                          safeSetState(() {});
                        }

                        HapticFeedback.lightImpact();
                      },
                      child: Container(
                        width: 50.0,
                        height: 28.0,
                        decoration: BoxDecoration(
                          color: valueOrDefault<Color>(
                            FFAppState().Switch7 == true
                                ? FlutterFlowTheme.of(context).primary
                                : FlutterFlowTheme.of(context).accent1,
                            FlutterFlowTheme.of(context).primary,
                          ),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Align(
                                  alignment: AlignmentDirectional(
                                      valueOrDefault<double>(
                                        FFAppState().Switch7 == true
                                            ? 1.0
                                            : -1.0,
                                        0.0,
                                      ),
                                      0.0),
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 100),
                                    curve: Curves.easeInOut,
                                    width: 25.0,
                                    height: 25.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context).info,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(15.0, 25.0, 15.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Promotions & News',
                      style: FlutterFlowTheme.of(context).labelLarge.override(
                            fontFamily: 'Onest',
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        if (FFAppState().Switch8) {
                          FFAppState().Switch8 = false;
                          safeSetState(() {});
                        } else {
                          FFAppState().Switch8 = true;
                          safeSetState(() {});
                        }

                        HapticFeedback.lightImpact();
                      },
                      child: Container(
                        width: 50.0,
                        height: 28.0,
                        decoration: BoxDecoration(
                          color: valueOrDefault<Color>(
                            FFAppState().Switch8 == true
                                ? FlutterFlowTheme.of(context).primary
                                : FlutterFlowTheme.of(context).accent1,
                            FlutterFlowTheme.of(context).primary,
                          ),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Align(
                                  alignment: AlignmentDirectional(
                                      valueOrDefault<double>(
                                        FFAppState().Switch8 == true
                                            ? 1.0
                                            : -1.0,
                                        0.0,
                                      ),
                                      0.0),
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 100),
                                    curve: Curves.easeInOut,
                                    width: 25.0,
                                    height: 25.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context).info,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(15.0, 25.0, 15.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'In-App Recommendations',
                      style: FlutterFlowTheme.of(context).labelLarge.override(
                            fontFamily: 'Onest',
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        if (FFAppState().Switch9) {
                          FFAppState().Switch9 = false;
                          safeSetState(() {});
                        } else {
                          FFAppState().Switch9 = true;
                          safeSetState(() {});
                        }

                        HapticFeedback.lightImpact();
                      },
                      child: Container(
                        width: 50.0,
                        height: 28.0,
                        decoration: BoxDecoration(
                          color: valueOrDefault<Color>(
                            FFAppState().Switch9 == true
                                ? FlutterFlowTheme.of(context).primary
                                : FlutterFlowTheme.of(context).accent1,
                            FlutterFlowTheme.of(context).primary,
                          ),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Align(
                                  alignment: AlignmentDirectional(
                                      valueOrDefault<double>(
                                        FFAppState().Switch9 == true
                                            ? 1.0
                                            : -1.0,
                                        0.0,
                                      ),
                                      0.0),
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 100),
                                    curve: Curves.easeInOut,
                                    width: 25.0,
                                    height: 25.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context).info,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(15.0, 25.0, 15.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Weekly Activity Summary',
                      style: FlutterFlowTheme.of(context).labelLarge.override(
                            fontFamily: 'Onest',
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        if (FFAppState().Switch10) {
                          FFAppState().Switch10 = false;
                          safeSetState(() {});
                        } else {
                          FFAppState().Switch10 = true;
                          safeSetState(() {});
                        }

                        HapticFeedback.lightImpact();
                      },
                      child: Container(
                        width: 50.0,
                        height: 28.0,
                        decoration: BoxDecoration(
                          color: valueOrDefault<Color>(
                            FFAppState().Switch10 == true
                                ? FlutterFlowTheme.of(context).primary
                                : FlutterFlowTheme.of(context).accent1,
                            FlutterFlowTheme.of(context).primary,
                          ),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Align(
                                  alignment: AlignmentDirectional(
                                      valueOrDefault<double>(
                                        FFAppState().Switch10 == true
                                            ? 1.0
                                            : -1.0,
                                        0.0,
                                      ),
                                      0.0),
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 100),
                                    curve: Curves.easeInOut,
                                    width: 25.0,
                                    height: 25.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context).info,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(15.0, 25.0, 15.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Connection Requests',
                      style: FlutterFlowTheme.of(context).labelLarge.override(
                            fontFamily: 'Onest',
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        if (FFAppState().Switch11) {
                          FFAppState().Switch11 = false;
                          safeSetState(() {});
                        } else {
                          FFAppState().Switch11 = true;
                          safeSetState(() {});
                        }

                        HapticFeedback.lightImpact();
                      },
                      child: Container(
                        width: 50.0,
                        height: 28.0,
                        decoration: BoxDecoration(
                          color: valueOrDefault<Color>(
                            FFAppState().Switch11 == true
                                ? FlutterFlowTheme.of(context).primary
                                : FlutterFlowTheme.of(context).accent1,
                            FlutterFlowTheme.of(context).primary,
                          ),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Align(
                                  alignment: AlignmentDirectional(
                                      valueOrDefault<double>(
                                        FFAppState().Switch11 == true
                                            ? 1.0
                                            : -1.0,
                                        0.0,
                                      ),
                                      0.0),
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 100),
                                    curve: Curves.easeInOut,
                                    width: 25.0,
                                    height: 25.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context).info,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(15.0, 25.0, 15.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Survey & Feedback Requests',
                      style: FlutterFlowTheme.of(context).labelLarge.override(
                            fontFamily: 'Onest',
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        if (FFAppState().Switch12) {
                          FFAppState().Switch12 = false;
                          safeSetState(() {});
                        } else {
                          FFAppState().Switch12 = true;
                          safeSetState(() {});
                        }

                        HapticFeedback.lightImpact();
                      },
                      child: Container(
                        width: 50.0,
                        height: 28.0,
                        decoration: BoxDecoration(
                          color: valueOrDefault<Color>(
                            FFAppState().Switch12 == true
                                ? FlutterFlowTheme.of(context).primary
                                : FlutterFlowTheme.of(context).accent1,
                            FlutterFlowTheme.of(context).primary,
                          ),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Align(
                                  alignment: AlignmentDirectional(
                                      valueOrDefault<double>(
                                        FFAppState().Switch12 == true
                                            ? 1.0
                                            : -1.0,
                                        0.0,
                                      ),
                                      0.0),
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 100),
                                    curve: Curves.easeInOut,
                                    width: 25.0,
                                    height: 25.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context).info,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ].addToEnd(SizedBox(height: 25.0)),
          ),
        ),
      ),
    );
  }
}
