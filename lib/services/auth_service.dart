import 'dart:convert';
import 'dart:developer' as devtools;
import 'dart:io';

import 'package:flutter_webapi_first_course/constants/api_constants.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_interceptor.dart';
import 'package:flutter_webapi_first_course/services/http_interceptors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  http.Client client =
      InterceptedClient.build(interceptors: [LoggingInterceptor()]);

  Future<bool> login({required String email, required String password}) async {
    http.Response response = await client.post(
        Uri.parse("$apiBaseUrl$resourceAuthLogin"),
        body: {'email': email, 'password': password});
    if (response.statusCode != statusCodeOk) {
      String content = json.decode(response.body) as String;
      switch (content) {
        case "Cannot find user":
          throw UserNotFoundException();
        default:
          throw HttpException(response.body);
      }
    }
    saveUserInfo(response.body);
    return true;
  }

  Future<bool> register(
      {required String email, required String password}) async {
    http.Response response = await client.post(
        Uri.parse("$apiBaseUrl$resourceAuthRegister"),
        body: {'email': email, 'password': password});
    if (response.statusCode != statusCodeCreated) {
      String content = json.decode(response.body) as String;
      switch (content) {
        case "Email already exists":
          throw EmailAlreadyExistsException();
        default:
          throw HttpException(response.body);
      }
    }
    saveUserInfo(response.body);
    return true;
  }

  saveUserInfo(String body) async {
    devtools.log("Save user info:");
    Map<String, dynamic> map = json.decode(body);
    String token = map['accessToken'];
    // TODO: Create User Class
    String email = map['user']['email'];
    int id = map['user']['id'] as int;
    //devtools.log("Token: $token\nEmail: $email\nId: $id");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("accessToken", token);
    prefs.setString("email", email);
    prefs.setInt("id", id);
    devtools.log("${prefs.getString('accessToken')}");
  }
}

class UserNotFoundException implements Exception {}

class EmailAlreadyExistsException implements Exception {}

class GenericAuthException implements Exception {}
