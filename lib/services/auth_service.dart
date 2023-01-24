import 'dart:convert';
import 'dart:developer' as devtools;
import 'dart:io';

import 'package:flutter_webapi_first_course/constants/api_constants.dart';
import 'package:flutter_webapi_first_course/constants/app_constants.dart';
import 'package:flutter_webapi_first_course/services/journal_service.dart';
import 'package:flutter_webapi_first_course/services/web_client.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Logger logger = Logger();
  http.Client client = WebClient().client;
  Future<bool> login({required String email, required String password}) async {
    try {
      http.Response response = await client.post(
          Uri.parse("$apiBaseUrl$resourceAuthLogin"),
          body: {'email': email, 'password': password});
      if (response.statusCode.compareTo(statusCodeOk) != 0) {
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
    } on UserNotFoundException {
      rethrow;
    } on Exception catch (e) {
      logger.e("$e");
      switch ("$e") {
        case "Connection refused":
          throw ConnectionRefused();
        default:
          throw HttpException("$e");
      }
    }
  }

  Future<bool> register(
      {required String email, required String password}) async {
    try {
      http.Response response = await client.post(
          Uri.parse("$apiBaseUrl$resourceAuthRegister"),
          body: {'email': email, 'password': password});
      if (response.statusCode.compareTo(statusCodeCreated) != 0) {
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
    } on EmailAlreadyExistsException {
      rethrow;
    } on Exception catch (e) {
      logger.e("$e");
      switch ("$e") {
        case "Connection refused":
          throw ConnectionRefused();
        default:
          throw HttpException("$e");
      }
    }
  }

  saveUserInfo(String body) async {
    logger.i("Save user info:");
    Map<String, dynamic> map = json.decode(body);
    String token = map[prefsAccessToken];
    // TODO: Create User Class
    String email = map['user'][prefsUserEmail];
    int id = map['user'][prefsUserId] as int;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(prefsAccessToken, token);
    prefs.setString(prefsUserEmail, email);
    prefs.setInt(prefsUserId, id);
  }
}

class UserNotFoundException implements Exception {}

class EmailAlreadyExistsException implements Exception {}

class JwtExpiredException implements Exception {}
