import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'start_walkthrough1_model.dart';
export 'start_walkthrough1_model.dart';

class StartWalkthrough1Widget extends StatefulWidget {
  const StartWalkthrough1Widget({super.key});

  @override
  State<StartWalkthrough1Widget> createState() =>
      _StartWalkthrough1WidgetState();
}

class _StartWalkthrough1WidgetState extends State<StartWalkthrough1Widget> {
  late StartWalkthrough1Model _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => StartWalkthrough1Model());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional(0.0, 0.0),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 15.0, 0.0),
        child: Text(
          'Tap this button to connect and chat with someone you\'re interested in.',
          textAlign: TextAlign.start,
          style: FlutterFlowTheme.of(context).labelLarge.override(
                fontFamily: 'Onest',
                color: FlutterFlowTheme.of(context).info,
                letterSpacing: 0.0,
              ),
        ),
      ),
    );
  }
}
