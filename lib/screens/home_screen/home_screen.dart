import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_webapi_first_course/constants/app_constants.dart';
import 'package:flutter_webapi_first_course/helpers/logout.dart';
import 'package:flutter_webapi_first_course/screens/commom/confirmation_dialog.dart';
import 'package:flutter_webapi_first_course/screens/home_screen/widgets/home_screen_list.dart';
import 'package:flutter_webapi_first_course/services/auth_service.dart';
import 'package:flutter_webapi_first_course/services/journal_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/journal.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // O último dia apresentado na lista
  DateTime currentDay = DateTime.now();

  // Tamanho da lista
  int windowPage = 10;

  // A base de dados mostrada na lista
  Map<String, Journal> database = {};
  final JournalService service = JournalService();

  final ScrollController _listScrollController = ScrollController();

  int? userId;

  String? userToken;

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Título basado no dia atual
        title: Text(
          "${currentDay.day}  |  ${currentDay.month}  |  ${currentDay.year}",
        ),
        actions: [
          IconButton(
              onPressed: () {
                refresh();
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              onTap: () {
                logout(context);
              },
              title: const Text('Sair'),
              leading: const Icon(Icons.logout),
            ),
          ],
        ),
      ),
      body: (userId != null && userToken != null)
          ? ListView(
              controller: _listScrollController,
              children: generateListJournalCards(
                windowPage: windowPage,
                currentDay: currentDay,
                database: database,
                refreshFunction: refresh,
                userId: userId!,
                token: userToken!,
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  refresh() {
    SharedPreferences.getInstance().then((prefs) async {
      String? token = prefs.getString(prefsAccessToken);
      String? email = prefs.getString(prefsUserEmail);
      int? id = prefs.getInt(prefsUserId);
      if (token != null && email != null && id != null) {
        setState(() {
          userId = id;
          userToken = token;
        });
        service
            .getAll(id: id.toString(), token: token)
            .then((List<Journal> journals) {
          setState(() {
            database = {};
            for (Journal jornal in journals) {
              database[jornal.id] = jornal;
            }
          });
        }).catchError(
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
            log("Não foi possível recuperar os diários");
            showConfirmationDialog(
              context,
              content:
                  "Não foi possível recuperar os diários.\n${error.message}",
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
      } else {
        Navigator.pushReplacementNamed(context, routeLoginScreen);
      }
    });
  }
}
