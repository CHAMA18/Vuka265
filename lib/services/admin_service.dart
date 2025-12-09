import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:vuka265/backend/schema/users_record.dart';

class AdminCredentials {
  static const String adminEmail = 'admin@vuka265.com';
  static const String adminPassword = 'Vuka265';

  static bool validateCredentials(String email, String password) {
    return email.toLowerCase() == adminEmail.toLowerCase() &&
        password == adminPassword;
  }
}

class AdminAnalytics {
  final int totalUsers;
  final int activeUsersToday;
  final int totalMatches;
  final int totalMessages;
  final int newUsersThisWeek;
  final int premiumUsers;
  final double totalRevenue;
  final List<UserActivity> mostActiveUsers;
  final Map<String, int> userGrowthByMonth;
  final Map<String, int> pageViews;

  AdminAnalytics({
    required this.totalUsers,
    required this.activeUsersToday,
    required this.totalMatches,
    required this.totalMessages,
    required this.newUsersThisWeek,
    required this.premiumUsers,
    required this.totalRevenue,
    required this.mostActiveUsers,
    required this.userGrowthByMonth,
    required this.pageViews,
  });
}

class UserActivity {
  final String oderId;
  final String email;
  final String displayName;
  final String photoUrl;
  final int matchCount;
  final int messageCount;
  final DateTime? lastActive;

  UserActivity({
    required this.oderId,
    required this.email,
    required this.displayName,
    required this.photoUrl,
    required this.matchCount,
    required this.messageCount,
    this.lastActive,
  });
}

class PaymentRecord {
  final String oderId;
  final String depositId;
  final String oderId2;
  final String userEmail;
  final String userName;
  final String planName;
  final double amount;
  final String currency;
  final String status;
  final DateTime createdAt;
  final String? correspondentName;

  PaymentRecord({
    required this.oderId,
    required this.depositId,
    required this.oderId2,
    required this.userEmail,
    required this.userName,
    required this.planName,
    required this.amount,
    required this.currency,
    required this.status,
    required this.createdAt,
    this.correspondentName,
  });

  factory PaymentRecord.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PaymentRecord(
      oderId: doc.id,
      depositId: data['depositId'] ?? '',
      oderId2: data['userId'] ?? '',
      userEmail: data['userEmail'] ?? '',
      userName: data['userName'] ?? 'Unknown',
      planName: data['planName'] ?? '',
      amount: (data['amount'] ?? 0).toDouble(),
      currency: data['currency'] ?? 'USD',
      status: data['status'] ?? 'UNKNOWN',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      correspondentName: data['correspondentName'],
    );
  }
}

class SpecialAccessRecord {
  final String oderId;
  final String oderId2;
  final String userEmail;
  final String userName;
  final String accessType;
  final DateTime grantedAt;
  final DateTime expiresAt;
  final String grantedBy;
  final bool isActive;

  SpecialAccessRecord({
    required this.oderId,
    required this.oderId2,
    required this.userEmail,
    required this.userName,
    required this.accessType,
    required this.grantedAt,
    required this.expiresAt,
    required this.grantedBy,
    required this.isActive,
  });

  factory SpecialAccessRecord.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SpecialAccessRecord(
      oderId: doc.id,
      oderId2: data['userId'] ?? '',
      userEmail: data['userEmail'] ?? '',
      userName: data['userName'] ?? 'Unknown',
      accessType: data['accessType'] ?? 'Premium',
      grantedAt: (data['grantedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      expiresAt: (data['expiresAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      grantedBy: data['grantedBy'] ?? 'Admin',
      isActive: data['isActive'] ?? false,
    );
  }
}

class AdminService {
  static final _firestore = FirebaseFirestore.instance;

  static Future<List<UsersRecord>> getAllUsers({
    int limit = 50,
    DocumentSnapshot? lastDocument,
    String? searchQuery,
  }) async {
    try {
      Query query = UsersRecord.collection.orderBy('created_time', descending: true);

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      query = query.limit(limit);

      final snapshot = await query.get();
      return snapshot.docs.map((doc) => UsersRecord.fromSnapshot(doc)).toList();
    } catch (e) {
      debugPrint('Error fetching users: $e');
      return [];
    }
  }

  static Future<int> getTotalUsersCount() async {
    try {
      final snapshot = await UsersRecord.collection.count().get();
      return snapshot.count ?? 0;
    } catch (e) {
      debugPrint('Error getting total users count: $e');
      return 0;
    }
  }

