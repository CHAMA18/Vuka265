import 'dart:async';

import 'package:from_css_color/from_css_color.dart';
import '/backend/algolia/serialization_util.dart';
import '/backend/algolia/algolia_manager.dart';
import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class UsersRecord extends FirestoreRecord {
  UsersRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  bool hasEmail() => _email != null;

  // "display_name" field.
  String? _displayName;
  String get displayName => _displayName ?? '';
  bool hasDisplayName() => _displayName != null;

  // "photo_url" field.
  String? _photoUrl;
  String get photoUrl => _photoUrl ?? '';
  bool hasPhotoUrl() => _photoUrl != null;

  // "uid" field.
  String? _uid;
  String get uid => _uid ?? '';
  bool hasUid() => _uid != null;

  // "created_time" field.
  DateTime? _createdTime;
  DateTime? get createdTime => _createdTime;
  bool hasCreatedTime() => _createdTime != null;

  // "phone_number" field.
  String? _phoneNumber;
  String get phoneNumber => _phoneNumber ?? '';
  bool hasPhoneNumber() => _phoneNumber != null;

  // "imgList" field.
  List<String>? _imgList;
  List<String> get imgList => _imgList ?? const [];
  bool hasImgList() => _imgList != null;

  // "likeUser" field.
  List<DocumentReference>? _likeUser;
  List<DocumentReference> get likeUser => _likeUser ?? const [];
  bool hasLikeUser() => _likeUser != null;

  // "GenderPreference" field.
  GenderStruct? _genderPreference;
  GenderStruct get genderPreference => _genderPreference ?? GenderStruct();
  bool hasGenderPreference() => _genderPreference != null;

  // "Notifications" field.
  DocumentReference? _notifications;
  DocumentReference? get notifications => _notifications;
  bool hasNotifications() => _notifications != null;

  // "perferencelist" field.
  List<DocumentReference>? _perferencelist;
  List<DocumentReference> get perferencelist => _perferencelist ?? const [];
  bool hasPerferencelist() => _perferencelist != null;

  // "InstagramLink" field.
  String? _instagramLink;
  String get instagramLink => _instagramLink ?? '';
  bool hasInstagramLink() => _instagramLink != null;

  // "x_twitterLink" field.
  String? _xTwitterLink;
  String get xTwitterLink => _xTwitterLink ?? '';
  bool hasXTwitterLink() => _xTwitterLink != null;

  // "tik_tok_Link" field.
  String? _tikTokLink;
  String get tikTokLink => _tikTokLink ?? '';
  bool hasTikTokLink() => _tikTokLink != null;

  // "Facebook_link" field.
  String? _facebookLink;
  String get facebookLink => _facebookLink ?? '';
  bool hasFacebookLink() => _facebookLink != null;

  // "dateofbirth" field.
  DateTime? _dateofbirth;
  DateTime? get dateofbirth => _dateofbirth;
  bool hasDateofbirth() => _dateofbirth != null;

  // "disliked" field.
  List<String>? _disliked;
  List<String> get disliked => _disliked ?? const [];
  bool hasDisliked() => _disliked != null;

  // "liked" field.
  List<String>? _liked;
  List<String> get liked => _liked ?? const [];
  bool hasLiked() => _liked != null;

  // "matches" field.
  List<String>? _matches;
  List<String> get matches => _matches ?? const [];
  bool hasMatches() => _matches != null;

  // "subscription" field.
  DocumentReference? _subscription;
  DocumentReference? get subscription => _subscription;
  bool hasSubscription() => _subscription != null;

  // "Bio" field.
  String? _bio;
  String get bio => _bio ?? '';
  bool hasBioField() => _bio != null;

  // "Location" field.
  LatLng? _location;
  LatLng? get location => _location;
  bool hasLocation() => _location != null;

  // "Verified" field.
  bool? _verified;
  bool get verified => _verified ?? false;
  bool hasVerified() => _verified != null;

  // "ReportsBlockedUsers" field.
  List<DocumentReference>? _reportsBlockedUsers;
  List<DocumentReference> get reportsBlockedUsers =>
      _reportsBlockedUsers ?? const [];
  bool hasReportsBlockedUsers() => _reportsBlockedUsers != null;

  // "messageType" field.
  MessageTypeStruct? _messageType;
  MessageTypeStruct get messageType => _messageType ?? MessageTypeStruct();
  bool hasMessageType() => _messageType != null;

  // "Seen" field.
  bool? _seen;
  bool get seen => _seen ?? false;
  bool hasSeen() => _seen != null;

  // "languages" field.
  List<String>? _languages;
  List<String> get languages => _languages ?? const [];
  bool hasLanguages() => _languages != null;

  // "interests" field.
  List<String>? _interests;
  List<String> get interests => _interests ?? const [];
  bool hasInterests() => _interests != null;

  // "relationshipGoals" field.
  List<String>? _relationshipGoals;
  List<String> get relationshipGoals => _relationshipGoals ?? const [];
  bool hasRelationshipGoals() => _relationshipGoals != null;

  // "age" field.
  int? _age;
  int get age => _age ?? 0;
  bool hasAge() => _age != null;

  // "photoCount" field.
  int? _photoCount;
  int get photoCount => _photoCount ?? 0;
  bool hasPhotoCount() => _photoCount != null;

  // "userGender" field.
  String? _userGender;
  String get userGender => _userGender ?? '';
  bool hasUserGender() => _userGender != null;

  // "hasBio" field.
  bool? _hasBio;
  bool get hasBio => _hasBio ?? false;
  bool hasHasBio() => _hasBio != null;

  // "relationshipGoal" field.
  String? _relationshipGoal;
  String get relationshipGoal => _relationshipGoal ?? '';
  bool hasRelationshipGoal() => _relationshipGoal != null;

  // "travelPreferences" field.
  List<String>? _travelPreferences;
  List<String> get travelPreferences => _travelPreferences ?? const [];
  bool hasTravelPreferences() => _travelPreferences != null;

  // "musicPreferences" field.
  List<String>? _musicPreferences;
  List<String> get musicPreferences => _musicPreferences ?? const [];
  bool hasMusicPreferences() => _musicPreferences != null;

  // "locationName" field.
  String? _locationName;
  String get locationName => _locationName ?? '';
  bool hasLocationName() => _locationName != null;

  // "religion" field.
  String? _religion;
  String get religion => _religion ?? '';
  bool hasReligion() => _religion != null;

  // "bookPreferences" field.
  List<String>? _bookPreferences;
  List<String> get bookPreferences => _bookPreferences ?? const [];
  bool hasBookPreferences() => _bookPreferences != null;

  // "moviePreferences" field.
  List<String>? _moviePreferences;
  List<String> get moviePreferences => _moviePreferences ?? const [];
  bool hasMoviePreferences() => _moviePreferences != null;

  // "height" field.
  String? _height;
  String get height => _height ?? '';
  bool hasHeight() => _height != null;

  // "weight" field.
  String? _weight;
  String get weight => _weight ?? '';
  bool hasWeight() => _weight != null;

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  bool hasTitle() => _title != null;

  // "company" field.
  String? _company;
  String get company => _company ?? '';
  bool hasCompany() => _company != null;

  // "education" field.
  String? _education;
  String get education => _education ?? '';
  bool hasEducation() => _education != null;

  // "familyPlans" field.
  String? _familyPlans;
  String get familyPlans => _familyPlans ?? '';
  bool hasFamilyPlans() => _familyPlans != null;

  // "pronouns" field.
  String? _pronouns;
  String get pronouns => _pronouns ?? '';
  bool hasPronouns() => _pronouns != null;

  // "myMatches" field.
  List<DocumentReference>? _myMatches;
  List<DocumentReference> get myMatches => _myMatches ?? const [];
  bool hasMyMatches() => _myMatches != null;

  // "myFavourites" field.
  List<DocumentReference>? _myFavourites;
  List<DocumentReference> get myFavourites => _myFavourites ?? const [];
  bool hasMyFavourites() => _myFavourites != null;

  // "myDisliked" field.
  List<DocumentReference>? _myDisliked;
  List<DocumentReference> get myDisliked => _myDisliked ?? const [];
  bool hasMyDisliked() => _myDisliked != null;

  // "myLikes" field.
  List<DocumentReference>? _myLikes;
  List<DocumentReference> get myLikes => _myLikes ?? const [];
  bool hasMyLikes() => _myLikes != null;

  // "dailyMessageCount" field.
  int? _dailyMessageCount;
  int get dailyMessageCount => _dailyMessageCount ?? 0;
  bool hasDailyMessageCount() => _dailyMessageCount != null;

  // "lastMessageResetDate" field.
  DateTime? _lastMessageResetDate;
  DateTime? get lastMessageResetDate => _lastMessageResetDate;
  bool hasLastMessageResetDate() => _lastMessageResetDate != null;

  // "receiveDirectMessages" field.
  bool? _receiveDirectMessages;
  bool get receiveDirectMessages => _receiveDirectMessages ?? true;
  bool hasReceiveDirectMessages() => _receiveDirectMessages != null;

  // "readReceipts" field.
  bool? _readReceipts;
  bool get readReceipts => _readReceipts ?? false;
  bool hasReadReceipts() => _readReceipts != null;

  // "fcmToken" field - Firebase Cloud Messaging token for push notifications
  String? _fcmToken;
  String get fcmToken => _fcmToken ?? '';
  bool hasFcmToken() => _fcmToken != null;

  void _initializeFields() {
    _email = snapshotData['email'] as String?;
    _displayName = snapshotData['display_name'] as String?;
    _photoUrl = snapshotData['photo_url'] as String?;
    _uid = snapshotData['uid'] as String?;
    _createdTime = snapshotData['created_time'] as DateTime?;
    _phoneNumber = snapshotData['phone_number'] as String?;
    _imgList = getDataList(snapshotData['imgList']);
    _likeUser = getDataList(snapshotData['likeUser']);
    _genderPreference = snapshotData['GenderPreference'] is GenderStruct
        ? snapshotData['GenderPreference']
        : GenderStruct.maybeFromMap(snapshotData['GenderPreference']);
    _notifications = snapshotData['Notifications'] as DocumentReference?;
    _perferencelist = getDataList(snapshotData['perferencelist']);
    _instagramLink = snapshotData['InstagramLink'] as String?;
    _xTwitterLink = snapshotData['x_twitterLink'] as String?;
    _tikTokLink = snapshotData['tik_tok_Link'] as String?;
    _facebookLink = snapshotData['Facebook_link'] as String?;
    _dateofbirth = snapshotData['dateofbirth'] as DateTime?;
    _disliked = getDataList(snapshotData['disliked']);
    _liked = getDataList(snapshotData['liked']);
    _matches = getDataList(snapshotData['matches']);
    _subscription = snapshotData['subscription'] as DocumentReference?;
    _bio = snapshotData['Bio'] as String?;
    _location = snapshotData['Location'] as LatLng?;
    _verified = snapshotData['Verified'] as bool?;
    _reportsBlockedUsers = getDataList(snapshotData['ReportsBlockedUsers']);
    _messageType = snapshotData['messageType'] is MessageTypeStruct
        ? snapshotData['messageType']
        : MessageTypeStruct.maybeFromMap(snapshotData['messageType']);
    _seen = snapshotData['Seen'] as bool?;
    _languages = getDataList(snapshotData['languages']);
    _interests = getDataList(snapshotData['interests']);
    _relationshipGoals = getDataList(snapshotData['relationshipGoals']);
    _age = castToType<int>(snapshotData['age']);
    _photoCount = castToType<int>(snapshotData['photoCount']);
    _userGender = snapshotData['userGender'] as String?;
    _hasBio = snapshotData['hasBio'] as bool?;
    _relationshipGoal = snapshotData['relationshipGoal'] as String?;
    _travelPreferences = getDataList(snapshotData['travelPreferences']);
    _musicPreferences = getDataList(snapshotData['musicPreferences']);
    _locationName = snapshotData['locationName'] as String?;
    _religion = snapshotData['religion'] as String?;
    _bookPreferences = getDataList(snapshotData['bookPreferences']);
    _moviePreferences = getDataList(snapshotData['moviePreferences']);
    _height = snapshotData['height'] as String?;
    _weight = snapshotData['weight'] as String?;
    _title = snapshotData['title'] as String?;
    _company = snapshotData['company'] as String?;
    _education = snapshotData['education'] as String?;
    _familyPlans = snapshotData['familyPlans'] as String?;
    _pronouns = snapshotData['pronouns'] as String?;
    _myMatches = getDataList(snapshotData['myMatches']);
    _myFavourites = getDataList(snapshotData['myFavourites']);
    _myDisliked = getDataList(snapshotData['myDisliked']);
    _myLikes = getDataList(snapshotData['myLikes']);
    _dailyMessageCount = castToType<int>(snapshotData['dailyMessageCount']);
    _lastMessageResetDate = snapshotData['lastMessageResetDate'] as DateTime?;
    _receiveDirectMessages = snapshotData['receiveDirectMessages'] as bool?;
    _readReceipts = snapshotData['readReceipts'] as bool?;
    _fcmToken = snapshotData['fcmToken'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('users');

  static Stream<UsersRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => UsersRecord.fromSnapshot(s));

  static Future<UsersRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => UsersRecord.fromSnapshot(s));

  static UsersRecord fromSnapshot(DocumentSnapshot snapshot) => UsersRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static UsersRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      UsersRecord._(reference, mapFromFirestore(data));

  static UsersRecord fromAlgolia(AlgoliaObjectSnapshot snapshot) =>
      UsersRecord.getDocumentFromData(
        {
          'email': snapshot.data['email'],
          'display_name': snapshot.data['display_name'],
          'photo_url': snapshot.data['photo_url'],
          'uid': snapshot.data['uid'],
          'created_time': convertAlgoliaParam(
            snapshot.data['created_time'],
            ParamType.DateTime,
            false,
          ),
          'phone_number': snapshot.data['phone_number'],
          'imgList': safeGet(
            () => snapshot.data['imgList'].toList(),
          ),
          'likeUser': safeGet(
            () => convertAlgoliaParam<DocumentReference>(
              snapshot.data['likeUser'],
              ParamType.DocumentReference,
              true,
            ).toList(),
          ),
          'GenderPreference': GenderStruct.fromAlgoliaData(
                  snapshot.data['GenderPreference'] ?? {})
              .toMap(),
          'Notifications': convertAlgoliaParam(
            snapshot.data['Notifications'],
            ParamType.DocumentReference,
            false,
          ),
          'perferencelist': safeGet(
            () => convertAlgoliaParam<DocumentReference>(
              snapshot.data['perferencelist'],
              ParamType.DocumentReference,
              true,
            ).toList(),
          ),
          'InstagramLink': snapshot.data['InstagramLink'],
          'x_twitterLink': snapshot.data['x_twitterLink'],
          'tik_tok_Link': snapshot.data['tik_tok_Link'],
          'Facebook_link': snapshot.data['Facebook_link'],
          'dateofbirth': convertAlgoliaParam(
            snapshot.data['dateofbirth'],
            ParamType.DateTime,
            false,
          ),
          'disliked': safeGet(
            () => snapshot.data['disliked'].toList(),
          ),
          'liked': safeGet(
            () => snapshot.data['liked'].toList(),
          ),
          'matches': safeGet(
            () => snapshot.data['matches'].toList(),
          ),
          'subscription': convertAlgoliaParam(
            snapshot.data['subscription'],
            ParamType.DocumentReference,
            false,
          ),
          'Bio': snapshot.data['Bio'],
          'Location': convertAlgoliaParam(
            snapshot.data,
            ParamType.LatLng,
            false,
          ),
          'Verified': snapshot.data['Verified'],
          'ReportsBlockedUsers': safeGet(
            () => convertAlgoliaParam<DocumentReference>(
              snapshot.data['ReportsBlockedUsers'],
              ParamType.DocumentReference,
              true,
            ).toList(),
          ),
          'messageType': MessageTypeStruct.fromAlgoliaData(
                  snapshot.data['messageType'] ?? {})
              .toMap(),
          'Seen': snapshot.data['Seen'],
          'languages': safeGet(
            () => snapshot.data['languages'].toList(),
          ),
          'interests': safeGet(
            () => snapshot.data['interests'].toList(),
          ),
          'relationshipGoals': safeGet(
            () => snapshot.data['relationshipGoals'].toList(),
          ),
          'age': convertAlgoliaParam(
            snapshot.data['age'],
            ParamType.int,
            false,
          ),
          'photoCount': convertAlgoliaParam(
            snapshot.data['photoCount'],
            ParamType.int,
            false,
          ),
          'userGender': snapshot.data['userGender'],
          'hasBio': snapshot.data['hasBio'],
          'relationshipGoal': snapshot.data['relationshipGoal'],
          'travelPreferences': safeGet(
            () => snapshot.data['travelPreferences'].toList(),
          ),
          'musicPreferences': safeGet(
            () => snapshot.data['musicPreferences'].toList(),
          ),
          'locationName': snapshot.data['locationName'],
          'religion': snapshot.data['religion'],
          'bookPreferences': safeGet(
            () => snapshot.data['bookPreferences'].toList(),
          ),
          'moviePreferences': safeGet(
            () => snapshot.data['moviePreferences'].toList(),
          ),
          'height': snapshot.data['height'],
          'weight': snapshot.data['weight'],
          'title': snapshot.data['title'],
          'company': snapshot.data['company'],
          'education': snapshot.data['education'],
          'familyPlans': snapshot.data['familyPlans'],
          'pronouns': snapshot.data['pronouns'],
          'myMatches': safeGet(
            () => convertAlgoliaParam<DocumentReference>(
              snapshot.data['myMatches'],
              ParamType.DocumentReference,
              true,
            ).toList(),
          ),
          'myFavourites': safeGet(
            () => convertAlgoliaParam<DocumentReference>(
              snapshot.data['myFavourites'],
              ParamType.DocumentReference,
              true,
            ).toList(),
          ),
          'myDisliked': safeGet(
            () => convertAlgoliaParam<DocumentReference>(
              snapshot.data['myDisliked'],
              ParamType.DocumentReference,
              true,
            ).toList(),
          ),
          'myLikes': safeGet(
            () => convertAlgoliaParam<DocumentReference>(
              snapshot.data['myLikes'],
              ParamType.DocumentReference,
              true,
            ).toList(),
          ),
          'dailyMessageCount': convertAlgoliaParam(
            snapshot.data['dailyMessageCount'],
            ParamType.int,
            false,
          ),
          'lastMessageResetDate': convertAlgoliaParam(
            snapshot.data['lastMessageResetDate'],
            ParamType.DateTime,
            false,
          ),
          'receiveDirectMessages': snapshot.data['receiveDirectMessages'],
          'readReceipts': snapshot.data['readReceipts'],
        },
        UsersRecord.collection.doc(snapshot.objectID),
      );

  static Future<List<UsersRecord>> search({
    String? term,
    FutureOr<LatLng>? location,
    int? maxResults,
    double? searchRadiusMeters,
    bool useCache = false,
  }) =>
      FFAlgoliaManager.instance
          .algoliaQuery(
            index: 'users',
            term: term,
            maxResults: maxResults,
            location: location,
            searchRadiusMeters: searchRadiusMeters,
            useCache: useCache,
          )
          .then((r) => r.map(fromAlgolia).toList());

  @override
  String toString() =>
      'UsersRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is UsersRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createUsersRecordData({
  String? email,
  String? displayName,
  String? photoUrl,
  String? uid,
  DateTime? createdTime,
  String? phoneNumber,
  GenderStruct? genderPreference,
  DocumentReference? notifications,
  String? instagramLink,
  String? xTwitterLink,
  String? tikTokLink,
  String? facebookLink,
  DateTime? dateofbirth,
  DocumentReference? subscription,
  String? bio,
  LatLng? location,
  bool? verified,
  MessageTypeStruct? messageType,
  bool? seen,
  int? age,
  int? photoCount,
  String? userGender,
  bool? hasBio,
  String? relationshipGoal,
  String? locationName,
  String? religion,
  String? height,
  String? weight,
  String? title,
  String? company,
  String? education,
  String? familyPlans,
  String? pronouns,
  int? dailyMessageCount,
  DateTime? lastMessageResetDate,
  bool? receiveDirectMessages,
  bool? readReceipts,
  String? fcmToken,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'email': email,
      'display_name': displayName,
      'photo_url': photoUrl,
      'uid': uid,
      'created_time': createdTime,
      'phone_number': phoneNumber,
      'GenderPreference': GenderStruct().toMap(),
      'Notifications': notifications,
      'InstagramLink': instagramLink,
      'x_twitterLink': xTwitterLink,
      'tik_tok_Link': tikTokLink,
      'Facebook_link': facebookLink,
      'dateofbirth': dateofbirth,
      'subscription': subscription,
      'Bio': bio,
      'Location': location,
      'Verified': verified,
      'messageType': MessageTypeStruct().toMap(),
      'Seen': seen,
      'age': age,
      'photoCount': photoCount,
      'userGender': userGender,
      'hasBio': hasBio,
      'relationshipGoal': relationshipGoal,
      'locationName': locationName,
      'religion': religion,
      'height': height,
      'weight': weight,
      'title': title,
      'company': company,
      'education': education,
      'familyPlans': familyPlans,
      'pronouns': pronouns,
      'dailyMessageCount': dailyMessageCount,
      'lastMessageResetDate': lastMessageResetDate,
      'receiveDirectMessages': receiveDirectMessages,
      'readReceipts': readReceipts,
      'fcmToken': fcmToken,
    }.withoutNulls,
  );

  // Handle nested data for "GenderPreference" field.
  addGenderStructData(firestoreData, genderPreference, 'GenderPreference');

  // Handle nested data for "messageType" field.
  addMessageTypeStructData(firestoreData, messageType, 'messageType');

  return firestoreData;
}

