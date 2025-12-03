import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PreferencesRecord extends FirestoreRecord {
  PreferencesRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "minagePreference" field.
  int? _minagePreference;
  int get minagePreference => _minagePreference ?? 0;
  bool hasMinagePreference() => _minagePreference != null;

  // "maxagepreference" field.
  int? _maxagepreference;
  int get maxagepreference => _maxagepreference ?? 0;
  bool hasMaxagepreference() => _maxagepreference != null;

  // "distance" field.
  int? _distance;
  int get distance => _distance ?? 0;
  bool hasDistance() => _distance != null;

  // "hobbies" field.
  List<DocumentReference>? _hobbies;
  List<DocumentReference> get hobbies => _hobbies ?? const [];
  bool hasHobbies() => _hobbies != null;

  // "userRef" field.
  DocumentReference? _userRef;
  DocumentReference? get userRef => _userRef;
  bool hasUserRef() => _userRef != null;

  void _initializeFields() {
    _minagePreference = castToType<int>(snapshotData['minagePreference']);
    _maxagepreference = castToType<int>(snapshotData['maxagepreference']);
    _distance = castToType<int>(snapshotData['distance']);
    _hobbies = getDataList(snapshotData['hobbies']);
    _userRef = snapshotData['userRef'] as DocumentReference?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('preferences');

  static Stream<PreferencesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => PreferencesRecord.fromSnapshot(s));

  static Future<PreferencesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => PreferencesRecord.fromSnapshot(s));

  static PreferencesRecord fromSnapshot(DocumentSnapshot snapshot) =>
      PreferencesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static PreferencesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      PreferencesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'PreferencesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is PreferencesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createPreferencesRecordData({
  int? minagePreference,
  int? maxagepreference,
  int? distance,
  DocumentReference? userRef,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'minagePreference': minagePreference,
      'maxagepreference': maxagepreference,
      'distance': distance,
      'userRef': userRef,
    }.withoutNulls,
  );

  return firestoreData;
}

class PreferencesRecordDocumentEquality implements Equality<PreferencesRecord> {
  const PreferencesRecordDocumentEquality();

  @override
  bool equals(PreferencesRecord? e1, PreferencesRecord? e2) {
    const listEquality = ListEquality();
    return e1?.minagePreference == e2?.minagePreference &&
        e1?.maxagepreference == e2?.maxagepreference &&
        e1?.distance == e2?.distance &&
        listEquality.equals(e1?.hobbies, e2?.hobbies) &&
        e1?.userRef == e2?.userRef;
  }

  @override
  int hash(PreferencesRecord? e) => const ListEquality().hash([
        e?.minagePreference,
        e?.maxagepreference,
        e?.distance,
        e?.hobbies,
        e?.userRef
      ]);

  @override
  bool isValidKey(Object? o) => o is PreferencesRecord;
}
