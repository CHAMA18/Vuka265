import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/services/notification_service.dart';
import '/services/agora_service.dart';
import '/chats/video_call/video_call_widget.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import '/flutter_flow/upload_data.dart';
import '/backend/firebase_storage/storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'dart:io' as io;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';
import 'dart:ui';
import '/actions/actions.dart' as action_blocks;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'single_chat_model.dart';
export 'single_chat_model.dart';

class SingleChatWidget extends StatefulWidget {
  const SingleChatWidget({
    super.key,
    required this.recieveChats,
    required this.chatWithName,
  });

  final DocumentReference? recieveChats;
  final String? chatWithName;

  static String routeName = 'SingleChat';
  static String routePath = '/singleChat';

  @override
  State<SingleChatWidget> createState() => _SingleChatWidgetState();
}

class _SingleChatWidgetState extends State<SingleChatWidget> {
  late SingleChatModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Incoming call handling state
  final Set<String> _handledIncomingCallIds = <String>{};
  bool _showingIncomingCall = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SingleChatModel());

    _model.textMessageTextController ??= TextEditingController();
    _model.textMessageFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    // On page dispose action.
    () async {
      await widget!.recieveChats!.update({
        ...mapToFirestore(
          {
            'lastSeenBy': FieldValue.arrayUnion([currentUserReference]),
          },
        ),
      });
      
      // Only mark messages as read if the current user has readReceipts enabled
      // This respects the user's privacy setting
      if (currentUserDocument?.readReceipts == true) {
        final messagesSnapshot = await widget!.recieveChats!.collection('messages')
          .where('senderId', isNotEqualTo: currentUserReference)
          .where('isRead', isEqualTo: false)
          .get();
        
        for (final doc in messagesSnapshot.docs) {
          await doc.reference.update({'isRead': true});
        }
      }
    }();

    _model.dispose();

    super.dispose();
  }

  void _maybeShowIncomingCall(MessagesRecord callMsg) {
    // Only react to calls from the other user
    if (callMsg.senderId == currentUserReference) return;
    // Must be a call message
    final type = callMsg.messageType;
    final isCall = type == 'voice_call';
    if (!isCall) return;
    // Require a meetingId
    final meetingId = callMsg.mediaUrl;
    if (meetingId.isEmpty) return;
    // Only show incoming call if the message is recent (within last 60 seconds)
    final now = DateTime.now();
    final msgTime = callMsg.timestamp ?? now;
    final ageInSeconds = now.difference(msgTime).inSeconds;
    if (ageInSeconds > 60) return;
    // Prevent duplicate presentations
    if (_handledIncomingCallIds.contains(callMsg.reference.id) || _showingIncomingCall) return;

    _handledIncomingCallIds.add(callMsg.reference.id);
    _showingIncomingCall = true;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final isAudioOnly = type == 'voice_call';

      await showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierLabel: 'Incoming call',
        pageBuilder: (context, anim1, anim2) {
          return _IncomingCallOverlay(
            callerName: callMsg.senderName.isNotEmpty
                ? callMsg.senderName
                : (widget.chatWithName ?? 'Unknown'),
            onDecline: () async {
              if (Navigator.of(context).canPop()) Navigator.of(context).pop();
            },
            onAccept: () async {
              // Request permissions before joining
              if (!kIsWeb) {
                await Permission.microphone.request();
              }

              if (Navigator.of(context).canPop()) Navigator.of(context).pop();
              if (!mounted) return;
              context.pushNamed(
                VideoCallWidget.routeName,
                queryParameters: {
                  'meetingId': meetingId,
                  'userName': widget.chatWithName ?? callMsg.senderName,
                  'isAudioOnly': 'true',
                },
              );
            },
          );
        },
        transitionBuilder: (context, anim1, anim2, child) {
          return FadeTransition(
            opacity: CurvedAnimation(parent: anim1, curve: Curves.easeOut),
            child: child,
          );
        },
      );

      _showingIncomingCall = false;
    });
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
        body: AuthUserStreamWidget(
          builder: (context) => Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Color(0xFFF6F1F1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 18.0, 5.0, 5.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                6.0, 6.0, 10.0, 6.0),
                            child: FlutterFlowIconButton(
                              borderColor:
                                  FlutterFlowTheme.of(context).transparent,
                              borderRadius: 30.0,
                              borderWidth: 0.0,
                              buttonSize: 40.0,
                              fillColor:
                                  FlutterFlowTheme.of(context).transparent,
                              icon: Icon(
                                FFIcons.karrowLeftMD,
                                color: FlutterFlowTheme.of(context).primaryText,
                                size: 25.0,
                              ),
                              onPressed: () async {
                                await action_blocks.wait(context);
                                context.safePop();
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 12.0, 0.0),
                            child: Container(
                              width: 40.0,
                              height: 40.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .primaryBackground,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: const AssetImage('assets/images/user.png'),
                                ),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                valueOrDefault<String>(
                                  widget!.chatWithName,
                                  'Alick',
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
                                      fontFamily: 'Onest',
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 3.0, 0.0, 0.0),
                                child: StreamBuilder<ChatsRecord>(
                                  stream: ChatsRecord.getDocument(
                                      widget!.recieveChats!),
                                  builder: (context, snapshot) {
                                    // Customize what your widget looks like when it's loading.
                                    if (!snapshot.hasData) {
                                      return Center(
                                        child: SizedBox(
                                          width: 30.0,
                                          height: 30.0,
                                          child: SpinKitFadingCircle(
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                            size: 30.0,
                                          ),
                                        ),
                                      );
                                    }

                                    final textChatsRecord = snapshot.data!;

                                    return Text(
                                      'Online ${valueOrDefault<String>(
                                        dateTimeFormat(
                                          "relative",
                                          textChatsRecord.lastMessageTime,
                                          locale: FFLocalizations.of(context)
                                              .languageCode,
                                        ),
                                        '3 minutes ago',
                                      )}',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyLarge
                                          .override(
                                            fontFamily: 'Onest',
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            fontSize: 12.0,
                                            letterSpacing: 0.0,
                                          ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            6.0, 6.0, 6.0, 6.0),
                        child: FlutterFlowIconButton(
                          borderColor: FlutterFlowTheme.of(context).accent1,
                          borderRadius: 30.0,
                          borderWidth: 1.0,
                          buttonSize: 40.0,
                          fillColor:
                              FlutterFlowTheme.of(context).transparent,
                          icon: Icon(
                            FFIcons.kphoneCall01,
                            color: FlutterFlowTheme.of(context).primaryText,
                            size: 22.0,
                          ),
                          onPressed: () async {
                            // Voice call
                            await _handleVoiceCall(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              15.0, 0.0, 15.0, 0.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: StreamBuilder<List<MessagesRecord>>(
                                  stream: queryMessagesRecord(
                                    parent: widget!.recieveChats,
                                    queryBuilder: (messagesRecord) =>
                                        messagesRecord.orderBy('timestamp',
                                            descending: true),
                                  ),
                                  builder: (context, snapshot) {
                                    // Customize what your widget looks like when it's loading.
                                    if (!snapshot.hasData) {
                                      return Center(
                                        child: SizedBox(
                                          width: 30.0,
                                          height: 30.0,
                                          child: SpinKitFadingCircle(
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                            size: 30.0,
                                          ),
                                        ),
                                      );
                                    }
                                    List<MessagesRecord>
                                        listViewMessagesRecordList =
                                        snapshot.data!;

                                     // Surface incoming call ring if a new call message arrives from the other user
                                     for (final m in listViewMessagesRecordList) {
                                       if (m.messageType == 'voice_call' && m.senderId != currentUserReference) {
                                         _maybeShowIncomingCall(m);
                                         break;
                                       }
                                     }

                                    return ListView.separated(
                                      padding: EdgeInsets.zero,
                                      reverse: true,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemCount:
                                          listViewMessagesRecordList.length,
                                      separatorBuilder: (_, __) =>
                                          SizedBox(height: 15.0),
                                      itemBuilder: (context, listViewIndex) {
                                        final listViewMessagesRecord =
                                            listViewMessagesRecordList[
                                                listViewIndex];
                                        return Stack(
                                          children: [
                                            if (listViewMessagesRecord
                                                    .senderId !=
                                                currentUserReference)
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 0.0, 40.0, 0.0),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Flexible(
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    10.0,
                                                                    10.0,
                                                                    10.0,
                                                                    10.0),
                                                        child: InkWell(
                                                          splashColor: Colors
                                                              .transparent,
                                                          focusColor: Colors
                                                              .transparent,
                                                          hoverColor: Colors
                                                              .transparent,
                                                          highlightColor: Colors
                                                              .transparent,
                                                          onLongPress:
                                                              () async {
                                                            await Clipboard.setData(
                                                                ClipboardData(
                                                                    text: listViewMessagesRecord
                                                                        .messageText));
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              SnackBar(
                                                                content: Text(
                                                                  'messasge copied',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                                duration: Duration(
                                                                    milliseconds:
                                                                        500),
                                                                backgroundColor:
                                                                    FlutterFlowTheme.of(
                                                                            context)
                                                                        .secondaryText,
                                                              ),
                                                            );
                                                          },
                                                          child: Material(
                                                            color: Colors
                                                                .transparent,
                                                            elevation: 1.0,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        1.0),
                                                                bottomRight: Radius
                                                                    .circular(
                                                                        8.0),
                                                                topLeft: Radius
                                                                    .circular(
                                                                        8.0),
                                                                topRight: Radius
                                                                    .circular(
                                                                        8.0),
                                                              ),
                                                            ),
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryBackground,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .only(
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          1.0),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          8.0),
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          8.0),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          8.0),
                                                                ),
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            10.0),
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    if (listViewMessagesRecord.messageType == 'image' && 
                                                                        listViewMessagesRecord.mediaUrl.isNotEmpty)
                                                                      InkWell(
                                                                        onTap: () {
                                                                          showDialog(
                                                                            context: context,
                                                                            builder: (context) => Dialog(
                                                                              backgroundColor: Colors.transparent,
                                                                              child: Stack(
                                                                                children: [
                                                                                  Center(
                                                                                    child: InteractiveViewer(
                                                                                      child: Image.network(
                                                                                        listViewMessagesRecord.mediaUrl,
                                                                                        fit: BoxFit.contain,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Positioned(
                                                                                    top: 10,
                                                                                    right: 10,
                                                                                    child: IconButton(
                                                                                      icon: Icon(Icons.close, color: Colors.white, size: 30),
                                                                                      onPressed: () => Navigator.of(context).pop(),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          );
                                                                        },
                                                                        child: ClipRRect(
                                                                          borderRadius: BorderRadius.circular(8.0),
                                                                          child: Image.network(
                                                                            listViewMessagesRecord.mediaUrl,
                                                                            width: 200.0,
                                                                            fit: BoxFit.cover,
                                                                            errorBuilder: (context, error, stackTrace) => 
                                                                              Icon(Icons.broken_image, size: 50),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    if (listViewMessagesRecord.messageType == 'audio' && 
                                                                        listViewMessagesRecord.mediaUrl.isNotEmpty)
                                                                      Row(
                                                                        children: [
                                                                          Icon(Icons.audiotrack, 
                                                                            color: FlutterFlowTheme.of(context).primary),
                                                                          SizedBox(width: 8),
                                                                          Text('Audio message', 
                                                                            style: FlutterFlowTheme.of(context).bodySmall),
                                                                        ],
                                                                      ),
                                                                    if (listViewMessagesRecord.messageType == 'document' && 
                                                                        listViewMessagesRecord.mediaUrl.isNotEmpty)
                                                                      Row(
                                                                        children: [
                                                                          Icon(Icons.insert_drive_file, 
                                                                            color: FlutterFlowTheme.of(context).primary),
                                                                          SizedBox(width: 8),
                                                                          Text('Document', 
                                                                            style: FlutterFlowTheme.of(context).bodySmall),
                                                                        ],
                                                                      ),
                                                                    if (listViewMessagesRecord.messageType == 'video' && 
                                                                        listViewMessagesRecord.mediaUrl.isNotEmpty)
                                                                      ClipRRect(
                                                                        borderRadius: BorderRadius.circular(8.0),
                                                                        child: Stack(
                                                                          alignment: Alignment.center,
                                                                          children: [
                                                                            Image.network(
                                                                              listViewMessagesRecord.mediaUrl,
                                                                              width: 200.0,
                                                                              height: 150.0,
                                                                              fit: BoxFit.cover,
                                                                              errorBuilder: (context, error, stackTrace) => 
                                                                                Container(
                                                                                  width: 200.0,
                                                                                  height: 150.0,
                                                                                  color: FlutterFlowTheme.of(context).primaryBackground,
                                                                                  child: Icon(Icons.videocam, size: 50, color: FlutterFlowTheme.of(context).primary),
                                                                                ),
                                                                            ),
                                                                            Container(
                                                                              padding: EdgeInsets.all(8),
                                                                              decoration: BoxDecoration(
                                                                                color: Colors.black.withValues(alpha: 0.5),
                                                                                shape: BoxShape.circle,
                                                                              ),
                                                                              child: Icon(Icons.play_arrow, color: Colors.white, size: 32),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    if (listViewMessagesRecord.messageText.isNotEmpty)
                                                                      Text(
                                                                        listViewMessagesRecord
                                                                            .messageText,
                                                                        style: FlutterFlowTheme.of(
                                                                                context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              fontFamily:
                                                                                  'Onest',
                                                                              color:
                                                                                  FlutterFlowTheme.of(context).primaryText,
                                                                              fontSize:
                                                                                  14.5,
                                                                              letterSpacing:
                                                                                  0.0,
                                                                              fontWeight:
                                                                                  FontWeight.w500,
                                                                            ),
                                                                      ),
                                                                    Padding(
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          1.0,
                                                                          0.0,
                                                                          0.0),
                                                                      child:
                                                                          Text(
                                                                        valueOrDefault<
                                                                            String>(
                                                                          dateTimeFormat(
                                                                            "relative",
                                                                            listViewMessagesRecord.timestamp,
                                                                            locale:
                                                                                FFLocalizations.of(context).languageCode,
                                                                          ),
                                                                          'a moment ago',
                                                                        ),
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              fontFamily: 'Onest',
                                                                              color: FlutterFlowTheme.of(context).secondaryText,
                                                                              fontSize: 8.0,
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
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            if (listViewMessagesRecord
                                                    .senderId ==
                                                currentUserReference)
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        40.0, 0.0, 0.0, 0.0),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Flexible(
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    10.0,
                                                                    10.0,
                                                                    10.0,
                                                                    10.0),
                                                        child: InkWell(
                                                          splashColor: Colors
                                                              .transparent,
                                                          focusColor: Colors
                                                              .transparent,
                                                          hoverColor: Colors
                                                              .transparent,
                                                          highlightColor: Colors
                                                              .transparent,
                                                          onLongPress:
                                                              () async {
                                                            await Clipboard.setData(
                                                                ClipboardData(
                                                                    text: listViewMessagesRecord
                                                                        .messageText));
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              SnackBar(
                                                                content: Text(
                                                                  'messasge copied',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                                duration: Duration(
                                                                    milliseconds:
                                                                        500),
                                                                backgroundColor:
                                                                    FlutterFlowTheme.of(
                                                                            context)
                                                                        .secondaryText,
                                                              ),
                                                            );
                                                          },
                                                          child: Material(
                                                            color: Colors
                                                                .transparent,
                                                            elevation: 1.0,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        8.0),
                                                                bottomRight: Radius
                                                                    .circular(
                                                                        1.0),
                                                                topLeft: Radius
                                                                    .circular(
                                                                        8.0),
                                                                topRight: Radius
                                                                    .circular(
                                                                        8.0),
                                                              ),
                                                            ),
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primary,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .only(
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          8.0),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          1.0),
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          8.0),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          8.0),
                                                                ),
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            10.0),
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    if (listViewMessagesRecord.messageType == 'image' && 
                                                                        listViewMessagesRecord.mediaUrl.isNotEmpty)
                                                                      InkWell(
                                                                        onTap: () {
                                                                          showDialog(
                                                                            context: context,
                                                                            builder: (context) => Dialog(
                                                                              backgroundColor: Colors.transparent,
                                                                              child: Stack(
                                                                                children: [
                                                                                  Center(
                                                                                    child: InteractiveViewer(
                                                                                      child: Image.network(
                                                                                        listViewMessagesRecord.mediaUrl,
                                                                                        fit: BoxFit.contain,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Positioned(
                                                                                    top: 10,
                                                                                    right: 10,
                                                                                    child: IconButton(
                                                                                      icon: Icon(Icons.close, color: Colors.white, size: 30),
                                                                                      onPressed: () => Navigator.of(context).pop(),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          );
                                                                        },
                                                                        child: ClipRRect(
                                                                          borderRadius: BorderRadius.circular(8.0),
                                                                          child: Image.network(
                                                                            listViewMessagesRecord.mediaUrl,
                                                                            width: 200.0,
                                                                            fit: BoxFit.cover,
                                                                            errorBuilder: (context, error, stackTrace) => 
                                                                              Icon(Icons.broken_image, size: 50, 
                                                                                color: FlutterFlowTheme.of(context).secondaryBackground),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    if (listViewMessagesRecord.messageType == 'audio' && 
                                                                        listViewMessagesRecord.mediaUrl.isNotEmpty)
                                                                      Row(
                                                                        mainAxisSize: MainAxisSize.min,
                                                                        children: [
                                                                          Icon(Icons.audiotrack, 
                                                                            color: FlutterFlowTheme.of(context).secondaryBackground),
                                                                          SizedBox(width: 8),
                                                                          Text('Audio message', 
                                                                            style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                              fontFamily: 'Onest',
                                                                              color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                              letterSpacing: 0.0,
                                                                            )),
                                                                        ],
                                                                      ),
                                                                    if (listViewMessagesRecord.messageType == 'document' && 
                                                                        listViewMessagesRecord.mediaUrl.isNotEmpty)
                                                                      Row(
                                                                        mainAxisSize: MainAxisSize.min,
                                                                        children: [
                                                                          Icon(Icons.insert_drive_file, 
                                                                            color: FlutterFlowTheme.of(context).secondaryBackground),
                                                                          SizedBox(width: 8),
                                                                          Text('Document', 
                                                                            style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                              fontFamily: 'Onest',
                                                                              color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                              letterSpacing: 0.0,
                                                                            )),
                                                                        ],
                                                                      ),
                                                                    if (listViewMessagesRecord.messageType == 'video' && 
                                                                        listViewMessagesRecord.mediaUrl.isNotEmpty)
                                                                      ClipRRect(
                                                                        borderRadius: BorderRadius.circular(8.0),
                                                                        child: Stack(
                                                                          alignment: Alignment.center,
                                                                          children: [
                                                                            Image.network(
                                                                              listViewMessagesRecord.mediaUrl,
                                                                              width: 200.0,
                                                                              height: 150.0,
                                                                              fit: BoxFit.cover,
                                                                              errorBuilder: (context, error, stackTrace) => 
                                                                                Container(
                                                                                  width: 200.0,
                                                                                  height: 150.0,
                                                                                  color: FlutterFlowTheme.of(context).primary.withValues(alpha: 0.2),
                                                                                  child: Icon(Icons.videocam, size: 50, color: FlutterFlowTheme.of(context).secondaryBackground),
                                                                                ),
                                                                            ),
                                                                            Container(
                                                                              padding: EdgeInsets.all(8),
                                                                              decoration: BoxDecoration(
                                                                                color: Colors.black.withValues(alpha: 0.5),
                                                                                shape: BoxShape.circle,
                                                                              ),
                                                                              child: Icon(Icons.play_arrow, color: Colors.white, size: 32),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    if (listViewMessagesRecord.messageText.isNotEmpty)
                                                                      Text(
                                                                        listViewMessagesRecord
                                                                            .messageText,
                                                                        style: FlutterFlowTheme.of(
                                                                                context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              fontFamily:
                                                                                  'Onest',
                                                                              color:
                                                                                  FlutterFlowTheme.of(context).secondaryBackground,
                                                                              fontSize:
                                                                                  14.5,
                                                                              letterSpacing:
                                                                                  0.0,
                                                                              fontWeight:
                                                                                  FontWeight.w500,
                                                                            ),
                                                                      ),
                                                                    Row(
                                                                      mainAxisSize: MainAxisSize.min,
                                                                      children: [
                                                                        Padding(
                                                                          padding: EdgeInsetsDirectional.fromSTEB(
                                                                              0.0,
                                                                              4.0,
                                                                              0.0,
                                                                              0.0),
                                                                          child:
                                                                              Text(
                                                                            valueOrDefault<
                                                                                String>(
                                                                              dateTimeFormat(
                                                                                "relative",
                                                                                listViewMessagesRecord.timestamp,
                                                                                locale:
                                                                                    FFLocalizations.of(context).languageCode,
                                                                              ),
                                                                              'a moment ago',
                                                                            ),
                                                                            style: FlutterFlowTheme.of(context)
                                                                                .bodyMedium
                                                                                .override(
                                                                                  fontFamily: 'Onest',
                                                                                  color: FlutterFlowTheme.of(context).alternate,
                                                                                  fontSize: 8.0,
                                                                                  letterSpacing: 0.0,
                                                                                ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(width: 4),
                                                                        // Only show read receipts if current user has readReceipts enabled
                                                                        if (currentUserDocument?.readReceipts == true)
                                                                          Icon(
                                                                            listViewMessagesRecord.isRead ? Icons.done_all : Icons.done,
                                                                            size: 14,
                                                                            color: listViewMessagesRecord.isRead 
                                                                              ? FlutterFlowTheme.of(context).info
                                                                              : FlutterFlowTheme.of(context).alternate,
                                                                          ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ]
                                .divide(SizedBox(height: 15.0))
                                .addToStart(SizedBox(height: 12.0))
                                .addToEnd(SizedBox(height: 12.0)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(6.0, 10.0, 12.0, 10.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                6.0, 2.0, 10.0, 6.0),
                            child: FlutterFlowIconButton(
                              borderColor:
                                  FlutterFlowTheme.of(context).transparent,
                              borderRadius: 30.0,
                              borderWidth: 0.0,
                              buttonSize: 40.0,
                              fillColor: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                              icon: Icon(
                                FFIcons.kplus,
                                color: FlutterFlowTheme.of(context).primaryText,
                                size: 22.0,
                              ),
                              onPressed: () async {
                                if (_model.other) {
                                  _model.other = false;
                                  safeSetState(() {});
                                } else {
                                  _model.other = true;
                                  safeSetState(() {});
                                }
                              },
                            ),
                          ),
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              height: 45.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .primaryBackground,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Container(
                                      width: 100.0,
                                      child: TextFormField(
                                        controller:
                                            _model.textMessageTextController,
                                        focusNode: _model.textMessageFocusNode,
                                        onFieldSubmitted: (_) async {
                                          if (_model.textMessageTextController
                                                      .text !=
                                                  null &&
                                              _model.textMessageTextController
                                                      .text !=
                                                  '') {
                                            // Check message limit
                                            final currentUserDoc = await currentUserReference!.get();
                                            final userData = UsersRecord.fromSnapshot(currentUserDoc);
                                            
                                            // Check if user has subscription (paid plan)
                                            final hasPaidSubscription = userData.subscription != null;
                                            
                                            if (!hasPaidSubscription) {
                                              // Reset count if 24 hours have passed
                                              final now = DateTime.now();
                                              final lastReset = userData.lastMessageResetDate;
                                              final shouldReset = lastReset == null || 
                                                  now.difference(lastReset).inHours >= 24;
                                              
                                              int currentCount = shouldReset ? 0 : userData.dailyMessageCount;
                                              
                                              if (currentCount >= 20) {
                                                await NotificationService.notifyMessageLimitReached();
                                                
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      'Daily message limit reached (20/20). Upgrade to Premium for unlimited messaging!',
                                                      style: TextStyle(color: Colors.white),
                                                    ),
                                                    duration: Duration(seconds: 3),
                                                    backgroundColor: FlutterFlowTheme.of(context).error,
                                                    action: SnackBarAction(
                                                      label: 'Upgrade',
                                                      textColor: Colors.white,
                                                      onPressed: () {
                                                        context.pushNamed('Subscription');
                                                      },
                                                    ),
                                                  ),
                                                );
                                                return;
                                              }
                                            }
                                            
                                            _model.message = _model
                                                .textMessageTextController.text;
                                            safeSetState(() {});
                                            safeSetState(() {
                                              _model.textMessageTextController
                                                  ?.clear();
                                            });

                                            await MessagesRecord.createDoc(
                                                    widget!.recieveChats!)
                                                .set(createMessagesRecordData(
                                              timestamp: getCurrentTimestamp,
                                              messageText: _model.message,
                                              senderId: currentUserReference,
                                              senderName:
                                                  currentUserDisplayName,
                                              isDelivered: true,
                                              isRead: false,
                                            ));

                                            // Get chat data to find recipients
                                            final chatDoc = await widget!.recieveChats!.get();
                                            final chatData = ChatsRecord.fromSnapshot(chatDoc);
                                            
                                            // Create notification for each recipient (excluding sender)
                                            for (final userRef in chatData.userIDs) {
                                              if (userRef != currentUserReference) {
                                                await NotificationsRecord.collection.doc().set(
                                                  createNotificationsRecordData(
                                                    notificationTitle: 'New Message',
                                                    notficationContent: 'You received a new message from ${currentUserDisplayName}',
                                                    timeDate: getCurrentTimestamp,
                                                    user: userRef,
                                                    delivered: false,
                                                    senderID: currentUserReference,
                                                  ),
                                                );
                                              }
                                            }

                                            await widget!.recieveChats!.update({
                                              ...createChatsRecordData(
                                                lastMessage: _model.message,
                                                lastMessageTime:
                                                    getCurrentTimestamp,
                                              ),
                                              ...mapToFirestore(
                                                {
                                                  'lastSeenBy':
                                                      FieldValue.delete(),
                                                },
                                              ),
                                            });

                                            await widget!.recieveChats!.update({
                                              ...mapToFirestore(
                                                {
                                                  'lastSeenBy':
                                                      FieldValue.arrayUnion([
                                                    currentUserReference
                                                  ]),
                                                },
                                              ),
                                            });
                                            
                                            // Update message count for free users
                                            if (!hasPaidSubscription) {
                                              final now = DateTime.now();
                                              final lastReset = userData.lastMessageResetDate;
                                              final shouldReset = lastReset == null || 
                                                  now.difference(lastReset).inHours >= 24;
                                              
                                              await currentUserReference!.update({
                                                'dailyMessageCount': shouldReset ? 1 : (userData.dailyMessageCount + 1),
                                                'lastMessageResetDate': shouldReset ? now : lastReset,
                                              });
                                            }
                                            return;
                                          } else {
                                            return;
                                          }
                                        },
                                        autofocus: false,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          isDense: false,
                                          hintText: 'Make your first move',
                                          hintStyle: FlutterFlowTheme.of(
                                                  context)
                                              .labelLarge
                                              .override(
                                                fontFamily: 'Onest',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                letterSpacing: 0.0,
                                              ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .transparent,
                                              width: 0.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .transparent,
                                              width: 0.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          errorBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                              width: 0.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          focusedErrorBorder:
                                              UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                              width: 0.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          contentPadding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  18.0, 10.0, 15.0, 11.0),
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .labelLarge
                                            .override(
                                              fontFamily: 'Onest',
                                              letterSpacing: 0.0,
                                            ),
                                        validator: _model
                                            .textMessageTextControllerValidator
                                            .asValidator(context),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 5.0, 5.0, 5.0),
                                    child: Container(
                                      width: 35.0,
                                      height: 35.0,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        shape: BoxShape.circle,
                                      ),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(24),
                                        onTap: () async {
                                          _model.showEmojiPicker = !_model.showEmojiPicker;
                                          if (_model.showEmojiPicker) {
                                            FocusScope.of(context).unfocus();
                                          }
                                          safeSetState(() {});
                                        },
                                        child: Align(
                                          alignment: AlignmentDirectional(0.0, 0.0),
                                          child: Icon(
                                            FFIcons.kfaceSmile,
                                            color: FlutterFlowTheme.of(context).primaryText,
                                            size: 20.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                12.0, 2.0, 6.0, 0.0),
                            child: FlutterFlowIconButton(
                              borderColor:
                                  FlutterFlowTheme.of(context).transparent,
                              borderRadius: 30.0,
                              borderWidth: 0.0,
                              buttonSize: 40.0,
                              fillColor: FlutterFlowTheme.of(context).primary,
                              icon: Icon(
                                FFIcons.ksend03,
                                color: FlutterFlowTheme.of(context).info,
                                size: 18.0,
                              ),
                              onPressed: () async {
                                if (_model.textMessageTextController.text.isNotEmpty) {
                                  // Check message limit
                                  final currentUserDoc = await currentUserReference!.get();
                                  final userData = UsersRecord.fromSnapshot(currentUserDoc);
                                  
                                  // Check if user has subscription (paid plan)
                                  final hasPaidSubscription = userData.subscription != null;
                                  
                                  if (!hasPaidSubscription) {
                                    // Reset count if 24 hours have passed
                                    final now = DateTime.now();
                                    final lastReset = userData.lastMessageResetDate;
                                    final shouldReset = lastReset == null || 
                                        now.difference(lastReset).inHours >= 24;
                                    
                                    int currentCount = shouldReset ? 0 : userData.dailyMessageCount;
                                    
                                    if (currentCount >= 20) {
                                      await NotificationService.notifyMessageLimitReached();
                                      
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Daily message limit reached (20/20). Upgrade to Premium for unlimited messaging!',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          duration: Duration(seconds: 3),
                                          backgroundColor: FlutterFlowTheme.of(context).error,
                                          action: SnackBarAction(
                                            label: 'Upgrade',
                                            textColor: Colors.white,
                                            onPressed: () {
                                              context.pushNamed('Subscription');
                                            },
                                          ),
                                        ),
                                      );
                                      return;
                                    }
                                  }
                                  
                                  _model.message =
                                      _model.textMessageTextController.text;
                                  safeSetState(() {});
                                  safeSetState(() {
                                    _model.textMessageTextController?.clear();
                                  });

                                  await MessagesRecord.createDoc(
                                          widget!.recieveChats!)
                                      .set(createMessagesRecordData(
                                    messageText: _model.message,
                                    timestamp: getCurrentTimestamp,
                                    senderId: currentUserReference,
                                    senderName: currentUserDisplayName,
                                    isDelivered: true,
                                    isRead: false,
                                  ));

                                  // Get chat data to find recipients
                                  final chatDoc = await widget!.recieveChats!.get();
                                  final chatData = ChatsRecord.fromSnapshot(chatDoc);
                                  
                                  // Create notification for each recipient (excluding sender)
                                  for (final userRef in chatData.userIDs) {
                                    if (userRef != currentUserReference) {
                                      await NotificationsRecord.collection.doc().set(
                                        createNotificationsRecordData(
                                          notificationTitle: 'New Message',
                                          notficationContent: 'You received a new message from ${currentUserDisplayName}',
                                          timeDate: getCurrentTimestamp,
                                          user: userRef,
                                          delivered: false,
                                          senderID: currentUserReference,
                                        ),
                                      );
                                    }
                                  }

                                  await widget!.recieveChats!.update({
                                    ...createChatsRecordData(
                                      lastMessage: _model.message,
                                      lastMessageTime: getCurrentTimestamp,
                                    ),
                                    ...mapToFirestore(
                                      {
                                        'lastSeenBy': FieldValue.delete(),
                                      },
                                    ),
                                  });

                                  await widget!.recieveChats!.update({
                                    ...mapToFirestore(
                                      {
                                        'lastSeenBy': FieldValue.arrayUnion(
                                            [currentUserReference]),
                                      },
                                    ),
                                  });
                                  
                                  // Update message count for free users
                                  if (!hasPaidSubscription) {
                                    final now = DateTime.now();
                                    final lastReset = userData.lastMessageResetDate;
                                    final shouldReset = lastReset == null || 
                                        now.difference(lastReset).inHours >= 24;
                                    
                                    await currentUserReference!.update({
                                      'dailyMessageCount': shouldReset ? 1 : (userData.dailyMessageCount + 1),
                                      'lastMessageResetDate': shouldReset ? now : lastReset,
                                    });
                                  }
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_model.other == true)
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            15.0, 10.0, 15.0, 15.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 2.0, 0.0, 0.0),
                                  child: FlutterFlowIconButton(
                                    borderColor: FlutterFlowTheme.of(context)
                                        .transparent,
                                    borderRadius: 30.0,
                                    borderWidth: 0.0,
                                    buttonSize: 55.0,
                                    fillColor: Color(0xFFE50FFF),
                                    icon: Icon(
                                      FFIcons.kcamera,
                                      color: FlutterFlowTheme.of(context).info,
                                      size: 25.0,
                                    ),
                                    onPressed: () async {
                                      await _handleCamera(context);
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 7.0, 0.0, 0.0),
                                  child: Text(
                                    'Camera',
                                    style: FlutterFlowTheme.of(context)
                                        .labelSmall
                                        .override(
                                          fontFamily: 'Onest',
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.normal,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 2.0, 0.0, 0.0),
                                  child: FlutterFlowIconButton(
                                    borderColor: FlutterFlowTheme.of(context)
                                        .transparent,
                                    borderRadius: 30.0,
                                    borderWidth: 0.0,
                                    buttonSize: 55.0,
                                    fillColor:
                                        FlutterFlowTheme.of(context).error,
                                    icon: Icon(
                                      FFIcons.kdocumentDuplicate,
                                      color: FlutterFlowTheme.of(context).info,
                                      size: 25.0,
                                    ),
                                    onPressed: () async {
                                      await _handleDocument(context);
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 7.0, 0.0, 0.0),
                                  child: Text(
                                    'Document',
                                    style: FlutterFlowTheme.of(context)
                                        .labelSmall
                                        .override(
                                          fontFamily: 'Onest',
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.normal,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 2.0, 0.0, 0.0),
                                  child: FlutterFlowIconButton(
                                    borderColor: FlutterFlowTheme.of(context)
                                        .transparent,
                                    borderRadius: 30.0,
                                    borderWidth: 0.0,
                                    buttonSize: 55.0,
                                    fillColor:
                                        FlutterFlowTheme.of(context).accent4,
                                    icon: Icon(
                                      FFIcons.kimages,
                                      color: FlutterFlowTheme.of(context).info,
                                      size: 25.0,
                                    ),
                                    onPressed: () async {
                                      await _handleGallery(context);
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 7.0, 0.0, 0.0),
                                  child: Text(
                                    'Gallery',
                                    style: FlutterFlowTheme.of(context)
                                        .labelSmall
                                        .override(
                                          fontFamily: 'Onest',
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.normal,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 2.0, 0.0, 0.0),
                                  child: FlutterFlowIconButton(
                                    borderColor: FlutterFlowTheme.of(context)
                                        .transparent,
                                    borderRadius: 30.0,
                                    borderWidth: 0.0,
                                    buttonSize: 55.0,
                                    fillColor:
                                        FlutterFlowTheme.of(context).warning,
                                    icon: Icon(
                                      FFIcons.kvolumeUpFill,
                                      color: FlutterFlowTheme.of(context).info,
                                      size: 25.0,
                                    ),
                                    onPressed: () async {
                                      await _handleAudio(context);
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 7.0, 0.0, 0.0),
                                  child: Text(
                                    'Audio',
                                    style: FlutterFlowTheme.of(context)
                                        .labelSmall
                                        .override(
                                          fontFamily: 'Onest',
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.normal,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                   ],
                ),
              ),
              // Emoji picker panel
              if (_model.showEmojiPicker)
                SizedBox(
                  height: 280,
                  child: EmojiPicker(
                    onEmojiSelected: (category, emoji) {
                      final text = _model.textMessageTextController?.text ?? '';
                      final selection = _model.textMessageTextController?.selection ?? const TextSelection.collapsed(offset: -1);
                      final newText = StringBuffer();
                      if (selection.start >= 0 && selection.end >= 0 && selection.start <= text.length) {
                        newText.write(text.substring(0, selection.start));
                        newText.write(emoji.emoji);
                        newText.write(text.substring(selection.end));
                      } else {
                        newText.write(text + emoji.emoji);
                      }
                      _model.textMessageTextController?.text = newText.toString();
                      _model.textMessageTextController?.selection = TextSelection.fromPosition(
                        TextPosition(offset: _model.textMessageTextController!.text.length),
                      );
                      safeSetState(() {});
                    },
                    config: const Config(columns: 7, emojiSizeMax: 28),
                  ),
                ),
            ].addToEnd(SizedBox(height: 0.0)),
          ),
        ),
        ),
      ),
    );
  }

  Future<void> _handleVoiceCall(BuildContext context) async {
    try {
      // Request microphone permission
      if (!kIsWeb) {
        final status = await Permission.microphone.request();
        if (!status.isGranted) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Microphone permission is required for voice calls')),
          );
          return;
        }
      }

      // Find the other participant
      final chatDoc = await widget.recieveChats!.get();
      final chatData = ChatsRecord.fromSnapshot(chatDoc);
      DocumentReference? otherUserRef;
      for (final ref in chatData.userIDs) {
        if (ref != currentUserReference) {
          otherUserRef = ref;
          break;
        }
      }

      if (otherUserRef == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not find the other user')),
        );
        return;
      }

      // Generate a channel name for Agora
      final callId = AgoraService.generateChannelName();

      // Send a notification to the other user
      await NotificationsRecord.collection.doc().set(
        createNotificationsRecordData(
          notificationTitle: 'Incoming Voice Call',
          notficationContent: '${currentUserDisplayName} is calling you.',
          timeDate: DateTime.now(),
          user: otherUserRef,
          delivered: false,
          senderID: currentUserReference,
        ),
      );

      // Send a system message to the chat
      await MessagesRecord.createDoc(widget.recieveChats!).set(createMessagesRecordData(
        timestamp: DateTime.now(),
        senderId: currentUserReference,
        senderName: currentUserDisplayName,
        messageType: 'voice_call',
        messageText: '📞 Started a voice call',
        mediaUrl: callId,
      ));

      // Update chat last message
      await widget.recieveChats!.update(createChatsRecordData(
        lastMessage: '📞 Voice call',
        lastMessageTime: DateTime.now(),
      ));

      // Navigate to call screen
      if (!mounted) return;
      context.pushNamed(
        VideoCallWidget.routeName,
        queryParameters: {
          'meetingId': callId,
          'userName': widget.chatWithName ?? currentUserDisplayName,
          'isAudioOnly': 'true',
        },
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to start call: $e')),
      );
    }
  }

  Future<void> _handleCamera(BuildContext context) async {
    final selected = await selectMedia(
      isVideo: false,
      mediaSource: MediaSource.camera,
      includeDimensions: false,
    );
    await _uploadAndSend(selected, fallbackText: '📷 Photo');
    _model.other = false;
    safeSetState(() {});
  }

  Future<void> _handleGallery(BuildContext context) async {
    final selected = await selectMediaWithSourceBottomSheet(
      context: context,
      allowPhoto: true,
      allowVideo: true,
      includeDimensions: false,
    );
    await _uploadAndSend(selected, fallbackText: '🖼️ Media');
    _model.other = false;
    safeSetState(() {});
  }

  Future<void> _handleDocument(BuildContext context) async {
    final files = await selectFiles(
      allowedExtensions: ['pdf', 'doc', 'docx', 'ppt', 'pptx', 'xls', 'xlsx', 'txt'],
    );
    await _uploadAndSend(files, fallbackText: '📄 Document', messageType: 'file');
    _model.other = false;
    safeSetState(() {});
  }

  Future<void> _handleAudio(BuildContext context) async {
    if (kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Voice recording is not supported in web preview.')),
      );
      _model.other = false;
      safeSetState(() {});
      return;
    }

    final rec = Record();
    if (await Permission.microphone.request().isGranted) {
      final tmpDir = await getTemporaryDirectory();
      final path = '${tmpDir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';
      await rec.start(path: path, encoder: AudioEncoder.aacLc);

      // Simple sheet UI to stop recording
      await showModalBottomSheet(
        context: context,
        isDismissible: false,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),
                Text('Recording... tap Stop to send', style: FlutterFlowTheme.of(context).titleSmall),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.stop),
                  label: const Text('Stop'),
                ),
                const SizedBox(height: 12),
              ],
            ),
          );
        },
      );

      final filePath = await rec.stop();
      if (filePath != null) {
        final file = io.File(filePath);
        final bytes = await file.readAsBytes();
        final storagePath = _firebasePathFor('voice_${DateTime.now().microsecondsSinceEpoch}.m4a');
        final url = await uploadData(storagePath, bytes);
        if (url != null) {
          await _sendMessage(
            messageText: '🎤 Voice message',
            messageType: 'audio',
            mediaUrl: url,
          );
        }
      }
    }
    _model.other = false;
    safeSetState(() {});
  }

  String _firebasePathFor(String filename) => 'users/${currentUserUid}/uploads/${DateTime.now().microsecondsSinceEpoch}_$filename';

  Future<void> _uploadAndSend(List<SelectedFile>? selected, {required String fallbackText, String? messageType}) async {
    if (selected == null || selected.isEmpty) return;
    for (final file in selected) {
      final url = await uploadData(file.storagePath, file.bytes);
      if (url != null) {
        // Guess messageType if not provided
        final type = messageType ?? (file.storagePath.endsWith('.mp4') ? 'video' : 'image');
        await _sendMessage(
          messageText: fallbackText,
          messageType: type,
          mediaUrl: url,
        );
      }
    }
  }

  Future<void> _sendMessage({required String messageText, String? messageType, String? mediaUrl}) async {
    await MessagesRecord.createDoc(widget.recieveChats!).set(createMessagesRecordData(
      timestamp: DateTime.now(),
      senderId: currentUserReference,
      senderName: currentUserDisplayName,
      messageText: messageText,
      messageType: messageType,
      mediaUrl: mediaUrl,
      isDelivered: true,
      isRead: false,
    ));
    await widget.recieveChats!.update(createChatsRecordData(
      lastMessage: messageText,
      lastMessageTime: DateTime.now(),
    ));
  }
}

class _IncomingCallOverlay extends StatelessWidget {
  const _IncomingCallOverlay({
    required this.callerName,
    required this.onAccept,
    required this.onDecline,
  });

  final String callerName;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Material(
      color: Colors.black.withValues(alpha: 0.6),
      child: SafeArea(
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [theme.primary, theme.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Icon(
                    Icons.call,
                    color: theme.primary,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Incoming Voice Call',
                  style: theme.titleLarge.override(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  callerName,
                  style: theme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _roundAction(
                      context,
                      icon: Icons.call_end,
                      label: 'Decline',
                      color: Colors.red,
                      onTap: onDecline,
                    ),
                    _roundAction(
                      context,
                      icon: Icons.call,
                      label: 'Accept',
                      color: Colors.green,
                      onTap: onAccept,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _roundAction(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 66,
          height: 66,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: IconButton(
            icon: Icon(icon, color: Colors.white, size: 30),
            onPressed: onTap,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: FlutterFlowTheme.of(context).labelMedium.copyWith(color: Colors.white),
        )
      ],
    );
  }
}
