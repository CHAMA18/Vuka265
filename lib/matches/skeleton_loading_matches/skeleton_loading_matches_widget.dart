import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'skeleton_loading_matches_model.dart';
export 'skeleton_loading_matches_model.dart';

class SkeletonLoadingMatchesWidget extends StatefulWidget {
  const SkeletonLoadingMatchesWidget({super.key});

  @override
  State<SkeletonLoadingMatchesWidget> createState() =>
      _SkeletonLoadingMatchesWidgetState();
}

class _SkeletonLoadingMatchesWidgetState
    extends State<SkeletonLoadingMatchesWidget> with TickerProviderStateMixin {
  late SkeletonLoadingMatchesModel _model;

  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SkeletonLoadingMatchesModel());

    animationsMap.addAll({
      'wrapOnPageLoadAnimation': AnimationInfo(
        loop: true,
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          ShimmerEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 500.0.ms,
            color: FlutterFlowTheme.of(context).accent1,
            angle: 0,
          ),
        ],
      ),
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 11.0,
      runSpacing: 11.0,
      alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.start,
      direction: Axis.horizontal,
      runAlignment: WrapAlignment.start,
      verticalDirection: VerticalDirection.down,
      clipBehavior: Clip.none,
      children: [
        Container(
          width: MediaQuery.sizeOf(context).width * 0.44,
          height: 240.0,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).primaryBackground,
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        Container(
          width: MediaQuery.sizeOf(context).width * 0.44,
          height: 240.0,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).primaryBackground,
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        Container(
          width: MediaQuery.sizeOf(context).width * 0.44,
          height: 240.0,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).primaryBackground,
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        Container(
          width: MediaQuery.sizeOf(context).width * 0.44,
          height: 240.0,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).primaryBackground,
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ],
    ).animateOnPageLoad(animationsMap['wrapOnPageLoadAnimation']!);
  }
}
