import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Widgets/CupertinoListTile.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  bool notifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              "Ajustes",
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.black),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          CupertinoListTile(
            text: "Notificaciones",
            onPressed: () {
              setState(() {
                notifications = !notifications;
              });
            },
            icon:
                notifications ? CupertinoIcons.bell : CupertinoIcons.bell_slash,
            iconColor: CupertinoColors.activeBlue,
            child: CupertinoSwitch(
              value: notifications,
              thumbColor: CupertinoColors.white,
              trackColor: CupertinoColors.extraLightBackgroundGray,
              onChanged: (bool? value) {
                setState(() {
                  notifications = value!;
                });
              },
            ),
          ),
          const SizedBox(
            height: 16,
          ),
        ],
      ),
    ));
  }
}