class UsersRecordDocumentEquality implements Equality<UsersRecord> {
  const UsersRecordDocumentEquality();

  @override
  bool equals(UsersRecord? e1, UsersRecord? e2) {
    const listEquality = ListEquality();
    return e1?.email == e2?.email &&
        e1?.displayName == e2?.displayName &&
        e1?.photoUrl == e2?.photoUrl &&
        e1?.uid == e2?.uid &&
        e1?.createdTime == e2?.createdTime &&
        e1?.phoneNumber == e2?.phoneNumber &&
        listEquality.equals(e1?.imgList, e2?.imgList) &&
        listEquality.equals(e1?.likeUser, e2?.likeUser) &&
        e1?.genderPreference == e2?.genderPreference &&
        e1?.notifications == e2?.notifications &&
        listEquality.equals(e1?.perferencelist, e2?.perferencelist) &&
        e1?.instagramLink == e2?.instagramLink &&
        e1?.xTwitterLink == e2?.xTwitterLink &&
        e1?.tikTokLink == e2?.tikTokLink &&
        e1?.facebookLink == e2?.facebookLink &&
        e1?.dateofbirth == e2?.dateofbirth &&
        listEquality.equals(e1?.disliked, e2?.disliked) &&
        listEquality.equals(e1?.liked, e2?.liked) &&
        listEquality.equals(e1?.matches, e2?.matches) &&
        e1?.subscription == e2?.subscription &&
        e1?.bio == e2?.bio &&
        e1?.location == e2?.location &&
        e1?.verified == e2?.verified &&
        listEquality.equals(e1?.reportsBlockedUsers, e2?.reportsBlockedUsers) &&
        e1?.messageType == e2?.messageType &&
        e1?.seen == e2?.seen &&
        listEquality.equals(e1?.languages, e2?.languages) &&
        listEquality.equals(e1?.interests, e2?.interests) &&
        listEquality.equals(e1?.relationshipGoals, e2?.relationshipGoals) &&
        e1?.age == e2?.age &&
        e1?.photoCount == e2?.photoCount &&
        e1?.userGender == e2?.userGender &&
        e1?.hasBio == e2?.hasBio &&
        e1?.relationshipGoal == e2?.relationshipGoal &&
        listEquality.equals(e1?.travelPreferences, e2?.travelPreferences) &&
        listEquality.equals(e1?.musicPreferences, e2?.musicPreferences) &&
        e1?.locationName == e2?.locationName &&
        e1?.religion == e2?.religion &&
        listEquality.equals(e1?.bookPreferences, e2?.bookPreferences) &&
        listEquality.equals(e1?.moviePreferences, e2?.moviePreferences) &&
        e1?.height == e2?.height &&
        e1?.weight == e2?.weight &&
        e1?.title == e2?.title &&
        e1?.company == e2?.company &&
        e1?.education == e2?.education &&
        e1?.familyPlans == e2?.familyPlans &&
        e1?.pronouns == e2?.pronouns &&
        listEquality.equals(e1?.myMatches, e2?.myMatches) &&
        listEquality.equals(e1?.myFavourites, e2?.myFavourites) &&
        listEquality.equals(e1?.myDisliked, e2?.myDisliked) &&
        listEquality.equals(e1?.myLikes, e2?.myLikes) &&
        e1?.dailyMessageCount == e2?.dailyMessageCount &&
        e1?.lastMessageResetDate == e2?.lastMessageResetDate &&
        e1?.receiveDirectMessages == e2?.receiveDirectMessages &&
        e1?.readReceipts == e2?.readReceipts &&
        e1?.fcmToken == e2?.fcmToken;
  }

