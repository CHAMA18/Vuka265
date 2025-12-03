import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'start_walkthrough2_model.dart';
export 'start_walkthrough2_model.dart';

class StartWalkthrough2Widget extends StatefulWidget {
  const StartWalkthrough2Widget({super.key});

  @override
  State<StartWalkthrough2Widget> createState() =>
      _StartWalkthrough2WidgetState();
}

class _StartWalkthrough2WidgetState extends State<StartWalkthrough2Widget> {
  late StartWalkthrough2Model _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => StartWalkthrough2Model());

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
      width: double.infinity,
      height: 90.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).transparent,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Align(
        alignment: AlignmentDirectional(0.0, 0.0),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 15.0, 0.0),
          child: Text(
            'Tap this button if you\'re not interested in the person on the profile card.',
            textAlign: TextAlign.start,
            style: FlutterFlowTheme.of(context).labelLarge.override(
                  fontFamily: 'Onest',
                  color: FlutterFlowTheme.of(context).info,
                  letterSpacing: 0.0,
                ),
          ),
        ),
      ),
    );
  }
}
