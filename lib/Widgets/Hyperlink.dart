import 'package:flutter/material.dart';
class Hyperlink extends StatefulWidget {
  final String text;
  final FontWeight fontWeight;
  final VoidCallback onTap;

  const Hyperlink({
    Key? key,
    required this.text,
    required this.fontWeight,
    required this.onTap,
  }) : super(key: key);

  @override
  State<Hyperlink> createState() => _HyperlinkState();
}

class _HyperlinkState extends State<Hyperlink> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
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
