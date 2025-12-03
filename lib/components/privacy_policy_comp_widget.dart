import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'privacy_policy_comp_model.dart';
export 'privacy_policy_comp_model.dart';

/// PrivacyPolicyView
class PrivacyPolicyCompWidget extends StatefulWidget {
  const PrivacyPolicyCompWidget({super.key});

  @override
  State<PrivacyPolicyCompWidget> createState() =>
      _PrivacyPolicyCompWidgetState();
}

class _PrivacyPolicyCompWidgetState extends State<PrivacyPolicyCompWidget> {
  late PrivacyPolicyCompModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PrivacyPolicyCompModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.6,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        boxShadow: [
          BoxShadow(
            blurRadius: 4.0,
            color: Color(0x33000000),
            offset: Offset(
              0.0,
              2.0,
            ),
            spreadRadius: 0.0,
          )
        ],
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Privacy Policy',
                  style: FlutterFlowTheme.of(context).headlineSmall.override(
                        fontFamily: 'Onest',
                        letterSpacing: 0.0,
                      ),
                ),
                FlutterFlowIconButton(
                  borderColor: Colors.transparent,
                  borderRadius: 8.0,
                  buttonSize: 40.0,
                  fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                  icon: Icon(
                    Icons.close_rounded,
                    color: FlutterFlowTheme.of(context).primaryText,
                    size: 24.0,
                  ),
                  onPressed: () {
                    print('IconButton pressed ...');
                  },
                ),
              ],
            ),
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    height: 400.0,
                    decoration: BoxDecoration(),
                    child: Text(
                      'Privacy Policy for Vuka265\nEffective Date: 11th April 2025\n\nWelcome to Vuka265 (\"we,\" \"our,\" or \"us\"). Your privacy is important to us. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our mobile application (\"App\") and associated services.\n\nPlease read this policy carefully to understand our views and practices regarding your personal data and how we will treat it.\n\n1. Information We Collect\nWhen you use Vuka265, we collect the following types of information:\n\na. Information You Provide\nAccount Registration: Email address, phone number, password.\n\nProfile Details: Name, date of birth, gender, profile photos, bio, location, hobbies, and preferences.\n\nPayment Information: If you purchase a subscription or send money via the app, we may collect payment details through a secure third-party processor.\n\nCustomer Support: Any messages you send to us.\n\nb. Information We Collect Automatically\nLocation Data: Precise location from your device, if permitted.\n\nUsage Information: How you use the app, including swipe activity, messages, matches, log data, and device identifiers.\n\nDevice Information: Type of device, operating system, app version, and mobile network.\n\nc. Information from Others\nFirebase and Google Analytics: For authentication, crash reporting, and performance monitoring.\n\n2. How We Use Your Information\nWe use the information we collect for the following purposes:\n\nTo provide and personalize the Vuka265 experience.\n\nTo help users connect and match based on preferences.\n\nTo process payments and subscriptions securely.\n\nTo monitor and improve our services.\n\nTo ensure user safety and enforce our terms.\n\nTo communicate with you about updates or offers (with your consent).\n\n3. Sharing Your Information\nWe may share your information in the following cases:\n\nWith Other Users: Your public profile, photos, and general location (within a set radius) will be visible to other users.\n\nService Providers: Trusted third parties who help us operate the app (e.g., hosting, payment processing, data analytics).\n\nLegal Compliance: If required by law, or to protect the rights and safety of users or Vuka265.\n\nBusiness Transfers: In case of a merger, acquisition, or asset sale.\n\n4. Your Rights and Choices\nYou have the right to:\n\nAccess the personal data we hold about you.\n\nUpdate or delete your account information.\n\nWithdraw your consent for us to process your data (may affect app functionality).\n\nDisable location sharing at any time through your device settings.\n\nTo make any requests regarding your data, contact us at [Insert Contact Email].\n\n5. Data Retention\nWe retain your data for as long as your account is active or as needed to provide services. Deleted accounts are removed from our active systems but may remain in backups for a limited time.\n\n6. Security Measures\nWe implement appropriate technical and organizational security measures to protect your data. However, no system is 100% secure. You use Vuka265 at your own risk.\n\n7. International Data Transfers\nIf you access Vuka265 from outside Malawi, your data may be transferred to and processed in countries with different data protection laws.\n\n8. Children’s Privacy\nVuka265 is only available to users aged 18 and above. We do not knowingly collect data from minors.\n\n9. Updates to This Policy\nWe may update this policy periodically. We’ll notify you of significant changes via the app or email. Continued use of Vuka265 after such updates constitutes acceptance of the new policy.\n\n10. Contact Us\nIf you have any questions or concerns about this Privacy Policy, please contact us at:\n\nVuka265 Support Team\nEmail: info@vuka265.com\nWebsite: www.vuka265.com',
                      textAlign: TextAlign.start,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Onest',
                            letterSpacing: 0.0,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ].divide(SizedBox(height: 12.0)),
        ),
      ),
    );
  }
}
