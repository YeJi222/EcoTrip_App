import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'app.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    print('initState is called');
  }

  @override
  void dispose() {
    super.dispose();
    print('dispose is called');
  }

  @override
  Widget build(BuildContext context) {
    print(FirebaseAuth.instance.currentUser?.displayName);
    return Scaffold(
        backgroundColor: const Color(0xfffff9f9),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading:
            Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 10,
                ),
                Image.asset(
                  'img/logo.png',
                  height: 25,
                ),
              ],
            ),
          ]),
        ),
        extendBodyBehindAppBar: true,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 100,
            ),
            TextButton(
              // onPressed: signInWithGoogle,
              onPressed: () async {
                Navigator.popAndPushNamed(context, '/upload');
              },
              child: const Text(
                'Upload',
                style: TextStyle(
                    color: Color(0xfffc99a1),
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                ),
              ),
            ),
            ],
        ));
  }
}
