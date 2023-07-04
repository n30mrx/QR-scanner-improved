// ignore_for_file: file_names, prefer_const_constructors, use_build_context_synchronously, unused_element

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

void onQrGotCaptured(
    Barcode? scanData, BuildContext context, QRViewController? controller) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("code scanned!"),
        content: SelectableText(
          "The contents of the ${describeEnum(scanData!.format)} were: \n${scanData.code}",
        ),
        actions: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                    onPressed: () {
                      bool isURL(String? input) {
                        RegExp urlRegExp = RegExp(
                          r'^(https?|ftp)?://[^\s/$.?#].[^\s]*$',
                          caseSensitive: false,
                          multiLine: false,
                        );
                        return urlRegExp.hasMatch(input!);
                      }

                      bool isPhone(String? input) {
                        RegExp phoneRegex = RegExp(
                            r'^\+?[0-9]{1,3}[-.\s]?\(?\d{1,}\)?[-.\s]?\d{1,}[-.\s]?\d{1,}[-.\s]?\d{1,}[-.\s]?\d{1,}$');
                        return phoneRegex.hasMatch(input!);
                      }

                      Uri url = Uri.parse(scanData.code!);
                      if (isURL(scanData.code)) {
                        launchUrl(url, mode: LaunchMode.externalApplication);
                      } else if (isPhone(scanData.code)) {
                        launchUrlString("tel:${scanData.code}",
                            mode: LaunchMode.externalApplication);
                      }
                    },
                    child: Text("Open")),
              ),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                    onPressed: () async {
                      await Clipboard.setData(
                          ClipboardData(text: scanData.code!));
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Text copied!"),
                      ));
                      await controller
                          ?.resumeCamera()
                          .then((value) => Navigator.of(context).pop());
                    },
                    child: Text("Copy contents")),
              ),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () async {
                    Share.share("${scanData.code}");
                    await controller
                        ?.resumeCamera()
                        .then((value) => Navigator.of(context).pop());
                  },
                  label: Text("Share"),
                  icon: Icon(Icons.share_outlined),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                    onPressed: () async {
                      await controller
                          ?.resumeCamera()
                          .then((value) => Navigator.pop(context));
                    },
                    child: Text("close")),
              )
            ],
          )
        ],
      );
    },
  );
}
