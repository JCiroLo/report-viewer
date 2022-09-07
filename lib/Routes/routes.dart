import 'package:flutter/material.dart';
import 'package:report_app/Pages/LoginPage.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  'Login': (_) => const LoginPage(),
};
