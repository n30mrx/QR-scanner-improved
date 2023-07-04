// import 'package:firebase_auth/firebase_auth.dart';

// ignore_for_file: unused_import, file_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:io';

import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../utils/Qr_reciver.dart';

class HomeAppPage extends StatefulWidget {
  const HomeAppPage({super.key});

  @override
  State<HomeAppPage> createState() => _HomeAppPageState();
}

class _HomeAppPageState extends State<HomeAppPage> {
  bool isFront = true;
  bool isFlash = false;
  void initstate() {
    super.initState();
  }

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    // ?final FirebaseAuth _auth = FirebaseAuth.instance;
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            onPressed: !isFront
                ? null
                : () async {
                    await controller?.toggleFlash();
                    setState(() {
                      isFlash = !isFlash;
                    });
                  },
            icon: Icon(
                isFlash ? Icons.flash_on_outlined : Icons.flash_off_outlined),
          ),
          IconButton(
              onPressed: () async {
                await controller?.flipCamera();
                setState(() {
                  isFront = !isFront;
                });
              },
              icon: Icon(Icons.flip_camera_ios_outlined)),
          IconButton(
              onPressed: () {
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
                                "https://github.com/sk-geek/QR-scanner-improved",
                                mode: LaunchMode.externalApplication),
                            child: Text(
                              "GitHub link",
                              style: TextStyle(
                                  decoration: TextDecoration.underline),
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
                              style: TextStyle(
                                  decoration: TextDecoration.underline),
                            )),
                      ],
                    )
                  ],
                );
              },
              icon: Icon(Icons.info_outline))
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: Stack(
                children: [
                  QRView(
                    key: qrKey,
                    onQRViewCreated: _onQRViewCreated,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 100),
                    child: Center(child: Image.asset("assets/frame.png")),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/gen');
        },
        label: Text("Create"),
        icon: Icon(Icons.add_outlined),
      ),
    );
  }

  void flipQrCam() async {
    await controller?.flipCamera();
    setState(() {
      isFront = !isFront;
    });
    return null;
  }

  void _onQRViewCreated(QRViewController? controller) {
    this.controller = controller;
    controller?.scannedDataStream.listen((scanData) {
      setState(() async {
        result = scanData;
        await controller
            .pauseCamera()
            .then((value) => onQrGotCaptured(result, context, controller));
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
