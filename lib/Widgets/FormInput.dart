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
      padding: const EdgeInsets.only(right: 4, top: 0, left: 0, bottom: 0),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: const Offset(0, 4),
                blurRadius: 5)
          ]),
      child: TextField(
        controller: widget.textController,
        autocorrect: !_passwordIsVisible,
        keyboardType: widget.keyboardType,
        obscureText: _passwordIsVisible,
        cursorHeight: 23,
        decoration: InputDecoration(
            prefixIcon: Icon(widget.icon),
            focusedBorder: InputBorder.none,
            border: InputBorder.none,
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
      ),
    );
  }
}
