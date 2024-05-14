import 'dart:convert';
import 'package:http/http.dart' as http;

class EmailValidator {
  static const String _kickboxApiUrl = 'https://api.kickbox.com/v2/verify';
  static const String _kickboxApiKey = 'live_b8e746e40d002efc29cc2aa14398df808ac9d3c4041cd00f50ace06bf1be8cb0';

  static Future<bool> isEmailValid(String email) async {
    final response = await http.get(Uri.parse('$_kickboxApiUrl?email=$email&apikey=$_kickboxApiKey'));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final result = jsonResponse['result'];
      return result == 'deliverable';
    } else {
      throw Exception('Failed to validate email: ${response.statusCode}');
    }
  }
}