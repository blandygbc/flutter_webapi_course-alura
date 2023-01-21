import 'package:flutter/material.dart';
import 'package:flutter_webapi_first_course/constants/app_constants.dart';
// import 'package:flutter_webapi_first_course/models/journal.dart';
// import 'package:flutter_webapi_first_course/screens/add_journal_screen/add_journal_screen.dart';
import 'package:flutter_webapi_first_course/screens/home_screen/home_screen.dart';

final Map<String, WidgetBuilder> routes = {
  routeHomeScreen: (context) => const HomeScreen(),
  // routeAddJournalScreen: (context) => AddJournalScreen(
  //       journal: Journal(
  //         id: "id",
  //         content: "content",
  //         createdAt: DateTime.now(),
  //         updatedAt: DateTime.now(),
  //       ),
  //     )
};
