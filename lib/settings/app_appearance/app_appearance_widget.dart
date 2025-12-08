import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/internationalization.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/services/notification_service.dart';
import 'dart:ui';
import '/actions/actions.dart' as action_blocks;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'app_appearance_model.dart';
export 'app_appearance_model.dart';

class AppAppearanceWidget extends StatefulWidget {
  const AppAppearanceWidget({super.key});

  static String routeName = 'AppAppearance';
  static String routePath = '/AppAppearance';

  @override
  State<AppAppearanceWidget> createState() => _AppAppearanceWidgetState();
}

class _AppAppearanceWidgetState extends State<AppAppearanceWidget> {
  late AppAppearanceModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  String _getCurrentLanguageName(BuildContext context) {
    final locale = FFLocalizations.getStoredLocale();
    final localeCode = locale?.toString() ?? 'en';
    switch (localeCode) {
      case 'en': return 'English (US)';
      case 'zh': return 'Mandarin';
      case 'es': return 'Spanish';
      case 'hi': return 'Hindi';
      case 'fr': return 'French';
      case 'ar': return 'Arabic';
      case 'ru': return 'Russian';
      case 'ja': return 'Japanese';
      default: return 'English (US)';
    }
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AppAppearanceModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
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
            FFLocalizations.of(context).getText('app_appearance'),
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
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(15.0, 10.0, 15.0, 0.0),
                child: Builder(
                  builder: (context) {
                    final isDarkMode =
                        Theme.of(context).brightness == Brightness.dark;

                    return Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18.0),
                        gradient: LinearGradient(
                          colors: [
                            FlutterFlowTheme.of(context)
                                .primary
                                .withOpacity(0.12),
                            FlutterFlowTheme.of(context)
                                .primary
                                .withOpacity(0.04),
                          ],
                          begin: AlignmentDirectional.topStart,
                          end: AlignmentDirectional.bottomEnd,
                        ),
                        border: Border.all(
                          color: FlutterFlowTheme.of(context)
                              .primary
                              .withOpacity(0.15),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: FlutterFlowTheme.of(context)
                                .primary
                                .withOpacity(0.08),
                            blurRadius: 16.0,
                            offset: Offset(0.0, 12.0),
                          )
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            18.0, 18.0, 18.0, 18.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 52.0,
                              height: 52.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .primary
                                    .withOpacity(0.18),
                                shape: BoxShape.circle,
                              ),
                              alignment: AlignmentDirectional(0.0, 0.0),
                              child: Icon(
                                isDarkMode
                                    ? Icons.dark_mode_rounded
                                    : Icons.light_mode_rounded,
                                color: FlutterFlowTheme.of(context).info,
                                size: 26.0,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 0.0, 0.0, 0.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      FFLocalizations.of(context).getText('display_mode'),
                                      style: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .override(
                                            fontFamily: 'Onest',
                                            letterSpacing: 0.0,
                                          ),
                                    ),
                                    SizedBox(height: 6.0),
                                    Text(
                                      isDarkMode
                                          ? FFLocalizations.of(context).getText('dark_mode')
                                          : FFLocalizations.of(context).getText('light_mode'),
                                      style: FlutterFlowTheme.of(context)
                                          .labelLarge
                                          .override(
                                            fontFamily: 'Onest',
                                            color:
                                                FlutterFlowTheme.of(context)
                                                    .secondaryText,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.normal,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Switch.adaptive(
                              value: isDarkMode,
                              onChanged: (newValue) async {
                                setDarkModeSetting(
                                  context,
                                  newValue ? ThemeMode.dark : ThemeMode.light,
                                );
                                await NotificationService.notifyThemeChange(
                                  newValue ? 'Dark' : 'Light',
                                );
                                safeSetState(() {});
                              },
                              activeColor: FlutterFlowTheme.of(context).info,
                              activeTrackColor:
                                  FlutterFlowTheme.of(context).primary,
                              inactiveTrackColor:
                                  FlutterFlowTheme.of(context).accent1,
                              inactiveThumbColor:
                                  FlutterFlowTheme.of(context).primaryBackground,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(15.0, 10.0, 15.0, 0.0),
                child: InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    context.pushNamed(AppAppearanceLanguageWidget.routeName);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            0.0, 10.0, 0.0, 10.0),
                        child: Text(
                          FFLocalizations.of(context).getText('app_language'),
                          style:
                              FlutterFlowTheme.of(context).labelLarge.override(
                                    fontFamily: 'Onest',
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 10.0, 12.0, 10.0),
                            child: Text(
                              _getCurrentLanguageName(context),
                              style: FlutterFlowTheme.of(context)
                                  .labelLarge
                                  .override(
                                    fontFamily: 'Onest',
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.normal,
                                  ),
                            ),
                          ),
                          Icon(
                            FFIcons.kchevronRight,
                            color: FlutterFlowTheme.of(context).primaryText,
                            size: 18.0,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
