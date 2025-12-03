import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_icons.dart';
import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
import '/services/agora_service.dart';
import 'video_call_model.dart';
export 'video_call_model.dart';

class VideoCallWidget extends StatefulWidget {
  const VideoCallWidget({
    super.key,
    required this.meetingId,
    required this.userName,
    required this.isAudioOnly,
  });

  final String meetingId;
  final String userName;
  final bool isAudioOnly;

  static String routeName = 'VideoCall';
  static String routePath = '/videoCall';

  @override
  State<VideoCallWidget> createState() => _VideoCallWidgetState();
}

class _VideoCallWidgetState extends State<VideoCallWidget> {
  late VideoCallModel _model;
  bool _isMuted = false;
  bool _isCallActive = false;
  bool _remoteUserJoined = false;
  DateTime? _callStartTime;
  Timer? _callTimer;
  RtcEngine? _agoraEngine;
  bool _isInitialized = false;
  String _callStatus = 'Connecting...';

  @override
  void initState() {
    super.initState();
    _model = VideoCallModel();
    _startCall();
  }

  Future<void> _startCall() async {
    setState(() {
      _isCallActive = true;
      _callStartTime = DateTime.now();
    });

    // Web doesn't support Agora properly, use simulated connection
    if (kIsWeb) {
      print('🌐 Running on web - using simulated voice call');
      setState(() => _callStatus = 'Requesting microphone...');
      
      // Request microphone permission
      final micPermission = await Permission.microphone.request();
      if (micPermission.isGranted) {
        setState(() => _callStatus = 'Connecting...');
        // Simulate connection
        await Future.delayed(const Duration(seconds: 2));
        if (mounted && _isCallActive) {
          setState(() {
            _remoteUserJoined = true;
            _callStatus = 'Connected';
          });
          print('✅ Simulated connection established');
        }
      } else if (micPermission.isPermanentlyDenied) {
        setState(() => _callStatus = 'Microphone permission permanently denied');
        debugPrint('❌ Microphone permission permanently denied');
        if (mounted) {
          _showPermissionDeniedDialog(isPermanent: true);
        }
      } else {
        setState(() => _callStatus = 'Microphone permission required');
        debugPrint('❌ Microphone permission denied');
        if (mounted) {
          _showPermissionDeniedDialog(isPermanent: false);
        }
      }
      return;
    }

    // Mobile platforms - use real Agora
    try {
      print('🔊 Initializing Agora on mobile...');
      setState(() => _callStatus = 'Requesting microphone...');
      
      // Request microphone permission
      final micPermission = await Permission.microphone.request();
      if (!micPermission.isGranted) {
        if (micPermission.isPermanentlyDenied) {
          setState(() => _callStatus = 'Microphone permission permanently denied');
          debugPrint('❌ Microphone permission permanently denied');
          if (mounted) {
            _showPermissionDeniedDialog(isPermanent: true);
          }
        } else {
          setState(() => _callStatus = 'Microphone permission required');
          debugPrint('❌ Microphone permission denied');
          if (mounted) {
            _showPermissionDeniedDialog(isPermanent: false);
          }
        }
        return;
      }

      setState(() => _callStatus = 'Initializing...');
      
      // Initialize Agora engine
      _agoraEngine = createAgoraRtcEngine();
      await _agoraEngine!.initialize(RtcEngineContext(
        appId: AgoraService.appId,
        channelProfile: ChannelProfileType.channelProfileCommunication,
      ));

      // Register event handlers
      _agoraEngine!.registerEventHandler(RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          print('✅ Successfully joined channel');
          setState(() => _callStatus = 'In call...');
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          print('✅ Remote user joined: $remoteUid');
          setState(() {
            _remoteUserJoined = true;
            _callStatus = 'Connected';
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
          print('👋 Remote user left: $remoteUid');
          setState(() => _remoteUserJoined = false);
        },
        onError: (ErrorCodeType err, String msg) {
          print('❌ Agora error: $err - $msg');
          setState(() => _callStatus = 'Error: $msg');
        },
      ));

      // Enable audio
      await _agoraEngine!.enableAudio();
      await _agoraEngine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
      
      setState(() => _callStatus = 'Connecting...');

      // Join channel (no token for testing)
      await _agoraEngine!.joinChannel(
        token: '',
        channelId: widget.meetingId,
        uid: 0,
        options: const ChannelMediaOptions(
          channelProfile: ChannelProfileType.channelProfileCommunication,
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
        ),
      );

      setState(() => _isInitialized = true);
      print('✅ Agora initialized and joined channel: ${widget.meetingId}');
    } catch (e) {
      print('❌ Failed to initialize Agora: $e');
      setState(() => _callStatus = 'Connection failed');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to start call: $e')),
        );
      }
    }
  }

  void _showPermissionDeniedDialog({required bool isPermanent}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.mic_off, color: FlutterFlowTheme.of(context).error),
            const SizedBox(width: 8),
            const Text('Microphone Required'),
          ],
        ),
        content: Text(
          isPermanent
              ? 'Microphone permission is required for voice calls. Please enable it in your device settings.'
              : 'Microphone permission is required for voice calls. Please grant permission to continue.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              this.context.safePop();
            },
            child: const Text('Cancel'),
          ),
          if (isPermanent)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
              child: const Text('Open Settings'),
            )
          else
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _startCall();
              },
              child: const Text('Try Again'),
            ),
        ],
      ),
    );
  }

  Future<void> _toggleMute() async {
    setState(() => _isMuted = !_isMuted);
    
    if (_agoraEngine != null && _isInitialized) {
      await _agoraEngine!.muteLocalAudioStream(_isMuted);
      print('🎤 Microphone ${_isMuted ? "muted" : "unmuted"}');
    }
  }

  Future<void> _endCall() async {
    print('📞 Ending call...');
    
    // Clean up Agora resources
    if (_agoraEngine != null && _isInitialized) {
      await _agoraEngine!.leaveChannel();
      await _agoraEngine!.release();
      print('✅ Agora resources released');
    }
    
    setState(() {
      _isCallActive = false;
      _remoteUserJoined = false;
      _isInitialized = false;
    });
    
    _callTimer?.cancel();
    
    if (mounted) {
      context.safePop();
    }
  }

  String _getCallDuration() {
    if (_callStartTime == null) return '00:00';
    final duration = DateTime.now().difference(_callStartTime!);
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _callTimer?.cancel();
    
    // Clean up Agora
    if (_agoraEngine != null && _isInitialized) {
      _agoraEngine!.leaveChannel();
      _agoraEngine!.release();
    }
    
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                FlutterFlowTheme.of(context).primary,
                FlutterFlowTheme.of(context).secondary,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Voice Call',
                      style: FlutterFlowTheme.of(context).headlineSmall.override(
                            fontFamily: 'Onest',
                            color: Colors.white,
                            letterSpacing: 0.0,
                          ),
                    ),
                    StreamBuilder(
                      stream: Stream.periodic(const Duration(seconds: 1)),
                      builder: (context, snapshot) {
                        return Text(
                          _getCallDuration(),
                          style: FlutterFlowTheme.of(context).bodyLarge.override(
                                fontFamily: 'Onest',
                                color: Colors.white70,
                                letterSpacing: 0.0,
                              ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // Center content
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Avatar
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.2),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 3,
                        ),
                      ),
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // User name
                    Text(
                      widget.userName,
                      style: FlutterFlowTheme.of(context).headlineMedium.override(
                            fontFamily: 'Onest',
                            color: Colors.white,
                            letterSpacing: 0.0,
                          ),
                    ),
                    const SizedBox(height: 12),

                    // Status
                    Text(
                      _callStatus,
                      style: FlutterFlowTheme.of(context).bodyLarge.override(
                            fontFamily: 'Onest',
                            color: Colors.white70,
                            letterSpacing: 0.0,
                          ),
                    ),
                    
                    // Platform indicator (for debugging)
                    if (kIsWeb)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          '(Simulated call - Web)',
                          style: FlutterFlowTheme.of(context).bodySmall.override(
                                fontFamily: 'Onest',
                                color: Colors.white60,
                                fontSize: 11,
                                letterSpacing: 0.0,
                              ),
                        ),
                      ),

                    // Loading indicator when connecting
                    if (!_remoteUserJoined)
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: SizedBox(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white.withValues(alpha: 0.7),
                            ),
                            strokeWidth: 3,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Bottom controls
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Mute button
                    _buildControlButton(
                      icon: _isMuted ? Icons.mic_off : Icons.mic,
                      label: _isMuted ? 'Unmute' : 'Mute',
                      onPressed: _toggleMute,
                      color: _isMuted
                          ? FlutterFlowTheme.of(context).error
                          : Colors.white.withValues(alpha: 0.3),
                    ),

                    // End call button
                    _buildControlButton(
                      icon: Icons.call_end,
                      label: 'End',
                      onPressed: _endCall,
                      color: FlutterFlowTheme.of(context).error,
                      size: 70,
                    ),

                    // Speaker button
                    _buildControlButton(
                      icon: Icons.volume_up,
                      label: 'Speaker',
                      onPressed: () async {
                        if (_agoraEngine != null && _isInitialized) {
                          await _agoraEngine!.setEnableSpeakerphone(true);
                          print('🔊 Speaker enabled');
                        }
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Speaker mode active'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        }
                      },
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
    double size = 60,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(icon, color: Colors.white, size: size * 0.45),
            onPressed: onPressed,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: FlutterFlowTheme.of(context).bodySmall.override(
                fontFamily: 'Onest',
                color: Colors.white,
                letterSpacing: 0.0,
              ),
        ),
      ],
    );
  }
}
