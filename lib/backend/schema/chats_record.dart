import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ChatsRecord extends FirestoreRecord {
  ChatsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "lastMessage" field.
  String? _lastMessage;
  String get lastMessage => _lastMessage ?? '';
  bool hasLastMessage() => _lastMessage != null;

  // "lastMessageTime" field.
  DateTime? _lastMessageTime;
  DateTime? get lastMessageTime => _lastMessageTime;
  bool hasLastMessageTime() => _lastMessageTime != null;

  // "userIDs" field.
  List<DocumentReference>? _userIDs;
  List<DocumentReference> get userIDs => _userIDs ?? const [];
  bool hasUserIDs() => _userIDs != null;

  // "userName" field.
  List<String>? _userName;
  List<String> get userName => _userName ?? const [];
  bool hasUserName() => _userName != null;

  // "lastSeenBy" field.
  List<DocumentReference>? _lastSeenBy;
  List<DocumentReference> get lastSeenBy => _lastSeenBy ?? const [];
  bool hasLastSeenBy() => _lastSeenBy != null;

  // "isPinned" field.
  bool? _isPinned;
  bool get isPinned => _isPinned ?? false;
  bool hasIsPinned() => _isPinned != null;

  // "isArchived" field.
  bool? _isArchived;
  bool get isArchived => _isArchived ?? false;
  bool hasIsArchived() => _isArchived != null;

  // "pinnedBy" field.
  List<DocumentReference>? _pinnedBy;
  List<DocumentReference> get pinnedBy => _pinnedBy ?? const [];
  bool hasPinnedBy() => _pinnedBy != null;

  // "archivedBy" field.
  List<DocumentReference>? _archivedBy;
  List<DocumentReference> get archivedBy => _archivedBy ?? const [];
  bool hasArchivedBy() => _archivedBy != null;

  void _initializeFields() {
    _lastMessage = snapshotData['lastMessage'] as String?;
    _lastMessageTime = snapshotData['lastMessageTime'] as DateTime?;
    _userIDs = getDataList(snapshotData['userIDs']);
    _userName = getDataList(snapshotData['userName']);
    _lastSeenBy = getDataList(snapshotData['lastSeenBy']);
    _isPinned = snapshotData['isPinned'] as bool?;
    _isArchived = snapshotData['isArchived'] as bool?;
    _pinnedBy = getDataList(snapshotData['pinnedBy']);
    _archivedBy = getDataList(snapshotData['archivedBy']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('chats');

  static Stream<ChatsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ChatsRecord.fromSnapshot(s));

  static Future<ChatsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ChatsRecord.fromSnapshot(s));

  static ChatsRecord fromSnapshot(DocumentSnapshot snapshot) => ChatsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ChatsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ChatsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ChatsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ChatsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createChatsRecordData({
  String? lastMessage,
  DateTime? lastMessageTime,
  bool? isPinned,
  bool? isArchived,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime,
      'isPinned': isPinned,
      'isArchived': isArchived,
    }.withoutNulls,
  );

  return firestoreData;
}

class ChatsRecordDocumentEquality implements Equality<ChatsRecord> {
  const ChatsRecordDocumentEquality();

  @override
  bool equals(ChatsRecord? e1, ChatsRecord? e2) {
    const listEquality = ListEquality();
    return e1?.lastMessage == e2?.lastMessage &&
        e1?.lastMessageTime == e2?.lastMessageTime &&
        listEquality.equals(e1?.userIDs, e2?.userIDs) &&
        listEquality.equals(e1?.userName, e2?.userName) &&
        listEquality.equals(e1?.lastSeenBy, e2?.lastSeenBy) &&
        e1?.isPinned == e2?.isPinned &&
        e1?.isArchived == e2?.isArchived &&
        listEquality.equals(e1?.pinnedBy, e2?.pinnedBy) &&
        listEquality.equals(e1?.archivedBy, e2?.archivedBy);
  }

  @override
  int hash(ChatsRecord? e) => const ListEquality().hash([
        e?.lastMessage,
        e?.lastMessageTime,
        e?.userIDs,
        e?.userName,
        e?.lastSeenBy,
        e?.isPinned,
        e?.isArchived,
        e?.pinnedBy,
        e?.archivedBy
      ]);

  @override
  bool isValidKey(Object? o) => o is ChatsRecord;
}
