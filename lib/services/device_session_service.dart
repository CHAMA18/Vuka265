import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/firebase_auth/auth_util.dart';

/// Service to register and manage per-device login sessions for a user.
class DeviceSessionService {
  static const _prefsKey = 'ff_deviceId';
  static const _collectionName = 'device_sessions';

  static String? _deviceIdCache;
  static StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>?
      _sessionWatch;
  static Timer? _heartbeatTimer;

  /// Ensures a stable per-install deviceId stored locally.
  static Future<String> _getOrCreateDeviceId() async {
    if (_deviceIdCache != null) return _deviceIdCache!;
    final prefs = await SharedPreferences.getInstance();
    var id = prefs.getString(_prefsKey);
    if (id == null || id.isEmpty) {
      // Generate a pseudo-random id that's good enough to uniquely
      // identify this install across sessions.
      final rng = Random.secure();
      id = List.generate(24, (_) => rng.nextInt(36))
          .map((n) => n.toRadixString(36))
          .join();
      await prefs.setString(_prefsKey, id);
    }
    _deviceIdCache = id;
    return id;
  }

  /// Returns the locally persisted deviceId for the current install.
  static Future<String> getCurrentDeviceId() => _getOrCreateDeviceId();

  /// Collects device details in a cross-platform way.
  static Future<Map<String, dynamic>> _collectDeviceInfo() async {
    final plugin = DeviceInfoPlugin();
    String platform;
    String name = '';
    String os = '';
    try {
      if (kIsWeb) {
        final info = await plugin.webBrowserInfo;
        platform = 'web';
        name = info.browserName.name;
        os = info.userAgent ?? '';
      } else {
        // Try Android, else iOS, else generic.
        try {
          final a = await plugin.androidInfo;
          platform = 'android';
          name = '${a.brand} ${a.model}';
          os = 'Android ${a.version.release}';
        } catch (_) {
          try {
            final i = await plugin.iosInfo;
            platform = 'ios';
            name = i.utsname.machine ?? 'iOS Device';
            os = '${i.systemName} ${i.systemVersion}';
          } catch (_) {
            platform = 'unknown';
          }
        }
      }
    } catch (_) {
      platform = 'unknown';
    }

    return {
      'platform': platform,
      'deviceName': name,
      'osVersion': os,
    };
  }

  /// Returns the document reference for the current device session.
  static Future<DocumentReference<Map<String, dynamic>>?>
      _sessionDocRef() async {
    if (!loggedIn) return null;
    final uid = currentUserUid;
    final deviceId = await _getOrCreateDeviceId();
    return FirebaseFirestore.instance
        .collection(_collectionName)
        .doc('${uid}_$deviceId');
  }

  /// Create or update the current device session record.
  static Future<void> registerOrUpdateCurrentSession() async {
    if (!loggedIn) return;
    final info = await _collectDeviceInfo();
    final deviceId = await _getOrCreateDeviceId();
    final ref = await _sessionDocRef();
    if (ref == null) return;
    final now = DateTime.now();
    await ref.set({
      'userRef': currentUserReference,
      'uid': currentUserUid,
      'deviceId': deviceId,
      'platform': info['platform'],
      'deviceName': info['deviceName'],
      'osVersion': info['osVersion'],
      'createdTime': FieldValue.serverTimestamp(),
      'lastActiveTime': now,
      'revoked': false,
    }, SetOptions(merge: true));
    
    // Update user's lastActiveTime in users collection
    await _updateUserLastActiveTime();
    
    // Start periodic heartbeat to keep user status updated
    _startHeartbeat();
  }

  /// Update the user's lastActiveTime field in the users collection
  static Future<void> _updateUserLastActiveTime() async {
    if (!loggedIn || currentUserReference == null) return;
    try {
      await currentUserReference!.update({
        'lastActiveTime': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // Ignore errors - field might not exist yet
    }
  }

  /// Start a periodic timer to update user's active status
  static void _startHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(Duration(minutes: 2), (_) async {
      await _updateUserLastActiveTime();
    });
  }

  /// Stop the heartbeat timer
  static void _stopHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
  }

  /// Start watching the session doc for remote sign-out.
  static Future<void> startSessionWatch(BuildContext context) async {
    await _sessionWatch?.cancel();
    if (!loggedIn) return;
    final ref = await _sessionDocRef();
    if (ref == null) return;
    _sessionWatch = ref.snapshots().listen((snap) async {
      if (!snap.exists) {
        // Our session was deleted remotely. Sign out.
        try {
          await authManager.signOut();
        } catch (_) {}
        return;
      }
      final data = snap.data();
      if (data != null && data['revoked'] == true) {
        try {
          await authManager.signOut();
        } catch (_) {}
      }
    });
  }

  /// Stop watching the session document.
  static Future<void> stopSessionWatch() async {
    await _sessionWatch?.cancel();
    _sessionWatch = null;
    _stopHeartbeat();
  }

  /// Sign out the current device by deleting its session and signing out auth.
  static Future<void> signOutThisDevice() async {
    _stopHeartbeat();
    final ref = await _sessionDocRef();
    try {
      await ref?.delete();
    } catch (_) {}
    await authManager.signOut();
  }
}
