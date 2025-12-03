import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/auth/firebase_auth/auth_util.dart';

/// Background message handler - must be a top-level function
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Handling background message: ${message.messageId}');
  debugPrint('Message data: ${message.data}');
  debugPrint('Message notification: ${message.notification?.title}');
}

class PushNotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static String? _fcmToken;

  /// Initialize push notifications
  static Future<void> initialize() async {
    // Skip on web - FCM requires additional web configuration
    if (kIsWeb) {
      debugPrint('Push notifications not supported on web preview');
      return;
    }

    try {
      // Request permission for iOS and newer Android versions
      final settings = await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      debugPrint('Push notification permission status: ${settings.authorizationStatus}');

      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {
        // Get the FCM token
        await _getAndSaveToken();

        // Listen for token refresh
        _messaging.onTokenRefresh.listen(_saveTokenToFirestore);

        // Set up foreground message handler
        FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

        // Set up background message handler
        FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

        // Handle notification tap when app is in background/terminated
        FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

        // Check if app was opened from a notification
        final initialMessage = await _messaging.getInitialMessage();
        if (initialMessage != null) {
          _handleNotificationTap(initialMessage);
        }

        debugPrint('Push notification service initialized successfully');
      } else {
        debugPrint('Push notification permission denied');
      }
    } catch (e) {
      debugPrint('Error initializing push notifications: $e');
    }
  }

  /// Get FCM token and save to Firestore
  static Future<void> _getAndSaveToken() async {
    try {
      _fcmToken = await _messaging.getToken();
      debugPrint('FCM Token: $_fcmToken');

      if (_fcmToken != null) {
        await _saveTokenToFirestore(_fcmToken!);
      }
    } catch (e) {
      debugPrint('Error getting FCM token: $e');
    }
  }

  /// Save FCM token to user's Firestore document
  static Future<void> _saveTokenToFirestore(String token) async {
    try {
      if (currentUserReference != null) {
        await currentUserReference!.update({
          'fcmToken': token,
        });
        debugPrint('FCM token saved to Firestore');
      }
    } catch (e) {
      debugPrint('Error saving FCM token to Firestore: $e');
    }
  }

  /// Update token when user logs in
  static Future<void> updateTokenOnLogin() async {
    if (kIsWeb) return;

    try {
      final token = await _messaging.getToken();
      if (token != null && currentUserReference != null) {
        await currentUserReference!.update({
          'fcmToken': token,
        });
        debugPrint('FCM token updated on login');
      }
    } catch (e) {
      debugPrint('Error updating FCM token on login: $e');
    }
  }

  /// Clear token when user logs out
  static Future<void> clearTokenOnLogout() async {
    if (kIsWeb) return;

    try {
      if (currentUserReference != null) {
        await currentUserReference!.update({
          'fcmToken': FieldValue.delete(),
        });
        debugPrint('FCM token cleared on logout');
      }
    } catch (e) {
      debugPrint('Error clearing FCM token: $e');
    }
  }

  /// Handle foreground messages
  static void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('Received foreground message: ${message.messageId}');
    debugPrint('Title: ${message.notification?.title}');
    debugPrint('Body: ${message.notification?.body}');
    debugPrint('Data: ${message.data}');

    // You can show a local notification here if needed
    // For now, the app is in foreground so the user can see the message in real-time
  }

  /// Handle notification tap
  static void _handleNotificationTap(RemoteMessage message) {
    debugPrint('Notification tapped: ${message.messageId}');
    debugPrint('Data: ${message.data}');

    // Navigate to chat if chatId is provided
    final chatId = message.data['chatId'];
    if (chatId != null) {
      // Navigation will be handled by the app's routing
      debugPrint('Should navigate to chat: $chatId');
    }
  }

  /// Get current FCM token
  static String? get currentToken => _fcmToken;

  /// Subscribe to a topic
  static Future<void> subscribeToTopic(String topic) async {
    if (kIsWeb) return;
    try {
      await _messaging.subscribeToTopic(topic);
      debugPrint('Subscribed to topic: $topic');
    } catch (e) {
      debugPrint('Error subscribing to topic: $e');
    }
  }

  /// Unsubscribe from a topic
  static Future<void> unsubscribeFromTopic(String topic) async {
    if (kIsWeb) return;
    try {
      await _messaging.unsubscribeFromTopic(topic);
      debugPrint('Unsubscribed from topic: $topic');
    } catch (e) {
      debugPrint('Error unsubscribing from topic: $e');
    }
  }
}
