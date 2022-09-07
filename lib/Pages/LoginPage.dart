import 'package:flutter/material.dart';
import 'package:report_app/Store/userPreferences.dart';
import 'package:report_app/Widgets/FormInput.dart';
import 'package:report_app/Widgets/Button.dart';
import 'package:report_app/Widgets/Hyperlink.dart';
import 'package:report_app/Services/auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final Widget createAnAccount = Column(
    children: const [
      Text('¿No tienes una cuenta?', style: TextStyle(fontSize: 18)),
      Hyperlink(
          route: 'register',
          text: '¡Crea una ahora!',
          fontWeight: FontWeight.normal)
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [const _Form(), createAnAccount],
      ),
    );
  }
}

class _Form extends StatefulWidget {
  const _Form({Key? key}) : super(key: key);

  @override
  State<_Form> createState() => __FormState();
}

class __FormState extends State<_Form> {
  final userController = TextEditingController();
  final passwordController = TextEditingController();
  final userPreferences = UserPreferences();

  final Widget loginTitle = const Text(
    'Iniciar sesión',
    style: TextStyle(fontSize: 28),
  );

  final Widget forgotPassword = const Hyperlink(
    text: '¿Olviaste tu contraseña?',
    fontWeight: FontWeight.normal,
    route: 'forgotPassword',
  );

  void handleLogin() async {
    if (!mounted) return;
    final userInfo =
        await AuthService().login(userController.text, passwordController.text);
    if (userInfo['status']) {
      userPreferences.userToken = userInfo['data']['access_token'];
      print(userPreferences.userToken);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userPreferences = UserPreferences();
    print("Preferencias: ${userPreferences.userToken}");

    return Container(
        margin: const EdgeInsets.only(top: 24),
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          children: [
            loginTitle,
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
            Button(text: 'Iniciar sesión', onPressed: handleLogin),
            const SizedBox(
              height: 24,
            ),
            forgotPassword
          ],
        ));
  }
}
