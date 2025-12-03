import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'new_matches_model.dart';
export 'new_matches_model.dart';

class NewMatchesWidget extends StatefulWidget {
  const NewMatchesWidget({
    super.key,
    required this.userRef,
    this.statusLabel = 'New Match',
    this.statusColor,
    this.isPending = false,
  });

  final DocumentReference? userRef;
  final String statusLabel;
  final Color? statusColor;
  final bool isPending;

  @override
  State<NewMatchesWidget> createState() => _NewMatchesWidgetState();
}

class _NewMatchesWidgetState extends State<NewMatchesWidget> {
  late NewMatchesModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NewMatchesModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UsersRecord>(
      stream: UsersRecord.getDocument(widget!.userRef!),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Center(
            child: SizedBox(
              width: 30.0,
              height: 30.0,
              child: SpinKitFadingCircle(
                color: FlutterFlowTheme.of(context).primary,
                size: 30.0,
              ),
            ),
          );
        }

        final columnUsersRecord = snapshot.data!;
        final theme = FlutterFlowTheme.of(context);
        final name = columnUsersRecord.displayName;
        final age = columnUsersRecord.age;
        final location = columnUsersRecord.locationName;
        final relationshipGoal = columnUsersRecord.relationshipGoal;
        final statusColor = widget.statusColor ??
            (widget.isPending ? theme.warning : theme.primary);

        return SizedBox(
          width: 140.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Container(
                  height: 180.0,
                  decoration: BoxDecoration(
                    color: theme.primaryBackground,
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: columnUsersRecord.photoUrl != null &&
                                columnUsersRecord.photoUrl.isNotEmpty
                            ? Image.network(
                                columnUsersRecord.photoUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/images/user.png',
                                    fit: BoxFit.cover,
                                  );
                                },
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: SpinKitFadingCircle(
                                      color: theme.primary,
                                      size: 30.0,
                                    ),
                                  );
                                },
                              )
                            : Image.asset(
                                'assets/images/user.png',
                                fit: BoxFit.cover,
                              ),
                      ),
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.0),
                                Colors.black.withOpacity(0.2),
                                Colors.black.withOpacity(0.7),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 12.0,
                        left: 12.0,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 6.0,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.92),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                widget.isPending
                                    ? Icons.hourglass_top
                                    : Icons.favorite,
                                size: 14.0,
                                color: theme.info,
                              ),
                              SizedBox(width: 6.0),
                              Text(
                                widget.statusLabel,
                                style: theme.labelSmall.override(
                                      fontFamily: 'Onest',
                                      color: theme.info,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (relationshipGoal.isNotEmpty)
                        Positioned(
                          top: 12.0,
                          right: 12.0,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.0,
                              vertical: 6.0,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.45),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Text(
                              relationshipGoal,
                              style: theme.labelSmall.override(
                                    fontFamily: 'Onest',
                                    color: theme.info,
                                    letterSpacing: 0.0,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      Positioned(
                        left: 14.0,
                        right: 14.0,
                        bottom: 14.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              age > 0 ? '$name, $age' : name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.titleSmall.override(
                                    fontFamily: 'Onest',
                                    color: theme.info,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            SizedBox(height: 4.0),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  widget.isPending
                                      ? Icons.lock_clock
                                      : Icons.bolt_rounded,
                                  color: statusColor,
                                  size: 16.0,
                                ),
                                SizedBox(width: 6.0),
                                Expanded(
                                  child: Text(
                                    widget.isPending
                                        ? 'Awaiting a response'
                                        : 'Say hello and spark something',
                                    style: theme.labelSmall.override(
                                          fontFamily: 'Onest',
                                          color: theme.info.withOpacity(0.9),
                                          letterSpacing: 0.0,
                                        ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            if (location.isNotEmpty)
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 6.0, 0.0, 0.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.location_on_rounded,
                                      color: theme.info.withOpacity(0.85),
                                      size: 14.0,
                                    ),
                                    SizedBox(width: 4.0),
                                    Expanded(
                                      child: Text(
                                        location,
                                        style: theme.bodySmall.override(
                                              fontFamily: 'Onest',
                                              color:
                                                  theme.info.withOpacity(0.85),
                                              letterSpacing: 0.0,
                                            ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 12.0),
              Container(
                height: 4.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0),
                  gradient: LinearGradient(
                    colors: [
                      statusColor,
                      statusColor.withOpacity(0.4),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
