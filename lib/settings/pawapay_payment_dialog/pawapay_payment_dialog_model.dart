import 'package:flutter/material.dart';
import 'package:vuka265/flutter_flow/flutter_flow_model.dart';
import 'package:vuka265/services/pawapay_service.dart';

class PawaPayPaymentDialogModel extends FlutterFlowModel {
  TextEditingController? phoneController;
  FocusNode? phoneFocusNode;
  
  bool isProcessing = false;
  bool isLoadingCorrespondents = false;
  String? depositId;
  String? paymentStatus;
  
  List<PawaPayCorrespondent> correspondents = [];
  PawaPayCorrespondent? selectedCorrespondent;

  @override
  void initState(BuildContext context) {
    phoneController = TextEditingController();
    phoneFocusNode = FocusNode();
  }

  @override
  void dispose() {
    phoneController?.dispose();
    phoneFocusNode?.dispose();
  }
}
