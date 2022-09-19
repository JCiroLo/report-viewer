import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:report_app/Store/userPreferences.dart';
import 'package:report_app/routes/routes.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final userPreferences = UserPreferences();
  await userPreferences.initPrefs();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Report viewer',
      initialRoute: '/login',
      routes: appRoutes,
      navigatorKey: navigatorKey,
    );
  }
}
