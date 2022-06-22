import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecotripapp/loading.dart';
import 'package:ecotripapp/upload.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'home.dart';
import 'login.dart';
import 'timeline.dart';

class TravelApp extends StatelessWidget {
  const TravelApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TravelApp',
      initialRoute: "/loading",
      routes: {
        '/login': (BuildContext context) => const LoginPage(),
        '/home': (BuildContext context) => const HomePage(),
        '/loading': (BuildContext context) => const LoadingPage(),
        '/upload': (BuildContext context) => const UploadPage(),
        '/timeline': (BuildContext context) => const TimePage(),
        // '/cart': (BuildContext context) => const CartScreen(),
        // '/coin': (BuildContext context) => CoinPage(),
      },
    );
  }
}