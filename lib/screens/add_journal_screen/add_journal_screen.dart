import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_webapi_first_course/constants/app_constants.dart';
import 'package:flutter_webapi_first_course/helpers/logout.dart';
import 'package:flutter_webapi_first_course/helpers/weekday.dart';
import 'package:flutter_webapi_first_course/models/journal.dart';
import 'package:flutter_webapi_first_course/screens/commom/confirmation_dialog.dart';
import 'package:flutter_webapi_first_course/services/auth_service.dart';
import 'package:flutter_webapi_first_course/services/journal_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddJournalScreen extends StatelessWidget {
  final Journal journal;
  final bool isEditing;
  final TextEditingController _contentController = TextEditingController();
  AddJournalScreen({super.key, required this.journal, required this.isEditing});

  @override
  Widget build(BuildContext context) {
    _contentController.text = journal.content;
    return Scaffold(
      appBar: AppBar(
        title: Text(WeekDay(journal.createdAt).toString()),
        actions: [
          IconButton(
            onPressed: () {
              registerJournal(context);
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: _contentController,
          keyboardType: TextInputType.multiline,
          style: const TextStyle(fontSize: 24),
          expands: true,
          maxLines: null,
          minLines: null,
        ),
      ),
    );
  }

  void registerJournal(BuildContext context) async {
    SharedPreferences.getInstance().then((prefs) {
      String? token = prefs.getString(prefsAccessToken);
      if (token != null) {
        final String content = _contentController.text;
        journal.content = content;
        JournalService journalService = JournalService();
        if (isEditing) {
          journalService
              .edit(journal, token)
              .then((value) => Navigator.pop(context, value))
              .catchError(
            (error) {
              showConfirmationDialog(
                context,
                content: "Sessão expirada, logue novamente.",
                affirmativeOption: "Ok",
                haveCancel: false,
              ).then((_) {
                logout(context);
              });
            },
            test: (error) => error is JwtExpiredException,
          ).catchError(
            (error) {
              log("Erro no edição");
              showConfirmationDialog(
                context,
                content: error.message,
                affirmativeOption: "Ok",
                haveCancel: false,
              );
            },
            test: (error) => error is HttpException,
          ).catchError(
            (error) {
              showConfirmationDialog(
                context,
                title: "Um problema ocorreu",
                content:
                    "Não foi possível se conectar com o servidor.\n\nTente novamente mais tarde.",
                affirmativeOption: "Ok",
                haveCancel: false,
              );
            },
            test: (error) => error is ConnectionRefused,
          );
        } else {
          journalService
              .register(journal, token)
              .then((value) => Navigator.pop(context, value))
              .catchError(
            (error) {
              showConfirmationDialog(
                context,
                content: "Sessão expirada, logue novamente.",
                affirmativeOption: "Ok",
                haveCancel: false,
              ).then((_) {
                logout(context);
              });
            },
            test: (error) => error is JwtExpiredException,
          ).catchError(
            (error) {
              log("Erro no registro");
              showConfirmationDialog(
                context,
                content: error.message,
                affirmativeOption: "Ok",
                haveCancel: false,
              );
            },
            test: (error) => error is HttpException,
          ).catchError(
            (error) {
              showConfirmationDialog(
                context,
                title: "Um problema ocorreu",
                content:
                    "Não foi possível se conectar com o servidor.\n\nTente novamente mais tarde.",
                affirmativeOption: "Ok",
                haveCancel: false,
              );
            },
            test: (error) => error is TimeoutException,
          ).catchError(
            (error) {
              showConfirmationDialog(
                context,
                title: "Um problema ocorreu",
                content:
                    "Não foi possível se conectar com o servidor.\n\nTente novamente mais tarde.",
                affirmativeOption: "Ok",
                haveCancel: false,
              );
            },
            test: (error) => error is ConnectionRefused,
          );
        }
      }
    });
  }
}
