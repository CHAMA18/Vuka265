import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_swipeable_stack.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/home/added_to_favorites/added_to_favorites_widget.dart';
import '/home/filters/filters_widget.dart';
import '/home/navbar/navbar_widget.dart';
import '/walkthroughs/walkthrough.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart'
    show TutorialCoachMark;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'home_model.dart';
export 'home_model.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({
    super.key,
    bool? fromRegister,
    bool? isStartWalkthrough,
    bool? fromFilter,
  })  : this.fromRegister = fromRegister ?? false,
        this.isStartWalkthrough = isStartWalkthrough ?? false,
        this.fromFilter = fromFilter ?? false;

  final bool fromRegister;
  final bool isStartWalkthrough;
  final bool fromFilter;

  static String routeName = 'Home';
  static String routePath = '/home';

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  late HomeModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomeModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.notificationsCount = await queryNotificationsRecordCount(
        queryBuilder: (notificationsRecord) => notificationsRecord
            .where(
              'User',
              isEqualTo: currentUserReference,
            )
            .where(
              'Delivered',
              isEqualTo: false,
            ),
      );
      
      // Get recently skipped users (within last 48 hours)
      final DateTime fortyEightHoursAgo = DateTime.now().subtract(Duration(hours: 48));
      final recentSkips = await querySwipesRecordOnce(
        queryBuilder: (swipesRecord) => swipesRecord
            .where('swiperId', isEqualTo: currentUserReference)
            .where('type', isEqualTo: false)
            .where('timestamp', isGreaterThanOrEqualTo: fortyEightHoursAgo),
      );
      final skippedUserRefs = recentSkips.map((e) => e.targetuserid).whereType<DocumentReference>().toList();
      
      if (((FFAppState().algoliaResults.isNotEmpty) == true) &&
          widget!.fromFilter) {
        _model.filteredUsers = await queryUsersRecordOnce(
          queryBuilder: (usersRecord) => usersRecord
              .whereIn(
                  'uid',
                  functions
                      .firebaseFromJson(FFAppState().algoliaResults.toList())
                      .map((e) => e.id)
                      .toList())
              .whereNotIn(
                  'uid',
                  (currentUserDocument?.myMatches?.toList() ?? [])
                      .map((e) => e.id)
                      .toList()),
        );
        // Apply compatibility-based sorting to filtered results
        // Filter out recently skipped users (within 48 hours)
        List<UsersRecord> sortedFilteredUsers = _model.filteredUsers!
            .where((user) => !skippedUserRefs.contains(user.reference))
            .toList();
        if (currentUserDocument?.location != null) {
          sortedFilteredUsers.sort((a, b) {
            // Calculate enhanced compatibility scores with filter parameters
            int compatibilityA = functions.calculateFilteredCompatibilityScore(
              currentUserDocument?.interests,
              a.interests,
              currentUserDocument?.languages,
              a.languages,
              currentUserDocument?.religion,
              a.religion,
              currentUserDocument?.relationshipGoals,
              a.relationshipGoals,
              FFAppState().filterInterests,
              FFAppState().filterLanguages,
              currentUserDocument?.userGender,
              a.userGender,
              currentUserDocument?.age,
              a.age,
            );
            
            int compatibilityB = functions.calculateFilteredCompatibilityScore(
              currentUserDocument?.interests,
              b.interests,
              currentUserDocument?.languages,
              b.languages,
              currentUserDocument?.religion,
              b.religion,
              currentUserDocument?.relationshipGoals,
              b.relationshipGoals,
              FFAppState().filterInterests,
              FFAppState().filterLanguages,
              currentUserDocument?.userGender,
              b.userGender,
              currentUserDocument?.age,
              b.age,
            );
            
            // Primary sort: compatibility score (higher is better)
            if (compatibilityA != compatibilityB) {
              return compatibilityB - compatibilityA;
            }
            
            // Secondary sort: distance (closer is better, but only if both have location)
            if (a.location != null && b.location != null) {
              double distanceA = functions.calculateDistance(currentUserDocument!.location!, a.location!);
              double distanceB = functions.calculateDistance(currentUserDocument!.location!, b.location!);
              return distanceA.compareTo(distanceB);
            }
            
            return 0;
          });
        }
        
        _model.users = sortedFilteredUsers.toList().cast<UsersRecord>();
        _model.currentCardIndex = 0;
        safeSetState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'showing ${valueOrDefault<String>(
                _model.filteredUsers?.length?.toString(),
                '0',
              )} filtered results sorted by compatibility',
              style: TextStyle(
                color: FlutterFlowTheme.of(context).primaryText,
              ),
            ),
            duration: Duration(milliseconds: 4000),
            backgroundColor: FlutterFlowTheme.of(context).secondary,
          ),
        );
      } else {
        _model.defaultUsers = await queryUsersRecordOnce(
          queryBuilder: (usersRecord) => usersRecord.whereNotIn(
              'uid',
              (currentUserDocument?.myMatches?.toList() ?? [])
                  .map((e) => e.id)
                  .toList()),
          limit: 20,
        );
        
        // Sort users by compatibility and distance for better matching
        // Filter out recently skipped users (within 48 hours)
        List<UsersRecord> sortedUsers = _model.defaultUsers!
            .where((user) => !skippedUserRefs.contains(user.reference))
            .toList();
        if (currentUserDocument?.location != null) {
          sortedUsers.sort((a, b) {
            // Calculate compatibility scores
            int compatibilityA = functions.calculateCompatibilityScore(
              currentUserDocument?.interests,
              a.interests,
              currentUserDocument?.languages,
              a.languages,
              currentUserDocument?.religion,
              a.religion,
              currentUserDocument?.relationshipGoals,
              a.relationshipGoals,
            );
            
            int compatibilityB = functions.calculateCompatibilityScore(
              currentUserDocument?.interests,
              b.interests,
              currentUserDocument?.languages,
              b.languages,
              currentUserDocument?.religion,
              b.religion,
              currentUserDocument?.relationshipGoals,
              b.relationshipGoals,
            );
            
            // Primary sort: compatibility score (higher is better)
            if (compatibilityA != compatibilityB) {
              return compatibilityB - compatibilityA;
            }
            
            // Secondary sort: distance (closer is better, but only if both have location)
            if (a.location != null && b.location != null) {
              double distanceA = functions.calculateDistance(currentUserDocument!.location!, a.location!);
              double distanceB = functions.calculateDistance(currentUserDocument!.location!, b.location!);
              return distanceA.compareTo(distanceB);
            }
            
            return 0;
          });
        }
        
        _model.users = sortedUsers.take(10).toList().cast<UsersRecord>();
        _model.currentCardIndex = 0;
        safeSetState(() {});
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    // On page dispose action.
    () async {
      FFAppState().algoliaResults = [];
      safeSetState(() {});
    }();

    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(0.0),
          child: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
            automaticallyImplyLeading: false,
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
            centerTitle: false,
            elevation: 0.0,
          ),
        ),
        body: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(15.0, 18.0, 15.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(0.0),
                        child: Image.asset(
                          'assets/images/Vuka_Logo-Original.png',
                          width: 35.0,
                          height: 35.0,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(33.0, 0.0, 0.0, 0.0),
                        child: Text(
                          'Vuka',
                          style:
                              FlutterFlowTheme.of(context).titleMedium.override(
                                    fontFamily: 'Onest',
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Stack(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            children: [
                              FutureBuilder<int>(
                                future: queryNotificationsRecordCount(
                                  queryBuilder: (notificationsRecord) =>
                                      notificationsRecord
                                          .where(
                                            'User',
                                            isEqualTo: currentUserReference,
                                          )
                                          .where(
                                            'Delivered',
                                            isEqualTo: false,
                                          ),
                                ),
                                builder: (context, snapshot) {
                                  // Customize what your widget looks like when it's loading.
                                  if (!snapshot.hasData) {
                                    return Center(
                                      child: SizedBox(
                                        width: 30.0,
                                        height: 30.0,
                                        child: SpinKitFadingCircle(
                                          color:
                                              FlutterFlowTheme.of(context).primary,
                                          size: 30.0,
                                        ),
                                      ),
                                    );
                                  }
                                  int iconCount = snapshot.data!;

                                  return InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      context
                                          .pushNamed(NotificationWidget.routeName);
                                    },
                                    child: Icon(
                                      Icons.notifications_sharp,
                                      color: iconCount > 0
                                          ? FlutterFlowTheme.of(context).primary
                                          : FlutterFlowTheme.of(context)
                                              .primaryText,
                                      size: 27.0,
                                    ),
                                  );
                                },
                              ),
                              FutureBuilder<int>(
                                future: queryNotificationsRecordCount(
                                  queryBuilder: (notificationsRecord) =>
                                      notificationsRecord
                                          .where(
                                            'User',
                                            isEqualTo: currentUserReference,
                                          )
                                          .where(
                                            'Delivered',
                                            isEqualTo: false,
                                          ),
                                ),
                                builder: (context, snapshot) {
                                  // Count unread notifications
                                  int notificationCount = snapshot.data ?? 0;

                                  // Only show badge if there are unread notifications
                                  if (notificationCount == 0) return SizedBox.shrink();

                                  return Padding(
                                    padding:
                                        EdgeInsetsDirectional.fromSTEB(17.0, 0.0, 0.0, 38.0),
                                    child: Container(
                                      width: notificationCount > 9 ? 16.0 : 13.0,
                                      height: 13.0,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context).error,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            notificationCount > 9 ? 3.0 : 4.0, 1.0, 2.0, 1.0),
                                        child: Text(
                                          notificationCount > 9 ? '9+' : notificationCount.toString(),
                                          style:
                                              FlutterFlowTheme.of(context).bodySmall.override(
                                                    fontFamily: 'Onest',
                                                    color: FlutterFlowTheme.of(context).info,
                                                    fontSize: 8.0,
                                                    letterSpacing: 0.0,
                                                  ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              await showModalBottomSheet(
                                isScrollControlled: true,
                                backgroundColor:
                                    FlutterFlowTheme.of(context).transparent,
                                barrierColor:
                                    FlutterFlowTheme.of(context).accent3,
                                context: context,
                                builder: (context) {
                                  return GestureDetector(
                                    onTap: () {
                                      FocusScope.of(context).unfocus();
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                    },
                                    child: Padding(
                                      padding: MediaQuery.viewInsetsOf(context),
                                      child: FiltersWidget(
                                        page: 1,
                                      ),
                                    ),
                                  );
                                },
                              ).then((value) => safeSetState(() {}));
                            },
                            child: Icon(
                              Icons.filter_list,
                              color: FlutterFlowTheme.of(context).primaryText,
                              size: 28.0,
                            ),
                          ).addWalkthrough(
                            iconY8lmkf69,
                            _model.walkthroughController,
                          ),
                        ].divide(SizedBox(width: 12.0)),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Builder(
                    builder: (context) => Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 15.0),
                      child: Builder(
                        builder: (context) {
                          final stackUsers = _model.users.toList();

                          if (stackUsers.isEmpty) {
                            return Center(
                              child: Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.people_outline,
                                      size: 80.0,
                                      color: FlutterFlowTheme.of(context).secondaryText,
                                    ),
                                    SizedBox(height: 20.0),
                                    Text(
                                      'No More Profiles',
                                      style: FlutterFlowTheme.of(context).headlineSmall.override(
                                        fontFamily: 'Onest',
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 10.0),
                                    Text(
                                      'Check back later for new matches or adjust your filters to see more profiles.',
                                      textAlign: TextAlign.center,
                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        fontFamily: 'Onest',
                                        color: FlutterFlowTheme.of(context).secondaryText,
                                        letterSpacing: 0.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          return FlutterFlowSwipeableStack(
                            onSwipeFn: (index) {},
                            onLeftSwipe: (index) async {
                              final stackUsersItem = stackUsers[index];

                              await currentUserReference!.update({
                                ...mapToFirestore(
                                  {
                                    'myDisliked': FieldValue.arrayUnion(
                                        [stackUsersItem.reference]),
                                  },
                                ),
                              });
                              
                              // Create skip record with 48-hour timestamp
                              await SwipesRecord.collection.add(createSwipesRecordData(
                                type: false,
                                timestamp: getCurrentTimestamp,
                                swiperId: currentUserReference,
                                targetuserid: stackUsersItem.reference,
                              ));
                              
                              _model.incrementCardIndex();
                            },
                            onRightSwipe: (index) async {
                              final stackUsersItem = stackUsers[index];
                              _model.incrementCardIndex();

                              await currentUserReference!.update({
                                ...mapToFirestore(
                                  {
                                    'myLikes': FieldValue.arrayUnion(
                                        [stackUsersItem.reference]),
                                  },
                                ),
                              });

                              await stackUsersItem.reference.update({
                                ...mapToFirestore(
                                  {
                                    'myMatches': FieldValue.arrayUnion(
                                        [currentUserReference]),
                                  },
                                ),
                              });

                              var notificationsRecordReference =
                                  NotificationsRecord.collection.doc();
                              await notificationsRecordReference
                                  .set(createNotificationsRecordData(
                                notificationTitle: 'New Match alert!',
                                notficationContent:
                                    'You\'ve got a new match waiting to connect with you. Start a conversation!',
                                timeDate: getCurrentTimestamp,
                                user: stackUsersItem.reference,
                                delivered: false,
                                senderID: currentUserReference,
                              ));
                              _model.notification =
                                  NotificationsRecord.getDocumentFromData(
                                      createNotificationsRecordData(
                                        notificationTitle: 'New Match alert!',
                                        notficationContent:
                                            'You\'ve got a new match waiting to connect with you. Start a conversation!',
                                        timeDate: getCurrentTimestamp,
                                        user: stackUsersItem.reference,
                                        delivered: false,
                                        senderID: currentUserReference,
                                      ),
                                      notificationsRecordReference);

                              safeSetState(() {});
                            },
                            onUpSwipe: (index) async {
                              final stackUsersItem = stackUsers[index];
                              _model.incrementCardIndex();
                              await showDialog(
                                barrierColor:
                                    FlutterFlowTheme.of(context).transparent,
                                context: context,
                                builder: (dialogContext) {
                                  return Dialog(
                                    elevation: 0,
                                    insetPadding: EdgeInsets.zero,
                                    backgroundColor: Colors.transparent,
                                    alignment: AlignmentDirectional(0.0, 1.0)
                                        .resolve(Directionality.of(context)),
                                    child: GestureDetector(
                                      onTap: () {
                                        FocusScope.of(dialogContext).unfocus();
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                      },
                                      child: AddedToFavoritesWidget(),
                                    ),
                                  );
                                },
                              );

                              await currentUserReference!.update({
                                ...mapToFirestore(
                                  {
                                    'myFavourites': FieldValue.arrayUnion(
                                        [stackUsersItem.reference]),
                                  },
                                ),
                              });
                            },
                            onDownSwipe: (index) {},
                            itemBuilder: (context, stackUsersIndex) {
                              final stackUsersItem =
                                  stackUsers[stackUsersIndex];
                              return Visibility(
                                visible: stackUsersItem.reference !=
                                    currentUserReference,
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    context.pushNamed(
                                      SinglePageWidget.routeName,
                                      queryParameters: {
                                        'userRef': serializeParam(
                                          stackUsersItem.reference,
                                          ParamType.DocumentReference,
                                        ),
                                      }.withoutNulls,
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .primaryBackground,
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: profileImageProvider(
                                          stackUsersItem.photoUrl,
                                        ),
                                      ),
                                      borderRadius: BorderRadius.circular(18.0),
                                    ),
                                    child: Stack(
                                      alignment: AlignmentDirectional(0.0, 1.0),
                                      children: [
                                        // Compatibility Badge - Top Right
                                        Positioned(
                                          top: 15.0,
                                          right: 15.0,
                                          child: AuthUserStreamWidget(
                                            builder: (context) {
                                              int compatibilityScore = widget!.fromFilter 
                                                  ? functions.calculateFilteredCompatibilityScore(
                                                      currentUserDocument?.interests,
                                                      stackUsersItem.interests,
                                                      currentUserDocument?.languages,
                                                      stackUsersItem.languages,
                                                      currentUserDocument?.religion,
                                                      stackUsersItem.religion,
                                                      currentUserDocument?.relationshipGoals,
                                                      stackUsersItem.relationshipGoals,
                                                      FFAppState().filterInterests,
                                                      FFAppState().filterLanguages,
                                                      currentUserDocument?.userGender,
                                                      stackUsersItem.userGender,
                                                      currentUserDocument?.age,
                                                      stackUsersItem.age,
                                                    )
                                                  : functions.calculateCompatibilityScore(
                                                      currentUserDocument?.interests,
                                                      stackUsersItem.interests,
                                                      currentUserDocument?.languages,
                                                      stackUsersItem.languages,
                                                      currentUserDocument?.religion,
                                                      stackUsersItem.religion,
                                                      currentUserDocument?.relationshipGoals,
                                                      stackUsersItem.relationshipGoals,
                                                    );
                                              
                                              if (compatibilityScore <= 0) {
                                                return SizedBox.shrink();
                                              }
                                              
                                              return Container(
                                                height: 28.0,
                                                decoration: BoxDecoration(
                                                  color: compatibilityScore >= 70 
                                                      ? FlutterFlowTheme.of(context).success
                                                      : compatibilityScore >= 40
                                                          ? FlutterFlowTheme.of(context).warning
                                                          : FlutterFlowTheme.of(context).error,
                                                  borderRadius: BorderRadius.circular(14.0),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional.fromSTEB(
                                                      10.0, 5.0, 10.0, 5.0),
                                                  child: Text(
                                                    '$compatibilityScore%',
                                                    style: FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .override(
                                                          fontFamily: 'Onest',
                                                          color: FlutterFlowTheme.of(context).info,
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        Container(
                                          width: double.infinity,
                                          height: 250.0,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                FlutterFlowTheme.of(context)
                                                    .transparent,
                                                FlutterFlowTheme.of(context)
                                                    .everBlack
                                              ],
                                              stops: [0.1, 0.9],
                                              begin: AlignmentDirectional(
                                                  0.0, -1.0),
                                              end: AlignmentDirectional(0, 1.0),
                                            ),
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(18.0),
                                              bottomRight:
                                                  Radius.circular(18.0),
                                              topLeft: Radius.circular(0.0),
                                              topRight: Radius.circular(0.0),
                                            ),
                                          ),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    20.0, 80.0, 20.0, 20.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Text(
                                                          '${valueOrDefault<String>(
                                                            stackUsersItem
                                                                .displayName,
                                                            'Alick',
                                                          )} (${valueOrDefault<String>(
                                                            stackUsersItem.age
                                                                .toString(),
                                                            '22',
                                                          )})',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .headlineLarge
                                                              .override(
                                                                fontFamily:
                                                                    'Onest',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .info,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                    AuthUserStreamWidget(
                                                      builder: (context) =>
                                                          Text(
                                                        valueOrDefault<String>(
                                                          functions.metersaway(
                                                              currentUserDocument
                                                                  ?.location,
                                                              stackUsersItem
                                                                  .location),
                                                          'missing user location',
                                                        ),
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Onest',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .info,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    InkWell(
                                                      splashColor:
                                                          Colors.transparent,
                                                      focusColor:
                                                          Colors.transparent,
                                                      hoverColor:
                                                          Colors.transparent,
                                                      highlightColor:
                                                          Colors.transparent,
                                                      onTap: () async {
                                                        if (_model.isReloading) return;
                                                        
                                                        _model.isReloading = true;
                                                        safeSetState(() {});
                                                        
                                                        // Get recently skipped users (within last 48 hours)
                                                        final DateTime fortyEightHoursAgo = DateTime.now().subtract(Duration(hours: 48));
                                                        final recentSkips = await querySwipesRecordOnce(
                                                          queryBuilder: (swipesRecord) => swipesRecord
                                                              .where('swiperId', isEqualTo: currentUserReference)
                                                              .where('type', isEqualTo: false)
                                                              .where('timestamp', isGreaterThanOrEqualTo: fortyEightHoursAgo),
                                                        );
                                                        final skippedUserRefs = recentSkips.map((e) => e.targetuserid).whereType<DocumentReference>().toList();
                                                        
                                                        if (((FFAppState().algoliaResults.isNotEmpty) == true) && widget!.fromFilter) {
                                                          _model.filteredUsers = await queryUsersRecordOnce(
                                                            queryBuilder: (usersRecord) => usersRecord
                                                                .whereIn(
                                                                    'uid',
                                                                    functions
                                                                        .firebaseFromJson(FFAppState().algoliaResults.toList())
                                                                        .map((e) => e.id)
                                                                        .toList())
                                                                .whereNotIn(
                                                                    'uid',
                                                                    (currentUserDocument?.myMatches?.toList() ?? [])
                                                                        .map((e) => e.id)
                                                                        .toList()),
                                                          );
                                                          // Filter out recently skipped users (within 48 hours)
                                                          List<UsersRecord> sortedFilteredUsers = _model.filteredUsers!
                                                              .where((user) => !skippedUserRefs.contains(user.reference))
                                                              .toList();
                                                          if (currentUserDocument?.location != null) {
                                                            sortedFilteredUsers.sort((a, b) {
                                                              int compatibilityA = functions.calculateFilteredCompatibilityScore(
                                                                currentUserDocument?.interests,
                                                                a.interests,
                                                                currentUserDocument?.languages,
                                                                a.languages,
                                                                currentUserDocument?.religion,
                                                                a.religion,
                                                                currentUserDocument?.relationshipGoals,
                                                                a.relationshipGoals,
                                                                FFAppState().filterInterests,
                                                                FFAppState().filterLanguages,
                                                                currentUserDocument?.userGender,
                                                                a.userGender,
                                                                currentUserDocument?.age,
                                                                a.age,
                                                              );
                                                              int compatibilityB = functions.calculateFilteredCompatibilityScore(
                                                                currentUserDocument?.interests,
                                                                b.interests,
                                                                currentUserDocument?.languages,
                                                                b.languages,
                                                                currentUserDocument?.religion,
                                                                b.religion,
                                                                currentUserDocument?.relationshipGoals,
                                                                b.relationshipGoals,
                                                                FFAppState().filterInterests,
                                                                FFAppState().filterLanguages,
                                                                currentUserDocument?.userGender,
                                                                b.userGender,
                                                                currentUserDocument?.age,
                                                                b.age,
                                                              );
                                                              if (compatibilityA != compatibilityB) {
                                                                return compatibilityB - compatibilityA;
                                                              }
                                                              if (a.location != null && b.location != null) {
                                                                double distanceA = functions.calculateDistance(currentUserDocument!.location!, a.location!);
                                                                double distanceB = functions.calculateDistance(currentUserDocument!.location!, b.location!);
                                                                return distanceA.compareTo(distanceB);
                                                              }
                                                              return 0;
                                                            });
                                                          }
                                                          _model.users = sortedFilteredUsers.toList().cast<UsersRecord>();
                                                          _model.currentCardIndex = 0;
                                                        } else {
                                                          _model.defaultUsers = await queryUsersRecordOnce(
                                                            queryBuilder: (usersRecord) => usersRecord.whereNotIn(
                                                                'uid',
                                                                (currentUserDocument?.myMatches?.toList() ?? [])
                                                                    .map((e) => e.id)
                                                                    .toList()),
                                                            limit: 20,
                                                          );
                                                          // Filter out recently skipped users (within 48 hours)
                                                          List<UsersRecord> sortedUsers = _model.defaultUsers!
                                                              .where((user) => !skippedUserRefs.contains(user.reference))
                                                              .toList();
                                                          if (currentUserDocument?.location != null) {
                                                            sortedUsers.sort((a, b) {
                                                              int compatibilityA = functions.calculateCompatibilityScore(
                                                                currentUserDocument?.interests,
                                                                a.interests,
                                                                currentUserDocument?.languages,
                                                                a.languages,
                                                                currentUserDocument?.religion,
                                                                a.religion,
                                                                currentUserDocument?.relationshipGoals,
                                                                a.relationshipGoals,
                                                              );
                                                              int compatibilityB = functions.calculateCompatibilityScore(
                                                                currentUserDocument?.interests,
                                                                b.interests,
                                                                currentUserDocument?.languages,
                                                                b.languages,
                                                                currentUserDocument?.religion,
                                                                b.religion,
                                                                currentUserDocument?.relationshipGoals,
                                                                b.relationshipGoals,
                                                              );
                                                              if (compatibilityA != compatibilityB) {
                                                                return compatibilityB - compatibilityA;
                                                              }
                                                              if (a.location != null && b.location != null) {
                                                                double distanceA = functions.calculateDistance(currentUserDocument!.location!, a.location!);
                                                                double distanceB = functions.calculateDistance(currentUserDocument!.location!, b.location!);
                                                                return distanceA.compareTo(distanceB);
                                                              }
                                                              return 0;
                                                            });
                                                          }
                                                          _model.users = sortedUsers.take(10).toList().cast<UsersRecord>();
                                                          _model.currentCardIndex = 0;
                                                        }
                                                        
                                                        _model.isReloading = false;
                                                        safeSetState(() {});
                                                        
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                              'Refreshed matching options',
                                                              style: TextStyle(
                                                                color: FlutterFlowTheme.of(context).primaryText,
                                                              ),
                                                            ),
                                                            duration: Duration(milliseconds: 2000),
                                                            backgroundColor: FlutterFlowTheme.of(context).success,
                                                          ),
                                                        );
                                                      },
                                                      child: Material(
                                                        color: Colors.transparent,
                                                        elevation: 0.0,
                                                        shape:
                                                            const CircleBorder(),
                                                        child: Container(
                                                          width: 48.0,
                                                          height: 48.0,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .transparent,
                                                            shape:
                                                                BoxShape.circle,
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .success,
                                                              width: 1.0,
                                                            ),
                                                          ),
                                                          child: Align(
                                                            alignment:
                                                                AlignmentDirectional(
                                                                    0.0, 0.0),
                                                            child: _model.isReloading
                                                                ? SizedBox(
                                                                    width: 24.0,
                                                                    height: 24.0,
                                                                    child: SpinKitFadingCircle(
                                                                      color: FlutterFlowTheme.of(context).success,
                                                                      size: 24.0,
                                                                    ),
                                                                  )
                                                                : Icon(
                                                                    FFIcons
                                                                        .krefresh80dp000000FILL1Wght400GRAD0Opsz48,
                                                                    color: FlutterFlowTheme
                                                                            .of(context)
                                                                        .success,
                                                                    size: 32.0,
                                                                  ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      splashColor:
                                                          Colors.transparent,
                                                      focusColor:
                                                          Colors.transparent,
                                                      hoverColor:
                                                          Colors.transparent,
                                                      highlightColor:
                                                          Colors.transparent,
                                                      onTap: () async {
                                                        if (_model.currentCardIndex < _model.users.length) {
                                                          final stackUsersItem = _model.users[_model.currentCardIndex];
                                                          
                                                          // Create skip record with 48-hour timestamp
                                                          await SwipesRecord.collection.add(createSwipesRecordData(
                                                            type: false,
                                                            timestamp: getCurrentTimestamp,
                                                            swiperId: currentUserReference,
                                                            targetuserid: stackUsersItem.reference,
                                                          ));
                                                        }
                                                        
                                                        _model
                                                            .swipeableStackController
                                                            .swipeLeft();
                                                      },
                                                      child: Material(
                                                        color:
                                                            Colors.transparent,
                                                        elevation: 0.0,
                                                        shape:
                                                            const CircleBorder(),
                                                        child: Container(
                                                          width: 53.0,
                                                          height: 53.0,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .transparent,
                                                            shape:
                                                                BoxShape.circle,
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .error,
                                                              width: 1.0,
                                                            ),
                                                          ),
                                                          child: Align(
                                                            alignment:
                                                                AlignmentDirectional(
                                                                    0.0, 0.0),
                                                            child: Icon(
                                                              FFIcons.kcloseLG,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .error,
                                                              size: 23.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ).addWalkthrough(
                                                      containerZadcvt62,
                                                      _model
                                                          .walkthroughController,
                                                    ),
                                                    InkWell(
                                                      splashColor:
                                                          Colors.transparent,
                                                      focusColor:
                                                          Colors.transparent,
                                                      hoverColor:
                                                          Colors.transparent,
                                                      highlightColor:
                                                          Colors.transparent,
                                                      onTap: () async {
                                                        _model
                                                            .swipeableStackController
                                                            .swipeTop();
                                                      },
                                                      child: Material(
                                                        color:
                                                            Colors.transparent,
                                                        elevation: 0.0,
                                                        shape:
                                                            const CircleBorder(),
                                                        child: Container(
                                                          width: 58.0,
                                                          height: 58.0,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .transparent,
                                                            shape:
                                                                BoxShape.circle,
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .warning,
                                                              width: 1.0,
                                                            ),
                                                          ),
                                                          child: Align(
                                                            alignment:
                                                                AlignmentDirectional(
                                                                    0.0, 0.0),
                                                            child: Icon(
                                                              FFIcons
                                                                  .kgrade80dp000000FILL1Wght400GRAD0Opsz48,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .warning,
                                                              size: 37.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ).addWalkthrough(
                                                      containerEgho0w4e,
                                                      _model
                                                          .walkthroughController,
                                                    ),
                                                    InkWell(
                                                      splashColor:
                                                          Colors.transparent,
                                                      focusColor:
                                                          Colors.transparent,
                                                      hoverColor:
                                                          Colors.transparent,
                                                      highlightColor:
                                                          Colors.transparent,
                                                      onTap: () async {
                                                        _model
                                                            .swipeableStackController
                                                            .swipeRight();
                                                      },
                                                      child: Material(
                                                        color:
                                                            Colors.transparent,
                                                        elevation: 0.0,
                                                        shape:
                                                            const CircleBorder(),
                                                        child: Container(
                                                          width: 53.0,
                                                          height: 53.0,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .transparent,
                                                            shape:
                                                                BoxShape.circle,
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primary,
                                                              width: 1.0,
                                                            ),
                                                          ),
                                                          child: Align(
                                                            alignment:
                                                                AlignmentDirectional(
                                                                    0.0, 0.0),
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          3.0,
                                                                          0.0,
                                                                          0.0),
                                                              child: Icon(
                                                                FFIcons
                                                                    .kfavorite80dp000000FILL1Wght400GRAD0Opsz48,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primary,
                                                                size: 32.0,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ).addWalkthrough(
                                                      containerT7fzt027,
                                                      _model
                                                          .walkthroughController,
                                                    ),
                                                    Material(
                                                      color: Colors.transparent,
                                                      elevation: 0.0,
                                                      shape:
                                                          const CircleBorder(),
                                                      child: Container(
                                                        width: 48.0,
                                                        height: 48.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .transparent,
                                                          shape:
                                                              BoxShape.circle,
                                                          border: Border.all(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .accent4,
                                                            width: 1.0,
                                                          ),
                                                        ),
                                                        child: Align(
                                                          alignment:
                                                              AlignmentDirectional(
                                                                  0.0, 0.0),
                                                          child: Icon(
                                                            FFIcons.kbolt,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .accent4,
                                                            size: 30.0,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: stackUsers.length,
                            controller: _model.swipeableStackController,
                            loop: true,
                            cardDisplayCount: 3,
                            scale: 0.9,
                            maxAngle: 30.0,
                            cardPadding: EdgeInsetsDirectional.fromSTEB(
                                15.0, 15.0, 15.0, 15.0),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                wrapWithModel(
                  model: _model.navbarModel,
                  updateCallback: () => safeSetState(() {}),
                  child: NavbarWidget(
                    pages: 0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TutorialCoachMark createPageWalkthrough(BuildContext context) =>
      TutorialCoachMark(
        targets: createWalkthroughTargets(context),
        onFinish: () async {
          safeSetState(() => _model.walkthroughController = null);
        },
        onSkip: () {
          return true;
        },
      );
}
