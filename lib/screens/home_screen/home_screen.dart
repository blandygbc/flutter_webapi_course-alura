import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_webapi_first_course/constants/app_constants.dart';
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
                logout();
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
      //TODO: errors not working (when put await wors)
      if (token != null && email != null && id != null) {
        try {
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
          });
        } on JwtExpiredException catch (e) {
          log("$e");
          showConfirmationDialog(
            context,
            content: "Sessão expirada, logue novamente.",
            affirmativeOption: "Ok",
            haveCancel: false,
          ).then(
              (_) => Navigator.pushReplacementNamed(context, routeLoginScreen));
        } catch (e) {
          log("Não foi possível recuperar os diários");
          log("$e");
        }
      } else {
        Navigator.pushReplacementNamed(context, routeLoginScreen);
      }
    });
  }

  void logout() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.clear();
      Navigator.pushReplacementNamed(context, routeLoginScreen);
    });
  }
}
