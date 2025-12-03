import 'dart:convert';
import 'package:http/http.dart' as http;

class VideoSDKService {
  static const String _apiKey = '006aedd2-3c0c-471d-948f-728b84ac35db';
  static const String _secretKey = '6a5a2ebd92d416f3256226ac1fe10421547126514d601d2921a21d532e2eaec6';
  static const String _baseUrl = 'https://api.videosdk.live/v2';

  /// Creates a new meeting room and returns the meeting ID
  static Future<String> createMeeting() async {
    try {
      final token = _generateToken();
      final response = await http.post(
        Uri.parse('$_baseUrl/rooms'),
        headers: {
          'Authorization': token,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['roomId'] as String;
      } else {
        throw Exception('Failed to create meeting: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error creating meeting: $e');
    }
  }

  /// Validates if a meeting room exists
  static Future<bool> validateMeeting(String meetingId) async {
    try {
      final token = _generateToken();
      final response = await http.get(
        Uri.parse('$_baseUrl/rooms/$meetingId'),
        headers: {
          'Authorization': token,
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// Generates authentication token for VideoSDK API
  static String _generateToken() {
    // For production, you should generate JWT token server-side
    // This is a simplified version for client-side usage
    final credentials = base64.encode(utf8.encode('$_apiKey:$_secretKey'));
    return credentials;
  }

  /// Generates a meeting token for joining a room
  static Future<String> getMeetingToken(String meetingId) async {
    try {
      // In a production app, this should be done server-side
      // For now, we'll use the API key directly
      return _apiKey;
    } catch (e) {
      throw Exception('Error getting meeting token: $e');
    }
  }
}
