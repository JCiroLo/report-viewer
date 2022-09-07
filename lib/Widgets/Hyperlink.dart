import 'package:flutter/material.dart';

class Hyperlink extends StatefulWidget {
  final String route;
  final String text;
  final FontWeight fontWeight;

  const Hyperlink({
    Key? key,
    required this.route,
    required this.text,
    required this.fontWeight,
  }) : super(key: key);

  @override
  State<Hyperlink> createState() => _HyperlinkState();
}

class _HyperlinkState extends State<Hyperlink> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, widget.route);
      },
      child: Text(
        widget.text,
        style: TextStyle(
            color: Theme.of(context).primaryColorDark,
            fontSize: 18,
            fontWeight: widget.fontWeight),
      ),
    );
  }
}
