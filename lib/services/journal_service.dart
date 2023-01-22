import 'dart:convert';

import 'package:flutter_webapi_first_course/constants/api_constants.dart';
import 'package:flutter_webapi_first_course/models/journal.dart';
import 'package:flutter_webapi_first_course/services/http_interceptors.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_interceptor.dart';

class JournalService {
  http.Client client =
      InterceptedClient.build(interceptors: [LoggingInterceptor()]);

  String getUrl() {
    return "$apiBaseUrl$apiResource";
  }

  Future<int> register(Journal journal) async {
    final String jsonJournal = journal.toJson();
    final http.Response response = await client.post(
      Uri.parse(getUrl()),
      headers: apiHeaders,
      body: jsonJournal,
    );
    return response.statusCode;
  }

  Future<List<Journal>> getAll() async {
    final http.Response response = await client.get(Uri.parse(getUrl()));
    if (response.statusCode.compareTo(statusCodeOk) != 0) {
      throw Exception();
    }
    List<Journal> journals = [];
    final List<dynamic> maps = json.decode(response.body);
    for (var map in maps) {
      journals.add(Journal.fromMap(map));
    }
    return journals;
  }
}