  static Future<int> getActiveUsersTodayCount() async {
    try {
      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day);

      final snapshot = await _firestore
          .collection('users')
          .where('lastMessageResetDate', isGreaterThanOrEqualTo: startOfDay)
          .count()
          .get();

      return snapshot.count ?? 0;
    } catch (e) {
      debugPrint('Error getting active users count: $e');
      return 0;
    }
  }

  static Future<int> getNewUsersThisWeekCount() async {
    try {
      final now = DateTime.now();
      final weekAgo = now.subtract(const Duration(days: 7));

      final snapshot = await _firestore
          .collection('users')
          .where('created_time', isGreaterThanOrEqualTo: weekAgo)
          .count()
          .get();

      return snapshot.count ?? 0;
    } catch (e) {
      debugPrint('Error getting new users count: $e');
      return 0;
    }
  }

  static Future<int> getTotalMatchesCount() async {
    try {
      final snapshot = await _firestore.collection('chats').count().get();
      return snapshot.count ?? 0;
    } catch (e) {
      debugPrint('Error getting matches count: $e');
      return 0;
    }
  }

  static Future<int> getTotalMessagesCount() async {
    try {
      final snapshot = await _firestore.collection('messages').count().get();
      return snapshot.count ?? 0;
    } catch (e) {
      debugPrint('Error getting messages count: $e');
      return 0;
    }
  }

  static Future<int> getPremiumUsersCount() async {
    try {
      final snapshot = await _firestore
          .collection('subscriptions')
          .where('subscriptionname', isNotEqualTo: 'Free')
          .count()
          .get();

      return snapshot.count ?? 0;
    } catch (e) {
      debugPrint('Error getting premium users count: $e');
      return 0;
    }
  }

  static Future<AdminAnalytics> getAnalytics() async {
    try {
      final results = await Future.wait([
        getTotalUsersCount(),
        getActiveUsersTodayCount(),
        getTotalMatchesCount(),
        getTotalMessagesCount(),
        getNewUsersThisWeekCount(),
        getPremiumUsersCount(),
        getTotalRevenue(),
        getMostActiveUsers(),
        getUserGrowthByMonth(),
      ]);

      return AdminAnalytics(
        totalUsers: results[0] as int,
        activeUsersToday: results[1] as int,
        totalMatches: results[2] as int,
        totalMessages: results[3] as int,
        newUsersThisWeek: results[4] as int,
        premiumUsers: results[5] as int,
        totalRevenue: results[6] as double,
        mostActiveUsers: results[7] as List<UserActivity>,
        userGrowthByMonth: results[8] as Map<String, int>,
        pageViews: {
          'Home': 1250,
          'Matches': 890,
          'Chats': 1100,
          'Profile': 650,
          'Settings': 320,
        },
      );
    } catch (e) {
      debugPrint('Error getting analytics: $e');
      return AdminAnalytics(
        totalUsers: 0,
        activeUsersToday: 0,
        totalMatches: 0,
        totalMessages: 0,
        newUsersThisWeek: 0,
        premiumUsers: 0,
        totalRevenue: 0,
        mostActiveUsers: [],
        userGrowthByMonth: {},
        pageViews: {},
      );
    }
  }

  static Future<double> getTotalRevenue() async {
    try {
      final snapshot = await _firestore
          .collection('payments')
          .where('status', isEqualTo: 'COMPLETED')
          .get();

      double total = 0;
      for (final doc in snapshot.docs) {
        final data = doc.data();
        total += (data['amount'] ?? 0).toDouble();
      }
      return total;
    } catch (e) {
      debugPrint('Error getting total revenue: $e');
      return 0;
    }
  }

