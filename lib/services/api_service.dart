import 'dart:convert'; // For JSON decoding
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://192.168.0.103:8000/login.php";

  // Login User
  static Future<Map<String, dynamic>> loginUser(String voterId, String password) async {
    var url = Uri.parse("$baseUrl/login.php");

    var response = await http.post(
      url,
      body: {
        'voter_id': voterId,
        'password': password, // Match the PHP script keys
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Parse JSON response
    } else {
      return {'error': "Server Error: ${response.statusCode}"};
    }
  }
}
