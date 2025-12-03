// ignore_for_file: unnecessary_getters_setters
import '/backend/algolia/serialization_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class GenderStruct extends FFFirebaseStruct {
  GenderStruct({
    bool? male,
    bool? female,
    bool? other,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _male = male,
        _female = female,
        _other = other,
        super(firestoreUtilData);

  // "Male" field.
  bool? _male;
  bool get male => _male ?? false;
  set male(bool? val) => _male = val;

  bool hasMale() => _male != null;

  // "Female" field.
  bool? _female;
  bool get female => _female ?? false;
  set female(bool? val) => _female = val;

  bool hasFemale() => _female != null;

  // "Other" field.
  bool? _other;
  bool get other => _other ?? false;
  set other(bool? val) => _other = val;

  bool hasOther() => _other != null;

  static GenderStruct fromMap(Map<String, dynamic> data) => GenderStruct(
        male: data['Male'] as bool?,
        female: data['Female'] as bool?,
        other: data['Other'] as bool?,
      );

  static GenderStruct? maybeFromMap(dynamic data) =>
      data is Map ? GenderStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'Male': _male,
        'Female': _female,
        'Other': _other,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'Male': serializeParam(
          _male,
          ParamType.bool,
        ),
        'Female': serializeParam(
          _female,
          ParamType.bool,
        ),
        'Other': serializeParam(
          _other,
          ParamType.bool,
        ),
      }.withoutNulls;

  static GenderStruct fromSerializableMap(Map<String, dynamic> data) =>
      GenderStruct(
        male: deserializeParam(
          data['Male'],
          ParamType.bool,
          false,
        ),
        female: deserializeParam(
          data['Female'],
          ParamType.bool,
          false,
        ),
        other: deserializeParam(
          data['Other'],
          ParamType.bool,
          false,
        ),
      );

  static GenderStruct fromAlgoliaData(Map<String, dynamic> data) =>
      GenderStruct(
        male: convertAlgoliaParam(
          data['Male'],
          ParamType.bool,
          false,
        ),
        female: convertAlgoliaParam(
          data['Female'],
          ParamType.bool,
          false,
        ),
        other: convertAlgoliaParam(
          data['Other'],
          ParamType.bool,
          false,
        ),
        firestoreUtilData: FirestoreUtilData(
          clearUnsetFields: false,
          create: true,
        ),
      );

  @override
  String toString() => 'GenderStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is GenderStruct &&
        male == other.male &&
        female == other.female &&
        other == other.other;
  }

  @override
  int get hashCode => const ListEquality().hash([male, female, other]);
}

GenderStruct createGenderStruct({
  bool? male,
  bool? female,
  bool? other,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    GenderStruct(
      male: male,
      female: female,
      other: other,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

GenderStruct? updateGenderStruct(
  GenderStruct? gender, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    gender
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addGenderStructData(
  Map<String, dynamic> firestoreData,
  GenderStruct? gender,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (gender == null) {
    return;
  }
  if (gender.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && gender.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final genderData = getGenderFirestoreData(gender, forFieldValue);
  final nestedData = genderData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = gender.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getGenderFirestoreData(
  GenderStruct? gender, [
  bool forFieldValue = false,
]) {
  if (gender == null) {
    return {};
  }
  final firestoreData = mapToFirestore(gender.toMap());

  // Add any Firestore field values
  gender.firestoreUtilData.fieldValues.forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getGenderListFirestoreData(
  List<GenderStruct>? genders,
) =>
    genders?.map((e) => getGenderFirestoreData(e, true)).toList() ?? [];
