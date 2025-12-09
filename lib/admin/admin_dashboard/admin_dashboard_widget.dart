import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/services/admin_service.dart';
import '/backend/schema/users_record.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'admin_dashboard_model.dart';
export 'admin_dashboard_model.dart';

class AdminDashboardWidget extends StatefulWidget {
  const AdminDashboardWidget({super.key});

  static String routeName = 'AdminDashboard';
  static String routePath = '/admin-dashboard';

  @override
  State<AdminDashboardWidget> createState() => _AdminDashboardWidgetState();
}

class _AdminDashboardWidgetState extends State<AdminDashboardWidget> {
  late AdminDashboardModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AdminDashboardModel());

    _model.searchController ??= TextEditingController();
    _model.searchFocusNode ??= FocusNode();

    _model.grantAccessEmailController ??= TextEditingController();
    _model.grantAccessEmailFocusNode ??= FocusNode();
    _model.grantAccessNameController ??= TextEditingController();
    _model.grantAccessNameFocusNode ??= FocusNode();
    _model.grantAccessUserIdController ??= TextEditingController();
    _model.grantAccessUserIdFocusNode ??= FocusNode();

    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _model.isLoading = true);

    try {
      final results = await Future.wait([
        AdminService.getAnalytics(),
        AdminService.getAllUsers(limit: 50),
        AdminService.getPayments(limit: 50),
        AdminService.getSpecialAccessRecords(limit: 50),
      ]);

      setState(() {
        _model.analytics = results[0] as AdminAnalytics;
        _model.users = results[1] as List<UsersRecord>;
        _model.payments = results[2] as List<PaymentRecord>;
        _model.specialAccessRecords = results[3] as List<SpecialAccessRecord>;
        _model.isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading admin data: $e');
      setState(() => _model.isLoading = false);
    }
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 800;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          child: Row(
            children: [
              if (isWideScreen) _buildSidebar(),
              Expanded(
                child: Column(
                  children: [
                    _buildHeader(isWideScreen),
                    Expanded(
                      child: _model.isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                color: FlutterFlowTheme.of(context).primary,
                              ),
                            )
                          : _buildContent(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        drawer: isWideScreen ? null : Drawer(child: _buildSidebar()),
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 250,
      color: FlutterFlowTheme.of(context).secondaryBackground,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/Vuka_Logo-Original.png',
                  width: 40,
                  height: 40,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Admin Panel',
                    style: FlutterFlowTheme.of(context).titleMedium.override(
                      fontFamily: 'Onest',
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _buildNavItem(0, Icons.dashboard_rounded, 'Overview'),
                _buildNavItem(1, Icons.people_rounded, 'Users'),
                _buildNavItem(2, Icons.analytics_rounded, 'Analytics'),
                _buildNavItem(3, Icons.payment_rounded, 'Payments'),
                _buildNavItem(4, Icons.star_rounded, 'Special Access'),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: InkWell(
              onTap: () => context.go('/admin'),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(Icons.logout, color: FlutterFlowTheme.of(context).error, size: 20),
                    const SizedBox(width: 12),
                    Text(
                      'Sign Out',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Onest',
                        color: FlutterFlowTheme.of(context).error,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _model.selectedTab == index;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: InkWell(
        onTap: () => setState(() => _model.selectedTab = index),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? FlutterFlowTheme.of(context).primary.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected
                    ? FlutterFlowTheme.of(context).primary
                    : FlutterFlowTheme.of(context).secondaryText,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Onest',
                  color: isSelected
                      ? FlutterFlowTheme.of(context).primary
                      : FlutterFlowTheme.of(context).primaryText,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isWideScreen) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: FlutterFlowTheme.of(context).secondaryBackground,
      child: Row(
        children: [
          if (!isWideScreen)
            IconButton(
              icon: Icon(Icons.menu, color: FlutterFlowTheme.of(context).primaryText),
              onPressed: () => scaffoldKey.currentState?.openDrawer(),
            ),
          if (!isWideScreen) ...[
            Image.asset(
              'assets/images/Vuka_Logo-Original.png',
              width: 32,
              height: 32,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              _getTabTitle(),
              style: FlutterFlowTheme.of(context).headlineSmall.override(
                fontFamily: 'Onest',
                fontWeight: FontWeight.bold,
                letterSpacing: 0,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.refresh, color: FlutterFlowTheme.of(context).primaryText),
            onPressed: _loadData,
          ),
        ],
      ),
    );
  }

  String _getTabTitle() {
    switch (_model.selectedTab) {
      case 0: return 'Dashboard Overview';
      case 1: return 'User Management';
      case 2: return 'Analytics';
      case 3: return 'Payments & Invoices';
      case 4: return 'Special Access';
      default: return 'Admin Dashboard';
    }
  }

  Widget _buildContent() {
    switch (_model.selectedTab) {
      case 0: return _buildOverview();
      case 1: return _buildUsersTab();
      case 2: return _buildAnalyticsTab();
      case 3: return _buildPaymentsTab();
      case 4: return _buildSpecialAccessTab();
      default: return _buildOverview();
    }
  }

  Widget _buildOverview() {
    final analytics = _model.analytics;
    if (analytics == null) {
      return const Center(child: Text('No data available'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final cardWidth = constraints.maxWidth > 600 
                  ? (constraints.maxWidth - 32) / 3 
                  : constraints.maxWidth > 400 
                      ? (constraints.maxWidth - 16) / 2 
                      : constraints.maxWidth;
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _buildStatCard('Total Users', '${analytics.totalUsers}', Icons.people, FlutterFlowTheme.of(context).primary, cardWidth - 8),
                  _buildStatCard('Active Today', '${analytics.activeUsersToday}', Icons.trending_up, FlutterFlowTheme.of(context).success, cardWidth - 8),
                  _buildStatCard('Total Matches', '${analytics.totalMatches}', Icons.favorite, FlutterFlowTheme.of(context).secondary, cardWidth - 8),
                  _buildStatCard('Messages', '${analytics.totalMessages}', Icons.message, FlutterFlowTheme.of(context).accent4, cardWidth - 8),
                  _buildStatCard('New This Week', '${analytics.newUsersThisWeek}', Icons.person_add, FlutterFlowTheme.of(context).warning, cardWidth - 8),
                  _buildStatCard('Premium Users', '${analytics.premiumUsers}', Icons.star, Colors.amber, cardWidth - 8),
                ],
              );
            },
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 700;
              return isWide 
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildActiveUsersCard(analytics)),
                        const SizedBox(width: 16),
                        Expanded(child: _buildPageViewsCard(analytics)),
                      ],
                    )
                  : Column(
                      children: [
                        _buildActiveUsersCard(analytics),
                        const SizedBox(height: 16),
                        _buildPageViewsCard(analytics),
                      ],
                    );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActiveUsersCard(AdminAnalytics analytics) {
    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.people_alt_rounded, color: FlutterFlowTheme.of(context).primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Most Active Users',
                  style: FlutterFlowTheme.of(context).titleSmall.override(
                    fontFamily: 'Onest',
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: FlutterFlowTheme.of(context).alternate),
          analytics.mostActiveUsers.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: Text(
                      'No active users data yet',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Onest',
                        color: FlutterFlowTheme.of(context).secondaryText,
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: analytics.mostActiveUsers.length.clamp(0, 5),
                  separatorBuilder: (_, __) => Divider(
                    height: 1,
                    color: FlutterFlowTheme.of(context).alternate,
                  ),
                  itemBuilder: (context, index) {
                    final user = analytics.mostActiveUsers[index];
                    return ListTile(
                      dense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      leading: CircleAvatar(
                        radius: 18,
                        backgroundImage: user.photoUrl.isNotEmpty ? NetworkImage(user.photoUrl) : null,
                        backgroundColor: FlutterFlowTheme.of(context).primary.withValues(alpha: 0.2),
                        child: user.photoUrl.isEmpty ? Icon(Icons.person, color: FlutterFlowTheme.of(context).primary, size: 18) : null,
                      ),
                      title: Text(
                        user.displayName,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Onest', fontWeight: FontWeight.w500, letterSpacing: 0),
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        user.email,
                        style: FlutterFlowTheme.of(context).bodySmall.override(fontFamily: 'Onest', color: FlutterFlowTheme.of(context).secondaryText, letterSpacing: 0, fontSize: 11),
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${user.messageCount}',
                          style: FlutterFlowTheme.of(context).bodySmall.override(fontFamily: 'Onest', color: FlutterFlowTheme.of(context).primary, fontWeight: FontWeight.w600, letterSpacing: 0),
                        ),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildPageViewsCard(AdminAnalytics analytics) {
    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.bar_chart_rounded, color: FlutterFlowTheme.of(context).primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Page Views',
                  style: FlutterFlowTheme.of(context).titleSmall.override(
                    fontFamily: 'Onest',
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: FlutterFlowTheme.of(context).alternate),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: analytics.pageViews.entries.map((entry) {
                final maxViews = analytics.pageViews.values.isEmpty ? 1 : analytics.pageViews.values.reduce((a, b) => a > b ? a : b);
                final percentage = maxViews > 0 ? entry.value / maxViews : 0.0;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              entry.key,
                              style: FlutterFlowTheme.of(context).bodySmall.override(fontFamily: 'Onest', letterSpacing: 0),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '${entry.value}',
                            style: FlutterFlowTheme.of(context).bodySmall.override(fontFamily: 'Onest', fontWeight: FontWeight.w600, letterSpacing: 0),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: LinearProgressIndicator(
                          value: percentage,
                          backgroundColor: FlutterFlowTheme.of(context).alternate,
                          color: FlutterFlowTheme.of(context).primary,
                          minHeight: 5,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color, double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: FlutterFlowTheme.of(context).titleLarge.override(
                    fontFamily: 'Onest',
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  title,
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                    fontFamily: 'Onest',
                    color: FlutterFlowTheme.of(context).secondaryText,
                    letterSpacing: 0,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsersTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _model.searchController,
                      focusNode: _model.searchFocusNode,
                      decoration: InputDecoration(
                        hintText: 'Search users by name or email...',
                        hintStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Onest',
                          color: FlutterFlowTheme.of(context).secondaryText,
                          letterSpacing: 0,
                        ),
                        prefixIcon: Icon(Icons.search, color: FlutterFlowTheme.of(context).secondaryText),
                        filled: true,
                        fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Onest',
                        letterSpacing: 0,
                      ),
                      onSubmitted: (value) async {
                        if (value.isNotEmpty) {
                          setState(() => _model.isLoading = true);
                          final results = await AdminService.searchUsers(value);
                          setState(() {
                            _model.users = results;
                            _model.isLoading = false;
                          });
                        } else {
                          _loadData();
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  FFButtonWidget(
                    onPressed: () async {
                      final query = _model.searchController?.text ?? '';
                      if (query.isNotEmpty) {
                        setState(() => _model.isLoading = true);
                        final results = await AdminService.searchUsers(query);
                        setState(() {
                          _model.users = results;
                          _model.isLoading = false;
                        });
                      }
                    },
                    text: 'Search',
                    options: FFButtonOptions(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      color: FlutterFlowTheme.of(context).primary,
                      textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Onest',
                        color: Colors.white,
                        letterSpacing: 0,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      elevation: 0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_model.users.length} users',
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                      fontFamily: 'Onest',
                      color: FlutterFlowTheme.of(context).secondaryText,
                      letterSpacing: 0,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      _model.searchController?.clear();
                      _loadData();
                    },
                    icon: Icon(Icons.refresh, size: 16, color: FlutterFlowTheme.of(context).primary),
                    label: Text(
                      'Show All',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                        fontFamily: 'Onest',
                        color: FlutterFlowTheme.of(context).primary,
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: _model.users.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.people_outline,
                        size: 64,
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No users found',
                        style: FlutterFlowTheme.of(context).bodyLarge.override(
                          fontFamily: 'Onest',
                          color: FlutterFlowTheme.of(context).secondaryText,
                          letterSpacing: 0,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Users will appear here once they register',
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontFamily: 'Onest',
                          color: FlutterFlowTheme.of(context).secondaryText,
                          letterSpacing: 0,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton.icon(
                        onPressed: _loadData,
                        icon: Icon(Icons.refresh, color: FlutterFlowTheme.of(context).primary),
                        label: Text(
                          'Refresh',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Onest',
                            color: FlutterFlowTheme.of(context).primary,
                            letterSpacing: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _model.users.length,
                  itemBuilder: (context, index) {
                    final user = _model.users[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: user.photoUrl.isNotEmpty
                              ? NetworkImage(user.photoUrl)
                              : null,
                          backgroundColor: FlutterFlowTheme.of(context).primary.withValues(alpha: 0.2),
                          child: user.photoUrl.isEmpty
                              ? Icon(Icons.person, color: FlutterFlowTheme.of(context).primary)
                              : null,
                        ),
                        title: Text(
                          user.displayName.isNotEmpty ? user.displayName : 'No Name',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Onest',
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.email,
                              style: FlutterFlowTheme.of(context).bodySmall.override(
                                fontFamily: 'Onest',
                                color: FlutterFlowTheme.of(context).secondaryText,
                                letterSpacing: 0,
                              ),
                            ),
                            if (user.createdTime != null)
                              Text(
                                'Joined ${DateFormat.yMMMd().format(user.createdTime!)}',
                                style: FlutterFlowTheme.of(context).bodySmall.override(
                                  fontFamily: 'Onest',
                                  color: FlutterFlowTheme.of(context).secondaryText,
                                  fontSize: 10,
                                  letterSpacing: 0,
                                ),
                              ),
                          ],
                        ),
                        trailing: PopupMenuButton<String>(
                          icon: Icon(Icons.more_vert, color: FlutterFlowTheme.of(context).secondaryText),
                          onSelected: (value) async {
                            if (value == 'grant') {
                              _showGrantAccessDialog(user);
                            } else if (value == 'suspend') {
                              await AdminService.suspendUser(user.uid);
                              _loadData();
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(value: 'grant', child: Text('Grant Special Access')),
                            const PopupMenuItem(value: 'suspend', child: Text('Suspend User')),
                          ],
                        ),
                        isThreeLine: true,
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildAnalyticsTab() {
    final analytics = _model.analytics;
    if (analytics == null) {
      return const Center(child: Text('No analytics data available'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'User Growth (Last 6 Months)',
            style: FlutterFlowTheme.of(context).titleMedium.override(
              fontFamily: 'Onest',
              fontWeight: FontWeight.bold,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 200,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: analytics.userGrowthByMonth.isEmpty
                ? Center(
                    child: Text(
                      'No growth data available',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Onest',
                        color: FlutterFlowTheme.of(context).secondaryText,
                        letterSpacing: 0,
                      ),
                    ),
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: analytics.userGrowthByMonth.entries.map((entry) {
                      final maxValue = analytics.userGrowthByMonth.values.isNotEmpty
                          ? analytics.userGrowthByMonth.values.reduce((a, b) => a > b ? a : b)
                          : 1;
                      final height = maxValue > 0 ? (entry.value / maxValue) * 150 : 0.0;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                '${entry.value}',
                                style: FlutterFlowTheme.of(context).bodySmall.override(
                                  fontFamily: 'Onest',
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                height: height.clamp(10.0, 150.0),
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).primary,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                entry.key,
                                style: FlutterFlowTheme.of(context).bodySmall.override(
                                  fontFamily: 'Onest',
                                  color: FlutterFlowTheme.of(context).secondaryText,
                                  letterSpacing: 0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
          ),
          const SizedBox(height: 24),
          Text(
            'Key Metrics',
            style: FlutterFlowTheme.of(context).titleMedium.override(
              fontFamily: 'Onest',
              fontWeight: FontWeight.bold,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final cardWidth = constraints.maxWidth > 600 
                  ? (constraints.maxWidth - 24) / 4 
                  : constraints.maxWidth > 400 
                      ? (constraints.maxWidth - 12) / 2 
                      : constraints.maxWidth;
              return Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _buildMetricCard('Avg Matches/User', 
                    analytics.totalUsers > 0 
                      ? (analytics.totalMatches / analytics.totalUsers).toStringAsFixed(1) 
                      : '0',
                    Icons.favorite_border,
                    cardWidth - 6,
                  ),
                  _buildMetricCard('Avg Messages/User', 
                    analytics.totalUsers > 0 
                      ? (analytics.totalMessages / analytics.totalUsers).toStringAsFixed(1) 
                      : '0',
                    Icons.chat_bubble_outline,
                    cardWidth - 6,
                  ),
                  _buildMetricCard('Premium Rate', 
                    analytics.totalUsers > 0 
                      ? '${((analytics.premiumUsers / analytics.totalUsers) * 100).toStringAsFixed(1)}%' 
                      : '0%',
                    Icons.trending_up,
                    cardWidth - 6,
                  ),
                  _buildMetricCard('Total Revenue', 
                    '\$${analytics.totalRevenue.toStringAsFixed(2)}',
                    Icons.attach_money,
                    cardWidth - 6,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          Text(
            'Most Active Users',
            style: FlutterFlowTheme.of(context).titleMedium.override(
              fontFamily: 'Onest',
              fontWeight: FontWeight.bold,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: analytics.mostActiveUsers.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(24),
                    child: Center(
                      child: Text(
                        'No active users data',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Onest',
                          color: FlutterFlowTheme.of(context).secondaryText,
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: analytics.mostActiveUsers.length,
                    separatorBuilder: (_, __) => Divider(
                      height: 1,
                      color: FlutterFlowTheme.of(context).alternate,
                    ),
                    itemBuilder: (context, index) {
                      final user = analytics.mostActiveUsers[index];
                      return ListTile(
                        leading: Text(
                          '#${index + 1}',
                          style: FlutterFlowTheme.of(context).titleMedium.override(
                            fontFamily: 'Onest',
                            color: FlutterFlowTheme.of(context).primary,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0,
                          ),
                        ),
                        title: Text(
                          user.displayName,
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Onest',
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0,
                          ),
                        ),
                        subtitle: Text(
                          '${user.matchCount} matches | ${user.messageCount} messages',
                          style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily: 'Onest',
                            color: FlutterFlowTheme.of(context).secondaryText,
                            letterSpacing: 0,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: FlutterFlowTheme.of(context).primary, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: FlutterFlowTheme.of(context).titleSmall.override(
                    fontFamily: 'Onest',
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  title,
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                    fontFamily: 'Onest',
                    color: FlutterFlowTheme.of(context).secondaryText,
                    fontSize: 11,
                    letterSpacing: 0,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentsTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButton<String>(
                  value: 'all',
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('All Payments')),
                    DropdownMenuItem(value: 'COMPLETED', child: Text('Completed')),
                    DropdownMenuItem(value: 'PENDING', child: Text('Pending')),
                    DropdownMenuItem(value: 'FAILED', child: Text('Failed')),
                  ],
                  onChanged: (value) async {
                    if (value != null && value != 'all') {
                      setState(() => _model.isLoading = true);
                      final payments = await AdminService.getPayments(statusFilter: value);
                      setState(() {
                        _model.payments = payments;
                        _model.isLoading = false;
                      });
                    } else {
                      setState(() => _model.isLoading = true);
                      final payments = await AdminService.getPayments();
                      setState(() {
                        _model.payments = payments;
                        _model.isLoading = false;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _model.payments.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.payment_outlined,
                        size: 64,
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No payments found',
                        style: FlutterFlowTheme.of(context).bodyLarge.override(
                          fontFamily: 'Onest',
                          color: FlutterFlowTheme.of(context).secondaryText,
                          letterSpacing: 0,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Payment records will appear here once users make purchases',
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontFamily: 'Onest',
                          color: FlutterFlowTheme.of(context).secondaryText,
                          letterSpacing: 0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _model.payments.length,
                  itemBuilder: (context, index) {
                    final payment = _model.payments[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  payment.userName,
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Onest',
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              _buildStatusBadge(payment.status),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            payment.userEmail,
                            style: FlutterFlowTheme.of(context).bodySmall.override(
                              fontFamily: 'Onest',
                              color: FlutterFlowTheme.of(context).secondaryText,
                              letterSpacing: 0,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${payment.planName} Plan',
                                style: FlutterFlowTheme.of(context).bodySmall.override(
                                  fontFamily: 'Onest',
                                  letterSpacing: 0,
                                ),
                              ),
                              Text(
                                '${payment.amount} ${payment.currency}',
                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                  fontFamily: 'Onest',
                                  fontWeight: FontWeight.bold,
                                  color: FlutterFlowTheme.of(context).primary,
                                  letterSpacing: 0,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat.yMMMd().add_jm().format(payment.createdAt),
                            style: FlutterFlowTheme.of(context).bodySmall.override(
                              fontFamily: 'Onest',
                              color: FlutterFlowTheme.of(context).secondaryText,
                              fontSize: 10,
                              letterSpacing: 0,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status.toUpperCase()) {
      case 'COMPLETED':
        color = FlutterFlowTheme.of(context).success;
        break;
      case 'PENDING':
        color = FlutterFlowTheme.of(context).warning;
        break;
      case 'FAILED':
        color = FlutterFlowTheme.of(context).error;
        break;
      default:
        color = FlutterFlowTheme.of(context).secondaryText;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: FlutterFlowTheme.of(context).bodySmall.override(
          fontFamily: 'Onest',
          color: color,
          fontWeight: FontWeight.w500,
          letterSpacing: 0,
        ),
      ),
    );
  }

  Widget _buildSpecialAccessTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FFButtonWidget(
                onPressed: () => _showGrantAccessDialog(null),
                text: 'Grant New Access',
                icon: const Icon(Icons.add, color: Colors.white, size: 18),
                options: FFButtonOptions(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  color: FlutterFlowTheme.of(context).primary,
                  textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Onest',
                    color: Colors.white,
                    letterSpacing: 0,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  elevation: 0,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _model.specialAccessRecords.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.star_outline,
                        size: 64,
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No special access records',
                        style: FlutterFlowTheme.of(context).bodyLarge.override(
                          fontFamily: 'Onest',
                          color: FlutterFlowTheme.of(context).secondaryText,
                          letterSpacing: 0,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Grant special access to users above',
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontFamily: 'Onest',
                          color: FlutterFlowTheme.of(context).secondaryText,
                          letterSpacing: 0,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _model.specialAccessRecords.length,
                  itemBuilder: (context, index) {
                    final record = _model.specialAccessRecords[index];
                    final isExpired = record.expiresAt.isBefore(DateTime.now());
                    
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        borderRadius: BorderRadius.circular(12),
                        border: isExpired
                            ? Border.all(color: FlutterFlowTheme.of(context).error.withValues(alpha: 0.3))
                            : null,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  record.userName,
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Onest',
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isExpired
                                      ? FlutterFlowTheme.of(context).error.withValues(alpha: 0.1)
                                      : Colors.amber.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  record.accessType,
                                  style: FlutterFlowTheme.of(context).bodySmall.override(
                                    fontFamily: 'Onest',
                                    color: isExpired 
                                        ? FlutterFlowTheme.of(context).error
                                        : Colors.amber[800],
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            record.userEmail,
                            style: FlutterFlowTheme.of(context).bodySmall.override(
                              fontFamily: 'Onest',
                              color: FlutterFlowTheme.of(context).secondaryText,
                              letterSpacing: 0,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                isExpired 
                                    ? 'Expired ${DateFormat.yMMMd().format(record.expiresAt)}'
                                    : 'Expires ${DateFormat.yMMMd().format(record.expiresAt)}',
                                style: FlutterFlowTheme.of(context).bodySmall.override(
                                  fontFamily: 'Onest',
                                  color: isExpired 
                                      ? FlutterFlowTheme.of(context).error
                                      : FlutterFlowTheme.of(context).secondaryText,
                                  letterSpacing: 0,
                                ),
                              ),
                              if (record.isActive && !isExpired)
                                TextButton(
                                  onPressed: () async {
                                    final confirmed = await showDialog<bool>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Revoke Access'),
                                        content: Text('Are you sure you want to revoke ${record.accessType} access for ${record.userName}?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, false),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, true),
                                            child: const Text('Revoke'),
                                          ),
                                        ],
                                      ),
                                    );
                                    
                                    if (confirmed == true) {
                                      await AdminService.revokeSpecialAccess(record.oderId);
                                      _loadData();
                                    }
                                  },
                                  child: Text(
                                    'Revoke',
                                    style: FlutterFlowTheme.of(context).bodySmall.override(
                                      fontFamily: 'Onest',
                                      color: FlutterFlowTheme.of(context).error,
                                      letterSpacing: 0,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  void _showGrantAccessDialog(UsersRecord? user) {
    if (user != null) {
      _model.grantAccessUserIdController?.text = user.uid;
      _model.grantAccessEmailController?.text = user.email;
      _model.grantAccessNameController?.text = user.displayName;
    } else {
      _model.grantAccessUserIdController?.clear();
      _model.grantAccessEmailController?.clear();
      _model.grantAccessNameController?.clear();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Grant Special Access',
                      style: FlutterFlowTheme.of(context).titleMedium.override(
                        fontFamily: 'Onest',
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (user == null) ...[
                  Text(
                    'User ID',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Onest',
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _model.grantAccessUserIdController,
                    decoration: InputDecoration(
                      hintText: 'Enter user ID',
                      filled: true,
                      fillColor: FlutterFlowTheme.of(context).primaryBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'User Email',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Onest',
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _model.grantAccessEmailController,
                    decoration: InputDecoration(
                      hintText: 'Enter user email',
                      filled: true,
                      fillColor: FlutterFlowTheme.of(context).primaryBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'User Name',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Onest',
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _model.grantAccessNameController,
                    decoration: InputDecoration(
                      hintText: 'Enter user name',
                      filled: true,
                      fillColor: FlutterFlowTheme.of(context).primaryBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ] else ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primaryBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: user.photoUrl.isNotEmpty
                              ? NetworkImage(user.photoUrl)
                              : null,
                          backgroundColor: FlutterFlowTheme.of(context).primary.withValues(alpha: 0.2),
                          child: user.photoUrl.isEmpty
                              ? Icon(Icons.person, color: FlutterFlowTheme.of(context).primary)
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.displayName,
                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                  fontFamily: 'Onest',
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0,
                                ),
                              ),
                              Text(
                                user.email,
                                style: FlutterFlowTheme.of(context).bodySmall.override(
                                  fontFamily: 'Onest',
                                  color: FlutterFlowTheme.of(context).secondaryText,
                                  letterSpacing: 0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                Text(
                  'Access Type',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Onest',
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButton<String>(
                    value: _model.selectedAccessType,
                    isExpanded: true,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(value: 'Daily', child: Text('Daily')),
                      DropdownMenuItem(value: 'Weekly', child: Text('Weekly')),
                      DropdownMenuItem(value: 'Yearly', child: Text('Yearly')),
                      DropdownMenuItem(value: 'Gold', child: Text('Gold (Premium)')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setSheetState(() => _model.selectedAccessType = value);
                      }
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Duration (Days)',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Onest',
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButton<int>(
                    value: _model.selectedDuration,
                    isExpanded: true,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(value: 1, child: Text('1 Day')),
                      DropdownMenuItem(value: 7, child: Text('7 Days')),
                      DropdownMenuItem(value: 14, child: Text('14 Days')),
                      DropdownMenuItem(value: 30, child: Text('30 Days')),
                      DropdownMenuItem(value: 90, child: Text('90 Days')),
                      DropdownMenuItem(value: 365, child: Text('365 Days (1 Year)')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setSheetState(() => _model.selectedDuration = value);
                      }
                    },
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FFButtonWidget(
                    onPressed: () async {
                      final oderId = user?.uid ?? _model.grantAccessUserIdController?.text ?? '';
                      final email = user?.email ?? _model.grantAccessEmailController?.text ?? '';
                      final name = user?.displayName ?? _model.grantAccessNameController?.text ?? '';

                      if (oderId.isEmpty || email.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please fill in all required fields')),
                        );
                        return;
                      }

                      final success = await AdminService.grantSpecialAccess(
                        oderId: oderId,
                        userEmail: email,
                        userName: name,
                        accessType: _model.selectedAccessType,
                        durationDays: _model.selectedDuration,
                      );

                      if (mounted) {
                        Navigator.pop(context);
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Special access granted to $name')),
                          );
                          _loadData();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Failed to grant special access')),
                          );
                        }
                      }
                    },
                    text: 'Grant Access',
                    options: FFButtonOptions(
                      height: 50,
                      color: FlutterFlowTheme.of(context).primary,
                      textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                        fontFamily: 'Onest',
                        color: Colors.white,
                        letterSpacing: 0,
                      ),
                      borderRadius: BorderRadius.circular(25),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
