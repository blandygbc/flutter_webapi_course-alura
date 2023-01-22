import 'package:flutter/material.dart';
import 'package:flutter_webapi_first_course/config/routes/routes.dart';
import 'package:flutter_webapi_first_course/config/routes/theme/light_theme.dart';
import 'package:flutter_webapi_first_course/constants/app_constants.dart';
import 'package:flutter_webapi_first_course/models/journal.dart';
import 'package:flutter_webapi_first_course/screens/add_journal_screen/add_journal_screen.dart';

void main() {
  runApp(const MyApp());

  //JournalService journalService = JournalService();
  //journalService.register(Journal.empty());
  //journalService.get();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Journal',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.light,
      initialRoute: routeHomeScreen,
      routes: routes,
      onGenerateRoute: (settings) {
        if (settings.name == routeAddJournalScreen) {
          final Journal journal = settings.arguments as Journal;
          return MaterialPageRoute(
            builder: (context) {
              return AddJournalScreen(journal: journal);
            },
          );
        }
        return null;
      },
    );
  }
}
