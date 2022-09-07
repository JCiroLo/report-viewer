import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:report_app/Store/userPreferences.dart';
import 'package:report_app/routes/routes.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// APP THEME

final appTheme = ThemeData(
    textTheme: const TextTheme(
      bodyText1: TextStyle(),
      bodyText2: TextStyle(),
    ).apply(
        bodyColor: const Color(0xff5f6368),
        displayColor: const Color(0xff5f6368)),
    colorScheme: ThemeData().colorScheme.copyWith(
          primary: const Color(0xff00918f),
          secondary: const Color(0xffCE6A6B),
        ),
    primaryColor: const Color(0xff00918f),
    primaryColorDark: const Color(0xff006d65),
    inputDecorationTheme: const InputDecorationTheme(
      hintStyle: TextStyle(color: Color(0xff5f6368)),
      labelStyle: TextStyle(color: Color(0xff00918f)),
    ),
    textSelectionTheme:
        const TextSelectionThemeData(cursorColor: Color(0xff00918f)));

// APP

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
      initialRoute: 'Login',
      routes: appRoutes,
      theme: appTheme,
      navigatorKey: navigatorKey,
    );
  }
}
