import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vuka265/auth/firebase_auth/auth_util.dart';
import 'package:vuka265/flutter_flow/flutter_flow_theme.dart';
import 'package:vuka265/flutter_flow/flutter_flow_util.dart';
import 'package:vuka265/flutter_flow/flutter_flow_widgets.dart';
import 'package:vuka265/services/pawapay_service.dart';
import 'pawapay_payment_dialog_model.dart';
export 'pawapay_payment_dialog_model.dart';

class PawaPayPaymentDialogWidget extends StatefulWidget {
  const PawaPayPaymentDialogWidget({
    super.key,
    required this.planTitle,
    required this.priceLabel,
    required this.onPaymentSuccess,
  });

  final String planTitle;
  final String priceLabel;
  final Function() onPaymentSuccess;

  @override
  State<PawaPayPaymentDialogWidget> createState() => _PawaPayPaymentDialogWidgetState();
}

class _PawaPayPaymentDialogWidgetState extends State<PawaPayPaymentDialogWidget> {
  late PawaPayPaymentDialogModel _model;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PawaPayPaymentDialogModel());
    _loadCorrespondents();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _loadCorrespondents() async {
    setState(() => _model.isLoadingCorrespondents = true);
    
    final correspondents = await PawaPayService.getCorrespondents(planTitle: widget.planTitle);
    
    if (mounted) {
      setState(() {
        _model.correspondents = correspondents;
        _model.isLoadingCorrespondents = false;
      });
    }
  }

  Future<void> _initiatePayment() async {
    final phoneNumber = _model.phoneController?.text.trim() ?? '';
    
    if (_model.selectedCorrespondent == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select your country/provider')),
      );
      return;
    }

    if (phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your phone number')),
      );
      return;
    }

    if (phoneNumber.length < 9) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid phone number')),
      );
      return;
    }

    setState(() {
      _model.isProcessing = true;
      _model.paymentStatus = 'Initiating payment...';
    });

    final depositId = PawaPayService.generateDepositId();
    _model.depositId = depositId;

    final result = await PawaPayService.initiateDeposit(
      planTitle: widget.planTitle,
      phoneNumber: phoneNumber,
      depositId: depositId,
      correspondentKey: _model.selectedCorrespondent!.key,
    );

    if (!mounted) return;

    if (result['success'] == true) {
      final currency = result['currency'] ?? _model.selectedCorrespondent!.currency;
      final amount = result['amount'];
      setState(() {
        _model.paymentStatus = 'Payment request sent ($amount $currency). Check your phone...';
      });

      _pollPaymentStatus(depositId);
    } else {
      setState(() {
        _model.isProcessing = false;
        _model.paymentStatus = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['error'] ?? 'Payment failed'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Updates the user's subscription in Firestore after successful payment
  Future<void> _updateUserSubscription() async {
    try {
      final userId = currentUserUid;
      if (userId.isEmpty) {
        debugPrint('Cannot update subscription: No user ID');
        return;
      }

      final correspondent = _model.selectedCorrespondent;
      final priceLabel = correspondent != null 
          ? '${correspondent.amount ?? ''} ${correspondent.currency}'
          : widget.priceLabel;
      
      // Calculate subscription duration
      DateTime duration;
      final now = DateTime.now();
      switch (widget.planTitle) {
        case 'Daily':
          duration = now.add(const Duration(days: 1));
          break;
        case 'Weekly':
          duration = now.add(const Duration(days: 7));
          break;
        case 'Yearly':
          duration = now.add(const Duration(days: 365));
          break;
        case 'Gold':
          duration = now.add(const Duration(days: 36500)); // ~100 years
          break;
        default:
          duration = now.add(const Duration(days: 30));
      }

      final firestore = FirebaseFirestore.instance;
      final subscriptionRef = firestore.collection('subscriptions').doc(userId);
      final userRef = firestore.collection('users').doc(userId);

      // Create subscription document
      await subscriptionRef.set({
        'subscriptionname': '${widget.planTitle} Plan',
        'price': priceLabel,
        'duration': Timestamp.fromDate(duration),
        'users': userRef,
        'status': 'active',
        'startDate': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'isLifetime': widget.planTitle == 'Gold',
      }, SetOptions(merge: true));

      // Update user's subscription reference
      await userRef.update({
        'subscription': subscriptionRef,
      });

      debugPrint('Subscription updated successfully for user: $userId');
    } catch (e) {
      debugPrint('Error updating subscription: $e');
      // Don't fail the payment flow if subscription update fails
    }
  }

  Future<void> _pollPaymentStatus(String depositId) async {
    int attempts = 0;
    const maxAttempts = 30;

    while (attempts < maxAttempts && mounted) {
      await Future.delayed(const Duration(seconds: 3));

      final statusResult = await PawaPayService.checkDepositStatus(depositId);

      if (!mounted) return;

      if (statusResult['success'] != true) {
        setState(() {
          _model.isProcessing = false;
          _model.paymentStatus = null;
        });

        final errorMessage =
            statusResult['error'] ?? 'Unable to verify payment status. Please try again.';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final paymentStatus = statusResult['status'];

      if (paymentStatus == 'COMPLETED' || paymentStatus == 'ACCEPTED') {
        setState(() {
          _model.isProcessing = false;
          _model.paymentStatus = 'Payment successful!';
        });

        // Update user subscription in Firestore (especially for test mode)
        await _updateUserSubscription();

        await Future.delayed(const Duration(seconds: 1));
          
        if (mounted) {
          widget.onPaymentSuccess();
          Navigator.of(context).pop();
        }
        return;
      } else if (paymentStatus == 'FAILED' || paymentStatus == 'REJECTED') {
        setState(() {
          _model.isProcessing = false;
          _model.paymentStatus = null;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment was declined. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      attempts++;
    }

    if (mounted) {
      setState(() {
        _model.isProcessing = false;
        _model.paymentStatus = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment timeout. Please check your transaction status.'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (_, controller) => Container(
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryText.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Select Your Country/Provider',
                  style: FlutterFlowTheme.of(context).titleMedium.override(
                    fontFamily: 'Onest',
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.0,
                  ),
                ),
              ),
              Expanded(
                child: _model.isLoadingCorrespondents
                    ? const Center(child: CircularProgressIndicator())
                    : _model.correspondents.isEmpty
                        ? Center(
                            child: Text(
                              'Unable to load payment options.\nPlease try again.',
                              textAlign: TextAlign.center,
                              style: FlutterFlowTheme.of(context).bodyMedium,
                            ),
                          )
                        : ListView.builder(
                            controller: controller,
                            itemCount: _model.correspondents.length,
                            itemBuilder: (ctx, index) {
                              final correspondent = _model.correspondents[index];
                              final isSelected = _model.selectedCorrespondent?.key == correspondent.key;
                              final priceText = correspondent.amount != null
                                  ? '${correspondent.amount} ${correspondent.currency}'
                                  : correspondent.currency;
                              
                              return ListTile(
                                leading: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).primary.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.phone_android,
                                    color: FlutterFlowTheme.of(context).primary,
                                    size: 20,
                                  ),
                                ),
                                title: Text(
                                  correspondent.name,
                                  style: FlutterFlowTheme.of(context).bodyLarge.override(
                                    fontFamily: 'Onest',
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.0,
                                  ),
                                ),
                                subtitle: Text(
                                  priceText,
                                  style: FlutterFlowTheme.of(context).bodySmall.override(
                                    fontFamily: 'Onest',
                                    color: FlutterFlowTheme.of(context).primary,
                                    letterSpacing: 0.0,
                                  ),
                                ),
                                trailing: isSelected
                                    ? Icon(Icons.check_circle, color: FlutterFlowTheme.of(context).primary)
                                    : null,
                                onTap: () {
                                  setState(() => _model.selectedCorrespondent = correspondent);
                                  Navigator.pop(ctx);
                                },
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Mobile Money Payment',
                      style: FlutterFlowTheme.of(context).headlineSmall.override(
                        fontFamily: 'Onest',
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: _model.isProcessing ? null : () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.planTitle,
                            style: FlutterFlowTheme.of(context).titleMedium.override(
                              fontFamily: 'Onest',
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            widget.priceLabel,
                            style: FlutterFlowTheme.of(context).headlineSmall.override(
                              fontFamily: 'Onest',
                              color: FlutterFlowTheme.of(context).primary,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.phone_android, color: FlutterFlowTheme.of(context).primary, size: 40.0),
                  ],
                ),
              ),
              const SizedBox(height: 24.0),
              Text(
                'Country / Provider',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Onest',
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8.0),
              InkWell(
                onTap: _model.isProcessing ? null : _showCountryPicker,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: FlutterFlowTheme.of(context).accent1, width: 1.5),
                    borderRadius: BorderRadius.circular(12.0),
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.public,
                        color: FlutterFlowTheme.of(context).secondaryText,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _model.isLoadingCorrespondents
                            ? Text(
                                'Loading...',
                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                  fontFamily: 'Onest',
                                  color: FlutterFlowTheme.of(context).secondaryText,
                                  letterSpacing: 0.0,
                                ),
                              )
                            : Text(
                                _model.selectedCorrespondent?.name ?? 'Select your country/provider',
                                style: FlutterFlowTheme.of(context).bodyLarge.override(
                                  fontFamily: 'Onest',
                                  color: _model.selectedCorrespondent != null
                                      ? FlutterFlowTheme.of(context).primaryText
                                      : FlutterFlowTheme.of(context).secondaryText,
                                  letterSpacing: 0.0,
                                ),
                              ),
                      ),
                      Icon(Icons.arrow_drop_down, color: FlutterFlowTheme.of(context).secondaryText),
                    ],
                  ),
                ),
              ),
              if (_model.selectedCorrespondent != null) ...[
                const SizedBox(height: 8.0),
                Text(
                  'Price: ${_model.selectedCorrespondent!.amount ?? 'N/A'} ${_model.selectedCorrespondent!.currency}',
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                    fontFamily: 'Onest',
                    color: FlutterFlowTheme.of(context).primary,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.0,
                  ),
                ),
              ],
              const SizedBox(height: 16.0),
              Text(
                'Mobile Money Number',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Onest',
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: _model.phoneController,
                focusNode: _model.phoneFocusNode,
                enabled: !_model.isProcessing,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(15),
                ],
                decoration: InputDecoration(
                  hintText: 'Enter phone number with country code',
                  hintStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Onest',
                    color: FlutterFlowTheme.of(context).secondaryText,
                    letterSpacing: 0.0,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: FlutterFlowTheme.of(context).accent1, width: 1.5),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: FlutterFlowTheme.of(context).primary, width: 2.0),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  filled: true,
                  fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                ),
                style: FlutterFlowTheme.of(context).bodyLarge.override(
                  fontFamily: 'Onest',
                  letterSpacing: 0.0,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Enter your mobile money number including country code',
                style: FlutterFlowTheme.of(context).bodySmall.override(
                  fontFamily: 'Onest',
                  color: FlutterFlowTheme.of(context).secondaryText,
                  letterSpacing: 0.0,
                ),
              ),
              if (_model.paymentStatus != null) ...[
                const SizedBox(height: 16.0),
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 20.0,
                        height: 20.0,
                        child: CircularProgressIndicator(strokeWidth: 2.0),
                      ),
                      const SizedBox(width: 12.0),
                      Expanded(
                        child: Text(
                          _model.paymentStatus!,
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Onest',
                            color: Colors.blue,
                            letterSpacing: 0.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 24.0),
              FFButtonWidget(
                onPressed: _model.isProcessing ? null : _initiatePayment,
                text: _model.isProcessing ? 'Processing...' : 'Pay Now',
                options: FFButtonOptions(
                  width: double.infinity,
                  height: 50.0,
                  color: FlutterFlowTheme.of(context).primary,
                  textStyle: FlutterFlowTheme.of(context).titleMedium.override(
                    fontFamily: 'Onest',
                    color: FlutterFlowTheme.of(context).info,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w600,
                  ),
                  elevation: 0.0,
                  borderRadius: BorderRadius.circular(25.0),
                ),
                showLoadingIndicator: false,
              ),
              const SizedBox(height: 12.0),
              Center(
                child: Text(
                  'Powered by PawaPay',
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                    fontFamily: 'Onest',
                    color: FlutterFlowTheme.of(context).secondaryText,
                    letterSpacing: 0.0,
                  ),
                ),
              ),
              if (PawaPayService.isTestMode) ...[
                const SizedBox(height: 8.0),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.science, size: 16, color: Colors.orange),
                      const SizedBox(width: 6),
                      Text(
                        'TEST MODE - No real payment',
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontFamily: 'Onest',
                          color: Colors.orange,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
