import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/chats/new_matches/new_matches_widget.dart';
import '/chats/skeleton_loading_match/skeleton_loading_match_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/home/navbar/navbar_widget.dart';
import '/matches/single_options/single_options_widget.dart';
import '/matches/single_page/single_page_widget.dart';
import '/matches/matches/matches_widget.dart';
import 'dart:math';
import 'dart:ui';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'chats_model.dart';
export 'chats_model.dart';
import '/custom_code/actions/index.dart' as custom_actions;

class ChatsWidget extends StatefulWidget {
  const ChatsWidget({super.key});

  static String routeName = 'Chats';
  static String routePath = '/chats';

  @override
  State<ChatsWidget> createState() => _ChatsWidgetState();
}

class _ChatsWidgetState extends State<ChatsWidget>
    with TickerProviderStateMixin {
  late ChatsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ChatsModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.unreadChats = await queryChatsRecordCount(
        queryBuilder: (chatsRecord) => chatsRecord.where(
          'lastSeenBy',
          arrayContains: currentUserReference,
        ),
      );

      // Deduplicate chats for the current user to ensure only one chat per pair exists.
      if (currentUserReference != null) {
        await custom_actions.dedupeChatsForUser(currentUserReference!);
      }
    });

    animationsMap.addAll({
      'columnOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 150.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
        ],
      ),
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(15.0, 15.5, 0.0, 0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            FFAppState().addedUserList = [];
                            safeSetState(() {});
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'addedfriendlist cleared',
                                  style: TextStyle(
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                  ),
                                ),
                                duration: Duration(milliseconds: 4000),
                                backgroundColor:
                                    FlutterFlowTheme.of(context).secondary,
                              ),
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(0.0),
                            child: Image.asset(
                              'assets/images/Vuka_Logo-Original.png',
                              width: 35.0,
                              height: 35.0,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              8.0, 0.0, 0.0, 0.0),
                          child: Text(
                            'Chats',
                            style: FlutterFlowTheme.of(context)
                                .titleMedium
                                .override(
                                  fontFamily: 'Onest',
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              6.0, 0.0, 6.0, 0.0),
                          child: FlutterFlowIconButton(
                            borderColor:
                                FlutterFlowTheme.of(context).transparent,
                            borderRadius: 30.0,
                            borderWidth: 0.0,
                            buttonSize: 40.0,
                            fillColor: FlutterFlowTheme.of(context).transparent,
                            icon: Icon(
                              FFIcons.kmoreVertical,
                              color: FlutterFlowTheme.of(context).primaryText,
                              size: 24.0,
                            ),
                            onPressed: () async {
                              await action_blocks.wait(context);
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
                                      child: SingleOptionsWidget(),
                                    ),
                                  );
                                },
                              ).then((value) => safeSetState(() {}));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                15.0, 17.0, 15.0, 0.0),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                context.pushNamed(SearchWidget.routeName);
                              },
                              child: Container(
                                width: double.infinity,
                                height: 48.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .primaryBackground,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      12.0, 0.0, 12.0, 0.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Icon(
                                        FFIcons.ksearchRefraction,
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        size: 22.0,
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            12.0, 0.0, 0.0, 0.0),
                                        child: Text(
                                          'Search',
                                          style: FlutterFlowTheme.of(context)
                                              .labelLarge
                                              .override(
                                                fontFamily: 'Onest',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                15.0, 18.0, 15.0, 0.0),
                            child: AuthUserStreamWidget(
                              builder: (context) {
                                final matches = (currentUserDocument?.myMatches
                                            ?.toList() ??
                                        [])
                                    .toList();
                                final pendingMatches = (currentUserDocument
                                            ?.myLikes
                                            ?.toList() ??
                                        [])
                                    .where((pendingRef) =>
                                        !(currentUserDocument?.myMatches
                                                ?.contains(pendingRef) ??
                                            false))
                                    .toList();
                                final theme = FlutterFlowTheme.of(context);

                                Widget buildSectionHeadline(
                                  String title,
                                  int count,
                                  Color badgeColor,
                                ) {
                                  return Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(
                                        title,
                                        style: theme.titleSmall.override(
                                              fontFamily: 'Onest',
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                      SizedBox(width: 8.0),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10.0,
                                          vertical: 4.0,
                                        ),
                                        decoration: BoxDecoration(
                                          color: badgeColor.withOpacity(0.18),
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                        ),
                                        child: Text(
                                          count.toString(),
                                          style: theme.labelMedium.override(
                                                fontFamily: 'Onest',
                                                color: badgeColor,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ),
                                    ],
                                  );
                                }

                                if (matches.isEmpty &&
                                    pendingMatches.isEmpty) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          theme.primary.withOpacity(0.12),
                                          theme.secondaryBackground,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(26.0),
                                      border: Border.all(
                                        color: theme.accent1,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              theme.accent3.withOpacity(0.15),
                                          blurRadius: 28.0,
                                          offset: Offset(0.0, 16.0),
                                        ),
                                      ],
                                    ),
                                    padding: EdgeInsets.all(22.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'No matches yet',
                                                style: theme.titleMedium
                                                    .override(
                                                  fontFamily: 'Onest',
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                            Icon(
                                              Icons.rocket_launch_rounded,
                                              color: theme.primary,
                                              size: 24.0,
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8.0),
                                        Text(
                                          'Head to Discover to keep swiping and build your match list.',
                                          style: theme.bodyMedium.override(
                                                fontFamily: 'Onest',
                                                color: theme.secondaryText,
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                        SizedBox(height: 18.0),
                                        FFButtonWidget(
                                          onPressed: () {
                                            context.pushNamed(
                                                MatchesWidget.routeName);
                                          },
                                          text: 'Find Matches',
                                          options: FFButtonOptions(
                                            height: 44.0,
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 24.0,
                                            ),
                                            iconPadding: EdgeInsets.zero,
                                            color: theme.primary,
                                            textStyle:
                                                theme.titleSmall.override(
                                              fontFamily: 'Onest',
                                              color: theme.info,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            elevation: 0.0,
                                            borderSide: BorderSide(
                                              color: theme.primary,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(24.0),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }

                                return Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        theme.primary.withOpacity(0.12),
                                        theme.secondaryBackground,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(26.0),
                                    border: Border.all(
                                      color: theme.accent1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: theme.accent3.withOpacity(0.12),
                                        blurRadius: 28.0,
                                        offset: Offset(0.0, 16.0),
                                      ),
                                    ],
                                  ),
                                  padding: EdgeInsets.all(20.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'New Matches',
                                                  style: theme.titleMedium
                                                      .override(
                                                    fontFamily: 'Onest',
                                                    letterSpacing: 0.0,
                                                    fontWeight:
                                                        FontWeight.w700,
                                                  ),
                                                ),
                                                SizedBox(height: 4.0),
                                                Text(
                                                  'Keep the energy going with people who recently matched with you.',
                                                  style: theme.bodySmall
                                                      .override(
                                                    fontFamily: 'Onest',
                                                    color:
                                                        theme.secondaryText,
                                                    letterSpacing: 0.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(10.0),
                                            decoration: BoxDecoration(
                                              color: theme.primary
                                                  .withOpacity(0.12),
                                              borderRadius:
                                                  BorderRadius.circular(16.0),
                                            ),
                                            child: Icon(
                                              Icons.favorite_rounded,
                                              color: theme.primary,
                                              size: 24.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (matches.isNotEmpty) ...[
                                        SizedBox(height: 20.0),
                                        buildSectionHeadline(
                                          'Ready to chat',
                                          matches.length,
                                          theme.primary,
                                        ),
                                        SizedBox(height: 12.0),
                                        SizedBox(
                                          height: 216.0,
                                          child: ListView.separated(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 4.0,
                                            ),
                                            primary: false,
                                            scrollDirection: Axis.horizontal,
                                            physics:
                                                BouncingScrollPhysics(),
                                            itemCount: matches.length,
                                            separatorBuilder: (_, __) =>
                                                SizedBox(width: 12.0),
                                            itemBuilder:
                                                (context, matchesIndex) {
                                              final matchesItem =
                                                  matches[matchesIndex];
                                              return InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () async {
                                                  // Ensure a unique chat per pair of users by using a deterministic
                                                  // document ID. If it already exists, reuse it.
                                                  final chatDocId =
                                                      functions.chatDocId(
                                                          currentUserReference!,
                                                          matchesItem);
                                                  final chatsRecordReference =
                                                      ChatsRecord.collection
                                                          .doc(chatDocId);

                                                  final existing =
                                                      await chatsRecordReference
                                                          .get();

                                                  if (existing.exists) {
                                                    _model.newchat =
                                                        ChatsRecord.fromSnapshot(
                                                            existing);
                                                  } else {
                                                    final data = {
                                                      ...createChatsRecordData(
                                                        lastMessage:
                                                            'Say Hello',
                                                        lastMessageTime:
                                                            getCurrentTimestamp,
                                                      ),
                                                      ...mapToFirestore({
                                                        'userIDs': functions
                                                            .newCustomFunction(
                                                                currentUserReference!,
                                                                matchesItem),
                                                        'userName': (String
                                                            authUser,
                                                            String otherUser) {
                                                          return [
                                                            authUser,
                                                            otherUser
                                                          ];
                                                        }(currentUserDisplayName,
                                                            matchesItem.id),
                                                      }),
                                                    };
                                                    await chatsRecordReference
                                                        .set(data);
                                                    _model.newchat =
                                                        ChatsRecord
                                                            .getDocumentFromData(
                                                                data,
                                                                chatsRecordReference);
                                                  }
                                                  FFAppState()
                                                      .addToAddedUserList(
                                                          matchesItem.id);
                                                  safeSetState(() {});

                                                  await currentUserReference!
                                                      .update({
                                                    ...mapToFirestore(
                                                      {
                                                        'myMatches': FieldValue
                                                            .arrayRemove(
                                                                [matchesItem]),
                                                      },
                                                    ),
                                                  });

                                                  context.pushNamed(
                                                    SingleChatWidget.routeName,
                                                    queryParameters: {
                                                      'recieveChats':
                                                          serializeParam(
                                                        _model
                                                            .newchat?.reference,
                                                        ParamType
                                                            .DocumentReference,
                                                      ),
                                                      'chatWithName':
                                                          serializeParam(
                                                        currentUserDisplayName,
                                                        ParamType.String,
                                                      ),
                                                    }.withoutNulls,
                                                  );

                                                  safeSetState(() {});
                                                },
                                                child: NewMatchesWidget(
                                                  key: Key(
                                                    'match_${matchesItem.id}_${matchesIndex}',
                                                  ),
                                                  userRef: matchesItem,
                                                  statusLabel: 'It\'s a match!',
                                                  statusColor: theme.primary,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                      if (pendingMatches.isNotEmpty) ...[
                                        SizedBox(
                                            height: matches.isNotEmpty
                                                ? 24.0
                                                : 20.0),
                                        buildSectionHeadline(
                                          'Awaiting reply',
                                          pendingMatches.length,
                                          theme.warning,
                                        ),
                                        SizedBox(height: 12.0),
                                        SizedBox(
                                          height: 216.0,
                                          child: ListView.separated(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 4.0,
                                            ),
                                            primary: false,
                                            scrollDirection: Axis.horizontal,
                                            physics:
                                                BouncingScrollPhysics(),
                                            itemCount: pendingMatches.length,
                                            separatorBuilder: (_, __) =>
                                                SizedBox(width: 12.0),
                                            itemBuilder:
                                                (context, pendingIndex) {
                                              final pendingItem =
                                                  pendingMatches[pendingIndex];
                                              return InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () async {
                                                  context.pushNamed(
                                                    SinglePageWidget.routeName,
                                                    queryParameters: {
                                                      'userRef': serializeParam(
                                                        pendingItem,
                                                        ParamType
                                                            .DocumentReference,
                                                      ),
                                                    }.withoutNulls,
                                                  );
                                                },
                                                child: NewMatchesWidget(
                                                  key: Key(
                                                    'pending_${pendingItem.id}_${pendingIndex}',
                                                  ),
                                                  userRef: pendingItem,
                                                  statusLabel: 'Awaiting reply',
                                                  statusColor: theme.warning,
                                                  isPending: true,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                15.0, 20.0, 15.0, 0.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  'New Messages',
                                  style: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: 'Onest',
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      6.0, 0.0, 0.0, 0.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          6.0, 3.0, 6.0, 3.0),
                                      child: Text(
                                        valueOrDefault<String>(
                                          _model.unreadChats?.toString(),
                                          'o',
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Onest',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .info,
                                              fontSize: 11.0,
                                              letterSpacing: 0.0,
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          StreamBuilder<List<ChatsRecord>>(
                            stream: queryChatsRecord(
                              queryBuilder: (chatsRecord) => chatsRecord
                                  .where(
                                    'userIDs',
                                    arrayContains: currentUserReference,
                                  )
                                  .orderBy('lastMessageTime', descending: true),
                            ),
                            builder: (context, snapshot) {
                              // Customize what your widget looks like when it's loading.
                              if (!snapshot.hasData) {
                                return SkeletonLoadingMatchWidget();
                              }
                              List<ChatsRecord> listViewChatsRecordList =
                                  snapshot.data!;

                              return ListView.separated(
                                padding: EdgeInsets.fromLTRB(
                                  0,
                                  10.0,
                                  0,
                                  15.0,
                                ),
                                primary: false,
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: listViewChatsRecordList.length,
                                separatorBuilder: (_, __) =>
                                    SizedBox(height: 0.0),
                                itemBuilder: (context, listViewIndex) {
                                  final listViewChatsRecord =
                                      listViewChatsRecordList[listViewIndex];
                                  
                                  // Get the other user's reference
                                  final otherUserRef = functions.getOtherUserRef(
                                      listViewChatsRecord.userIDs.toList(),
                                      currentUserReference!);
                                  
                                  // Skip if chatting with self
                                  if (otherUserRef == null || otherUserRef == currentUserReference) {
                                    return SizedBox.shrink();
                                  }
                                  
                                  return StreamBuilder<UsersRecord>(
                                    stream: UsersRecord.getDocument(otherUserRef),
                                    builder: (context, snapshot) {
                                      // Customize what your widget looks like when it's loading.
                                      if (!snapshot.hasData) {
                                        return Center(
                                          child: SizedBox(
                                            width: 30.0,
                                            height: 30.0,
                                            child: SpinKitFadingCircle(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              size: 30.0,
                                            ),
                                          ),
                                        );
                                      }

                                      final rowUsersRecord = snapshot.data!;
                                      final isPinned = listViewChatsRecord.pinnedBy.contains(currentUserReference);

                                      return Dismissible(
                                        key: Key('chat_${listViewChatsRecord.reference.id}'),
                                        confirmDismiss: (direction) async {
                                          if (direction == DismissDirection.endToStart) {
                                            // Show action bottom sheet
                                            await showModalBottomSheet(
                                              context: context,
                                              backgroundColor: Colors.transparent,
                                              builder: (context) => Container(
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(context).secondaryBackground,
                                                  borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
                                                ),
                                                padding: EdgeInsets.all(20.0),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    ListTile(
                                                      leading: Icon(Icons.delete_outline, color: FlutterFlowTheme.of(context).error),
                                                      title: Text('Delete', style: TextStyle(color: FlutterFlowTheme.of(context).error)),
                                                      onTap: () async {
                                                        Navigator.pop(context);
                                                        await listViewChatsRecord.reference.delete();
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          SnackBar(
                                                            content: Text('Chat deleted'),
                                                            duration: Duration(milliseconds: 2000),
                                                            backgroundColor: FlutterFlowTheme.of(context).error,
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                    ListTile(
                                                      leading: Icon(Icons.archive_outlined, color: FlutterFlowTheme.of(context).primary),
                                                      title: Text('Archive'),
                                                      onTap: () async {
                                                        Navigator.pop(context);
                                                        await listViewChatsRecord.reference.update({
                                                          'archivedBy': FieldValue.arrayUnion([currentUserReference]),
                                                        });
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          SnackBar(
                                                            content: Text('Chat archived'),
                                                            duration: Duration(milliseconds: 2000),
                                                            backgroundColor: FlutterFlowTheme.of(context).success,
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                    ListTile(
                                                      leading: Icon(
                                                        isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                                                        color: FlutterFlowTheme.of(context).primary,
                                                      ),
                                                      title: Text(isPinned ? 'Unpin Chat' : 'Pin Chat'),
                                                      onTap: () async {
                                                        Navigator.pop(context);
                                                        if (isPinned) {
                                                          await listViewChatsRecord.reference.update({
                                                            'pinnedBy': FieldValue.arrayRemove([currentUserReference]),
                                                          });
                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                            SnackBar(
                                                              content: Text('Chat unpinned'),
                                                              duration: Duration(milliseconds: 2000),
                                                              backgroundColor: FlutterFlowTheme.of(context).secondary,
                                                            ),
                                                          );
                                                        } else {
                                                          await listViewChatsRecord.reference.update({
                                                            'pinnedBy': FieldValue.arrayUnion([currentUserReference]),
                                                          });
                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                            SnackBar(
                                                              content: Text('Chat pinned'),
                                                              duration: Duration(milliseconds: 2000),
                                                              backgroundColor: FlutterFlowTheme.of(context).success,
                                                            ),
                                                          );
                                                        }
                                                      },
                                                    ),
                                                    ListTile(
                                                      leading: Icon(Icons.block, color: FlutterFlowTheme.of(context).error),
                                                      title: Text('Block User', style: TextStyle(color: FlutterFlowTheme.of(context).error)),
                                                      onTap: () async {
                                                        Navigator.pop(context);
                                                        await currentUserReference!.update({
                                                          ...mapToFirestore({
                                                            'ReportsBlockedUsers': FieldValue.arrayUnion([otherUserRef]),
                                                          }),
                                                        });
                                                        await listViewChatsRecord.reference.delete();
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          SnackBar(
                                                            content: Text('User blocked'),
                                                            duration: Duration(milliseconds: 2000),
                                                            backgroundColor: FlutterFlowTheme.of(context).error,
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                            return false;
                                          }
                                          return false;
                                        },
                                        background: Container(
                                          alignment: Alignment.centerRight,
                                          padding: EdgeInsets.only(right: 20.0),
                                          color: FlutterFlowTheme.of(context).primary,
                                          child: Icon(
                                            Icons.more_horiz,
                                            color: FlutterFlowTheme.of(context).info,
                                            size: 30.0,
                                          ),
                                        ),
                                        direction: DismissDirection.endToStart,
                                        child: Container(
                                          color: FlutterFlowTheme.of(context).secondaryBackground,
                                          child: InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                            onTap: () async {
                                              context.pushNamed(
                                                SingleChatWidget.routeName,
                                                queryParameters: {
                                                  'recieveChats': serializeParam(
                                                    listViewChatsRecord.reference,
                                                    ParamType.DocumentReference,
                                                  ),
                                                  'chatWithName': serializeParam(
                                                    rowUsersRecord.displayName,
                                                    ParamType.String,
                                                  ),
                                                }.withoutNulls,
                                              );
                                            },
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                if (isPinned)
                                                  Padding(
                                                    padding: EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 0.0, 0.0),
                                                    child: Icon(
                                                      Icons.push_pin,
                                                      color: FlutterFlowTheme.of(context).primary,
                                                      size: 18.0,
                                                    ),
                                                  ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          isPinned ? 8.0 : 15.0, 0.0, 0.0, 0.0),
                                                  child: Stack(
                                                alignment: AlignmentDirectional(
                                                    1.0, 1.0),
                                                children: [
                                                  Container(
                                                    width: 60.0,
                                                    height: 60.0,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .primaryBackground,
                                                      image: DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image:
                                                            profileImageProvider(
                                                          rowUsersRecord
                                                              .photoUrl,
                                                        ),
                                                      ),
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                  FutureBuilder<bool>(
                                                    future: _model.checkUserOnlineStatus(rowUsersRecord.reference),
                                                    builder: (context, onlineSnapshot) {
                                                      bool isOnline = onlineSnapshot.data ?? false;
                                                      
                                                      return Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(0.0, 0.0,
                                                                    5.0, 4.0),
                                                        child: Container(
                                                          width: 10.0,
                                                          height: 10.0,
                                                          decoration: BoxDecoration(
                                                            color: isOnline 
                                                                ? FlutterFlowTheme.of(context).success
                                                                : FlutterFlowTheme.of(context).error,
                                                            boxShadow: [
                                                              BoxShadow(
                                                                blurRadius: 0.0,
                                                                color: FlutterFlowTheme
                                                                        .of(context)
                                                                    .secondaryBackground,
                                                                offset: Offset(
                                                                  0.0,
                                                                  0.0,
                                                                ),
                                                                spreadRadius: 2.0,
                                                              )
                                                            ],
                                                            shape: BoxShape.circle,
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .transparent,
                                                              width: 0.0,
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        15.0, 0.0, 15.0, 0.0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  15.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            valueOrDefault<
                                                                String>(
                                                              rowUsersRecord
                                                                  .displayName,
                                                              'Alick',
                                                            ),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelLarge
                                                                .override(
                                                                  fontFamily:
                                                                      'Onest',
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                          ),
                                                          Text(
                                                            valueOrDefault<
                                                                String>(
                                                              dateTimeFormat(
                                                                "relative",
                                                                listViewChatsRecord
                                                                    .lastMessageTime,
                                                                locale: FFLocalizations.of(
                                                                        context)
                                                                    .languageCode,
                                                              ),
                                                              'a second ago',
                                                            ),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Onest',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryText,
                                                                  letterSpacing:
                                                                      0.0,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  7.0,
                                                                  0.0,
                                                                  15.0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            valueOrDefault<
                                                                String>(
                                                              listViewChatsRecord
                                                                  .lastMessage,
                                                              'Hey there hows it  going',
                                                            ),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelSmall
                                                                .override(
                                                                  fontFamily:
                                                                      'Onest',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryText,
                                                                  letterSpacing:
                                                                      0.0,
                                                                ),
                                                          ),
                                                          if (listViewChatsRecord
                                                                  .lastSeenBy
                                                                  .contains(
                                                                      currentUserReference) ==
                                                              false)
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          6.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondary,
                                                                  shape: BoxShape
                                                                      .circle,
                                                                ),
                                                                child: Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          6.0,
                                                                          3.0,
                                                                          6.0,
                                                                          3.0),
                                                                  child: Text(
                                                                    ' ',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Onest',
                                                                          color:
                                                                              FlutterFlowTheme.of(context).tertiary,
                                                                          fontSize:
                                                                              11.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                        ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      width: double.infinity,
                                                      height: 1.0,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .accent1,
                                                      ),
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
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            wrapWithModel(
              model: _model.navbarModel,
              updateCallback: () => safeSetState(() {}),
              child: NavbarWidget(
                pages: 2,
              ),
            ),
          ],
        ).animateOnPageLoad(animationsMap['columnOnPageLoadAnimation']!),
      ),
    );
  }
}
