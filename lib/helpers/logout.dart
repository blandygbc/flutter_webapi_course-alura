import 'package:flutter/cupertino.dart';
import 'package:flutter_webapi_first_course/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

void logout(BuildContext context) {
  SharedPreferences.getInstance().then((prefs) {
    prefs.clear();
    Navigator.pushReplacementNamed(context, routeLoginScreen);
  });
}
