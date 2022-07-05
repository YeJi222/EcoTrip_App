import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'cotroller.dart';
import 'package:day_night_switcher/day_night_switcher.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, String? title,}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final LoginController loginController = Get.put(LoginController());

  bool isDarkModeEnabled = false;
  final storage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.yellow,
        scaffoldBackgroundColor: Color(0xfff9fff8),
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
              const SizedBox(
                width: 10,
              )
            ],
          ),
          extendBodyBehindAppBar: true,
          // backgroundColor: Color(0xfff9fff8),
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
                      child: Container(
                            width: 130,
                            height: 130,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100.0),
                              child: Image.network(
                                loginController.profile_url,
                                // '${FirebaseAuth.instance.currentUser!.photoURL}',
                                // photoURL ?? default_url,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
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
                        Column(
                              children: [
                                Text(
                                  loginController.name,
                                  // "${FirebaseAuth.instance.currentUser!.displayName}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 7),
                                Text(
                                  loginController.email,
                                  // "${FirebaseAuth.instance.currentUser!.email}",
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                        // ),
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
                          Navigator.pushNamed(context, '/challenge_list');
                        },
                        child: Row(
                          children: const [
                            Icon(
                              Icons.check_circle_outline_sharp,
                              size: 25,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'My Challenges List',
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
                          Navigator.pushNamed(context, '/editProfile').then((value) => {
                          setState(() {})
                          });
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
                          storage.delete(key: "login");
                          Navigator.pushNamed(context, '/loading');
                        },
                        child: Row(
                          children: const [
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
                        const SizedBox(width: 10),
                        const Text(
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