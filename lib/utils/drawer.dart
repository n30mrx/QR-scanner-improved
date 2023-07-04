// ignore_for_file: must_be_immutable, prefer_const_constructors_in_immutables, prefer_if_null_operators, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';

class QeDrawer extends StatefulWidget {
  QeDrawer({super.key});

  @override
  State<QeDrawer> createState() => _QeDrawerState();
}

class _QeDrawerState extends State<QeDrawer> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int _selectedDestination = 0;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        // padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Text(
                      "Welcome to my QR scanner",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Text("I hope you find it good and easy to use :)"),
                  ],
                ),
                Expanded(child: Container()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Text("Made by chekhov\nTelegram: @gop_g"),
                  ],
                )
              ],
            ),
          ),
          ListTile(
            title: Text("Home"),
            selected: _selectedDestination == 0,
            leading: Icon(Icons.home_outlined),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100)),
            selectedTileColor: Theme.of(context).colorScheme.secondaryContainer,
            onTap: () => selectTab(0),
          ),
          ListTile(
            title: Text("Create"),
            selected: _selectedDestination == 1,
            selectedTileColor: Theme.of(context).colorScheme.secondaryContainer,
            leading: Icon(Icons.create_outlined),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100)),
            onTap: () => selectTab(1),
          ),
          QrImageView(
      data: '1234567890',
      version: QrVersions.auto,
      size: 200.0,
    ),
          Expanded(
            flex: 1,
            child: Container(),
          ),
          ListTile(
            title: Text("About app"),
            selected: _selectedDestination == 5,
            selectedTileColor: Theme.of(context).colorScheme.secondaryContainer,
            leading: Icon(Icons.info_outline),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100)),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationIcon: Icon(Icons.qr_code),
                applicationName: "Qr scanner",
                applicationVersion: "1.0",
                children: [
                  Text(
                      "This app was made by Chekhov using flutter\nIt is licensed under MIT license"),
                  Row(
                    children: [
                      Text("Source code:"),
                      TextButton(
                          onPressed: () => launchUrlString(
                              "https://github.com/sk-geek/QR-code-scanner-with-flutter",
                              mode: LaunchMode.externalApplication),
                          child: Text(
                            "GitHub link",
                            style:
                                TextStyle(decoration: TextDecoration.underline),
                          )),
                    ],
                  ),
                  Row(
                    children: [
                      Text("Telegram:"),
                      TextButton(
                          onPressed: () => launchUrlString(
                              "https://t.me/n30arch",
                              mode: LaunchMode.externalApplication),
                          child: Text(
                            "Telegram link",
                            style:
                                TextStyle(decoration: TextDecoration.underline),
                          )),
                    ],
                  )
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  void selectTab(int index) {
    setState(() {
      _selectedDestination = index;
    });
  }

  void signOutAction() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    await _auth
        .signOut()
        .then((value) => Navigator.popAndPushNamed(context, "/login"));
  }
}