  static Future<List<UserActivity>> getMostActiveUsers({int limit = 10}) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .orderBy('dailyMessageCount', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return UserActivity(
          oderId: doc.id,
          email: data['email'] ?? '',
          displayName: data['display_name'] ?? 'Unknown',
          photoUrl: data['photo_url'] ?? '',
          matchCount: (data['myMatches'] as List?)?.length ?? 0,
          messageCount: data['dailyMessageCount'] ?? 0,
          lastActive: (data['lastMessageResetDate'] as Timestamp?)?.toDate(),
        );
      }).toList();
    } catch (e) {
      debugPrint('Error getting most active users: $e');
      return [];
    }
  }

  static Future<Map<String, int>> getUserGrowthByMonth() async {
    try {
      final now = DateTime.now();
      final sixMonthsAgo = DateTime(now.year, now.month - 5, 1);

      final snapshot = await _firestore
          .collection('users')
          .where('created_time', isGreaterThanOrEqualTo: sixMonthsAgo)
          .get();

      final Map<String, int> growth = {};
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

      for (int i = 5; i >= 0; i--) {
        final month = DateTime(now.year, now.month - i, 1);
        final key = months[month.month - 1];
        growth[key] = 0;
      }

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final createdTime = (data['created_time'] as Timestamp?)?.toDate();
        if (createdTime != null) {
          final key = months[createdTime.month - 1];
          if (growth.containsKey(key)) {
            growth[key] = (growth[key] ?? 0) + 1;
          }
        }
      }

      return growth;
    } catch (e) {
      debugPrint('Error getting user growth: $e');
      return {};
    }
  }

  static Future<List<PaymentRecord>> getPayments({
    int limit = 50,
    DocumentSnapshot? lastDocument,
    String? statusFilter,
  }) async {
    try {
      Query query = _firestore.collection('payments').orderBy('createdAt', descending: true);

      if (statusFilter != null && statusFilter.isNotEmpty) {
        query = query.where('status', isEqualTo: statusFilter);
      }

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      query = query.limit(limit);

      final snapshot = await query.get();
      return snapshot.docs.map((doc) => PaymentRecord.fromFirestore(doc)).toList();
    } catch (e) {
      debugPrint('Error fetching payments: $e');
      return [];
    }
  }

  static Future<List<SpecialAccessRecord>> getSpecialAccessRecords({
    int limit = 50,
    bool activeOnly = false,
  }) async {
    try {
      Query query = _firestore.collection('special_access').orderBy('grantedAt', descending: true);

      if (activeOnly) {
        query = query.where('isActive', isEqualTo: true);
      }

      query = query.limit(limit);

      final snapshot = await query.get();
      return snapshot.docs.map((doc) => SpecialAccessRecord.fromFirestore(doc)).toList();
    } catch (e) {
      debugPrint('Error fetching special access records: $e');
      return [];
    }
  }

  static Future<bool> grantSpecialAccess({
    required String oderId,
    required String userEmail,
    required String userName,
    required String accessType,
    required int durationDays,
  }) async {
    try {
      final now = DateTime.now();
      final expiresAt = now.add(Duration(days: durationDays));

      await _firestore.collection('special_access').add({
        'userId': oderId,
        'userEmail': userEmail,
        'userName': userName,
        'accessType': accessType,
        'grantedAt': Timestamp.fromDate(now),
        'expiresAt': Timestamp.fromDate(expiresAt),
        'grantedBy': 'Admin',
        'isActive': true,
      });

      await _firestore.collection('subscriptions').doc(oderId).set({
        'subscriptionname': accessType,
        'price': '0',
        'duration': Timestamp.fromDate(expiresAt),
        'users': _firestore.collection('users').doc(oderId),
      }, SetOptions(merge: true));

      return true;
    } catch (e) {
      debugPrint('Error granting special access: $e');
      return false;
    }
  }

  static Future<bool> revokeSpecialAccess(String accessId) async {
    try {
      await _firestore.collection('special_access').doc(accessId).update({
        'isActive': false,
      });
      return true;
    } catch (e) {
      debugPrint('Error revoking special access: $e');
      return false;
    }
  }

  static Future<bool> suspendUser(String oderId) async {
    try {
      await _firestore.collection('users').doc(oderId).update({
        'isSuspended': true,
        'suspendedAt': Timestamp.now(),
      });
      return true;
    } catch (e) {
      debugPrint('Error suspending user: $e');
      return false;
    }
  }

  static Future<bool> unsuspendUser(String oderId) async {
    try {
      await _firestore.collection('users').doc(oderId).update({
        'isSuspended': false,
        'suspendedAt': FieldValue.delete(),
      });
      return true;
    } catch (e) {
      debugPrint('Error unsuspending user: $e');
      return false;
    }
  }

  static Future<List<UsersRecord>> searchUsers(String query) async {
    try {
      final emailResults = await _firestore
          .collection('users')
          .where('email', isGreaterThanOrEqualTo: query.toLowerCase())
          .where('email', isLessThanOrEqualTo: '${query.toLowerCase()}\uf8ff')
          .limit(20)
          .get();

      final nameResults = await _firestore
          .collection('users')
          .where('display_name', isGreaterThanOrEqualTo: query)
          .where('display_name', isLessThanOrEqualTo: '$query\uf8ff')
          .limit(20)
          .get();

      final Map<String, DocumentSnapshot> uniqueResults = {};
      for (final doc in emailResults.docs) {
        uniqueResults[doc.id] = doc;
      }
      for (final doc in nameResults.docs) {
        uniqueResults[doc.id] = doc;
      }

      return uniqueResults.values.map((doc) => UsersRecord.fromSnapshot(doc)).toList();
    } catch (e) {
      debugPrint('Error searching users: $e');
      return [];
    }
  }
}
