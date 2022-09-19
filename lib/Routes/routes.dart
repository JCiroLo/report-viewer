import 'package:flutter/material.dart';
import 'package:report_app/Pages/LoginPage.dart';
import 'package:report_app/Pages/HomePage.dart';
import 'package:report_app/Pages/UserScreen.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  '/home': (_) => const HomePage(),
  '/profile': (_) => const UserScreen(),
  '/login': (_) => const LoginPage(),
  'login': (_) => const LoginPage()
};
