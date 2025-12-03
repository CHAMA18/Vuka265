import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';

class PawaPayCorrespondent {
  final String key;
  final String code;
  final String currency;
  final String name;
  final int? amount;

  PawaPayCorrespondent({
    required this.key,
    required this.code,
    required this.currency,
    required this.name,
    this.amount,
  });

  factory PawaPayCorrespondent.fromMap(Map<String, dynamic> map) {
    return PawaPayCorrespondent(
      key: map['key'] ?? '',
      code: map['code'] ?? '',
      currency: map['currency'] ?? '',
      name: map['name'] ?? '',
      amount: map['amount'],
    );
  }
}

class PawaPayService {
  static final _functions = FirebaseFunctions.instance;

  // Plan amounts in USD
  static const Map<String, double> _planAmountsUSD = {
    'Daily': 1.20,
    'Weekly': 8.00,
    'Yearly': 15.00,
    'Gold': 50.00,
  };

  // Exchange rates from USD
  static const Map<String, double> _exchangeRates = {
    'USD': 1,
    'MWK': 1700,
    'KES': 155,
    'GHS': 15,
    'NGN': 1500,
    'TZS': 2700,
    'UGX': 3800,
    'ZMW': 27,
    'ZWG': 14,
    'RWF': 1300,
    'XOF': 610,
    'XAF': 610,
    'GNF': 8600,
    'MZN': 64,
    'SLE': 22,
  };

  // Static list of correspondents as fallback
  static final List<Map<String, dynamic>> _staticCorrespondents = [
    {'key': 'BJ', 'code': 'MTN_MOMO_BEN', 'currency': 'XOF', 'name': 'Benin (MTN)'},
    {'key': 'BF', 'code': 'ORANGE_BFA', 'currency': 'XOF', 'name': 'Burkina Faso (Orange)'},
    {'key': 'CM_MTN', 'code': 'MTN_MOMO_CMR', 'currency': 'XAF', 'name': 'Cameroon (MTN)'},
    {'key': 'CM_ORANGE', 'code': 'ORANGE_CMR', 'currency': 'XAF', 'name': 'Cameroon (Orange)'},
    {'key': 'CG', 'code': 'MTN_MOMO_COG', 'currency': 'XAF', 'name': 'Congo Brazzaville (MTN)'},
    {'key': 'CI_MTN', 'code': 'MTN_MOMO_CIV', 'currency': 'XOF', 'name': 'Ivory Coast (MTN)'},
    {'key': 'CI_ORANGE', 'code': 'ORANGE_CIV', 'currency': 'XOF', 'name': 'Ivory Coast (Orange)'},
    {'key': 'CI_MOOV', 'code': 'MOOV_CIV', 'currency': 'XOF', 'name': 'Ivory Coast (Moov)'},
    {'key': 'CI_WAVE', 'code': 'WAVE_CIV', 'currency': 'XOF', 'name': 'Ivory Coast (Wave)'},
    {'key': 'CD_AIRTEL', 'code': 'AIRTEL_COD', 'currency': 'USD', 'name': 'DRC (Airtel)'},
    {'key': 'CD_ORANGE', 'code': 'ORANGE_COD', 'currency': 'USD', 'name': 'DRC (Orange)'},
    {'key': 'CD_VODACOM', 'code': 'VODACOM_COD', 'currency': 'USD', 'name': 'DRC (Vodacom)'},
    {'key': 'GH_MTN', 'code': 'MTN_MOMO_GHA', 'currency': 'GHS', 'name': 'Ghana (MTN)'},
    {'key': 'GH_VODAFONE', 'code': 'VODAFONE_GHA', 'currency': 'GHS', 'name': 'Ghana (Vodafone)'},
    {'key': 'GH_AIRTELTIGO', 'code': 'AIRTELTIGO_GHA', 'currency': 'GHS', 'name': 'Ghana (AirtelTigo)'},
    {'key': 'GN', 'code': 'MTN_MOMO_GIN', 'currency': 'GNF', 'name': 'Guinea (MTN)'},
    {'key': 'KE', 'code': 'MPESA_KEN', 'currency': 'KES', 'name': 'Kenya (M-Pesa)'},
    {'key': 'MW_TNM', 'code': 'TNM_MMALAWI', 'currency': 'MWK', 'name': 'Malawi (TNM)'},
    {'key': 'MW_AIRTEL', 'code': 'AIRTEL_MWI', 'currency': 'MWK', 'name': 'Malawi (Airtel)'},
    {'key': 'MZ_VODACOM', 'code': 'VODACOM_MOZ', 'currency': 'MZN', 'name': 'Mozambique (Vodacom)'},
    {'key': 'MZ_MPESA', 'code': 'MPESA_MOZ', 'currency': 'MZN', 'name': 'Mozambique (M-Pesa)'},
    {'key': 'NG', 'code': 'OPAY_NGR', 'currency': 'NGN', 'name': 'Nigeria (OPay)'},
    {'key': 'RW', 'code': 'MTN_MOMO_RWA', 'currency': 'RWF', 'name': 'Rwanda (MTN)'},
    {'key': 'SN_ORANGE', 'code': 'ORANGE_SEN', 'currency': 'XOF', 'name': 'Senegal (Orange)'},
    {'key': 'SN_FREE', 'code': 'FREE_SEN', 'currency': 'XOF', 'name': 'Senegal (Free)'},
    {'key': 'SN_WAVE', 'code': 'WAVE_SEN', 'currency': 'XOF', 'name': 'Senegal (Wave)'},
    {'key': 'SL', 'code': 'ORANGE_SLE', 'currency': 'SLE', 'name': 'Sierra Leone (Orange)'},
    {'key': 'TZ_VODACOM', 'code': 'VODACOM_TZN', 'currency': 'TZS', 'name': 'Tanzania (Vodacom)'},
    {'key': 'TZ_AIRTEL', 'code': 'AIRTEL_TZN', 'currency': 'TZS', 'name': 'Tanzania (Airtel)'},
    {'key': 'TZ_TIGO', 'code': 'TIGO_TZN', 'currency': 'TZS', 'name': 'Tanzania (Tigo)'},
    {'key': 'TZ_HALOTEL', 'code': 'HALOTEL_TZN', 'currency': 'TZS', 'name': 'Tanzania (Halotel)'},
    {'key': 'UG_MTN', 'code': 'MTN_MOMO_UGA', 'currency': 'UGX', 'name': 'Uganda (MTN)'},
    {'key': 'UG_AIRTEL', 'code': 'AIRTEL_UGA', 'currency': 'UGX', 'name': 'Uganda (Airtel)'},
    {'key': 'ZM_MTN', 'code': 'MTN_MOMO_ZMB', 'currency': 'ZMW', 'name': 'Zambia (MTN)'},
    {'key': 'ZM_AIRTEL', 'code': 'AIRTEL_ZMB', 'currency': 'ZMW', 'name': 'Zambia (Airtel)'},
    {'key': 'ZW', 'code': 'ECOCASH_ZWE', 'currency': 'ZWG', 'name': 'Zimbabwe (EcoCash)'},
  ];

