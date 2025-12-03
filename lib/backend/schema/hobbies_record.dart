import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// List of Hobbies & Preferences
class HobbiesRecord extends FirestoreRecord {
  HobbiesRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "nameofhobby" field.
  String? _nameofhobby;
  String get nameofhobby => _nameofhobby ?? '';
  bool hasNameofhobby() => _nameofhobby != null;

  // "icon" field.
  String? _icon;
  String get icon => _icon ?? '';
  bool hasIcon() => _icon != null;

  void _initializeFields() {
    _nameofhobby = snapshotData['nameofhobby'] as String?;
    _icon = snapshotData['icon'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('hobbies');

  static Stream<HobbiesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => HobbiesRecord.fromSnapshot(s));

  static Future<HobbiesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => HobbiesRecord.fromSnapshot(s));

  static HobbiesRecord fromSnapshot(DocumentSnapshot snapshot) =>
      HobbiesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static HobbiesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      HobbiesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'HobbiesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is HobbiesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createHobbiesRecordData({
  String? nameofhobby,
  String? icon,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'nameofhobby': nameofhobby,
      'icon': icon,
    }.withoutNulls,
  );

  return firestoreData;
}

class HobbiesRecordDocumentEquality implements Equality<HobbiesRecord> {
  const HobbiesRecordDocumentEquality();

  @override
  bool equals(HobbiesRecord? e1, HobbiesRecord? e2) {
    return e1?.nameofhobby == e2?.nameofhobby && e1?.icon == e2?.icon;
  }

  @override
  int hash(HobbiesRecord? e) =>
      const ListEquality().hash([e?.nameofhobby, e?.icon]);

  @override
  bool isValidKey(Object? o) => o is HobbiesRecord;
}
