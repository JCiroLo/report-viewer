import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:report_app/Widgets/FormInput.dart';

import '../Services/auth.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final verificationCodeController = TextEditingController();
  bool tosController = false;

  void handleRegister(BuildContext context) async {
    if (!mounted) return;

    if (passwordController.text.toString() !=
        confirmPasswordController.text.toString()) return;

    await AuthService().registrySendCode(
      usernameController.text.toString(),
      emailController.text.toString(),
      passwordController.text.toString(),
    );
  }

  void handleSendVerificationCode() async {
    if (!mounted) return;

    await AuthService().registryConfirmationCode(
        usernameController.text.toString(),
        verificationCodeController.text.toString());
  }

  Widget backButton(context) {
    return CupertinoButton(
        padding: const EdgeInsets.all(0),
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Icon(CupertinoIcons.back));
  }

  void verificationCodeDialog(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Código de verificación'),
        content: Container(
          margin: const EdgeInsets.only(top: 16),
          child: Column(
            children: [
              CupertinoTextField(
                autocorrect: true,
                controller: verificationCodeController,
                keyboardType: TextInputType.number,
                placeholder: 'Código de verificación',
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      width: 1, color: CupertinoColors.lightBackgroundGray),
                ),
              ),
            ],
          ),
        ),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Cancelar',
              style: TextStyle(
                  color: CupertinoColors.link, fontWeight: FontWeight.w400),
            ),
          ),
          CupertinoDialogAction(
            onPressed: () {
              handleSendVerificationCode();
              Navigator.pop(context);
            },
            child: const Text(
              'Enviar',
              style: TextStyle(
                  color: CupertinoColors.link, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ProgressHUD(
      backgroundRadius: const Radius.circular(100),
      barrierColor: Colors.black26,
      borderColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              backButton(context),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Registrarse",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 28,
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    FormInput(
                      icon: CupertinoIcons.person,
                      placehoder: "Usuario",
                      textController: usernameController,
                      keyboardType: TextInputType.text,
                    ),
                    FormInput(
                      icon: CupertinoIcons.at,
                      placehoder: "Correo",
                      textController: emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    FormInput(
                      icon: CupertinoIcons.lock,
                      placehoder: "Contraseña",
                      textController: passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      isPassword: true,
                    ),
                    FormInput(
                      icon: CupertinoIcons.lock,
                      placehoder: "Confirmar contraseña",
                      textController: confirmPasswordController,
                      keyboardType: TextInputType.visiblePassword,
                      isPassword: true,
                    ),
                    CheckboxListTile(
                      title: const Text("Acepto los términos y condiciones"),
                      controlAffinity: ListTileControlAffinity.leading,
                      value: tosController,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      onChanged: (value) {
                        tosController = !tosController;
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: CupertinoButton.filled(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            /* final progress = ProgressHUD.of(context);
                            progress!.show();

                            Future.delayed(const Duration(seconds: 2), () {
                              progress.dismiss();
                            }); */
                            handleRegister(context);
                            verificationCodeDialog(context);
                          },
                          child: const Text('Registrarme')),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 88,
              )
            ]),
      ),
    ));
  }
}
