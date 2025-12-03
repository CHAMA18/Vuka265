import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class MessagesRecord extends FirestoreRecord {
  MessagesRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "senderId" field.
  DocumentReference? _senderId;
  DocumentReference? get senderId => _senderId;
  bool hasSenderId() => _senderId != null;

  // "receiverId" field.
  DocumentReference? _receiverId;
  DocumentReference? get receiverId => _receiverId;
  bool hasReceiverId() => _receiverId != null;

  // "messageText" field.
  String? _messageText;
  String get messageText => _messageText ?? '';
  bool hasMessageText() => _messageText != null;

  // "timestamp" field.
  DateTime? _timestamp;
  DateTime? get timestamp => _timestamp;
  bool hasTimestamp() => _timestamp != null;

  // "senderName" field.
  String? _senderName;
  String get senderName => _senderName ?? '';
  bool hasSenderName() => _senderName != null;

  // "messageType" field.
  String? _messageType;
  String get messageType => _messageType ?? 'text';
  bool hasMessageType() => _messageType != null;

  // "mediaUrl" field.
  String? _mediaUrl;
  String get mediaUrl => _mediaUrl ?? '';
  bool hasMediaUrl() => _mediaUrl != null;

  // "mediaDuration" field.
  int? _mediaDuration;
  int get mediaDuration => _mediaDuration ?? 0;
  bool hasMediaDuration() => _mediaDuration != null;

  // "isDelivered" field.
  bool? _isDelivered;
  bool get isDelivered => _isDelivered ?? false;
  bool hasIsDelivered() => _isDelivered != null;

  // "isRead" field.
  bool? _isRead;
  bool get isRead => _isRead ?? false;
  bool hasIsRead() => _isRead != null;

  DocumentReference get parentReference => reference.parent.parent!;

  void _initializeFields() {
    _senderId = snapshotData['senderId'] as DocumentReference?;
    _receiverId = snapshotData['receiverId'] as DocumentReference?;
    _messageText = snapshotData['messageText'] as String?;
    _timestamp = snapshotData['timestamp'] as DateTime?;
    _senderName = snapshotData['senderName'] as String?;
    _messageType = snapshotData['messageType'] as String?;
    _mediaUrl = snapshotData['mediaUrl'] as String?;
    _mediaDuration = castToType<int>(snapshotData['mediaDuration']);
    _isDelivered = snapshotData['isDelivered'] as bool?;
    _isRead = snapshotData['isRead'] as bool?;
  }

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('messages')
          : FirebaseFirestore.instance.collectionGroup('messages');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('messages').doc(id);

  static Stream<MessagesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => MessagesRecord.fromSnapshot(s));

  static Future<MessagesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => MessagesRecord.fromSnapshot(s));

  static MessagesRecord fromSnapshot(DocumentSnapshot snapshot) =>
      MessagesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static MessagesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      MessagesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'MessagesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is MessagesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createMessagesRecordData({
  DocumentReference? senderId,
  DocumentReference? receiverId,
  String? messageText,
  DateTime? timestamp,
  String? senderName,
  String? messageType,
  String? mediaUrl,
  int? mediaDuration,
  bool? isDelivered,
  bool? isRead,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'senderId': senderId,
      'receiverId': receiverId,
      'messageText': messageText,
      'timestamp': timestamp,
      'senderName': senderName,
      'messageType': messageType,
      'mediaUrl': mediaUrl,
      'mediaDuration': mediaDuration,
      'isDelivered': isDelivered,
      'isRead': isRead,
    }.withoutNulls,
  );

  return firestoreData;
}

class MessagesRecordDocumentEquality implements Equality<MessagesRecord> {
  const MessagesRecordDocumentEquality();

  @override
  bool equals(MessagesRecord? e1, MessagesRecord? e2) {
    return e1?.senderId == e2?.senderId &&
        e1?.receiverId == e2?.receiverId &&
        e1?.messageText == e2?.messageText &&
        e1?.timestamp == e2?.timestamp &&
        e1?.senderName == e2?.senderName &&
        e1?.messageType == e2?.messageType &&
        e1?.mediaUrl == e2?.mediaUrl &&
        e1?.mediaDuration == e2?.mediaDuration &&
        e1?.isDelivered == e2?.isDelivered &&
        e1?.isRead == e2?.isRead;
  }

  @override
  int hash(MessagesRecord? e) => const ListEquality().hash([
        e?.senderId,
        e?.receiverId,
        e?.messageText,
        e?.timestamp,
        e?.senderName,
        e?.messageType,
        e?.mediaUrl,
        e?.mediaDuration,
        e?.isDelivered,
        e?.isRead,
      ]);

  @override
  bool isValidKey(Object? o) => o is MessagesRecord;
}
