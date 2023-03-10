import 'package:flutter/material.dart';
import 'package:flutter_webapi_first_course/config/routes/routes.dart';
import 'package:flutter_webapi_first_course/config/routes/theme/light_theme.dart';
import 'package:flutter_webapi_first_course/constants/app_constants.dart';
import 'package:flutter_webapi_first_course/models/journal.dart';
import 'package:flutter_webapi_first_course/screens/add_journal_screen/add_journal_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final bool isLogged = await verifyToken();
  runApp(MyApp(
    isLogged: isLogged,
  ));

  //JournalService journalService = JournalService();
  //journalService.register(Journal.empty());
  //journalService.get();
}

Future<bool> verifyToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString(prefsAccessToken);
  if (token != null) {
    return true;
  }
  return false;
}

class MyApp extends StatelessWidget {
  final bool isLogged;
  const MyApp({Key? key, required this.isLogged}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Journal',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.light,
      initialRoute: isLogged ? routeHomeScreen : routeLoginScreen,
      routes: routes,
      onGenerateRoute: (settings) {
        if (settings.name == routeAddJournalScreen) {
          Map<String, dynamic> map = settings.arguments as Map<String, dynamic>;
          final Journal journal = map[argumentJournal] as Journal;
          final bool isEditing = map[argumentIsEditing] as bool;
          return MaterialPageRoute(
            builder: (context) {
              return AddJournalScreen(
                journal: journal,
                isEditing: isEditing,
              );
            },
          );
        }
        return null;
      },
    );
  }
}
