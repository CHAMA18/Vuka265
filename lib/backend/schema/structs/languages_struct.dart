// ignore_for_file: unnecessary_getters_setters
import '/backend/algolia/serialization_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class LanguagesStruct extends FFFirebaseStruct {
  LanguagesStruct({
    String? img,
    String? title,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _img = img,
        _title = title,
        super(firestoreUtilData);

  // "img" field.
  String? _img;
  String get img => _img ?? '';
  set img(String? val) => _img = val;

  bool hasImg() => _img != null;

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  set title(String? val) => _title = val;

  bool hasTitle() => _title != null;

  static LanguagesStruct fromMap(Map<String, dynamic> data) => LanguagesStruct(
        img: data['img'] as String?,
        title: data['title'] as String?,
      );

  static LanguagesStruct? maybeFromMap(dynamic data) => data is Map
      ? LanguagesStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'img': _img,
        'title': _title,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'img': serializeParam(
          _img,
          ParamType.String,
        ),
        'title': serializeParam(
          _title,
          ParamType.String,
        ),
      }.withoutNulls;

  static LanguagesStruct fromSerializableMap(Map<String, dynamic> data) =>
      LanguagesStruct(
        img: deserializeParam(
          data['img'],
          ParamType.String,
          false,
        ),
        title: deserializeParam(
          data['title'],
          ParamType.String,
          false,
        ),
      );

  static LanguagesStruct fromAlgoliaData(Map<String, dynamic> data) =>
      LanguagesStruct(
        img: convertAlgoliaParam(
          data['img'],
          ParamType.String,
          false,
        ),
        title: convertAlgoliaParam(
          data['title'],
          ParamType.String,
          false,
        ),
        firestoreUtilData: FirestoreUtilData(
          clearUnsetFields: false,
          create: true,
        ),
      );

  @override
  String toString() => 'LanguagesStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is LanguagesStruct && img == other.img && title == other.title;
  }

  @override
  int get hashCode => const ListEquality().hash([img, title]);
}

LanguagesStruct createLanguagesStruct({
  String? img,
  String? title,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    LanguagesStruct(
      img: img,
      title: title,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

LanguagesStruct? updateLanguagesStruct(
  LanguagesStruct? languages, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    languages
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addLanguagesStructData(
  Map<String, dynamic> firestoreData,
  LanguagesStruct? languages,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (languages == null) {
    return;
  }
  if (languages.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && languages.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final languagesData = getLanguagesFirestoreData(languages, forFieldValue);
  final nestedData = languagesData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = languages.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getLanguagesFirestoreData(
  LanguagesStruct? languages, [
  bool forFieldValue = false,
]) {
  if (languages == null) {
    return {};
  }
  final firestoreData = mapToFirestore(languages.toMap());

  // Add any Firestore field values
  languages.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getLanguagesListFirestoreData(
  List<LanguagesStruct>? languagess,
) =>
    languagess?.map((e) => getLanguagesFirestoreData(e, true)).toList() ?? [];
