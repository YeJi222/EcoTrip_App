import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecotripapp/upload.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'home.dart';
import 'login.dart';

class TravelApp extends StatelessWidget {
  const TravelApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TravelApp',
      initialRoute: "/login",
      routes: {
        '/login': (BuildContext context) => const LoginPage(),
        '/home': (BuildContext context) => const HomePage(),
        // '/profile': (BuildContext context) => const ProfilePage(),
        '/upload': (BuildContext context) => const UploadPage(),
        // '/search': (BuildContext context) => const SearchPage(),
        // '/cart': (BuildContext context) => const CartScreen(),
        // '/coin': (BuildContext context) => CoinPage(),
      },
    );
  }
}