import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/actions/actions.dart' as action_blocks;
import '/app_state.dart';
import '/services/device_session_service.dart';

import 'device_management_model.dart';
export 'device_management_model.dart';

class DeviceManagementWidget extends StatefulWidget {
  const DeviceManagementWidget({super.key});

  static String routeName = 'DeviceManagement';
  static String routePath = '/deviceManagement';

  @override
  State<DeviceManagementWidget> createState() => _DeviceManagementWidgetState();
}

class _DeviceManagementWidgetState extends State<DeviceManagementWidget> {
  late DeviceManagementModel _model;

  String _currentDeviceId = '';

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DeviceManagementModel());
    () async {
      final id = await DeviceSessionService.getCurrentDeviceId();
      if (mounted) {
        setState(() => _currentDeviceId = id);
      }
    }();
  }

  @override
  void dispose() {
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
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          automaticallyImplyLeading: false,
          leading: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(6.0, 6.0, 6.0, 6.0),
            child: FlutterFlowIconButton(
              borderColor: FlutterFlowTheme.of(context).transparent,
              borderRadius: 30.0,
              borderWidth: 0.0,
              buttonSize: 40.0,
              fillColor: FlutterFlowTheme.of(context).transparent,
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
          title: Text(
            'Device Management',
            style: FlutterFlowTheme.of(context).titleMedium.override(
                  fontFamily: 'Onest',
                  letterSpacing: 0.0,
                ),
          ),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 8.0),
                child: Text(
                  'These devices are currently signed in to your account.',
                  style: FlutterFlowTheme.of(context).labelLarge.override(
                        fontFamily: 'Onest',
                        color: FlutterFlowTheme.of(context).secondaryText,
                        letterSpacing: 0.0,
                      ),
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('device_sessions')
                      .where('uid', isEqualTo: currentUserUid)
                      .orderBy('lastActiveTime', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final docs = snapshot.data!.docs;
                    if (docs.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Text(
                            'No active devices found.',
                            style: FlutterFlowTheme.of(context).bodyMedium,
                          ),
                        ),
                      );
                    }
                    return ListView.separated(
                      itemCount: docs.length,
                      separatorBuilder: (_, __) => Divider(height: 1),
                      itemBuilder: (context, index) {
                        final data = docs[index].data();
                        final deviceId = data['deviceId'] as String? ?? '';
                        final platform = (data['platform'] as String?) ?? '';
                        final name = (data['deviceName'] as String?)?.trim();
                        final os = (data['osVersion'] as String?)?.trim();
                        final lastActive = (data['lastActiveTime'] as Timestamp?)
                                ?.toDate() ??
                            null;
                        final isThisDevice = deviceId.isNotEmpty &&
                            _currentDeviceId.isNotEmpty &&
                            deviceId == _currentDeviceId;

                        IconData icon;
                        switch (platform) {
                          case 'android':
                            icon = FFIcons.kdevicePhoneMobile;
                            break;
                          case 'ios':
                            icon = FFIcons.kdevicePhoneMobile;
                            break;
                          case 'web':
                            icon = FFIcons.kmonitor01;
                            break;
                          default:
                            icon = FFIcons.kdevicePhoneMobile;
                        }

                        return ListTile(
                          leading: Icon(
                            icon,
                            color: FlutterFlowTheme.of(context).primaryText,
                          ),
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  name?.isNotEmpty == true
                                      ? name!
                                      : (platform.isNotEmpty
                                          ? platform
                                          : 'Unknown Device'),
                                  style: FlutterFlowTheme.of(context)
                                      .labelLarge
                                      .override(
                                        fontFamily: 'Onest',
                                        letterSpacing: 0.0,
                                      ),
                                ),
                              ),
                              if (isThisDevice)
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color:
                                        FlutterFlowTheme.of(context).accent1,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    'This device',
                                    style: FlutterFlowTheme.of(context)
                                        .labelSmall
                                        .override(
                                          fontFamily: 'Onest',
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                ),
                            ],
                          ),
                          subtitle: Text(
                            [
                              if (os?.isNotEmpty == true) os!,
                              if (lastActive != null)
                                'Last active ${dateTimeFormat("relative", lastActive)}',
                            ].where((e) => e.isNotEmpty).join(' • '),
                            style: FlutterFlowTheme.of(context)
                                .bodySmall
                                .override(
                                  fontFamily: 'Onest',
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  letterSpacing: 0.0,
                                ),
                          ),
                          trailing: isThisDevice
                              ? TextButton(
                                  onPressed: () async {
                                    // Sign out this device.
                                    await DeviceSessionService
                                        .signOutThisDevice();
                                  },
                                  child: Text('Sign out',
                                      style: FlutterFlowTheme.of(context)
                                          .labelMedium),
                                )
                              : TextButton(
                                  onPressed: () async {
                                    // Revoke remote device by deleting its session.
                                    await docs[index].reference.delete();
                                  },
                                  child: Text('Sign out',
                                      style: FlutterFlowTheme.of(context)
                                          .labelMedium),
                                ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
