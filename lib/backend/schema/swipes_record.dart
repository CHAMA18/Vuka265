import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SwipesRecord extends FirestoreRecord {
  SwipesRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "type" field.
  bool? _type;
  bool get type => _type ?? false;
  bool hasType() => _type != null;

  // "timestamp" field.
  DateTime? _timestamp;
  DateTime? get timestamp => _timestamp;
  bool hasTimestamp() => _timestamp != null;

  // "swiperId" field.
  DocumentReference? _swiperId;
  DocumentReference? get swiperId => _swiperId;
  bool hasSwiperId() => _swiperId != null;

  // "targetuserid" field.
  DocumentReference? _targetuserid;
  DocumentReference? get targetuserid => _targetuserid;
  bool hasTargetuserid() => _targetuserid != null;

  void _initializeFields() {
    _type = snapshotData['type'] as bool?;
    _timestamp = snapshotData['timestamp'] as DateTime?;
    _swiperId = snapshotData['swiperId'] as DocumentReference?;
    _targetuserid = snapshotData['targetuserid'] as DocumentReference?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('swipes');

  static Stream<SwipesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => SwipesRecord.fromSnapshot(s));

  static Future<SwipesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => SwipesRecord.fromSnapshot(s));

  static SwipesRecord fromSnapshot(DocumentSnapshot snapshot) => SwipesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static SwipesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      SwipesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'SwipesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is SwipesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createSwipesRecordData({
  bool? type,
  DateTime? timestamp,
  DocumentReference? swiperId,
  DocumentReference? targetuserid,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'type': type,
      'timestamp': timestamp,
      'swiperId': swiperId,
      'targetuserid': targetuserid,
    }.withoutNulls,
  );

  return firestoreData;
}

class SwipesRecordDocumentEquality implements Equality<SwipesRecord> {
  const SwipesRecordDocumentEquality();

  @override
  bool equals(SwipesRecord? e1, SwipesRecord? e2) {
    return e1?.type == e2?.type &&
        e1?.timestamp == e2?.timestamp &&
        e1?.swiperId == e2?.swiperId &&
        e1?.targetuserid == e2?.targetuserid;
  }

  @override
  int hash(SwipesRecord? e) => const ListEquality()
      .hash([e?.type, e?.timestamp, e?.swiperId, e?.targetuserid]);

  @override
  bool isValidKey(Object? o) => o is SwipesRecord;
}
