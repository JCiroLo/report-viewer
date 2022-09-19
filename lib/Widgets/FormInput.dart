import 'package:flutter/material.dart';

class FormInput extends StatefulWidget {
  final IconData icon;
  final String placehoder;
  final TextEditingController textController;
  final TextInputType keyboardType;
  final bool isPassword;

  const FormInput(
      {Key? key,
      required this.icon,
      required this.placehoder,
      required this.textController,
      required this.keyboardType,
      this.isPassword = false})
      : super(key: key);

  @override
  State<FormInput> createState() => _FormInputState();
}

class _FormInputState extends State<FormInput> {
  bool _passwordIsVisible = false;

  @override
  void initState() {
    if (widget.isPassword) {
      _passwordIsVisible = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: TextField(
          controller: widget.textController,
          autocorrect: !_passwordIsVisible,
          keyboardType: widget.keyboardType,
          obscureText: _passwordIsVisible,
          cursorHeight: 23,
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(0),
              prefixIcon: Icon(widget.icon),
              border:
                  const OutlineInputBorder(borderSide: BorderSide(width: 1.0)),
              hintText: widget.placehoder,
              suffixIcon: widget.isPassword
                  ? IconButton(
                      icon: Icon(!_passwordIsVisible
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _passwordIsVisible = !_passwordIsVisible;
                        });
                      },
                    )
                  : null),
        ));
  }
}
