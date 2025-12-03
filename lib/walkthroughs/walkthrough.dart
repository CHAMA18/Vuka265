import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '/home/start_walkthrough1/start_walkthrough1_widget.dart';
import '/home/start_walkthrough2/start_walkthrough2_widget.dart';
import '/home/start_walkthrough3/start_walkthrough3_widget.dart';
import '/home/start_walkthrough4/start_walkthrough4_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';

// Focus widget keys for this walkthrough
final containerT7fzt027 = GlobalKey();
final containerZadcvt62 = GlobalKey();
final containerEgho0w4e = GlobalKey();
final iconY8lmkf69 = GlobalKey();

/// Walkthrough
///
///
List<TargetFocus> createWalkthroughTargets(BuildContext context) => [
      /// Step 1
      TargetFocus(
        keyTarget: containerT7fzt027,
        enableOverlayTab: true,
        alignSkip: Alignment.bottomRight,
        shape: ShapeLightFocus.Circle,
        color: Colors.black,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, __) => StartWalkthrough1Widget(),
          ),
        ],
      ),

      /// Step 2
      TargetFocus(
        keyTarget: containerZadcvt62,
        enableOverlayTab: true,
        alignSkip: Alignment.bottomRight,
        shape: ShapeLightFocus.Circle,
        color: Colors.black,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, __) => StartWalkthrough2Widget(),
          ),
        ],
      ),

      /// Step 3
      TargetFocus(
        keyTarget: containerEgho0w4e,
        enableOverlayTab: true,
        alignSkip: Alignment.bottomRight,
        shape: ShapeLightFocus.Circle,
        color: Colors.black,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, __) => StartWalkthrough3Widget(),
          ),
        ],
      ),

      /// Step 4
      TargetFocus(
        keyTarget: iconY8lmkf69,
        enableOverlayTab: true,
        alignSkip: Alignment.bottomRight,
        shape: ShapeLightFocus.Circle,
        color: Colors.black,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, __) => StartWalkthrough4Widget(),
          ),
        ],
      ),
    ];
