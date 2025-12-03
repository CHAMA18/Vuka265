import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/actions/actions.dart' as action_blocks;
import 'app_appearance_language_widget.dart' show AppAppearanceLanguageWidget;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AppAppearanceLanguageModel
    extends FlutterFlowModel<AppAppearanceLanguageWidget> {
  ///  Local state fields for this page.

  String language = 'English (US)';

  /// Map language names to locale codes
  String getLocaleCode() {
    switch (language) {
      case 'English (US)':
        return 'en';
      case 'English (UK)':
        return 'en';
      case 'Mandarin':
        return 'zh';
      case 'Spanish':
        return 'es';
      case 'Hindi':
        return 'hi';
      case 'French':
        return 'fr';
      case 'Arabic':
        return 'ar';
      case 'Russian':
        return 'ru';
      case 'Japanese':
        return 'ja';
      default:
        return 'en';
    }
  }

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
