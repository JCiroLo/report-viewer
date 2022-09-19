import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Contact extends StatelessWidget {
  final String name;
  final String lastname;
  final String cellphone;
  final String email;
  final Color color;
  final VoidCallback? onCall;
  final VoidCallback? onMessage;

  const Contact({
    Key? key,
    required this.name,
    required this.lastname,
    required this.cellphone,
    required this.email,
    required this.color,
    this.onCall,
    this.onMessage,
  }) : super(key: key);

  String getContactAcronym({required String name, required String lastname}) =>
      '${name == '' ? '' : name[0].toUpperCase()}${lastname == '' ? '' : lastname[0].toUpperCase()}';

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      pressedOpacity: 0.65,
      color: CupertinoColors.white,
      borderRadius: const BorderRadius.all(
        Radius.circular(8),
      ),
      padding: const EdgeInsets.all(8),
      onPressed: () {},
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: CircleAvatar(
              backgroundColor: color,
              child: Text(getContactAcronym(name: name, lastname: lastname),
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600)),
            ),
          ),
          Flexible(
              fit: FlexFit.tight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$name $lastname',
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: CupertinoColors.label),
                  ),
                  Text(cellphone,
                      style: const TextStyle(
                          fontSize: 12, color: CupertinoColors.secondaryLabel))
                ],
              )),
          Row(
            children: [
              onCall != null
                  ? CupertinoButton(
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                      child: const Icon(Icons.call))
                  : const SizedBox(),
              onMessage != null
                  ? CupertinoButton(
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                      child: const Icon(Icons.whatsapp))
                  : const SizedBox()
            ],
          )
        ],
      ),
    );
  }
}
