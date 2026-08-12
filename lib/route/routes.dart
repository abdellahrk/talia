import 'package:flutter/widgets.dart';
import 'package:tasks/screen/intro_screen.dart';
import 'package:tasks/screen/splash_screen.dart';
import 'package:tasks/screen/task/task_list.dart';
import 'package:tasks/screen/welcome_screen.dart';
import 'package:tasks/screen/widget/bottom_nav.dart';

Map<String, WidgetBuilder> routeLists(BuildContext context) {
  return {
    // "/": (context) => HomeScreen(),
    "/splash": (context) => SplashScreen(),
    "/intro": (context) => IntroScreen(),
    "/welcome": (context) => WelcomeScreen(),
    "/tasks": (context) => TaskList(),
    "/bottombar": (context) => BottomNav(),
  };
}
