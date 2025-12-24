import 'dart:math';
import 'package:http/http.dart' as http;

class AgoraService {
  // Agora App ID
  static const String appId = '950b44f0d45f4bbf8f9b807c749f5720';
  
  /// Generates a simple channel name for P2P calls
  static String generateChannelName() {
    final random = Random();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final randomSuffix = random.nextInt(9999);
    return 'voice_${timestamp}_$randomSuffix';
  }
  
  /// For production, you should generate tokens server-side
  /// For development/testing, you can use null token (less secure)
  static Future<String?> getToken(String channelName, int uid) async {
    // In a production app, call your backend server to generate token
    // For now, we'll return null which works for testing (with app certificate disabled)
    return null;
  }
}
