import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'start_walkthrough4_model.dart';
export 'start_walkthrough4_model.dart';

class StartWalkthrough4Widget extends StatefulWidget {
  const StartWalkthrough4Widget({super.key});

  @override
  State<StartWalkthrough4Widget> createState() =>
      _StartWalkthrough4WidgetState();
}

class _StartWalkthrough4WidgetState extends State<StartWalkthrough4Widget> {
  late StartWalkthrough4Model _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => StartWalkthrough4Model());

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
        padding: EdgeInsetsDirectional.fromSTEB(15.0, 15.0, 15.0, 15.0),
        child: Text(
          'Use this button to narrow your search by age, location, interests, and more to find your ideal match.',
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