  @override
  int hash(UsersRecord? e) => const ListEquality().hash([
        e?.email,
        e?.displayName,
        e?.photoUrl,
        e?.uid,
        e?.createdTime,
        e?.phoneNumber,
        e?.imgList,
        e?.likeUser,
        e?.genderPreference,
        e?.notifications,
        e?.perferencelist,
        e?.instagramLink,
        e?.xTwitterLink,
        e?.tikTokLink,
        e?.facebookLink,
        e?.dateofbirth,
        e?.disliked,
        e?.liked,
        e?.matches,
        e?.subscription,
        e?.bio,
        e?.location,
        e?.verified,
        e?.reportsBlockedUsers,
        e?.messageType,
        e?.seen,
        e?.languages,
        e?.interests,
        e?.relationshipGoals,
        e?.age,
        e?.photoCount,
        e?.userGender,
        e?.hasBio,
        e?.relationshipGoal,
        e?.travelPreferences,
        e?.musicPreferences,
        e?.locationName,
        e?.religion,
        e?.bookPreferences,
        e?.moviePreferences,
        e?.height,
        e?.weight,
        e?.title,
        e?.company,
        e?.education,
        e?.familyPlans,
        e?.pronouns,
        e?.myMatches,
        e?.myFavourites,
        e?.myDisliked,
        e?.myLikes,
        e?.dailyMessageCount,
        e?.lastMessageResetDate,
        e?.receiveDirectMessages,
        e?.readReceipts,
        e?.fcmToken,
      ]);

  @override
  bool isValidKey(Object? o) => o is UsersRecord;
}
