import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:report_app/Pages/ForgotPasswordPage.dart';
import 'package:report_app/Pages/RegisterPage.dart';
import 'package:report_app/Store/userPreferences.dart';
import 'package:report_app/Widgets/FormInput.dart';
import 'package:report_app/Widgets/Hyperlink.dart';
import 'package:report_app/Services/auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Widget createAnAccount() => Column(
        children: [
          const Text('¿No tienes una cuenta?', style: TextStyle(fontSize: 18)),
          Hyperlink(
            text: '¡Crea una ahora!',
            fontWeight: FontWeight.normal,
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RegisterPage(),
                ),
              )
            },
          )
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProgressHUD(
        backgroundRadius: const Radius.circular(100),
        barrierColor: Colors.black26,
        borderColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [const _Form(), createAnAccount()],
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  const _Form({
    Key? key,
  }) : super(key: key);

  @override
  State<_Form> createState() => _FormState();
}

class _FormState extends State<_Form> {
  final userController = TextEditingController();
  final passwordController = TextEditingController();
  late UserPreferences userPreferences;

  @override
  void initState() {
    super.initState();

    userPreferences = UserPreferences();

    if (DateTime.now().millisecondsSinceEpoch <
        userPreferences.userTokenExpiration) {
      if (userPreferences.userToken != '') {
        print(userPreferences.userToken);

        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pushReplacementNamed(context, '/home');
        });
      }
    }
  }

  void handleLogin() async {
    if (!mounted) return;
    final progress = ProgressHUD.of(context);
    progress!.show();

    Future.delayed(const Duration(seconds: 2), () {
      progress.dismiss();
    });

    final dynamic userInfo = await AuthService().login(
        userController.text.toString(), passwordController.text.toString());

    if (userInfo['status']) {
      userPreferences.userToken = userInfo['data']['access_token'];
      userPreferences.username = userController.text;

      final expirationTime = DateTime.now().millisecondsSinceEpoch +
          (userInfo['data']['expires_in'] * 1000);

      userPreferences.userTokenExpiration = expirationTime as int;

      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacementNamed(context, '/home');
      });
    } else {
      print(userInfo);
    }
  }

  Widget loginTitle() => const Text(
        'Iniciar sesión',
        style: TextStyle(fontSize: 28),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 24),
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          children: [
            loginTitle(),
            const SizedBox(
              height: 24,
            ),
            FormInput(
              icon: Icons.person,
              placehoder: 'Usuario',
              keyboardType: TextInputType.text,
              textController: userController,
            ),
            FormInput(
              icon: Icons.lock,
              placehoder: 'Contraseña',
              keyboardType: TextInputType.text,
              textController: passwordController,
              isPassword: true,
            ),
            const SizedBox(
              height: 24,
            ),
            SizedBox(
              width: double.infinity,
              child: CupertinoButton.filled(
                  padding: EdgeInsets.zero,
                  onPressed: handleLogin,
                  child: const Text('Iniciar sesión')),
            ),
            const SizedBox(
              height: 24,
            ),
            Hyperlink(
              text: '¿Olviaste tu contraseña?',
              fontWeight: FontWeight.normal,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ForgotPasswordPage(),
                  ),
                );
              },
            )
          ],
        ));
  }
}
