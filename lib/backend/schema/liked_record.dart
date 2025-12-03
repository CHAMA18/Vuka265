import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// liked by users
class LikedRecord extends FirestoreRecord {
  LikedRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "user" field.
  DocumentReference? _user;
  DocumentReference? get user => _user;
  bool hasUser() => _user != null;

  // "likedbypotentialmatch" field.
  bool? _likedbypotentialmatch;
  bool get likedbypotentialmatch => _likedbypotentialmatch ?? false;
  bool hasLikedbypotentialmatch() => _likedbypotentialmatch != null;

  // "time" field.
  DateTime? _time;
  DateTime? get time => _time;
  bool hasTime() => _time != null;

  DocumentReference get parentReference => reference.parent.parent!;

  void _initializeFields() {
    _user = snapshotData['user'] as DocumentReference?;
    _likedbypotentialmatch = snapshotData['likedbypotentialmatch'] as bool?;
    _time = snapshotData['time'] as DateTime?;
  }

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('liked')
          : FirebaseFirestore.instance.collectionGroup('liked');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('liked').doc(id);

  static Stream<LikedRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => LikedRecord.fromSnapshot(s));

  static Future<LikedRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => LikedRecord.fromSnapshot(s));

  static LikedRecord fromSnapshot(DocumentSnapshot snapshot) => LikedRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static LikedRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      LikedRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'LikedRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is LikedRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createLikedRecordData({
  DocumentReference? user,
  bool? likedbypotentialmatch,
  DateTime? time,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'user': user,
      'likedbypotentialmatch': likedbypotentialmatch,
      'time': time,
    }.withoutNulls,
  );

  return firestoreData;
}

class LikedRecordDocumentEquality implements Equality<LikedRecord> {
  const LikedRecordDocumentEquality();

  @override
  bool equals(LikedRecord? e1, LikedRecord? e2) {
    return e1?.user == e2?.user &&
        e1?.likedbypotentialmatch == e2?.likedbypotentialmatch &&
        e1?.time == e2?.time;
  }

  @override
  int hash(LikedRecord? e) =>
      const ListEquality().hash([e?.user, e?.likedbypotentialmatch, e?.time]);

  @override
  bool isValidKey(Object? o) => o is LikedRecord;
}
