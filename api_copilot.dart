// This is the FlutterFlow app code
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// A class for storing the user data
class User {
  final String username;
  final String email;
  final String fullName;
  final bool disabled;

  User({this.username, this.email, this.fullName, this.disabled});

  // A factory method to create a user from a JSON object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      email: json['email'],
      fullName: json['full_name'],
      disabled: json['disabled'],
    );
  }
}

// A class for storing the access token data
class Token {
  final String accessToken;
  final String tokenType;

  Token({this.accessToken, this.tokenType});

  // A factory method to create a token from a JSON object
  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      accessToken: json['access_token'],
      tokenType: json['token_type'],
    );
  }
}

// A global variable to store the token
Token token;

// A function to login with username and password and get an access token
Future<Token> login(String username, String password) async {
  // The URL of the token endpoint
  final url = 'http://localhost:8000/token';
  // The body of the request
  final body = {
    'username': username,
    'password': password,
  };
  // The headers of the request
  final headers = {
    'Content-Type': 'application/x-www-form-urlencoded',
  };
  // Send a POST request to the token endpoint
  final response = await http.post(url, body: body, headers: headers);
  // If the request is successful, parse the response and return a token
  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    return Token.fromJson(json);
  } else {
    // If the request is not successful, throw an exception
    throw Exception('Failed to login');
  }
}

// A function to get the current user data using the access token
Future<User> getCurrentUser() async {
  // The URL of the user endpoint
  final url = 'http://localhost:8000/users/me';
  // The headers of the request, including the authorization header
  final headers = {
    'Authorization': '${token.tokenType} ${token.accessToken}',
  };
  // Send a GET request to the user endpoint
  final response = await http.get(url, headers: headers);
  // If the request is successful, parse the response and return a user
  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    return User.fromJson(json);
  } else {
    // If the request is not successful, throw an exception
    throw Exception('Failed to get current user');
  }
}

// A function to get the current user's email using the access token
Future<String> getCurrentUserEmail() async {
  // The URL of the email endpoint
  final url = 'http://localhost:8000/users/me/email';
  // The headers of the request, including the authorization header
  final headers = {
    'Authorization': '${token.tokenType} ${token.accessToken}',
  };
  // Send a GET request to the email endpoint
  final response = await http.get(url, headers: headers);
  // If the request is successful, return the email as a string
  if (response.statusCode == 200) {
    return response.body;
  } else {
    // If the request is not successful, throw an exception
    throw Exception('Failed to get current user email');
  }
}

// A widget for displaying the user data
class UserWidget extends StatelessWidget {
  final User user;

  UserWidget({this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Username: ${user.username}'),
        Text('Email: ${user.email}'),
        Text('Full name: ${user.fullName}'),
        Text('Disabled: ${user.disabled}'),
      ],
    );
  }
}

// A widget for displaying the login form
class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  // A controller for the username field
  final usernameController = TextEditingController();
  // A controller for the password field
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller