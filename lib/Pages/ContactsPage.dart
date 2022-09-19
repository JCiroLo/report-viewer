import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../Widgets/Contact.dart';

class ContactsPage extends StatelessWidget {
  final List contacts;

  const ContactsPage({
    Key? key,
    required this.contacts,
  }) : super(key: key);

  Widget backButton(context) {
    return CupertinoButton(
        padding: const EdgeInsets.all(0),
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Icon(CupertinoIcons.back));
  }

  Widget userContacts() {
    return Column(
      children: <Widget>[
        for (var contact in contacts)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: Contact(
              name: contact['name'],
              lastname: contact['lastName'] ?? '',
              cellphone: contact['cellPhone'] ?? '',
              email: contact['email'] ?? '',
              color: CupertinoColors.activeBlue,
              onCall: () {},
              onMessage: () {},
            ),
          )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        backButton(context),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Contactos",
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.black),
              ),
              const SizedBox(
                height: 24,
              ),
              userContacts(),
              const SizedBox(height: 32),
            ],
          ),
        )
      ]),
    ));
  }
}
