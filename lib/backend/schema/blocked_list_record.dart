import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class BlockedListRecord extends FirestoreRecord {
  BlockedListRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "Blocker" field.
  DocumentReference? _blocker;
  DocumentReference? get blocker => _blocker;
  bool hasBlocker() => _blocker != null;

  // "Blocked" field.
  DocumentReference? _blocked;
  DocumentReference? get blocked => _blocked;
  bool hasBlocked() => _blocked != null;

  // "Date" field.
  DateTime? _date;
  DateTime? get date => _date;
  bool hasDate() => _date != null;

  // "ReportReason" field.
  String? _reportReason;
  String get reportReason => _reportReason ?? '';
  bool hasReportReason() => _reportReason != null;

  void _initializeFields() {
    _blocker = snapshotData['Blocker'] as DocumentReference?;
    _blocked = snapshotData['Blocked'] as DocumentReference?;
    _date = snapshotData['Date'] as DateTime?;
    _reportReason = snapshotData['ReportReason'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('BlockedList');

  static Stream<BlockedListRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => BlockedListRecord.fromSnapshot(s));

  static Future<BlockedListRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => BlockedListRecord.fromSnapshot(s));

  static BlockedListRecord fromSnapshot(DocumentSnapshot snapshot) =>
      BlockedListRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static BlockedListRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      BlockedListRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'BlockedListRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is BlockedListRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createBlockedListRecordData({
  DocumentReference? blocker,
  DocumentReference? blocked,
  DateTime? date,
  String? reportReason,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'Blocker': blocker,
      'Blocked': blocked,
      'Date': date,
      'ReportReason': reportReason,
    }.withoutNulls,
  );

  return firestoreData;
}

class BlockedListRecordDocumentEquality implements Equality<BlockedListRecord> {
  const BlockedListRecordDocumentEquality();

  @override
  bool equals(BlockedListRecord? e1, BlockedListRecord? e2) {
    return e1?.blocker == e2?.blocker &&
        e1?.blocked == e2?.blocked &&
        e1?.date == e2?.date &&
        e1?.reportReason == e2?.reportReason;
  }

  @override
  int hash(BlockedListRecord? e) => const ListEquality()
      .hash([e?.blocker, e?.blocked, e?.date, e?.reportReason]);

  @override
  bool isValidKey(Object? o) => o is BlockedListRecord;
}
