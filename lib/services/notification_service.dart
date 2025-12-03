import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vuka265/backend/backend.dart';
import 'package:vuka265/auth/firebase_auth/auth_util.dart';

class NotificationService {
  static Future<void> createNotification({
    required String title,
    required String content,
    DocumentReference? senderID,
  }) async {
    if (currentUserReference == null) return;

    await NotificationsRecord.collection.add({
      'NotificationTitle': title,
      'NotficationContent': content,
      'TimeDate': DateTime.now(),
      'User': currentUserReference,
      'Delivered': false,
      'senderID': senderID,
    });
  }

  // Notification for new match
  static Future<void> notifyNewMatch(DocumentReference matchedUserRef) async {
    await createNotification(
      title: '🎉 New Match!',
      content: 'You\'ve got a new match! Start a conversation and get to know each other.',
      senderID: matchedUserRef,
    );
  }

  // Notification for new message
  static Future<void> notifyNewMessage(DocumentReference senderRef, String senderName) async {
    await createNotification(
      title: '💬 New Message',
      content: '$senderName sent you a message. Tap to view and reply.',
      senderID: senderRef,
    );
  }

  // Notification for subscription upgrade
  static Future<void> notifySubscriptionUpgrade(String planName) async {
    await createNotification(
      title: '⭐ Subscription Upgraded!',
      content: 'Welcome to $planName! You now have access to unlimited messaging and premium features.',
    );
  }

  // Notification for subscription downgrade/cancellation
  static Future<void> notifySubscriptionChange(String message) async {
    await createNotification(
      title: '📋 Subscription Updated',
      content: message,
    );
  }

  // Notification for payment method added
  static Future<void> notifyPaymentMethodAdded(String cardBrand, String lastFour) async {
    await createNotification(
      title: '💳 Payment Method Added',
      content: 'Your $cardBrand card ending in $lastFour has been successfully added.',
    );
  }

  // Notification for payment method removed
  static Future<void> notifyPaymentMethodRemoved(String cardBrand, String lastFour) async {
    await createNotification(
      title: '💳 Payment Method Removed',
      content: 'Your $cardBrand card ending in $lastFour has been removed from your account.',
    );
  }

  // Notification for theme change
  static Future<void> notifyThemeChange(String theme) async {
    await createNotification(
      title: '🎨 Theme Updated',
      content: 'Your app appearance has been changed to $theme mode.',
    );
  }

  // Notification for profile update
  static Future<void> notifyProfileUpdate() async {
    await createNotification(
      title: '✅ Profile Updated',
      content: 'Your profile information has been successfully updated.',
    );
  }

  // Notification for account security change
  static Future<void> notifySecurityChange(String action) async {
    await createNotification(
      title: '🔒 Security Update',
      content: '$action Your account security settings have been updated.',
    );
  }

  // Notification for message limit reached
  static Future<void> notifyMessageLimitReached() async {
    await createNotification(
      title: '⚠️ Message Limit Reached',
      content: 'You\'ve reached your daily message limit (20 messages). Upgrade to Premium for unlimited messaging!',
    );
  }

  // Notification for privacy settings change
  static Future<void> notifyPrivacyChange(String setting) async {
    await createNotification(
      title: '🔐 Privacy Settings Updated',
      content: 'Your $setting privacy settings have been updated successfully.',
    );
  }

  // Notification for blocked user
  static Future<void> notifyUserBlocked(String username) async {
    await createNotification(
      title: '🚫 User Blocked',
      content: '$username has been blocked and will no longer be able to contact you.',
    );
  }

  // Notification for unblocked user
  static Future<void> notifyUserUnblocked(String username) async {
    await createNotification(
      title: '✅ User Unblocked',
      content: '$username has been unblocked and can now contact you again.',
    );
  }
}
