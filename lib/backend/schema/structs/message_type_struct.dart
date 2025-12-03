// ignore_for_file: unnecessary_getters_setters
import '/backend/algolia/serialization_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class MessageTypeStruct extends FFFirebaseStruct {
  MessageTypeStruct({
    String? text,
    String? images,
    String? video,
    String? voicenote,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _text = text,
        _images = images,
        _video = video,
        _voicenote = voicenote,
        super(firestoreUtilData);

  // "text" field.
  String? _text;
  String get text => _text ?? '';
  set text(String? val) => _text = val;

  bool hasText() => _text != null;

  // "images" field.
  String? _images;
  String get images => _images ?? '';
  set images(String? val) => _images = val;

  bool hasImages() => _images != null;

  // "video" field.
  String? _video;
  String get video => _video ?? '';
  set video(String? val) => _video = val;

  bool hasVideo() => _video != null;

  // "voicenote" field.
  String? _voicenote;
  String get voicenote => _voicenote ?? '';
  set voicenote(String? val) => _voicenote = val;

  bool hasVoicenote() => _voicenote != null;

  static MessageTypeStruct fromMap(Map<String, dynamic> data) =>
      MessageTypeStruct(
        text: data['text'] as String?,
        images: data['images'] as String?,
        video: data['video'] as String?,
        voicenote: data['voicenote'] as String?,
      );

  static MessageTypeStruct? maybeFromMap(dynamic data) => data is Map
      ? MessageTypeStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'text': _text,
        'images': _images,
        'video': _video,
        'voicenote': _voicenote,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'text': serializeParam(
          _text,
          ParamType.String,
        ),
        'images': serializeParam(
          _images,
          ParamType.String,
        ),
        'video': serializeParam(
          _video,
          ParamType.String,
        ),
        'voicenote': serializeParam(
          _voicenote,
          ParamType.String,
        ),
      }.withoutNulls;

  static MessageTypeStruct fromSerializableMap(Map<String, dynamic> data) =>
      MessageTypeStruct(
        text: deserializeParam(
          data['text'],
          ParamType.String,
          false,
        ),
        images: deserializeParam(
          data['images'],
          ParamType.String,
          false,
        ),
        video: deserializeParam(
          data['video'],
          ParamType.String,
          false,
        ),
        voicenote: deserializeParam(
          data['voicenote'],
          ParamType.String,
          false,
        ),
      );

  static MessageTypeStruct fromAlgoliaData(Map<String, dynamic> data) =>
      MessageTypeStruct(
        text: convertAlgoliaParam(
          data['text'],
          ParamType.String,
          false,
        ),
        images: convertAlgoliaParam(
          data['images'],
          ParamType.String,
          false,
        ),
        video: convertAlgoliaParam(
          data['video'],
          ParamType.String,
          false,
        ),
        voicenote: convertAlgoliaParam(
          data['voicenote'],
          ParamType.String,
          false,
        ),
        firestoreUtilData: FirestoreUtilData(
          clearUnsetFields: false,
          create: true,
        ),
      );

  @override
  String toString() => 'MessageTypeStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is MessageTypeStruct &&
        text == other.text &&
        images == other.images &&
        video == other.video &&
        voicenote == other.voicenote;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([text, images, video, voicenote]);
}

MessageTypeStruct createMessageTypeStruct({
  String? text,
  String? images,
  String? video,
  String? voicenote,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    MessageTypeStruct(
      text: text,
      images: images,
      video: video,
      voicenote: voicenote,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

MessageTypeStruct? updateMessageTypeStruct(
  MessageTypeStruct? messageType, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    messageType
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addMessageTypeStructData(
  Map<String, dynamic> firestoreData,
  MessageTypeStruct? messageType,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (messageType == null) {
    return;
  }
  if (messageType.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && messageType.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final messageTypeData =
      getMessageTypeFirestoreData(messageType, forFieldValue);
  final nestedData =
      messageTypeData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = messageType.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getMessageTypeFirestoreData(
  MessageTypeStruct? messageType, [
  bool forFieldValue = false,
]) {
  if (messageType == null) {
    return {};
  }
  final firestoreData = mapToFirestore(messageType.toMap());

  // Add any Firestore field values
  messageType.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getMessageTypeListFirestoreData(
  List<MessageTypeStruct>? messageTypes,
) =>
    messageTypes?.map((e) => getMessageTypeFirestoreData(e, true)).toList() ??
    [];
