import 'package:flutter/material.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'dart:convert';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _Languages = prefs
              .getStringList('ff_Languages')
              ?.map((x) {
                try {
                  return LanguagesStruct.fromSerializableMap(jsonDecode(x));
                } catch (e) {
                  print("Can't decode persisted data type. Error: $e.");
                  return null;
                }
              })
              .withoutNulls
              .toList() ??
          _Languages;
    });
    _safeInit(() {
      _categories = prefs
              .getStringList('ff_categories')
              ?.map((x) {
                try {
                  return CategoryStruct.fromSerializableMap(jsonDecode(x));
                } catch (e) {
                  print("Can't decode persisted data type. Error: $e.");
                  return null;
                }
              })
              .withoutNulls
              .toList() ??
          _categories;
    });
    _safeInit(() {
      _enablE = prefs.getBool('ff_enablE') ?? _enablE;
    });
    _safeInit(() {
      _addedUserList =
          prefs.getStringList('ff_addedUserList') ?? _addedUserList;
    });
    _safeInit(() {
      _savedPaymentCards =
          prefs.getStringList('ff_savedPaymentCards') ?? _savedPaymentCards;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  bool _AutoUpdate = false;
  bool get AutoUpdate => _AutoUpdate;
  set AutoUpdate(bool value) {
    _AutoUpdate = value;
  }

  double _start = 0.0;
  double get start => _start;
  set start(double value) {
    _start = value;
  }

  double _end = 60.0;
  double get end => _end;
  set end(double value) {
    _end = value;
  }

  int _MatchesTab = 0;
  int get MatchesTab => _MatchesTab;
  set MatchesTab(int value) {
    _MatchesTab = value;
  }

  int _distance = 0;
  int get distance => _distance;
  set distance(int value) {
    _distance = value;
  }

  bool _Switch1 = true;
  bool get Switch1 => _Switch1;
  set Switch1(bool value) {
    _Switch1 = value;
  }

  bool _Switch2 = true;
  bool get Switch2 => _Switch2;
  set Switch2(bool value) {
    _Switch2 = value;
  }

  bool _Switch3 = true;
  bool get Switch3 => _Switch3;
  set Switch3(bool value) {
    _Switch3 = value;
  }

  bool _Switch4 = false;
  bool get Switch4 => _Switch4;
  set Switch4(bool value) {
    _Switch4 = value;
  }

  bool _Switch5 = false;
  bool get Switch5 => _Switch5;
  set Switch5(bool value) {
    _Switch5 = value;
  }

  bool _Switch6 = true;
  bool get Switch6 => _Switch6;
  set Switch6(bool value) {
    _Switch6 = value;
  }

  bool _Switch7 = false;
  bool get Switch7 => _Switch7;
  set Switch7(bool value) {
    _Switch7 = value;
  }

  bool _Switch8 = false;
  bool get Switch8 => _Switch8;
  set Switch8(bool value) {
    _Switch8 = value;
  }

  bool _Switch9 = true;
  bool get Switch9 => _Switch9;
  set Switch9(bool value) {
    _Switch9 = value;
  }

  bool _Switch10 = true;
  bool get Switch10 => _Switch10;
  set Switch10(bool value) {
    _Switch10 = value;
  }

  bool _Switch11 = false;
  bool get Switch11 => _Switch11;
  set Switch11(bool value) {
    _Switch11 = value;
  }

  bool _Switch12 = false;
  bool get Switch12 => _Switch12;
  set Switch12(bool value) {
    _Switch12 = value;
  }

  List<LanguagesStruct> _Languages = [
    LanguagesStruct.fromSerializableMap(jsonDecode(
        '{\"img\":\"https://firebasestorage.googleapis.com/v0/b/datinger-e2bc1.appspot.com/o/image_2024-09-03_21-04-31.png?alt=media&token=7d727615-4daa-4fce-8311-aaf932e7d6e8\",\"title\":\"English (US)\"}')),
    LanguagesStruct.fromSerializableMap(jsonDecode(
        '{\"img\":\"https://firebasestorage.googleapis.com/v0/b/datinger-e2bc1.appspot.com/o/image_2024-09-03_21-04-49.png?alt=media&token=86fc3a2f-af7c-4e79-a425-db3595894a77\",\"title\":\"English (UK)\"}')),
    LanguagesStruct.fromSerializableMap(jsonDecode(
        '{\"img\":\"https://firebasestorage.googleapis.com/v0/b/datinger-e2bc1.appspot.com/o/image_2024-09-03_21-05-05.png?alt=media&token=e8fc1ae4-4060-4c53-9452-17d8825120c5\",\"title\":\"Mandarin\"}')),
    LanguagesStruct.fromSerializableMap(jsonDecode(
        '{\"img\":\"https://firebasestorage.googleapis.com/v0/b/datinger-e2bc1.appspot.com/o/image_2024-09-03_21-05-19.png?alt=media&token=240aff33-6e71-4cd7-97ba-12810162bfb5\",\"title\":\"Spanish\"}')),
    LanguagesStruct.fromSerializableMap(jsonDecode(
        '{\"img\":\"https://firebasestorage.googleapis.com/v0/b/datinger-e2bc1.appspot.com/o/image_2024-09-03_21-05-36.png?alt=media&token=67367c11-1ce1-48cf-8dfb-52bc78a2e11b\",\"title\":\"Hindi\"}')),
    LanguagesStruct.fromSerializableMap(jsonDecode(
        '{\"img\":\"https://firebasestorage.googleapis.com/v0/b/datinger-e2bc1.appspot.com/o/image_2024-09-03_21-05-51.png?alt=media&token=df7d997f-7081-45bf-8f35-f2c4b904c4b8\",\"title\":\"French\"}')),
    LanguagesStruct.fromSerializableMap(jsonDecode(
        '{\"img\":\"https://firebasestorage.googleapis.com/v0/b/datinger-e2bc1.appspot.com/o/image_2024-09-03_21-06-11.png?alt=media&token=413da6b3-a070-4229-9632-a04b70e78eb1\",\"title\":\"Arabic\"}')),
    LanguagesStruct.fromSerializableMap(jsonDecode(
        '{\"img\":\"https://firebasestorage.googleapis.com/v0/b/datinger-e2bc1.appspot.com/o/image_2024-09-03_21-06-29.png?alt=media&token=45713e7e-7258-4c8d-b912-23d35d9902b8\",\"title\":\"Russian\"}')),
    LanguagesStruct.fromSerializableMap(jsonDecode(
        '{\"img\":\"https://firebasestorage.googleapis.com/v0/b/datinger-e2bc1.appspot.com/o/image_2024-09-03_21-06-45.png?alt=media&token=7188e698-9ec0-4f9b-b85d-9ed137e1c81c\",\"title\":\"Japanese\"}'))
  ];
  List<LanguagesStruct> get Languages => _Languages;
  set Languages(List<LanguagesStruct> value) {
    _Languages = value;
    prefs.setStringList(
        'ff_Languages', value.map((x) => x.serialize()).toList());
  }

  void addToLanguages(LanguagesStruct value) {
    Languages.add(value);
    prefs.setStringList(
        'ff_Languages', _Languages.map((x) => x.serialize()).toList());
  }

  void removeFromLanguages(LanguagesStruct value) {
    Languages.remove(value);
    prefs.setStringList(
        'ff_Languages', _Languages.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromLanguages(int index) {
    Languages.removeAt(index);
    prefs.setStringList(
        'ff_Languages', _Languages.map((x) => x.serialize()).toList());
  }

  void updateLanguagesAtIndex(
    int index,
    LanguagesStruct Function(LanguagesStruct) updateFn,
  ) {
    Languages[index] = updateFn(_Languages[index]);
    prefs.setStringList(
        'ff_Languages', _Languages.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInLanguages(int index, LanguagesStruct value) {
    Languages.insert(index, value);
    prefs.setStringList(
        'ff_Languages', _Languages.map((x) => x.serialize()).toList());
  }

  List<String> _chatMessages = [];
  List<String> get chatMessages => _chatMessages;
  set chatMessages(List<String> value) {
    _chatMessages = value;
  }

  void addToChatMessages(String value) {
    chatMessages.add(value);
  }

  void removeFromChatMessages(String value) {
    chatMessages.remove(value);
  }

  void removeAtIndexFromChatMessages(int index) {
    chatMessages.removeAt(index);
  }

  void updateChatMessagesAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    chatMessages[index] = updateFn(_chatMessages[index]);
  }

  void insertAtIndexInChatMessages(int index, String value) {
    chatMessages.insert(index, value);
  }

  List<CategoryStruct> _categories = [];
  List<CategoryStruct> get categories => _categories;
  set categories(List<CategoryStruct> value) {
    _categories = value;
    prefs.setStringList(
        'ff_categories', value.map((x) => x.serialize()).toList());
  }

  void addToCategories(CategoryStruct value) {
    categories.add(value);
    prefs.setStringList(
        'ff_categories', _categories.map((x) => x.serialize()).toList());
  }

  void removeFromCategories(CategoryStruct value) {
    categories.remove(value);
    prefs.setStringList(
        'ff_categories', _categories.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromCategories(int index) {
    categories.removeAt(index);
    prefs.setStringList(
        'ff_categories', _categories.map((x) => x.serialize()).toList());
  }

  void updateCategoriesAtIndex(
    int index,
    CategoryStruct Function(CategoryStruct) updateFn,
  ) {
    categories[index] = updateFn(_categories[index]);
    prefs.setStringList(
        'ff_categories', _categories.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInCategories(int index, CategoryStruct value) {
    categories.insert(index, value);
    prefs.setStringList(
        'ff_categories', _categories.map((x) => x.serialize()).toList());
  }

  double _filterDistance = 0.0;
  double get filterDistance => _filterDistance;
  set filterDistance(double value) {
    _filterDistance = value;
  }

  int _filterAge = 0;
  int get filterAge => _filterAge;
  set filterAge(int value) {
    _filterAge = value;
  }

  int _filterNumberOfPhotos = 0;
  int get filterNumberOfPhotos => _filterNumberOfPhotos;
  set filterNumberOfPhotos(int value) {
    _filterNumberOfPhotos = value;
  }

  List<String> _filterGender = [];
  List<String> get filterGender => _filterGender;
  set filterGender(List<String> value) {
    _filterGender = value;
  }

  void addToFilterGender(String value) {
    filterGender.add(value);
  }

  void removeFromFilterGender(String value) {
    filterGender.remove(value);
  }

  void removeAtIndexFromFilterGender(int index) {
    filterGender.removeAt(index);
  }

  void updateFilterGenderAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    filterGender[index] = updateFn(_filterGender[index]);
  }

  void insertAtIndexInFilterGender(int index, String value) {
    filterGender.insert(index, value);
  }

  bool _filterHasBio = false;
  bool get filterHasBio => _filterHasBio;
  set filterHasBio(bool value) {
    _filterHasBio = value;
  }

  List<String> _filterInterests = [];
  List<String> get filterInterests => _filterInterests;
  set filterInterests(List<String> value) {
    _filterInterests = value;
  }

  void addToFilterInterests(String value) {
    filterInterests.add(value);
  }

  void removeFromFilterInterests(String value) {
    filterInterests.remove(value);
  }

  void removeAtIndexFromFilterInterests(int index) {
    filterInterests.removeAt(index);
  }

  void updateFilterInterestsAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    filterInterests[index] = updateFn(_filterInterests[index]);
  }

  void insertAtIndexInFilterInterests(int index, String value) {
    filterInterests.insert(index, value);
  }

  List<String> _filterLanguages = [];
  List<String> get filterLanguages => _filterLanguages;
  set filterLanguages(List<String> value) {
    _filterLanguages = value;
  }

  void addToFilterLanguages(String value) {
    filterLanguages.add(value);
  }

  void removeFromFilterLanguages(String value) {
    filterLanguages.remove(value);
  }

  void removeAtIndexFromFilterLanguages(int index) {
    filterLanguages.removeAt(index);
  }

  void updateFilterLanguagesAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    filterLanguages[index] = updateFn(_filterLanguages[index]);
  }

  void insertAtIndexInFilterLanguages(int index, String value) {
    filterLanguages.insert(index, value);
  }

  List<String> _filterRelationshipGoals = [];
  List<String> get filterRelationshipGoals => _filterRelationshipGoals;
  set filterRelationshipGoals(List<String> value) {
    _filterRelationshipGoals = value;
  }

  void addToFilterRelationshipGoals(String value) {
    filterRelationshipGoals.add(value);
  }

  void removeFromFilterRelationshipGoals(String value) {
    filterRelationshipGoals.remove(value);
  }

  void removeAtIndexFromFilterRelationshipGoals(int index) {
    filterRelationshipGoals.removeAt(index);
  }

  void updateFilterRelationshipGoalsAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    filterRelationshipGoals[index] = updateFn(_filterRelationshipGoals[index]);
  }

  void insertAtIndexInFilterRelationshipGoals(int index, String value) {
    filterRelationshipGoals.insert(index, value);
  }

  bool _enablE = false;
  bool get enablE => _enablE;
  set enablE(bool value) {
    _enablE = value;
    prefs.setBool('ff_enablE', value);
  }

  List<dynamic> _algoliaResults = [];
  List<dynamic> get algoliaResults => _algoliaResults;
  set algoliaResults(List<dynamic> value) {
    _algoliaResults = value;
  }

  void addToAlgoliaResults(dynamic value) {
    algoliaResults.add(value);
  }

  void removeFromAlgoliaResults(dynamic value) {
    algoliaResults.remove(value);
  }

  void removeAtIndexFromAlgoliaResults(int index) {
    algoliaResults.removeAt(index);
  }

  void updateAlgoliaResultsAtIndex(
    int index,
    dynamic Function(dynamic) updateFn,
  ) {
    algoliaResults[index] = updateFn(_algoliaResults[index]);
  }

  void insertAtIndexInAlgoliaResults(int index, dynamic value) {
    algoliaResults.insert(index, value);
  }

  bool _fromFilter = false;
  bool get fromFilter => _fromFilter;
  set fromFilter(bool value) {
    _fromFilter = value;
  }

  List<String> _addedUserList = [];
  List<String> get addedUserList => _addedUserList;
  set addedUserList(List<String> value) {
    _addedUserList = value;
    prefs.setStringList('ff_addedUserList', value);
  }

  void addToAddedUserList(String value) {
    addedUserList.add(value);
    prefs.setStringList('ff_addedUserList', _addedUserList);
  }

  void removeFromAddedUserList(String value) {
    addedUserList.remove(value);
    prefs.setStringList('ff_addedUserList', _addedUserList);
  }

  void removeAtIndexFromAddedUserList(int index) {
    addedUserList.removeAt(index);
    prefs.setStringList('ff_addedUserList', _addedUserList);
  }

  void updateAddedUserListAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    addedUserList[index] = updateFn(_addedUserList[index]);
    prefs.setStringList('ff_addedUserList', _addedUserList);
  }

  void insertAtIndexInAddedUserList(int index, String value) {
    addedUserList.insert(index, value);
    prefs.setStringList('ff_addedUserList', _addedUserList);
  }

  List<String> _savedPaymentCards = [];
  List<String> get savedPaymentCards => _savedPaymentCards;
  set savedPaymentCards(List<String> value) {
    _savedPaymentCards = value;
    prefs.setStringList('ff_savedPaymentCards', value);
  }

  void addToSavedPaymentCards(String value) {
    savedPaymentCards.add(value);
    prefs.setStringList('ff_savedPaymentCards', _savedPaymentCards);
  }

  void removeFromSavedPaymentCards(String value) {
    savedPaymentCards.remove(value);
    prefs.setStringList('ff_savedPaymentCards', _savedPaymentCards);
  }

  void removeAtIndexFromSavedPaymentCards(int index) {
    savedPaymentCards.removeAt(index);
    prefs.setStringList('ff_savedPaymentCards', _savedPaymentCards);
  }

  void updateSavedPaymentCardsAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    savedPaymentCards[index] = updateFn(_savedPaymentCards[index]);
    prefs.setStringList('ff_savedPaymentCards', _savedPaymentCards);
  }

  void insertAtIndexInSavedPaymentCards(int index, String value) {
    savedPaymentCards.insert(index, value);
    prefs.setStringList('ff_savedPaymentCards', _savedPaymentCards);
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
