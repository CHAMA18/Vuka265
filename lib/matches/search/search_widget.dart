import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/actions/actions.dart' as action_blocks;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'search_model.dart';
export 'search_model.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key});

  static String routeName = 'Search';
  static String routePath = '/search';

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  late SearchModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SearchModel());
    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) {
      safeSetState(() {
        _model.searchResults = [];
        _model.isSearching = false;
        _model.searchError = null;
      });
      return;
    }

    safeSetState(() {
      _model.isSearching = true;
      _model.searchError = null;
    });

    try {
      final results = await UsersRecord.search(
        term: query.trim(),
        maxResults: 20,
        useCache: false,
      );

      // Filter out current user from results
      final filteredResults = results
          .where((user) => user.uid != currentUserUid)
          .toList();

      safeSetState(() {
        _model.searchResults = filteredResults;
        _model.isSearching = false;
      });
    } catch (e) {
      debugPrint('Search error: $e');
      safeSetState(() {
        _model.searchResults = [];
        _model.isSearching = false;
        _model.searchError = 'Search failed. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(0.0),
          child: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
            automaticallyImplyLeading: false,
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
            // Search bar row
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 18.0, 15.0, 0.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(6.0, 6.0, 10.0, 6.0),
                    child: FlutterFlowIconButton(
                      borderColor: FlutterFlowTheme.of(context).transparent,
                      borderRadius: 30.0,
                      borderWidth: 0.0,
                      buttonSize: 40.0,
                      fillColor: FlutterFlowTheme.of(context).transparent,
                      icon: Icon(
                        Icons.chevron_left,
                        color: FlutterFlowTheme.of(context).primaryText,
                        size: 25.0,
                      ),
                      onPressed: () async {
                        await action_blocks.wait(context);
                        context.safePop();
                      },
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _model.textController,
                      focusNode: _model.textFieldFocusNode,
                      onChanged: (_) => EasyDebounce.debounce(
                        '_model.textController',
                        const Duration(milliseconds: 500),
                        () => _performSearch(_model.textController!.text),
                      ),
                      autofocus: true,
                      obscureText: false,
                      decoration: InputDecoration(
                        isDense: false,
                        hintText: 'Search people',
                        hintStyle: FlutterFlowTheme.of(context).labelLarge.override(
                          fontFamily: 'Onest',
                          color: FlutterFlowTheme.of(context).secondaryText,
                          letterSpacing: 0.0,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).transparent,
                            width: 0.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).transparent,
                            width: 0.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).error,
                            width: 0.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedErrorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).error,
                            width: 0.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        filled: true,
                        fillColor: FlutterFlowTheme.of(context).primaryBackground,
                        contentPadding: const EdgeInsetsDirectional.fromSTEB(15.0, 13.0, 15.0, 13.0),
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: FlutterFlowTheme.of(context).accent2,
                          size: 29.0,
                        ),
                        suffixIcon: _model.textController!.text.isNotEmpty
                            ? InkWell(
                                onTap: () async {
                                  _model.textController?.clear();
                                  safeSetState(() {
                                    _model.searchResults = [];
                                    _model.searchError = null;
                                  });
                                },
                                child: Icon(
                                  Icons.clear,
                                  color: FlutterFlowTheme.of(context).accent2,
                                  size: 20.0,
                                ),
                              )
                            : null,
                      ),
                      style: FlutterFlowTheme.of(context).labelLarge.override(
                        fontFamily: 'Onest',
                        letterSpacing: 0.0,
                      ),
                      validator: _model.textControllerValidator.asValidator(context),
                    ),
                  ),
                ],
              ),
            ),
            
            // Search results
            Expanded(
              child: _buildSearchResults(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    // Loading state
    if (_model.isSearching) {
      return Center(
        child: SpinKitFadingCircle(
          color: FlutterFlowTheme.of(context).primary,
          size: 40.0,
        ),
      );
    }

    // Error state
    if (_model.searchError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                color: FlutterFlowTheme.of(context).error,
                size: 48.0,
              ),
              const SizedBox(height: 12.0),
              Text(
                _model.searchError!,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Onest',
                  color: FlutterFlowTheme.of(context).secondaryText,
                  letterSpacing: 0.0,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    // Empty state (no search yet)
    if (_model.textController!.text.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.search,
                color: FlutterFlowTheme.of(context).secondaryText,
                size: 64.0,
              ),
              const SizedBox(height: 16.0),
              Text(
                'Search for people',
                style: FlutterFlowTheme.of(context).titleMedium.override(
                  fontFamily: 'Onest',
                  color: FlutterFlowTheme.of(context).primaryText,
                  letterSpacing: 0.0,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Type a name to find people',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Onest',
                  color: FlutterFlowTheme.of(context).secondaryText,
                  letterSpacing: 0.0,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // No results state
    if (_model.searchResults.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.person_search,
                color: FlutterFlowTheme.of(context).secondaryText,
                size: 64.0,
              ),
              const SizedBox(height: 16.0),
              Text(
                'No results found',
                style: FlutterFlowTheme.of(context).titleMedium.override(
                  fontFamily: 'Onest',
                  color: FlutterFlowTheme.of(context).primaryText,
                  letterSpacing: 0.0,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Try a different search term',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Onest',
                  color: FlutterFlowTheme.of(context).secondaryText,
                  letterSpacing: 0.0,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Results list
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      itemCount: _model.searchResults.length,
      itemBuilder: (context, index) {
        final user = _model.searchResults[index];
        return _SearchResultItem(user: user);
      },
    );
  }
}

class _SearchResultItem extends StatelessWidget {
  const _SearchResultItem({required this.user});

  final UsersRecord user;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.pushNamed(
          'SinglePage',
          queryParameters: {
            'userRef': serializeParam(user.reference, ParamType.DocumentReference),
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).primaryBackground,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          children: [
            // Profile image
            Container(
              width: 60.0,
              height: 60.0,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: profileImageProvider(user.photoUrl),
                ),
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            const SizedBox(width: 12.0),
            // User info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          user.displayName.isNotEmpty ? user.displayName : 'Unknown',
                          style: FlutterFlowTheme.of(context).titleSmall.override(
                            fontFamily: 'Onest',
                            color: FlutterFlowTheme.of(context).primaryText,
                            fontSize: 16.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (user.age > 0)
                        Container(
                          margin: const EdgeInsets.only(left: 8.0),
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Text(
                            '${user.age}',
                            style: FlutterFlowTheme.of(context).bodySmall.override(
                              fontFamily: 'Onest',
                              color: FlutterFlowTheme.of(context).primary,
                              fontSize: 12.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      if (user.verified)
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: Icon(
                            Icons.verified,
                            color: FlutterFlowTheme.of(context).primary,
                            size: 18.0,
                          ),
                        ),
                    ],
                  ),
                  if (user.locationName.isNotEmpty || user.bio.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        user.locationName.isNotEmpty ? user.locationName : user.bio,
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontFamily: 'Onest',
                          color: FlutterFlowTheme.of(context).secondaryText,
                          fontSize: 13.0,
                          letterSpacing: 0.0,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
            ),
            // Arrow icon
            Icon(
              Icons.chevron_right,
              color: FlutterFlowTheme.of(context).secondaryText,
              size: 24.0,
            ),
          ],
        ),
      ),
    );
  }
}
