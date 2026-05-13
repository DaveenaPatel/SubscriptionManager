import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'splash.dart';

void main() async {

  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyBvwIWP5gfD_IuZlOj44Z5N7xQefFMFN2U",
        appId: "283615807014",
        messagingSenderId: "1:283615807014:android:b7d291f99bab0ab72e08e7",
        projectId: "subwallet-864ed"),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: SplashScreenPage(), debugShowCheckedModeBanner: false );
  }
}

