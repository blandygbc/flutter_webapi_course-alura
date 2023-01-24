import 'dart:convert';
import 'dart:io';

import 'package:flutter_webapi_first_course/constants/api_constants.dart';
import 'package:flutter_webapi_first_course/models/journal.dart';
import 'package:flutter_webapi_first_course/services/auth_service.dart';
import 'package:flutter_webapi_first_course/services/web_client.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class JournalService {
  Logger logger = Logger();
  http.Client client = WebClient().client;

  String getUrl() {
    return "$apiBaseUrl$resourceJournals";
  }

  Future<bool> register(Journal journal, String token) async {
    try {
      final http.Response response = await client.post(
        Uri.parse(getUrl()),
        headers: getHeaders(token, complement: apiHeadersJsonType),
        body: journal.toJson(),
      );
      if (response.statusCode.compareTo(statusCodeCreated) != 0) {
        String content = json.decode(response.body) as String;
        switch (content) {
          case "jwt expired":
            throw JwtExpiredException();
          default:
            throw HttpException(response.body);
        }
      }
      return true;
    } on JwtExpiredException {
      rethrow;
    } catch (e) {
      logger.e("$e");
      switch ("$e") {
        case "Connection refused":
          throw ConnectionRefused();
        default:
          throw HttpException("$e");
      }
    }
  }

  Future<List<Journal>> getAll(
      {required String id, required String token}) async {
    try {
      final http.Response response = await client.get(
        Uri.parse("$apiBaseUrl$resourceAuthUsers$id/$resourceJournals"),
        headers: getHeaders(token),
      );
      if (response.statusCode.compareTo(statusCodeOk) != 0) {
        String content = json.decode(response.body) as String;
        switch (content) {
          case "jwt expired":
            throw JwtExpiredException();
          default:
            throw HttpException(response.body);
        }
      }
      List<Journal> journals = [];
      final List<dynamic> list = json.decode(response.body);
      for (var map in list) {
        journals.add(Journal.fromMap(map));
      }
      return journals;
    } on JwtExpiredException {
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

  Future<bool> edit(Journal journal, String token) async {
    try {
      journal.updatedAt = DateTime.now();
      final http.Response response = await client.put(
        Uri.parse("${getUrl()}${journal.id}"),
        headers: getHeaders(token, complement: apiHeadersJsonType),
        body: journal.toJson(),
      );
      if (response.statusCode.compareTo(statusCodeOk) != 0) {
        String content = json.decode(response.body) as String;
        switch (content) {
          case "jwt expired":
            throw JwtExpiredException();
          default:
            throw HttpException(response.body);
        }
      }
      return true;
    } on JwtExpiredException {
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

  Future<bool> delete(String id, String token) async {
    try {
      final http.Response response = await http.delete(
        Uri.parse("${getUrl()}$id"),
        headers: getHeaders(token),
      );
      if (response.statusCode.compareTo(statusCodeOk) != 0) {
        String content = json.decode(response.body) as String;
        switch (content) {
          case "jwt expired":
            throw JwtExpiredException();
          default:
            throw HttpException(response.body);
        }
      }
      return true;
    } on JwtExpiredException {
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

  Map<String, String> getHeaders(String token,
      {Map<String, String>? complement}) {
    Map<String, String> baseHeader = {'Authorization': "Bearer $token"};
    if (complement != null) {
      baseHeader.addAll(complement);
      return baseHeader;
    }
    return baseHeader;
  }
}

class ConnectionRefused implements Exception {}
