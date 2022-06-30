import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';
import 'cotroller.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  final storage = const FlutterSecureStorage();
  final LoginController loginController = Get.put(LoginController());

  LoginPage({Key? key}) : super(key: key);

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  googleCreate() async {
    final document = await FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    if (document.exists == false) {
      // 처음 등록때만
      FirebaseFirestore.instance
          .collection('user')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set(<String, dynamic>{
        'email': FirebaseAuth.instance.currentUser!.email,
        'name': FirebaseAuth.instance.currentUser!.displayName,
        'uid': FirebaseAuth.instance.currentUser!.uid,
        'profile_url': FirebaseAuth.instance.currentUser!.photoURL,
      });

      loginController.name = (FirebaseAuth.instance.currentUser?.displayName)!;
      loginController.uid = (FirebaseAuth.instance.currentUser?.uid)!;
      loginController.email = (FirebaseAuth.instance.currentUser?.email)!;
      loginController.profile_url = (FirebaseAuth.instance.currentUser?.photoURL)!;

    } else {
      loginController.name = document.data()!['name'] as String;
      loginController.uid = document.data()!['uid'] as String;
      loginController.email = document.data()!['email'] as String;
      loginController.profile_url = document.data()!['profile_url'] as String;
    }

    loginController.getLikeProduct();
    await storage.write(
        key: "login",
        value:
            "name ${loginController.name} uid ${loginController.uid} email ${loginController.email} photoURL ${loginController.profile_url}");

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: Container(
        height: 400,
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('img/login.png'), // 배경 이미지
          ),
        ),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 250,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: SizedBox(
                    width: 300,
                    child: Image.asset(
                      'img/logo.png',
                      fit: BoxFit.fitWidth,
                    )),
              ),
              const SizedBox(
                height: 380,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 320,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Color(0xfffc99a1),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: TextButton(
                      onPressed: () async {
                        final userCredential = await signInWithGoogle();
                        if (userCredential != null) {
                          googleCreate();
                          Navigator.pushNamed(context, '/navigator');
                        } else {
                          print(
                              "Google auth hasn't been enabled for this project.");
                        }
                      },
                      child: const Text(
                        'Google Login',
                        style: TextStyle(
                            color: Color(0xfffc99a1),
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
