import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// socialplatforms
class SocialplatformsRecord extends FirestoreRecord {
  SocialplatformsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "instagram" field.
  bool? _instagram;
  bool get instagram => _instagram ?? false;
  bool hasInstagram() => _instagram != null;

  // "Tiktok" field.
  bool? _tiktok;
  bool get tiktok => _tiktok ?? false;
  bool hasTiktok() => _tiktok != null;

  // "Facebook" field.
  bool? _facebook;
  bool get facebook => _facebook ?? false;
  bool hasFacebook() => _facebook != null;

  // "Twitter_x" field.
  bool? _twitterX;
  bool get twitterX => _twitterX ?? false;
  bool hasTwitterX() => _twitterX != null;

  DocumentReference get parentReference => reference.parent.parent!;

  void _initializeFields() {
    _instagram = snapshotData['instagram'] as bool?;
    _tiktok = snapshotData['Tiktok'] as bool?;
    _facebook = snapshotData['Facebook'] as bool?;
    _twitterX = snapshotData['Twitter_x'] as bool?;
  }

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('socialplatforms')
          : FirebaseFirestore.instance.collectionGroup('socialplatforms');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('socialplatforms').doc(id);

  static Stream<SocialplatformsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => SocialplatformsRecord.fromSnapshot(s));

  static Future<SocialplatformsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => SocialplatformsRecord.fromSnapshot(s));

  static SocialplatformsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      SocialplatformsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static SocialplatformsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      SocialplatformsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'SocialplatformsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is SocialplatformsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createSocialplatformsRecordData({
  bool? instagram,
  bool? tiktok,
  bool? facebook,
  bool? twitterX,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'instagram': instagram,
      'Tiktok': tiktok,
      'Facebook': facebook,
      'Twitter_x': twitterX,
    }.withoutNulls,
  );

  return firestoreData;
}

class SocialplatformsRecordDocumentEquality
    implements Equality<SocialplatformsRecord> {
  const SocialplatformsRecordDocumentEquality();

  @override
  bool equals(SocialplatformsRecord? e1, SocialplatformsRecord? e2) {
    return e1?.instagram == e2?.instagram &&
        e1?.tiktok == e2?.tiktok &&
        e1?.facebook == e2?.facebook &&
        e1?.twitterX == e2?.twitterX;
  }

  @override
  int hash(SocialplatformsRecord? e) => const ListEquality()
      .hash([e?.instagram, e?.tiktok, e?.facebook, e?.twitterX]);

  @override
  bool isValidKey(Object? o) => o is SocialplatformsRecord;
}
