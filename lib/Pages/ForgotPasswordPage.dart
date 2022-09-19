import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  Widget backButton(context) {
    return CupertinoButton(
        padding: const EdgeInsets.all(0),
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Icon(CupertinoIcons.back));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(8),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              backButton(context),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text("Hola")),
            ])));
  }
}
