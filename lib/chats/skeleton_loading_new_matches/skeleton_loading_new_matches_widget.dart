import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'skeleton_loading_new_matches_model.dart';
export 'skeleton_loading_new_matches_model.dart';

class SkeletonLoadingNewMatchesWidget extends StatefulWidget {
  const SkeletonLoadingNewMatchesWidget({super.key});

  @override
  State<SkeletonLoadingNewMatchesWidget> createState() =>
      _SkeletonLoadingNewMatchesWidgetState();
}

class _SkeletonLoadingNewMatchesWidgetState
    extends State<SkeletonLoadingNewMatchesWidget> {
  late SkeletonLoadingNewMatchesModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SkeletonLoadingNewMatchesModel());

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
      height: 216.0,
      decoration: BoxDecoration(),
      child: StreamBuilder<List<UsersRecord>>(
        stream: queryUsersRecord(
          queryBuilder: (usersRecord) => usersRecord.orderBy('age'),
          limit: 7,
        ),
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
          List<UsersRecord> listViewUsersRecordList = snapshot.data!;

          return ListView.separated(
            padding: EdgeInsets.fromLTRB(
              15.0,
              0,
              15.0,
              0,
            ),
            primary: false,
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            itemCount: listViewUsersRecordList.length,
            separatorBuilder: (_, __) => SizedBox(width: 12.0),
            itemBuilder: (context, listViewIndex) {
              return SizedBox(
                width: 140.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Container(
                        height: 180.0,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              FlutterFlowTheme.of(context)
                                  .accent1
                                  .withOpacity(0.65),
                              FlutterFlowTheme.of(context)
                                  .accent1
                                  .withOpacity(0.35),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Center(
                          child: SizedBox(
                            width: 24.0,
                            height: 24.0,
                            child: SpinKitFadingCircle(
                              color: FlutterFlowTheme.of(context).accent2,
                              size: 24.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.0),
                    Container(
                      width: 100.0,
                      height: 6.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context)
                            .accent1
                            .withOpacity(0.6),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
