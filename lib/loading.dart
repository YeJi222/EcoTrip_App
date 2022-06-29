import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'cotroller.dart';
import 'firebase_options.dart';
import 'home.dart';
import 'login.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  final storage = const FlutterSecureStorage();
  String userInfo = "None";

  final LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    Timer(
        const Duration(seconds: 2),
        () async => {
              if (await storage.read(key: "login")!=null)
                {
                  userInfo = (await storage.read(key: "login"))!,
                  loginController.name = userInfo.split(" ")[1],
                  loginController.uid = userInfo.split(" ")[3],
                  loginController.email = userInfo.split(" ")[5],
                  loginController.profile_url = userInfo.split(" ")[7],
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (c, a1, a2) => NavigatorPage(),
                      transitionsBuilder: (c, anim, a2, child) =>
                          FadeTransition(opacity: anim, child: child),
                      transitionDuration: const Duration(milliseconds: 1500),
                    ),
                  )
                }
              else
                {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (c, a1, a2) => LoginPage(),
                      transitionsBuilder: (c, anim, a2, child) =>
                          FadeTransition(opacity: anim, child: child),
                      transitionDuration: const Duration(milliseconds: 1500),
                    ),
                  )
                }
            });

    @override
    void initState() {
      super.initState();
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        userInfo = (await storage.read(key: "login"))!;
      });
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
                  child: Lottie.asset("img/ecology.json"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
