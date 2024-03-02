import 'dart:convert';
import 'package:http/http.dart' as http;

// Function to authenticate user and get JWT token
Future<String> authenticateUser(String email, String password) async {
  final response = await http.post(
    Uri.parse('http://your-fastapi-backend.com/token'),
    headers: <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: <String, String>{
      'username': email,
      'password': password,
    },
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> data = jsonDecode(response.body);
    return data['access_token'];
  } else {
    throw Exception('Failed to authenticate user');
  }
}

// Example usage
void main() async {
  try {
    String token = await authenticateUser('user@example.com', 'password');
    print('Token: $token');
  } catch (e) {
    print('Error: $e');
  }
}