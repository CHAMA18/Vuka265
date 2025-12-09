import '/flutter_flow/flutter_flow_model.dart';
import 'package:flutter/material.dart';
import '/services/admin_service.dart';
import '/backend/schema/users_record.dart';
import 'admin_dashboard_widget.dart' show AdminDashboardWidget;

class AdminDashboardModel extends FlutterFlowModel<AdminDashboardWidget> {
  final unfocusNode = FocusNode();
  
  int selectedTab = 0;
  bool isLoading = true;
  
  AdminAnalytics? analytics;
  List<UsersRecord> users = [];
  List<PaymentRecord> payments = [];
  List<SpecialAccessRecord> specialAccessRecords = [];
  
  String? searchQuery;
  FocusNode? searchFocusNode;
  TextEditingController? searchController;
  
  FocusNode? grantAccessEmailFocusNode;
  TextEditingController? grantAccessEmailController;
  FocusNode? grantAccessNameFocusNode;
  TextEditingController? grantAccessNameController;
  FocusNode? grantAccessUserIdFocusNode;
  TextEditingController? grantAccessUserIdController;
  
  String selectedAccessType = 'Gold';
  int selectedDuration = 30;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
    searchFocusNode?.dispose();
    searchController?.dispose();
    grantAccessEmailFocusNode?.dispose();
    grantAccessEmailController?.dispose();
    grantAccessNameFocusNode?.dispose();
    grantAccessNameController?.dispose();
    grantAccessUserIdFocusNode?.dispose();
    grantAccessUserIdController?.dispose();
  }
}
