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
import 'help_support_terms_model.dart';
export 'help_support_terms_model.dart';

class HelpSupportTermsWidget extends StatefulWidget {
  const HelpSupportTermsWidget({super.key});

  static String routeName = 'HelpSupportTerms';
  static String routePath = '/helpSupportTerms';

  @override
  State<HelpSupportTermsWidget> createState() => _HelpSupportTermsWidgetState();
}

class _HelpSupportTermsWidgetState extends State<HelpSupportTermsWidget> {
  late HelpSupportTermsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HelpSupportTermsModel());

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
            'Terms & Conditions',
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
                              '1. Introduction\nWelcome to Vuka265, a dating platform designed to help you connect with others. By accessing or using Vuka265, you agree to be bound by these Terms and Conditions (\"Terms\"). If you do not agree with these Terms, you should not use Vuka265.\n\n2. Eligibility\nYou must be at least 18 years old to use Vuka265. By using the app, you represent and warrant that you meet this age requirement and have the legal capacity to enter into this agreement.\n\n3. Account Registration\nTo use Vuka265, you must create an account by providing accurate and complete information. You are responsible for maintaining the confidentiality of your login credentials and for all activities that occur under your account.\n\n4. User Conduct\nYou agree to use Vuka265 in a respectful and lawful manner. You will not:\n\nImpersonate any person or entity.\nHarass, abuse, or harm another person.\nPost or share any content that is offensive, inappropriate, or illegal.\nUse Vuka265 for any commercial purposes without our prior consent.\nCollect or store personal information of other users without their consent.\n5. Content\nYou are solely responsible for the content you post or share on Vuka265. By posting content, you grant Vuka265 a non-exclusive, royalty-free, worldwide, sublicensable, and transferable license to use, display, reproduce, and distribute your content in connection with the app\'s services.\n\n6. Prohibited Activities\nYou agree not to engage in any activity that:\n\nViolates these Terms or any applicable laws.\nCompromises the security of Vuka265 or its users.\nInvolves sending spam, junk mail, or chain letters.\nAttempts to reverse-engineer, modify, or hack Vuka265\'s software.\n7. Termination\nWe reserve the right to terminate or suspend your account at our discretion if we believe you have violated these Terms. You may also terminate your account at any time by following the instructions within the app.\n\n8. Privacy\nYour privacy is important to us. Please review our Privacy Policy to understand how we collect, use, and protect your personal information.\n\n9. Disclaimer of Warranties\nVuka265 is provided \"as is\" without any warranties, express or implied. We do not guarantee that the app will be error-free, secure, or uninterrupted. Your use of Vuka265 is at your own risk.\n\n10. Limitation of Liability\nIn no event shall Vuka265 be liable for any indirect, incidental, consequential, or punitive damages arising out of your use of the app. Our total liability to you for any claims arising from the use of Vuka265 shall not exceed the amount you paid, if any, to use the app.\n\n11. Changes to the Terms\nWe may update these Terms from time to time. If we make significant changes, we will notify you through the app or via email. Your continued use of Vuka265 after any changes constitutes your acceptance of the new Terms.\n\n12. Governing Law\nThese Terms shall be governed by and construed in accordance with the laws of [Your Country/State]. Any disputes arising under these Terms shall be subject to the exclusive jurisdiction of the courts located in [Your Country/State].',
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
