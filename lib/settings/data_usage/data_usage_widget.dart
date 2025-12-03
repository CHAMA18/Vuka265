import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data_usage/data_usage_model.dart';

class DataUsageWidget extends StatefulWidget {
  const DataUsageWidget({super.key});

  static String routeName = 'DataUsage';
  static String routePath = '/dataUsage';

  @override
  State<DataUsageWidget> createState() => _DataUsageWidgetState();
}

class _DataUsageWidgetState extends State<DataUsageWidget> {
  late DataUsageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DataUsageModel());
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final userRef = currentUserReference;
    if (userRef == null) {
      setState(() {
        _model.errorMessage = 'You must be signed in to view data usage.';
      });
      return;
    }

    setState(() {
      _model.isLoading = true;
      _model.errorMessage = null;
    });

    try {
      // Fetch counts in parallel.
      final chatsCountFut = FirebaseFirestore.instance
          .collection('chats')
          .where('userIDs', arrayContains: userRef)
          .count()
          .get();

      final sentMessagesFut = FirebaseFirestore.instance
          .collectionGroup('messages')
          .where('senderId', isEqualTo: userRef)
          .count()
          .get();

      final receivedMessagesFut = FirebaseFirestore.instance
          .collectionGroup('messages')
          .where('receiverId', isEqualTo: userRef)
          .count()
          .get();

      final swipesCountFut = FirebaseFirestore.instance
          .collection('swipes')
          .where('swiperId', isEqualTo: userRef)
          .count()
          .get();

      final results = await Future.wait([
        chatsCountFut,
        sentMessagesFut,
        receivedMessagesFut,
        swipesCountFut,
      ]);

      setState(() {
        _model.chatsCount = results[0].count;
        _model.sentMessagesCount = results[1].count;
        _model.receivedMessagesCount = results[2].count;
        _model.swipesCount = results[3].count;
        _model.isLoading = false;
      });
    } catch (e) {
      setState(() {
        _model.errorMessage = 'Failed to compute usage. Please try again.';
        _model.isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: theme.secondaryBackground,
        appBar: AppBar(
          backgroundColor: theme.secondaryBackground,
          automaticallyImplyLeading: false,
          leading: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(6.0, 6.0, 6.0, 6.0),
            child: FlutterFlowIconButton(
              borderColor: theme.transparent,
              borderRadius: 30.0,
              borderWidth: 0.0,
              buttonSize: 40.0,
              fillColor: theme.transparent,
              icon: Icon(
                FFIcons.karrowLeftMD,
                color: theme.primaryText,
                size: 25.0,
              ),
              onPressed: () => context.safePop(),
            ),
          ),
          title: Text(
            'Data Usage',
            style: theme.titleMedium.override(
              fontFamily: 'Onest',
              letterSpacing: 0.0,
            ),
          ),
          centerTitle: true,
          elevation: 0.0,
          actions: [
            IconButton(
              icon: Icon(Icons.refresh, color: theme.primary),
              onPressed: _load,
              tooltip: 'Recalculate',
            ),
          ],
        ),
        body: SafeArea(
          top: true,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_model.isLoading)
                  LinearProgressIndicator(
                    backgroundColor:
                        theme.primary.withValues(alpha: 0.15),
                    color: theme.primary,
                  ),
                if (_model.errorMessage != null) ...[
                  const SizedBox(height: 8.0),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: theme.error.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: theme.error),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: Text(
                            _model.errorMessage!,
                            style: theme.bodyMedium.override(
                              fontFamily: 'Onest',
                              letterSpacing: 0.0,
                              color: theme.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 16.0),
                _StatTile(
                  label: 'Active Chats',
                  value: _model.chatsCount,
                  icon: Icons.chat_bubble_outline,
                ),
                const SizedBox(height: 8.0),
                _StatTile(
                  label: 'Messages Sent',
                  value: _model.sentMessagesCount,
                  icon: Icons.send_outlined,
                ),
                const SizedBox(height: 8.0),
                _StatTile(
                  label: 'Messages Received',
                  value: _model.receivedMessagesCount,
                  icon: Icons.inbox_outlined,
                ),
                const SizedBox(height: 8.0),
                _StatTile(
                  label: 'Total Swipes',
                  value: _model.swipesCount,
                  icon: Icons.favorite_border,
                ),
                const Spacer(),
                Text(
                  'These stats are computed live from your account data.',
                  style: theme.labelSmall.override(
                    fontFamily: 'Onest',
                    letterSpacing: 0.0,
                    color: theme.secondaryText,
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

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final int? value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 14.0),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: theme.alternate),
      ),
      child: Row(
        children: [
          Icon(icon, color: theme.primary, size: 22.0),
          const SizedBox(width: 12.0),
          Expanded(
            child: Text(
              label,
              style: theme.labelLarge.override(
                fontFamily: 'Onest',
                letterSpacing: 0.0,
              ),
            ),
          ),
          Text(
            value == null ? '—' : value.toString(),
            style: theme.titleSmall.override(
              fontFamily: 'Onest',
              letterSpacing: 0.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
