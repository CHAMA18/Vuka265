import '/flutter_flow/flutter_flow_model.dart';
import 'data_usage_widget.dart' show DataUsageWidget;
import 'package:flutter/material.dart';

class DataUsageModel extends FlutterFlowModel<DataUsageWidget> {
  // Computed usage values
  int? chatsCount;
  int? sentMessagesCount;
  int? receivedMessagesCount;
  int? swipesCount;

  bool isLoading = false;
  String? errorMessage;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
