import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// Social Profiles
class SocialprofilesRecord extends FirestoreRecord {
  SocialprofilesRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "SocialMediaLink" field.
  String? _socialMediaLink;
  String get socialMediaLink => _socialMediaLink ?? '';
  bool hasSocialMediaLink() => _socialMediaLink != null;

  // "Social" field.
  DocumentReference? _social;
  DocumentReference? get social => _social;
  bool hasSocial() => _social != null;

  // "User" field.
  DocumentReference? _user;
  DocumentReference? get user => _user;
  bool hasUser() => _user != null;

  // "platform" field.
  DocumentReference? _platform;
  DocumentReference? get platform => _platform;
  bool hasPlatform() => _platform != null;

  void _initializeFields() {
    _socialMediaLink = snapshotData['SocialMediaLink'] as String?;
    _social = snapshotData['Social'] as DocumentReference?;
    _user = snapshotData['User'] as DocumentReference?;
    _platform = snapshotData['platform'] as DocumentReference?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('socialprofiles');

  static Stream<SocialprofilesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => SocialprofilesRecord.fromSnapshot(s));

  static Future<SocialprofilesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => SocialprofilesRecord.fromSnapshot(s));

  static SocialprofilesRecord fromSnapshot(DocumentSnapshot snapshot) =>
      SocialprofilesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static SocialprofilesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      SocialprofilesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'SocialprofilesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is SocialprofilesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createSocialprofilesRecordData({
  String? socialMediaLink,
  DocumentReference? social,
  DocumentReference? user,
  DocumentReference? platform,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'SocialMediaLink': socialMediaLink,
      'Social': social,
      'User': user,
      'platform': platform,
    }.withoutNulls,
  );

  return firestoreData;
}

class SocialprofilesRecordDocumentEquality
    implements Equality<SocialprofilesRecord> {
  const SocialprofilesRecordDocumentEquality();

  @override
  bool equals(SocialprofilesRecord? e1, SocialprofilesRecord? e2) {
    return e1?.socialMediaLink == e2?.socialMediaLink &&
        e1?.social == e2?.social &&
        e1?.user == e2?.user &&
        e1?.platform == e2?.platform;
  }

  @override
  int hash(SocialprofilesRecord? e) => const ListEquality()
      .hash([e?.socialMediaLink, e?.social, e?.user, e?.platform]);

  @override
  bool isValidKey(Object? o) => o is SocialprofilesRecord;
}
