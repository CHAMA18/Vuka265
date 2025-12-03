// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart' as functions; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:cloud_firestore/cloud_firestore.dart';

/// Deduplicate chats for a given user by ensuring only one chat document exists
/// per unique pair of participants. Keeps/creates a canonical chat with a
/// deterministic ID and migrates messages from duplicates, then deletes them.
Future<void> dedupeChatsForUser(DocumentReference userRef) async {
  final firestore = FirebaseFirestore.instance;

  try {
    // Fetch all chats where the user participates
    final chatsSnap = await firestore
        .collection('chats')
        .where('userIDs', arrayContains: userRef)
        .get();

    if (chatsSnap.docs.isEmpty) return;

    // Group chats by the other participant's id (assuming 1:1 chats)
    final Map<String, List<QueryDocumentSnapshot<Map<String, dynamic>>>> groups = {};

    for (final doc in chatsSnap.docs) {
      final data = doc.data();
      final List<dynamic>? usersDyn = data['userIDs'] as List<dynamic>?;
      if (usersDyn == null || usersDyn.length != 2) {
        // Skip non 1:1 chats
        continue;
      }
      final users = usersDyn.cast<DocumentReference>();
      // Identify other participant
      final other = users.first == userRef ? users.last : users.first;
      final key = [userRef.id, other.id]..sort();
      final groupKey = '${key[0]}_${key[1]}';
      groups.putIfAbsent(groupKey, () => []).add(doc);
    }

    // Process groups with duplicates
    for (final entry in groups.entries) {
      final docs = entry.value;
      if (docs.length <= 1) continue; // already unique

      // Determine participants
      final firstData = docs.first.data();
      final users = (firstData['userIDs'] as List).cast<DocumentReference>();
      final userA = users.first;
      final userB = users.last;
      final a = userA.id.compareTo(userB.id) <= 0 ? userA : userB;
      final b = a == userA ? userB : userA;

      // Canonical ref based on deterministic id
      final canonicalId = functions.chatDocId(a, b);
      final canonicalRef = firestore.collection('chats').doc(canonicalId);

      // Pick best source doc (most recent lastMessageTime)
      QueryDocumentSnapshot<Map<String, dynamic>> bestDoc = docs.first;
      DateTime? bestTime = (bestDoc.data()['lastMessageTime'] as Timestamp?)?.toDate();
      for (final d in docs.skip(1)) {
        final t = (d.data()['lastMessageTime'] as Timestamp?)?.toDate();
        if (bestTime == null || (t != null && t.isAfter(bestTime))) {
          bestDoc = d;
          bestTime = t;
        }
      }

      // Ensure canonical chat exists with correct metadata
      final canonicalSnap = await canonicalRef.get();
      if (!canonicalSnap.exists) {
        final meta = bestDoc.data();
        final List<dynamic> userNamesDyn = (meta['userName'] as List<dynamic>? ?? []);
        await canonicalRef.set({
          'lastMessage': meta['lastMessage'],
          'lastMessageTime': meta['lastMessageTime'],
          'userIDs': [a, b],
          'userName': userNamesDyn.map((e) => e.toString()).toList(),
          'lastSeenBy': meta['lastSeenBy'] ?? [],
        });
      }

      // Migrate messages from all duplicates into canonical, then delete duplicates
      for (final d in docs) {
        if (d.reference.path == canonicalRef.path) continue; // skip canonical

        // Copy messages
        final msgsSnap = await d.reference.collection('messages').get();

        // Use batched writes to migrate messages
        WriteBatch? batch;
        int opCount = 0;
        void commitIfNeeded() async {
          if (batch != null && opCount > 0) {
            await batch!.commit();
          }
          batch = firestore.batch();
          opCount = 0;
        }

        batch = firestore.batch();
        for (final msg in msgsSnap.docs) {
          // Write message under canonical chat with same id to avoid duplicates
          final targetRef = canonicalRef.collection('messages').doc(msg.id);
          batch!.set(targetRef, msg.data(), SetOptions(merge: true));
          opCount++;
          if (opCount >= 450) {
            await batch!.commit();
            batch = firestore.batch();
            opCount = 0;
          }
        }
        if (opCount > 0) {
          await batch!.commit();
        }

        // After migrating, delete original messages and the duplicate chat
        final delMsgsSnap = await d.reference.collection('messages').get();
        WriteBatch delBatch = firestore.batch();
        int delCount = 0;
        for (final msg in delMsgsSnap.docs) {
          delBatch.delete(msg.reference);
          delCount++;
          if (delCount >= 450) {
            await delBatch.commit();
            delBatch = firestore.batch();
            delCount = 0;
          }
        }
        if (delCount > 0) {
          await delBatch.commit();
        }

        // Finally delete the duplicate chat document
        await d.reference.delete();
      }
    }
  } catch (e) {
    debugPrint('dedupeChatsForUser error: $e');
  }
}