  static int _convertToLocalCurrency(double usdAmount, String currency) {
    final rate = _exchangeRates[currency] ?? 1;
    return (usdAmount * rate).round();
  }

  /// Fetches supported correspondents (countries/providers)
  /// Falls back to static list if Cloud Function fails
  static Future<List<PawaPayCorrespondent>> getCorrespondents({String? planTitle}) async {
    try {
      final callable = _functions.httpsCallable('getPawaPayCorrespondents');
      final result = await callable.call({'planTitle': planTitle});

      final data = result.data as Map<String, dynamic>;
      if (data['success'] == true) {
        final list = data['correspondents'] as List<dynamic>;
        return list
            .map((e) => PawaPayCorrespondent.fromMap(Map<String, dynamic>.from(e)))
            .toList();
      }
      // Fall through to static list
    } catch (e) {
      debugPrint('Error fetching PawaPay correspondents from Cloud Function: $e');
      debugPrint('Using static correspondent list as fallback');
    }
    
    // Return static list with calculated amounts
    final usdAmount = planTitle != null ? _planAmountsUSD[planTitle] : null;
    return _staticCorrespondents.map((c) {
      final currency = c['currency'] as String;
      final amount = usdAmount != null ? _convertToLocalCurrency(usdAmount, currency) : null;
      return PawaPayCorrespondent(
        key: c['key'] as String,
        code: c['code'] as String,
        currency: currency,
        name: c['name'] as String,
        amount: amount,
      );
    }).toList();
  }

  /// Initiates a deposit for the selected plan via Firebase Cloud Function
  /// Returns a map with status and transaction details
  static Future<Map<String, dynamic>> initiateDeposit({
    required String planTitle,
    required String phoneNumber,
    required String depositId,
    required String correspondentKey,
  }) async {
    try {
      final callable = _functions.httpsCallable('initiatePawaPayDeposit');
      final result = await callable.call({
        'planTitle': planTitle,
        'phoneNumber': phoneNumber,
        'depositId': depositId,
        'correspondentKey': correspondentKey,
      });

      final data = result.data as Map<String, dynamic>;
      return data;
    } on FirebaseFunctionsException catch (e) {
      debugPrint('PawaPay deposit error: ${e.message}');
      return {
        'success': false,
        'error': e.message ?? 'Payment initiation failed',
        'code': e.code,
      };
    } catch (e) {
      debugPrint('PawaPay deposit error: $e');
      return {
        'success': false,
        'error': 'Unable to connect to payment service. Please try again.',
        'technicalDetails': e.toString(),
      };
    }
  }

  /// Checks the status of a deposit via Firebase Cloud Function
  static Future<Map<String, dynamic>> checkDepositStatus(String depositId) async {
    try {
      final callable = _functions.httpsCallable('checkPawaPayDepositStatus');
      final result = await callable.call({'depositId': depositId});

      final data = result.data as Map<String, dynamic>;
      return data;
    } on FirebaseFunctionsException catch (e) {
      debugPrint('PawaPay status check error: ${e.message}');
      return {
        'success': false,
        'error': e.message ?? 'Status check failed',
        'code': e.code,
      };
    } catch (e) {
      debugPrint('PawaPay status check error: $e');
      return {
        'success': false,
        'error': 'Connection error: ${e.toString()}',
      };
    }
  }

  /// Generates a unique deposit ID using timestamp and random suffix
  static String generateDepositId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = (timestamp % 10000).toString().padLeft(4, '0');
    return 'VK265-$timestamp-$random';
  }
}
