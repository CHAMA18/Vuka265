import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/actions/actions.dart' as action_blocks;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'help_support_privacy_model.dart';
export 'help_support_privacy_model.dart';

class HelpSupportPrivacyWidget extends StatefulWidget {
  const HelpSupportPrivacyWidget({super.key});

  static String routeName = 'HelpSupportPrivacy';
  static String routePath = '/helpSupportPrivacy';

  @override
  State<HelpSupportPrivacyWidget> createState() =>
      _HelpSupportPrivacyWidgetState();
}

class _HelpSupportPrivacyWidgetState extends State<HelpSupportPrivacyWidget> {
  late HelpSupportPrivacyModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HelpSupportPrivacyModel());

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
            'Privacy Policy',
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(15.0, 15.0, 15.0, 15.0),
                  child: RichText(
                    textScaler: MediaQuery.of(context).textScaler,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text:
                              '1. Introduction\nAt Vuka265, we are committed to protecting your privacy. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our mobile application. By using Vuka265, you consent to the practices described in this policy.\n\n2. Information We Collect\nWe collect the following types of information:\n\n2.1 Personal Information\nRegistration Information: When you create an account, we collect your name, email address, date of birth, gender, and any other information you choose to provide.\nProfile Information: We collect details you voluntarily share on your profile, such as photos, interests, and other personal descriptions.\nLocation Information: With your consent, we may collect your location data to enhance your experience on Vuka265.\n2.2 Non-Personal Information\nUsage Data: We collect information about how you use the app, including the features you access, the interactions you have with other users, and the time and duration of your sessions.\nDevice Information: We may collect information about your device, such as its model, operating system, unique device identifiers, and mobile network information.\n3. How We Use Your Information\nWe use the information we collect for the following purposes:\n\nTo Provide and Improve the App: We use your information to operate, maintain, and enhance Vuka265\'s features and services.\nTo Personalize Your Experience: We use your information to tailor content, match you with other users, and provide personalized recommendations.\nTo Communicate with You: We may send you notifications, updates, and promotional messages. You can opt-out of marketing communications at any time.\nTo Ensure Safety and Security: We use your information to detect and prevent fraud, abuse, and other harmful activities.\nTo Comply with Legal Obligations: We may use your information to comply with applicable laws, regulations, and legal processes.\n4. How We Share Your Information\nWe do not share your personal information with third parties except in the following circumstances:\n\nWith Your Consent: We may share your information when you give us explicit permission to do so.\nWith Service Providers: We may share your information with third-party service providers who perform services on our behalf, such as hosting, data analysis, and customer support.\nFor Legal Reasons: We may disclose your information if required by law, to protect our rights, or to respond to legal requests or governmental inquiries.\nIn Business Transfers: If Vuka265 undergoes a merger, acquisition, or sale of assets, your information may be transferred as part of that transaction.\n5. Data Security\nWe implement appropriate security measures to protect your information from unauthorized access, alteration, disclosure, or destruction. However, no method of transmission over the internet or electronic storage is completely secure, so we cannot guarantee its absolute security.\n\n6. Your Choices\nYou have the following rights regarding your information:\n\nAccess and Correction: You can access and update your personal information within the app.\nAccount Deletion: You can delete your account and personal information by following the instructions within the app.\nOpt-Out: You can opt-out of receiving promotional messages by adjusting your notification settings in the app.\n7. Children\'s Privacy\nVuka265 is not intended for users under the age of 18. We do not knowingly collect or solicit personal information from anyone under 18. If we become aware that we have collected personal information from a user under 18, we will delete it as quickly as possible.\n\n8. International Data Transfers\nYour information may be transferred to and processed in countries other than your own. By using Vuka265, you consent to the transfer of your information to countries outside your country of residence, which may have different data protection laws.\n\n9. Changes to This Privacy Policy\nWe may update this Privacy Policy from time to time. If we make significant changes, we will notify you through the app or via email. Your continued use of Vuka265 after any changes indicates your acceptance of the new policy.',
                          style:
                              FlutterFlowTheme.of(context).labelLarge.override(
                                    fontFamily: 'Onest',
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.normal,
                                  ),
                        )
                      ],
                      style: FlutterFlowTheme.of(context).labelLarge.override(
                            fontFamily: 'Onest',
                            letterSpacing: 0.0,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
