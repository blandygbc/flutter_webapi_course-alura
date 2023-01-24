import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_webapi_first_course/constants/api_constants.dart';
import 'package:flutter_webapi_first_course/models/journal.dart';
import 'package:flutter_webapi_first_course/services/auth_service.dart';
import 'package:flutter_webapi_first_course/services/http_interceptors.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_interceptor.dart';

class JournalService {
  http.Client client =
      InterceptedClient.build(interceptors: [LoggingInterceptor()]);

  String getUrl() {
    return "$apiBaseUrl$resourceJournals";
  }

  Future<int> register(Journal journal, String token) async {
    final http.Response response = await client.post(
      Uri.parse(getUrl()),
      headers: getHeaders(token, complement: apiHeaders),
      body: journal.toJson(),
    );
    return response.statusCode;
  }

  Future<List<Journal>> getAll(
      {required String id, required String token}) async {
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
  }

  Future<int> edit(Journal journal, String token) async {
    final http.Response response = await client.put(
      Uri.parse("${getUrl()}${journal.id}"),
      headers: getHeaders(token, complement: apiHeaders),
      body: journal.toJson(),
    );
    return response.statusCode;
  }

  Future<int> delete(String id, String token) async {
    final http.Response response = await http.delete(
      Uri.parse("${getUrl()}$id"),
      headers: getHeaders(token),
    );
    return response.statusCode;
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
