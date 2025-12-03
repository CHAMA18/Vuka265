import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/home/navbar/navbar_widget.dart';
import 'dart:ui';
import '/actions/actions.dart' as action_blocks;
import '/index.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'profile_model.dart';
export 'profile_model.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key});

  static String routeName = 'Profile';
  static String routePath = '/profile';

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  late ProfileModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProfileModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  double _calculateProfileCompletion(UsersRecord user) {
    int completedFields = 0;
    int totalFields = 21; // Total number of profile fields to check

    try {
      // Basic information
      if (user.hasDisplayName() && user.displayName.isNotEmpty) completedFields++;
      if (user.hasPhotoUrl() && user.photoUrl.isNotEmpty) completedFields++;
      if (user.hasEmail() && user.email.isNotEmpty) completedFields++;
      if (user.hasAge() && user.age > 0) completedFields++;
      if (user.hasUserGender() && user.userGender.isNotEmpty) completedFields++;
      
      // Location
      if (user.hasLocationName() && user.locationName.isNotEmpty) completedFields++;
      if (user.hasLocation() && user.location != null) completedFields++;
      
      // Profile details
      if (user.hasBioField() && user.bio.isNotEmpty) completedFields++;
      if (user.hasHeight() && user.height.isNotEmpty) completedFields++;
      if (user.hasWeight() && user.weight.isNotEmpty) completedFields++;
      if (user.hasTitle() && user.title.isNotEmpty) completedFields++;
      if (user.hasCompany() && user.company.isNotEmpty) completedFields++;
      if (user.hasEducation() && user.education.isNotEmpty) completedFields++;
      if (user.hasReligion() && user.religion.isNotEmpty) completedFields++;
      if (user.hasFamilyPlans() && user.familyPlans.isNotEmpty) completedFields++;
      
      // Preferences and lists
      if (user.hasInterests() && user.interests.isNotEmpty) completedFields++;
      if (user.hasRelationshipGoals() && user.relationshipGoals.isNotEmpty) completedFields++;
      if (user.hasLanguages() && user.languages.isNotEmpty) completedFields++;
      if (user.hasTravelPreferences() && user.travelPreferences.isNotEmpty) completedFields++;
      if (user.hasMusicPreferences() && user.musicPreferences.isNotEmpty) completedFields++;
      
      // Additional photos
      if (user.hasImgList() && user.imgList.length > 1) completedFields++;
      
    } catch (e) {
      // Fallback calculation with basic safety
      if (user.displayName.isNotEmpty) completedFields++;
      if (user.photoUrl.isNotEmpty) completedFields++;
      if (user.email.isNotEmpty) completedFields++;
      totalFields = 3; // Reduce total fields for safety
    }
    
    return totalFields > 0 ? completedFields / totalFields : 0.0;
  }

  String _getProfileCompletionText(double percentage) {
    return '${(percentage * 100).round()}%';
  }

  String _getCompletionMessage(double percentage) {
    final percent = (percentage * 100).round();
    if (percent >= 90) {
      return 'Great! Your profile is almost complete!';
    } else if (percent >= 70) {
      return 'Good progress! Add a few more details.';
    } else if (percent >= 50) {
      return 'You\'re halfway there! Keep going.';
    } else if (percent >= 30) {
      return 'Good start! Add more info to get better matches.';
    } else {
      return 'Complete your profile to experience the best dating!';
    }
  }

  Widget _buildSubscriptionStatusCard(
    BuildContext context,
    UsersRecord user,
  ) {
    const int dailyFreeLimit = 20;
    final subscriptionRef = user.subscription;
    final int sentMessages = user.dailyMessageCount;
    final int safeSentMessages = sentMessages < 0 ? 0 : sentMessages;
    final int remainingMessages =
        dailyFreeLimit - safeSentMessages > 0 ? dailyFreeLimit - safeSentMessages : 0;
    final double usagePercent = dailyFreeLimit > 0
        ? ((safeSentMessages / dailyFreeLimit).clamp(0.0, 1.0)).toDouble()
        : 0.0;

    if (subscriptionRef == null) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: const [
              Color(0xFFFD6585),
              Color(0xFFFC7E3F),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33FD6585),
              blurRadius: 18.0,
              offset: Offset(0.0, 12.0),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(18.0, 18.0, 18.0, 18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48.0,
                    height: 48.0,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.lock_open_rounded,
                      color: FlutterFlowTheme.of(context).info,
                      size: 26.0,
                    ),
                  ),
                  const SizedBox(width: 14.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Free plan',
                          style: FlutterFlowTheme.of(context).titleLarge.override(
                                fontFamily: 'Onest',
                                color: FlutterFlowTheme.of(context).info,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          'Send up to $dailyFreeLimit messages every 24 hours.',
                          style: FlutterFlowTheme.of(context).bodySmall.override(
                                fontFamily: 'Onest',
                                color: FlutterFlowTheme.of(context).info.withOpacity(0.85),
                                letterSpacing: 0.0,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  FFButtonWidget(
                    onPressed: () async {
                      context.pushNamed(SubscriptionWidget.routeName);
                    },
                    text: 'Upgrade',
                    options: FFButtonOptions(
                      height: 36.0,
                      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                      iconPadding: EdgeInsetsDirectional.zero,
                      color: FlutterFlowTheme.of(context).info,
                      textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Onest',
                            color: const Color(0xFFFD6585),
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.bold,
                          ),
                      elevation: 0.0,
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                        width: 0.0,
                      ),
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              LinearPercentIndicator(
                percent: usagePercent,
                lineHeight: 8.0,
                animation: true,
                progressColor: FlutterFlowTheme.of(context).info,
                backgroundColor: Colors.white.withOpacity(0.25),
                barRadius: const Radius.circular(12.0),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(2.0, 10.0, 0.0, 0.0),
                child: Text(
                  '$remainingMessages messages left today',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Onest',
                        color: FlutterFlowTheme.of(context).info,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return StreamBuilder<SubscriptionsRecord>(
      stream: SubscriptionsRecord.getDocument(subscriptionRef),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6A85B6), Color(0xFFBAC8E0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: const Padding(
              padding: EdgeInsets.all(24.0),
              child: Center(
                child: SizedBox(
                  width: 24.0,
                  height: 24.0,
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          );
        }

        final plan = snapshot.data!;
        final String planName = plan.subscriptionname.isNotEmpty
            ? plan.subscriptionname
            : 'Premium Member';
        final String planPrice = plan.price;

        return Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF5A4AE3), Color(0xFF9C4CD9)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: const [
              BoxShadow(
                color: Color(0x405A4AE3),
                blurRadius: 20.0,
                offset: Offset(0.0, 12.0),
              ),
            ],
          ),
          child: Padding(
            padding:
                const EdgeInsetsDirectional.fromSTEB(18.0, 18.0, 18.0, 18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48.0,
                      height: 48.0,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.workspace_premium_rounded,
                        color: FlutterFlowTheme.of(context).info,
                        size: 26.0,
                      ),
                    ),
                    const SizedBox(width: 14.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            planName,
                            style: FlutterFlowTheme.of(context)
                                .titleLarge
                                .override(
                                  fontFamily: 'Onest',
                                  color: FlutterFlowTheme.of(context).info,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          if (planPrice.isNotEmpty)
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 4.0, 0.0, 0.0),
                              child: Text(
                                planPrice,
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Onest',
                                      color:
                                          FlutterFlowTheme.of(context).info,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0.0, 6.0, 0.0, 0.0),
                            child: Text(
                              'Unlimited messaging unlocked. Enjoy every conversation.',
                              style: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .override(
                                    fontFamily: 'Onest',
                                    color: FlutterFlowTheme.of(context)
                                        .info
                                        .withOpacity(0.9),
                                    letterSpacing: 0.0,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    FFButtonWidget(
                      onPressed: () async {
                        context.pushNamed(SubscriptionWidget.routeName);
                      },
                      text: 'Manage',
                      options: FFButtonOptions(
                        height: 36.0,
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            18.0, 0.0, 18.0, 0.0),
                        iconPadding: EdgeInsetsDirectional.zero,
                        color: FlutterFlowTheme.of(context).info,
                        textStyle: FlutterFlowTheme.of(context)
                            .bodyMedium
                            .override(
                              fontFamily: 'Onest',
                              color: const Color(0xFF5A4AE3),
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.bold,
                            ),
                        elevation: 0.0,
                        borderSide: const BorderSide(
                          color: Colors.transparent,
                          width: 0.0,
                        ),
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Wrap(
                  spacing: 10.0,
                  runSpacing: 8.0,
                  children: [
                    Container(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          12.0, 6.0, 12.0, 6.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.all_inclusive,
                            size: 18.0,
                            color: FlutterFlowTheme.of(context).info,
                          ),
                          const SizedBox(width: 6.0),
                          Text(
                            'Unlimited messages',
                            style: FlutterFlowTheme.of(context)
                                .bodySmall
                                .override(
                                  fontFamily: 'Onest',
                                  color:
                                      FlutterFlowTheme.of(context).info,
                                  letterSpacing: 0.0,
                                ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          12.0, 6.0, 12.0, 6.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.flash_on_rounded,
                            size: 18.0,
                            color: FlutterFlowTheme.of(context).info,
                          ),
                          const SizedBox(width: 6.0),
                          Text(
                            'Priority support',
                            style: FlutterFlowTheme.of(context)
                                .bodySmall
                                .override(
                                  fontFamily: 'Onest',
                                  color:
                                      FlutterFlowTheme.of(context).info,
                                  letterSpacing: 0.0,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UsersRecord>(
      stream: UsersRecord.getDocument(currentUserReference!),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
            body: Center(
              child: SizedBox(
                width: 30.0,
                height: 30.0,
                child: SpinKitFadingCircle(
                  color: FlutterFlowTheme.of(context).primary,
                  size: 30.0,
                ),
              ),
            ),
          );
        }

        final profileUsersRecord = snapshot.data!;

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
            floatingActionButton: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 75.0),
              child: FloatingActionButton(
                onPressed: () async {
                  context.pushNamed(ProfileEditWidget.routeName);
                },
                backgroundColor: FlutterFlowTheme.of(context).primary,
                elevation: 5.0,
                child: Icon(
                  FFIcons.kuserEdit,
                  color: FlutterFlowTheme.of(context).info,
                  size: 27.0,
                ),
              ),
            ),
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(0.0),
              child: AppBar(
                backgroundColor:
                    FlutterFlowTheme.of(context).secondaryBackground,
                automaticallyImplyLeading: false,
                actions: [],
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    width: 100.0,
                    height: 100.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                    ),
                  ),
                ),
                centerTitle: false,
                elevation: 0.0,
              ),
            ),
            body: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            15.0, 18.0, 12.0, 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(0.0),
                              child: Image.asset(
                                'assets/images/Vuka_Logo-Original.png',
                                width: 35.0,
                                height: 35.0,
                                fit: BoxFit.contain,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    18.0, 0.0, 10.0, 0.0),
                                child: Text(
                                  'Profile',
                                  textAlign: TextAlign.start,
                                  style: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .override(
                                        fontFamily: 'Onest',
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 6.0, 0.0, 6.0),
                              child: FlutterFlowIconButton(
                                borderColor: FlutterFlowTheme.of(context)
                                    .transparent,
                                borderRadius: 30.0,
                                borderWidth: 0.0,
                                buttonSize: 40.0,
                                fillColor: FlutterFlowTheme.of(context)
                                    .transparent,
                                icon: Icon(
                                  FFIcons.ksettings,
                                  color: FlutterFlowTheme.of(context)
                                      .primaryText,
                                  size: 24.0,
                                ),
                                onPressed: () async {
                                  await action_blocks.wait(context);

                                  context
                                      .pushNamed(SettingsWidget.routeName);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          primary: false,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      15.0, 15.0, 15.0, 0.0),
                                  child: _buildSubscriptionStatusCard(
                                    context,
                                    profileUsersRecord,
                                  ),
                                ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    15.0, 15.0, 15.0, 15.0),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    context
                                        .pushNamed(ProfileEditWidget.routeName);
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          15.0, 15.0, 15.0, 15.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Builder(
                                            builder: (context) {
                                              final completionPercentage = _calculateProfileCompletion(profileUsersRecord);
                                              final completionText = _getProfileCompletionText(completionPercentage);
                                              
                                              return CircularPercentIndicator(
                                                percent: completionPercentage,
                                                radius: 31.0,
                                                lineWidth: 6.0,
                                                animation: true,
                                                animateFromLastPercent: true,
                                                progressColor:
                                                    FlutterFlowTheme.of(context)
                                                        .info,
                                                backgroundColor: Color(0x5EFFFFFF),
                                                center: Text(
                                                  completionText,
                                                  style:
                                                      FlutterFlowTheme.of(context)
                                                          .titleMedium
                                                          .override(
                                                            fontFamily: 'Onest',
                                                            color:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .info,
                                                            letterSpacing: 0.0,
                                                          ),
                                                ),
                                              );
                                            },
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      12.0, 0.0, 0.0, 0.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Complete your Profile',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .titleSmall
                                                        .override(
                                                          fontFamily: 'Onest',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .info,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 6.0,
                                                                0.0, 0.0),
                                                    child: Text(
                                                      _getCompletionMessage(_calculateProfileCompletion(profileUsersRecord)),
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .labelSmall
                                                          .override(
                                                            fontFamily: 'Onest',
                                                            color: Color(
                                                                0xC4FFFFFF),
                                                            letterSpacing: 0.0,
                                                          ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(),
                                child: Builder(
                                  builder: (context) {
                                    final images =
                                        profileUsersRecord.imgList.toList();

                                    // Show placeholder if no images
                                    if (images.isEmpty) {
                                      return Container(
                                        width: double.infinity,
                                        height: 200.0,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(8.0),
                                          child: Image.asset(
                                            'assets/images/user.png',
                                            width: 200.0,
                                            height: 200.0,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      );
                                    }

                                    return Container(
                                      width: double.infinity,
                                      height: 200.0,
                                      child: CarouselSlider.builder(
                                        itemCount: images.length,
                                        itemBuilder: (context, imagesIndex, _) {
                                          if (imagesIndex >= images.length) {
                                            return SizedBox.shrink();
                                          }
                                          final imagesItem =
                                              images[imagesIndex];
                                          return ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: Image(
                                              image: profileImageProvider(
                                                imagesItem,
                                              ),
                                              width: 200.0,
                                              height: 200.0,
                                              fit: BoxFit.cover,
                                            ),
                                          );
                                        },
                                        carouselController:
                                            _model.carouselController ??=
                                                CarouselSliderController(),
                                        options: CarouselOptions(
                                          initialPage: images.isNotEmpty ? 
                                              max(0, min(0, images.length - 1)) : 0,
                                          viewportFraction: 0.5,
                                          disableCenter: true,
                                          enlargeCenterPage: true,
                                          enlargeFactor: 0.25,
                                          enableInfiniteScroll: images.length > 1,
                                          scrollDirection: Axis.horizontal,
                                          autoPlay: false,
                                          onPageChanged: (index, _) => _model
                                              .carouselCurrentIndex = index,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          12.0, 18.0, 0.0, 12.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Text(
                                                '${profileUsersRecord.displayName}(${profileUsersRecord.age.toString()})',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .headlineSmall
                                                        .override(
                                                          fontFamily: 'Onest',
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        5.0, 0.0, 0.0, 0.0),
                                                child: Icon(
                                                  Icons.verified_rounded,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primary,
                                                  size: 25.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 5.0, 0.0, 0.0),
                                            child: Text(
                                              'Less than a kilometer away',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .override(
                                                        fontFamily: 'Onest',
                                                        letterSpacing: 0.0,
                                                      ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          15.0, 15.0, 15.0, 0.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Stack(
                                            children: [
                                              if (profileUsersRecord
                                                      .userGender ==
                                                  'Male')
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Icon(
                                                      FFIcons.kgenderMale,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                      size: 20.0,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  15.0,
                                                                  0.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: Text(
                                                        'Man',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelLarge
                                                                .override(
                                                                  fontFamily:
                                                                      'Onest',
                                                                  letterSpacing:
                                                                      0.0,
                                                                ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              if (profileUsersRecord
                                                      .userGender ==
                                                  'Female')
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Icon(
                                                      FFIcons.kgenderFemale,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                      size: 20.0,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  15.0,
                                                                  0.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: Text(
                                                        'Female',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelLarge
                                                                .override(
                                                                  fontFamily:
                                                                      'Onest',
                                                                  letterSpacing:
                                                                      0.0,
                                                                ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Icon(
                                                FFIcons.kmapPin,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                size: 20.0,
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        15.0, 0.0, 0.0, 0.0),
                                                child: Text(
                                                  valueOrDefault<String>(
                                                    profileUsersRecord
                                                        .locationName,
                                                    'New York',
                                                  ),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .labelLarge
                                                      .override(
                                                        fontFamily: 'Onest',
                                                        letterSpacing: 0.0,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ].divide(SizedBox(height: 12.0)),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          15.0, 18.0, 15.0, 18.0),
                                      child: Container(
                                        width: double.infinity,
                                        height: 1.0,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .accent1,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          15.0, 0.0, 0.0, 15.0),
                                      child: Text(
                                        'Interests',
                                        style: FlutterFlowTheme.of(context)
                                            .titleLarge
                                            .override(
                                              fontFamily: 'Onest',
                                              letterSpacing: 0.0,
                                            ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          15.0, 0.0, 15.0, 0.0),
                                      child: Builder(
                                        builder: (context) {
                                          final myinterests = profileUsersRecord
                                              .interests
                                              .toList();

                                          return Wrap(
                                            spacing: 10.0,
                                            runSpacing: 10.0,
                                            alignment: WrapAlignment.start,
                                            crossAxisAlignment:
                                                WrapCrossAlignment.start,
                                            direction: Axis.horizontal,
                                            runAlignment: WrapAlignment.start,
                                            verticalDirection:
                                                VerticalDirection.down,
                                            clipBehavior: Clip.none,
                                            children: List.generate(
                                                myinterests.length,
                                                (myinterestsIndex) {
                                              final myinterestsItem =
                                                  myinterests[myinterestsIndex];
                                              return Container(
                                                height: 35.0,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.0),
                                                  border: Border.all(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .accent1,
                                                    width: 1.0,
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          15.0, 7.0, 15.0, 7.0),
                                                  child: Text(
                                                    myinterestsItem,
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .labelLarge
                                                        .override(
                                                          fontFamily: 'Onest',
                                                          letterSpacing: 0.0,
                                                          lineHeight: 1.2,
                                                        ),
                                                  ),
                                                ),
                                              );
                                            }),
                                          );
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          15.0, 18.0, 15.0, 18.0),
                                      child: Container(
                                        width: double.infinity,
                                        height: 1.0,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .accent1,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          15.0, 0.0, 0.0, 15.0),
                                      child: Text(
                                        'Relationship Goal',
                                        style: FlutterFlowTheme.of(context)
                                            .titleLarge
                                            .override(
                                              fontFamily: 'Onest',
                                              letterSpacing: 0.0,
                                            ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          15.0, 0.0, 15.0, 0.0),
                                      child: Wrap(
                                        spacing: 10.0,
                                        runSpacing: 10.0,
                                        alignment: WrapAlignment.start,
                                        crossAxisAlignment:
                                            WrapCrossAlignment.start,
                                        direction: Axis.horizontal,
                                        runAlignment: WrapAlignment.start,
                                        verticalDirection:
                                            VerticalDirection.down,
                                        clipBehavior: Clip.none,
                                        children: [
                                          Builder(
                                            builder: (context) {
                                              final goals = profileUsersRecord
                                                  .relationshipGoals
                                                  .toList();

                                              return SingleChildScrollView(
                                                scrollDirection: Axis.horizontal,
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: List.generate(
                                                      goals.length, (goalsIndex) {
                                                    final goalsItem =
                                                        goals[goalsIndex];
                                                    return Padding(
                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                        0.0, 0.0, goalsIndex < goals.length - 1 ? 10.0 : 0.0, 0.0),
                                                      child: Container(
                                                        height: 35.0,
                                                        decoration: BoxDecoration(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .transparent,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30.0),
                                                      border: Border.all(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .accent1,
                                                        width: 1.0,
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  15.0,
                                                                  7.0,
                                                                  15.0,
                                                                  7.0),
                                                      child: Text(
                                                        valueOrDefault<String>(
                                                          goalsItem,
                                                          'goal',
                                                        ),
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .labelLarge
                                                            .override(
                                                              fontFamily:
                                                                  'Onest',
                                                              letterSpacing:
                                                                  0.0,
                                                              lineHeight: 1.2,
                                                            ),
                                                      ),
                                                    ),
                                                      ),
                                                    );
                                                }),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          15.0, 18.0, 15.0, 18.0),
                                      child: Container(
                                        width: double.infinity,
                                        height: 1.0,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .accent1,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          15.0, 0.0, 0.0, 15.0),
                                      child: Text(
                                        'Languages i know',
                                        style: FlutterFlowTheme.of(context)
                                            .titleLarge
                                            .override(
                                              fontFamily: 'Onest',
                                              letterSpacing: 0.0,
                                            ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          15.0, 0.0, 15.0, 0.0),
                                      child: Builder(
                                        builder: (context) {
                                          final myLanguages = profileUsersRecord
                                              .languages
                                              .toList();

                                          return Wrap(
                                            spacing: 10.0,
                                            runSpacing: 10.0,
                                            alignment: WrapAlignment.start,
                                            crossAxisAlignment:
                                                WrapCrossAlignment.start,
                                            direction: Axis.horizontal,
                                            runAlignment: WrapAlignment.start,
                                            verticalDirection:
                                                VerticalDirection.down,
                                            clipBehavior: Clip.none,
                                            children: List.generate(
                                                myLanguages.length,
                                                (myLanguagesIndex) {
                                              final myLanguagesItem =
                                                  myLanguages[myLanguagesIndex];
                                              return Container(
                                                height: 35.0,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.0),
                                                  border: Border.all(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .accent1,
                                                    width: 1.0,
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          15.0, 7.0, 15.0, 7.0),
                                                  child: Text(
                                                    myLanguagesItem,
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .labelLarge
                                                        .override(
                                                          fontFamily: 'Onest',
                                                          letterSpacing: 0.0,
                                                          lineHeight: 1.2,
                                                        ),
                                                  ),
                                                ),
                                              );
                                            }),
                                          );
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          15.0, 18.0, 15.0, 18.0),
                                      child: Container(
                                        width: double.infinity,
                                        height: 1.0,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .accent1,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          15.0, 0.0, 0.0, 15.0),
                                      child: Text(
                                        'Travel Preferences',
                                        style: FlutterFlowTheme.of(context)
                                            .titleLarge
                                            .override(
                                              fontFamily: 'Onest',
                                              letterSpacing: 0.0,
                                            ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          15.0, 0.0, 15.0, 0.0),
                                      child: Builder(
                                        builder: (context) {
                                          final travelPreferences =
                                              profileUsersRecord
                                                  .travelPreferences
                                                  .toList();

                                          return Wrap(
                                            spacing: 10.0,
                                            runSpacing: 10.0,
                                            alignment: WrapAlignment.start,
                                            crossAxisAlignment:
                                                WrapCrossAlignment.start,
                                            direction: Axis.horizontal,
                                            runAlignment: WrapAlignment.start,
                                            verticalDirection:
                                                VerticalDirection.down,
                                            clipBehavior: Clip.none,
                                            children: List.generate(
                                                travelPreferences.length,
                                                (travelPreferencesIndex) {
                                              final travelPreferencesItem =
                                                  travelPreferences[
                                                      travelPreferencesIndex];
                                              return Container(
                                                height: 35.0,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.0),
                                                  border: Border.all(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .accent1,
                                                    width: 1.0,
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          15.0, 7.0, 15.0, 7.0),
                                                  child: Text(
                                                    travelPreferencesItem,
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .labelLarge
                                                        .override(
                                                          fontFamily: 'Onest',
                                                          letterSpacing: 0.0,
                                                          lineHeight: 1.2,
                                                        ),
                                                  ),
                                                ),
                                              );
                                            }),
                                          );
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          15.0, 18.0, 15.0, 18.0),
                                      child: Container(
                                        width: double.infinity,
                                        height: 1.0,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .accent1,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          15.0, 0.0, 0.0, 15.0),
                                      child: Text(
                                        'Music Preferences',
                                        style: FlutterFlowTheme.of(context)
                                            .titleLarge
                                            .override(
                                              fontFamily: 'Onest',
                                              letterSpacing: 0.0,
                                            ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          15.0, 0.0, 15.0, 20.0),
                                      child: Builder(
                                        builder: (context) {
                                          final musicPrefs = profileUsersRecord
                                              .musicPreferences
                                              .toList();

                                          return Wrap(
                                            spacing: 10.0,
                                            runSpacing: 10.0,
                                            alignment: WrapAlignment.start,
                                            crossAxisAlignment:
                                                WrapCrossAlignment.start,
                                            direction: Axis.horizontal,
                                            runAlignment: WrapAlignment.start,
                                            verticalDirection:
                                                VerticalDirection.down,
                                            clipBehavior: Clip.none,
                                            children:
                                                List.generate(musicPrefs.length,
                                                    (musicPrefsIndex) {
                                              final musicPrefsItem =
                                                  musicPrefs[musicPrefsIndex];
                                              return Container(
                                                height: 35.0,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.0),
                                                  border: Border.all(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .accent1,
                                                    width: 1.0,
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          15.0, 7.0, 15.0, 7.0),
                                                  child: Text(
                                                    musicPrefsItem,
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .labelLarge
                                                        .override(
                                                          fontFamily: 'Onest',
                                                          letterSpacing: 0.0,
                                                          lineHeight: 1.2,
                                                        ),
                                                  ),
                                                ),
                                              );
                                            }),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                wrapWithModel(
                  model: _model.navbarModel,
                  updateCallback: () => safeSetState(() {}),
                  child: NavbarWidget(
                    pages: 3,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
