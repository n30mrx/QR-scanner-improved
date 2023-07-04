// ignore_for_file: prefer_const_constructors, unused_import, unused_local_variable, unused_field, no_leading_underscores_for_local_identifiers, prefer_const_literals_to_create_immutables, camel_case_types
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:my_app/pages/Home_App_Page.dart';
import 'package:my_app/utils/qr_gen.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

bool isEmpty = false;
String confirmedPassword = '';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return MaterialApp(
          title: 'Qr scanner',
          theme: ThemeData(
            colorScheme: lightDynamic,
            useMaterial3: true,
          ),
          darkTheme: ThemeData(colorScheme: darkDynamic, useMaterial3: true),
          debugShowCheckedModeBanner: false,
          routes: {
            '/login': (_) => loginScreen(),
            '/home': (_) => HomeAppPage(),
            '/gen': (_)=>QrGen(),
          },
          initialRoute: '/login',
        );
      },
    );
  }
}

class loginScreen extends StatefulWidget {
  const loginScreen({super.key});

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // if (!snapshot.hasData) {
        // ignore: dead_code
        if (false) {
          return SignInScreen(
            providerConfigs: [
              EmailProviderConfiguration(),
            ],
            desktopLayoutDirection: TextDirection.ltr,
            oauthButtonVariant: OAuthButtonVariant.icon_and_text,
            showAuthActionSwitch: true,
            footerBuilder: (context, action) {
              return Row(
                children: [
                  Text("If you encounter any issues, please"),
                  TextButton(
                      onPressed: () {
                        launchUrlString("https://t.me/n30chat",
                            mode: LaunchMode.externalApplication);
                      },
                      child: Text("contact us")),
                ],
              );
            },
          );
        }
        return HomeAppPage();
      },
    );
  }
}
