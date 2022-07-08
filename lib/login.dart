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
      loginController.profile_url =
          (FirebaseAuth.instance.currentUser?.photoURL)!;
    } else {
      loginController.name = document.data()!['name'] as String;
      loginController.uid = document.data()!['uid'] as String;
      loginController.email = document.data()!['email'] as String;
      loginController.profile_url = document.data()!['profile_url'] as String;
      loginController.address = document.data()!['address'] as String;
      loginController.age = document.data()!['age'] as String;
      loginController.gender = document.data()!['gender'] as String;
    }

    loginController.getLikeProduct();
    await storage.write(
        key: "login",
        value:
            "name ${loginController.name} "
                "uid ${loginController.uid} "
                "email ${loginController.email} "
                "photoURL ${loginController.profile_url} "
                "age ${loginController.age} "
                "gender ${loginController.gender} "
                "address ${loginController.address}");
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
              // image: AssetImage('img/login.png'), // 배경 이미지
              image: AssetImage('img/profile_back.png')),
        ),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 200,
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
                height: 430,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 250,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(45.0),
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'img/google_logo.png',
                            width: 30,
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          const Text(
                            'Google Login',
                            style: TextStyle(
                                // color: Color(0xfffc99a1),
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ],
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
