// ignore_for_file: unused_import, prefer_const_literals_to_create_immutables, prefer_const_constructors, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:qr_flutter/qr_flutter.dart';

// todo: create a QR generator
class QrGen extends StatefulWidget {
  const QrGen({super.key});

  @override
  State<QrGen> createState() => _QrGenState();
}

class _QrGenState extends State<QrGen> {
  Color background = Colors.white;
  Color foreground = Colors.red;
  bool circleBits = false;
  bool circleEye = false;

  String myQr = '';
  bool isGapless = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create QR"),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              decoration: InputDecoration(
                  hintText:
                      "Type a URL, a phone number, or anything you want!"),
              onChanged: (value) {
                setState(() {
                  myQr = value;
                });
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FilledButton(
                  onPressed: () {
                    showDialog(
                      useSafeArea: true,
                      context: context,
                      builder: (context) {
                        return SizedBox(
                          child: Column(
                            children: [
                              AlertDialog(
                                title: Text("Choose background color"),
                                icon: Icon(Icons.edit),
                                content: Column(
                                  children: [
                                    ColorPicker(
                                      pickerColor: background,
                                      enableAlpha: false,
                                      paletteType: PaletteType.hueWheel,
                                      displayThumbColor: true,
                                      onColorChanged: (value) {
                                        setState(() {
                                          background = value;
                                        });
                                      },
                                    ),
                                    SizedBox(
                                      height: 50,
                                    ),
                                    TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text("Done"))
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Text("Background color")),
              FilledButton(
                  onPressed: () {
                    showDialog(
                      useSafeArea: true,
                      context: context,
                      builder: (context) {
                        return SizedBox(
                          child: Column(
                            children: [
                              AlertDialog(
                                title: Text("Choose foreground color"),
                                icon: Icon(Icons.edit),
                                content: Column(
                                  children: [
                                    ColorPicker(
                                      pickerColor: foreground,
                                      enableAlpha: false,
                                      paletteType: PaletteType.hueWheel,
                                      displayThumbColor: true,
                                      onColorChanged: (value) {
                                        setState(() {
                                          foreground = value;
                                        });
                                      },
                                    ),
                                    SizedBox(
                                      height: 50,
                                    ),
                                    TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text("Done"))
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Text("Foreground color")),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  Text("Circles:"),
                  Switch(
                    value: circleBits,
                    onChanged: (value) {
                      setState(() {
                        circleBits = value;
                      });
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  Text("Circle eyes:"),
                  Switch(
                    value: circleEye,
                    onChanged: (value) {
                      setState(() {
                        circleEye = value;
                      });
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  Text("Gaps:"),
                  Switch(
                    value: isGapless,
                    onChanged: (value) {
                      setState(() {
                        isGapless = value;
                      });
                    },
                  ),
                ],
              )
            ],
          ),
          Center(
            child: QrImageView(
              errorStateBuilder: (context, error) {
                return Text(
                  "AH! an error has occured\nError: $error",
                  textAlign: TextAlign.center,
                );
              },
              data: myQr,
              version: QrVersions.auto,
              size: 400,
              backgroundColor: background,
              foregroundColor: foreground,
              dataModuleStyle: QrDataModuleStyle(
                dataModuleShape: circleBits
                    ? QrDataModuleShape.circle
                    : QrDataModuleShape.square,
              ),
              padding: EdgeInsets.all(15),
              gapless: !isGapless,
              eyeStyle: QrEyeStyle(
                  eyeShape: circleEye ? QrEyeShape.circle : QrEyeShape.square),
            ),
          ),
        ],
      ),
    );
  }
}
