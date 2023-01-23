import 'package:flutter/material.dart';
import 'package:flutter_webapi_first_course/constants/app_constants.dart';
import 'package:flutter_webapi_first_course/screens/home_screen/home_screen.dart';
import 'package:flutter_webapi_first_course/screens/login_screen/login_screen.dart';

final Map<String, WidgetBuilder> routes = {
  routeHomeScreen: (context) => const HomeScreen(),
  routeLoginScreen: (context) => LoginScreen(),
};
