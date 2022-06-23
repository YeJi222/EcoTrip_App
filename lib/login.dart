import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'cotroller.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);
  final Controller controller = Get.put(Controller());

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

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
    if(document.exists == false) { // 처음 등록때만
      FirebaseFirestore.instance
          .collection('user')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set(<String, dynamic>{
        'email': FirebaseAuth.instance.currentUser!.email,
        'name': FirebaseAuth.instance.currentUser!.displayName,
        'uid': FirebaseAuth.instance.currentUser!.uid,
        'profile_url': FirebaseAuth.instance.currentUser!.photoURL,
      });
    }
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
                const SizedBox(height: 250,),
                ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: SizedBox(
                      width: 300,
                      child: Image.asset(
                        'img/logo.png',
                        fit: BoxFit.fitWidth,
                      )
                  ),
                ),
                const SizedBox(height: 390,),
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
                        // onPressed: signInWithGoogle,
                        onPressed: () async {
                          final userCredential = await signInWithGoogle();
                          if(userCredential != null){
                            googleCreate();
                            controller.getProduct();
                            Navigator.pushNamed(context, '/home');
                          } else{
                            print("Google auth hasn't been enabled for this project.");
                          }

                          // await context.read<FirebaseAuthMethods>().signInWithGoogle(context);
                          // if(FirebaseAuth.instance.currentUser?.uid != null) {
                          //   Navigator.popAndPushNamed(context, '/home');
                          // }
                        },
                        //test
                        child: const Text(
                          'Google Login',
                          style: TextStyle(
                            color: Color(0xfffc99a1),
                            fontWeight: FontWeight.bold,
                            fontSize: 20
                          ),
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