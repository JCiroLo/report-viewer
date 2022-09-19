import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:report_app/Pages/ContactsPage.dart';
import 'package:report_app/Services/user.dart';
import 'package:report_app/Widgets/CupertinoListTile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final nameController = TextEditingController();
  final lastnameController = TextEditingController();
  final newPassword1Controller = TextEditingController();
  final newPassword2Controller = TextEditingController();
  final oldPasswordController = TextEditingController();

  final UserService userService = UserService();
  late Future<Map> userInfo;

  @override
  void initState() {
    userInfo = userService.getUserInfo();
    super.initState();
  }

  void handleUpdateProfile() async {
    final response = await userService.updatedUserInfo(
        nameController.text, lastnameController.text);
    print(response);
  }

  Future handleLogout(BuildContext context) async {
    if (!mounted) return;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove('userToken');
    await preferences.remove('username');
    await preferences.remove('userTokenExpiration');
    if (!mounted) return;
  }

  void updateProfileDialog(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Editar perfil'),
        content: Container(
          margin: const EdgeInsets.only(top: 16),
          child: Column(
            children: [
              CupertinoTextField(
                autocorrect: true,
                controller: nameController,
                placeholder: 'Nuevo nombre',
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        width: 1, color: CupertinoColors.lightBackgroundGray)),
              ),
              const SizedBox(height: 8),
              CupertinoTextField(
                autocorrect: true,
                controller: lastnameController,
                placeholder: 'Nuevo apellido',
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        width: 1, color: CupertinoColors.lightBackgroundGray)),
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
              handleUpdateProfile();
              Navigator.pop(context);
            },
            child: const Text(
              'Actualizar',
              style: TextStyle(
                  color: CupertinoColors.link, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  void updatePasswordDialog(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Editar perfil'),
        content: Container(
          margin: const EdgeInsets.only(top: 16),
          child: Column(
            children: [
              CupertinoTextField(
                autocorrect: true,
                controller: newPassword1Controller,
                placeholder: 'Nueva contraseña',
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8)),
                    border: Border.all(
                        width: 1, color: CupertinoColors.lightBackgroundGray)),
              ),
              CupertinoTextField(
                autocorrect: true,
                controller: newPassword2Controller,
                placeholder: 'Ingrese de nuevo la contraseña',
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8)),
                    border: Border.all(
                        width: 1, color: CupertinoColors.lightBackgroundGray)),
              ),
              const SizedBox(height: 8),
              CupertinoTextField(
                autocorrect: true,
                controller: oldPasswordController,
                placeholder: 'Contraseña antigua',
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        width: 1, color: CupertinoColors.lightBackgroundGray)),
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
              handleUpdateProfile();
              Navigator.pop(context);
            },
            child: const Text(
              'Actualizar',
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
      body: FutureBuilder(
          future: userInfo,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final userInfoData =
                  json.decode(jsonEncode(snapshot.data))['data'];
              return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 32, horizontal: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                          flex: 0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  "Perfil",
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
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Row(
                                    children: [
                                      Flexible(
                                        child: ClipOval(
                                          child: Image.network(
                                            'https://loremflickr.com/640/360',
                                            fit: BoxFit.cover,
                                            height: 48,
                                            width: 48,
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                          flex: 0,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  userInfoData['username'],
                                                  style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Text(
                                                  userInfoData['email'],
                                                  style: const TextStyle(
                                                      color: CupertinoColors
                                                          .secondaryLabel),
                                                )
                                              ],
                                            ),
                                          ))
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              CupertinoListTile(
                                text: "Nombre",
                                onPressed: () {
                                  updateProfileDialog(context);
                                },
                                child: Text(
                                  userInfoData['name'] == ''
                                      ? 'Sin nombre'
                                      : userInfoData['name'],
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: CupertinoColors.secondaryLabel),
                                ),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              CupertinoListTile(
                                text: "Apellido",
                                onPressed: () {
                                  updateProfileDialog(context);
                                },
                                child: Text(
                                  userInfoData['lastName'] == ''
                                      ? 'Sin apellido'
                                      : userInfoData['lastName'],
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: CupertinoColors.secondaryLabel),
                                ),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              CupertinoListTile(
                                text: "Fecha de verificación",
                                onPressed: () {},
                                child: Text(
                                  userInfoData['fechaVerificacion'],
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: CupertinoColors.secondaryLabel),
                                ),
                              ),
                              const SizedBox(
                                height: 32,
                              ),
                              CupertinoListTile(
                                text: "Contactos",
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ContactsPage(
                                          contacts: userInfoData['contacts']),
                                    ),
                                  );
                                },
                                icon: CupertinoIcons.person,
                                iconColor: CupertinoColors.activeOrange,
                                child: const Icon(
                                  CupertinoIcons.chevron_right,
                                  color: CupertinoColors.secondaryLabel,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              CupertinoListTile(
                                text: "Actualizar contraseña",
                                onPressed: () {
                                  updatePasswordDialog(context);
                                },
                                icon: CupertinoIcons.lock,
                                iconColor: CupertinoColors.activeGreen,
                                child: const Icon(
                                  CupertinoIcons.chevron_right,
                                  color: CupertinoColors.secondaryLabel,
                                  size: 18,
                                ),
                              ),
                            ],
                          )),
                      Flexible(
                          child: CupertinoButton.filled(
                              onPressed: () async {
                                await handleLogout(context);
                                if (!mounted) return;
                                Navigator.pushReplacementNamed(
                                    context, '/login');
                              },
                              child: const Text('Cerrar sesión')))
                    ],
                  ));
            }
            return const CircularProgressIndicator();
          }),
    );
  }
}
