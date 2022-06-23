import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecotripapp/loading.dart';
import 'package:ecotripapp/profile.dart';
import 'package:ecotripapp/upload.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'home.dart';
import 'login.dart';
import 'package:get/get.dart';

class TravelApp extends StatelessWidget {
  const TravelApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'TravelApp',
      initialRoute: "/loading",
      routes: {
        '/login': (BuildContext context) => LoginPage(),
        '/home': (BuildContext context) => const HomePage(),
        '/loading': (BuildContext context) => const LoadingPage(),
        '/upload': (BuildContext context) => const UploadPage(),
        '/profile': (BuildContext context) => const ProfilePage(),
        // '/coin': (BuildContext context) => CoinPage(),
      },
    );
  }
}