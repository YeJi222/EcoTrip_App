import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecotripapp/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:floating_bottom_bar/animated_bottom_navigation_bar.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'login.dart';
import 'package:day_night_switcher/day_night_switcher.dart';

String name = '';
String email = '';
String profile_url = '';

class ApplicationState extends ChangeNotifier{
  ApplicationState(){
    init();
  }

  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    /*
    final doc_user = await FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    if(doc_user.exists == true){
      _name = doc_user.get('name');
      _email = doc_user.get('email');
      _profile_url = doc_user.get('profile_url');
    }
    notifyListeners();

     */

    FirebaseAuth.instance.userChanges().listen((user) async {
      if (user != null) {
        final doc_user = await FirebaseFirestore.instance
            .collection('user')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();
        if(doc_user.exists == true){
          _name = doc_user.get('name');
          _email = doc_user.get('email');
          _profile_url = doc_user.get('profile_url');
        }
        notifyListeners();
      }
      notifyListeners();
    });
  }

  String _name = '';
  String get name => _name;

  String _email = '';
  String get email => _email;

  String _profile_url = '';
  String get profile_url => _profile_url;
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, String? title,}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Stream<void> load_user() async*{
  //   FirebaseFirestore.instance
  //       .collection('user')
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .get()
  //       .then((value) {
  //         name = value.get('name') as String;
  //         email = value.get('email') as String;
  //   });
  //
  //   // print(name);
  // }

  bool isDarkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.yellow,
        // primaryColorLight: Colors.yellow,
        // textTheme: const TextTheme(
        //   bodyText1: TextStyle(color: Colors.yellow),
        // ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        // primaryColorDark: Colors.white,
        // appBarTheme: AppBarTheme(color: const Color(0xFF253341)),
        scaffoldBackgroundColor: const Color(0xFF15202B),
        // textTheme: const TextTheme(
        //   bodyText1: TextStyle(color: Colors.white),
        // ),
      ),
      themeMode: isDarkModeEnabled ? ThemeMode.dark : ThemeMode.light,
      home: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          // backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 10,
                ),
                Image.asset(
                  'img/leaf.png',
                  height: 35,
                ),
                const SizedBox(
                  width: 8,
                ),
                DefaultTextStyle(
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  child: AnimatedTextKit(
                    animatedTexts: [
                      WavyAnimatedText('EcoTrip'),
                    ],
                    isRepeatingAnimation: true,
                    repeatForever: true,
                    onTap: () {
                      print("Tap Event");
                    },
                  ),
                )
                // const Text(
                //   "Eco Trip",
                //   style: TextStyle(
                //       color: Colors.black,
                //       fontSize: 18,
                //       fontWeight: FontWeight.bold),
                // ),
                // commit
              ],
            ),
            leadingWidth: 250,
            elevation: 0.0,
            actions: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.notifications_none_outlined,
                    color: Colors.black,
                    size: 28,
                  )),
              // IconButton(
              //     onPressed: () {},
              //     icon: const Icon(
              //       Icons.bookmark_added_outlined,
              //       color: Colors.black,
              //       size: 28,
              //     )),
              SizedBox(
                width: 10,
              )
            ],
          ),
          extendBodyBehindAppBar: true,
          body: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomCenter,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 460,
                          child: Image.asset(
                            'img/profile_back.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Positioned(
                    bottom: 220.0,
                    child: CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.white,
                      child: Consumer<ApplicationState>(
                        builder: (context, appState, _){
                          // ApplicationState();
                          return Container(
                            width: 130,
                            height: 130,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100.0),
                              child: Image.network(
                                appState.profile_url,
                                // '${FirebaseAuth.instance.currentUser!.photoURL}',
                                // photoURL ?? default_url,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }
                      ),
                    ),
                  ),

                  // Positioned(
                  //   bottom: 140.0,
                  //   child: Text(
                  //     FirebaseAuth.instance.currentUser?.displayName == null ? "Anonymous" : name!,
                  //     style: TextStyle(
                  //       fontWeight: FontWeight.bold,
                  //       fontSize: 18,
                  //     ),
                  //   ),
                  // ),
                  Positioned(
                    bottom: 155.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Consumer<ApplicationState>(
                            builder: (context, appState, _) => Column(
                              children: [
                                Text(
                                  appState.name,
                                  // "${FirebaseAuth.instance.currentUser!.displayName}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 7),
                                Text(
                                  appState.email,
                                  // "${FirebaseAuth.instance.currentUser!.email}",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Padding(
                padding: EdgeInsets.only(left: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: 335,
                      height: 40,
                      child: GestureDetector(
                        onTap: () async {
                          Navigator.pushNamed(context, '/editProfile');
                        },
                        child: Row(
                          children: const [
                            Icon(
                              Icons.edit,
                              // color: Colors.black,
                              // color: Color(0xffB58CC8),
                              size: 25,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Edit Profile',
                              // style: Theme.of(context).textTheme.bodyText1,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                // color: Color(0xffB58CC8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: 335,
                      height: 40,
                      child: GestureDetector(
                        onTap: () async {
                          FirebaseAuth.instance.signOut();
                          Navigator.pushNamed(context, '/login');
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.logout,
                              // color: Colors.black,
                              // color: Color(0xffB58CC8),
                              size: 25,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Logout',
                              // style: Theme.of(context).textTheme.bodyText1,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                // color: Color(0xffB58CC8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(
                          Icons.dark_mode,
                          // color: Colors.black,
                          // color: Color(0xffB58CC8),
                          size: 25,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Light/Dark Theme',
                          // style: Theme.of(context).textTheme.bodyText1,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            // color: Color(0xffB58CC8),
                          ),
                        ),
                        SizedBox(width: 20),
                        DayNightSwitcher(
                          isDarkModeEnabled: isDarkModeEnabled,
                          onStateChanged: onStateChanged,
                          dayBackgroundColor: Colors.redAccent,
                          nightBackgroundColor: Colors.amber,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              /*
        Padding(
          padding: EdgeInsets.only(top: 2),
          child: DayNightSwitcherIcon(
            isDarkModeEnabled: isDarkModeEnabled,
            onStateChanged: onStateChanged,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text('Dark mode is ' +
              (isDarkModeEnabled ? 'enabled' : 'disabled') +
              '.'),
        ),
        */

              // Expanded(
              //     child: Consumer<FirebaseAuthMethods>(
              //       builder: (context, appState, _) => GridView.count(
              //         crossAxisCount: 2,
              //         padding: const EdgeInsets.all(16.0),
              //         childAspectRatio: 9.0 / 9.0,
              //         children: buildGridCards(appState.userProducts, context),
              //       ),
              //     ),
              // ),
            ],
          ),
          // bottomNavigationBar: floatingBar(context),
        ),
      ),
    );
  }

  void onStateChanged(bool isDarkModeEnabled) {
    setState(() {
      this.isDarkModeEnabled = isDarkModeEnabled;
    });
  }
}