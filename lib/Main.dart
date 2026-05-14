import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'splash.dart';
import 'settingsValues.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyBvwIWP5gfD_IuZlOj44Z5N7xQefFMFN2U",
      appId: "283615807014",
      messagingSenderId: "1:283615807014:android:b7d291f99bab0ab72e08e7",
      projectId: "subwallet-864ed",
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder <ThemeMode>(
      valueListenable: theme,
      builder: (context, mode, _){
        return ValueListenableBuilder<String>(
          valueListenable: font,
          builder: (context, fonts, _) {
            return MaterialApp(
              home: SplashScreenPage(),
              themeMode: mode,
              theme: ThemeData.light().copyWith(textTheme: textTheme(fonts)),
              darkTheme: ThemeData.dark().copyWith(textTheme: textTheme(fonts)),
              debugShowCheckedModeBanner: false,
            );
          },
        );

      },
    );
  }

  TextTheme? textTheme(String fonts) {
    switch (fonts) {
      case 'Margarine': return GoogleFonts.margarineTextTheme();
      case 'Knewave':      return GoogleFonts.knewaveTextTheme();
      case 'Metamorphous':      return GoogleFonts.metamorphousTextTheme();
      default:          return GoogleFonts.robotoTextTheme();
    }
  }
}
