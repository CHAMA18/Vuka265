import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class NotificationsRecord extends FirestoreRecord {
  NotificationsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "NotificationTitle" field.
  String? _notificationTitle;
  String get notificationTitle => _notificationTitle ?? '';
  bool hasNotificationTitle() => _notificationTitle != null;

  // "NotficationContent" field.
  String? _notficationContent;
  String get notficationContent => _notficationContent ?? '';
  bool hasNotficationContent() => _notficationContent != null;

  // "TimeDate" field.
  DateTime? _timeDate;
  DateTime? get timeDate => _timeDate;
  bool hasTimeDate() => _timeDate != null;

  // "User" field.
  DocumentReference? _user;
  DocumentReference? get user => _user;
  bool hasUser() => _user != null;

  // "Delivered" field.
  bool? _delivered;
  bool get delivered => _delivered ?? false;
  bool hasDelivered() => _delivered != null;

  // "senderID" field.
  DocumentReference? _senderID;
  DocumentReference? get senderID => _senderID;
  bool hasSenderID() => _senderID != null;

  void _initializeFields() {
    _notificationTitle = snapshotData['NotificationTitle'] as String?;
    _notficationContent = snapshotData['NotficationContent'] as String?;
    _timeDate = snapshotData['TimeDate'] as DateTime?;
    _user = snapshotData['User'] as DocumentReference?;
    _delivered = snapshotData['Delivered'] as bool?;
    _senderID = snapshotData['senderID'] as DocumentReference?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('notifications');

  static Stream<NotificationsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => NotificationsRecord.fromSnapshot(s));

  static Future<NotificationsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => NotificationsRecord.fromSnapshot(s));

  static NotificationsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      NotificationsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static NotificationsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      NotificationsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'NotificationsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is NotificationsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createNotificationsRecordData({
  String? notificationTitle,
  String? notficationContent,
  DateTime? timeDate,
  DocumentReference? user,
  bool? delivered,
  DocumentReference? senderID,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'NotificationTitle': notificationTitle,
      'NotficationContent': notficationContent,
      'TimeDate': timeDate,
      'User': user,
      'Delivered': delivered,
      'senderID': senderID,
    }.withoutNulls,
  );

  return firestoreData;
}

class NotificationsRecordDocumentEquality
    implements Equality<NotificationsRecord> {
  const NotificationsRecordDocumentEquality();

  @override
  bool equals(NotificationsRecord? e1, NotificationsRecord? e2) {
    return e1?.notificationTitle == e2?.notificationTitle &&
        e1?.notficationContent == e2?.notficationContent &&
        e1?.timeDate == e2?.timeDate &&
        e1?.user == e2?.user &&
        e1?.delivered == e2?.delivered &&
        e1?.senderID == e2?.senderID;
  }

  @override
  int hash(NotificationsRecord? e) => const ListEquality().hash([
        e?.notificationTitle,
        e?.notficationContent,
        e?.timeDate,
        e?.user,
        e?.delivered,
        e?.senderID
      ]);

  @override
  bool isValidKey(Object? o) => o is NotificationsRecord;
}
