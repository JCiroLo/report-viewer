import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  Button({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: raisedButtonStyle(context),
        onPressed: onPressed,
        child: SizedBox(
          width: double.infinity,
          height: 42,
          child: Center(
            child: Text(
              text,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ));
  }

  ButtonStyle raisedButtonStyle(BuildContext context) =>
      ElevatedButton.styleFrom(
        primary: Theme.of(context).primaryColor,
        onPrimary: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      );
}
