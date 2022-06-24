import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'home.dart';
import 'package:get/get.dart';
import 'cotroller.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {

  final Controller controller = Get.put(Controller());

  @override
  Widget build(BuildContext context) {
    Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (c, a1, a2) => const HomePage(),
            transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
            transitionDuration: const Duration(milliseconds: 1500),
          ),
        ));

    @override
    void initState() {
      super.initState();
    }

    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(
        backgroundColor: const Color(0xffd1f6b8),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: SizedBox(
                  width: 170,
                  // child: Image.asset(
                  //   'img/login_image.png',
                  //   fit: BoxFit.fitWidth,
                  // )
                  child: Lottie.asset(
                      "img/ecology.json"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
