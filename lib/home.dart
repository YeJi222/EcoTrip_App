import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecotripapp/profile.dart';
import 'package:ecotripapp/search.dart';
import 'package:ecotripapp/cotroller.dart';
import 'package:ecotripapp/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:floating_bottom_bar/animated_bottom_navigation_bar.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'favorite.dart';
import 'firebase_options.dart';

class NavigatorPage extends StatefulWidget {
  @override
  _NavigatorPageState createState() => _NavigatorPageState();
}

class _NavigatorPageState extends State<NavigatorPage> {
  int activeIndex = 0;
  void changeActivePage(int? index) {
    setState(() {
      activeIndex = index!;
    });
  }

  List<Widget> pages = [];

  @override
  void initState() {
    pages = [
      HomePage(),
      SearchPage(),
      FavoritePage(),
      ProfilePage(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xfff9fff8),
        bottomNavigationBar: AnimatedBottomNavigationBar(
          bottomBarItems: [
            BottomBarItemsModel(
              icon: const Icon(Icons.home, color: Colors.black),
              iconSelected: const Icon(Icons.home, color: Colors.green),
              dotColor: Colors.green,
              onTap: () => {
                changeActivePage(0),
              },
            ),
            BottomBarItemsModel(
              icon: Icon(Icons.search, color: Colors.black),
              iconSelected: Icon(Icons.search, color: Colors.green),
              dotColor: Colors.green,
              onTap: () => {
                changeActivePage(1),
              },
            ),
            BottomBarItemsModel(
              icon: Icon(Icons.bookmark_added_outlined, color: Colors.black),
              iconSelected: Icon(Icons.bookmark_added_outlined, color: Colors.green),
              dotColor: Colors.green,
              onTap: () => {
                changeActivePage(2),
              },
            ),
            BottomBarItemsModel(
              icon: Icon(Icons.person, color: Colors.black),
              iconSelected: Icon(Icons.person, color: Colors.green),
              dotColor: Colors.green,
              onTap: () => {
                changeActivePage(3),
              },
            ),
          ],
          bottomBarCenterModel: BottomBarCenterModel(
            centerBackgroundColor: Colors.green,
            centerIcon: const FloatingCenterButton(
              child: Icon(
                Icons.add,
                color: AppColors.white,
              ),
            ),
            centerIconChild: [
              FloatingCenterButtonChild(
                child: const Icon(
                  Icons.edit,
                  color: AppColors.white,
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/upload');
                },
              ),
              FloatingCenterButtonChild(
                child: const Icon(
                  Icons.arrow_downward,
                  color: AppColors.white,
                ),
                onTap: () { },
              ),
            ],
          ),
        ),
        body: pages[activeIndex]);
  }
}

class ApplicationHomeState extends ChangeNotifier{
  ApplicationHomeState(){
    init();
  }

  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FirebaseAuth.instance.userChanges().listen((user) async {
      if (user != null) {
        final doc_user = await FirebaseFirestore.instance
            .collection('user')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();
        if(doc_user.exists == true){
          _name = doc_user.get('name');
        }
        notifyListeners();
      }
      notifyListeners();
    });
  }

  String _name = '';
  String get name => _name;
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Controller controller = Get.put(Controller());

  static int load_num = 15; // number of cards to load
  Stream<int> loadStream =
  Stream<int>.periodic(const Duration(seconds: 2), (x) => load_num);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    print('dispose is called');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Color(0xfff9fff8),
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
              ),
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
                ),
            ),
            const SizedBox(width: 10,),
          ],
        ),
        body: StreamBuilder<int>(
            stream: loadStream,
            builder: (context, snapshot) {
              return ListView(
                padding: const EdgeInsets.only(left: 20, right: 20),
                scrollDirection: Axis.vertical,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          const SizedBox(width: 20.0, height: 70.0),
                          DefaultTextStyle(
                            style: const TextStyle(
                              fontSize: 20.0,
                              fontFamily: 'Horizon',
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            child: Consumer<ApplicationHomeState>(
                                builder: (context, appState, _) {
                                  return AnimatedTextKit(
                                    animatedTexts: [
                                      RotateAnimatedText(
                                        'Hello! ${appState.name} 🌿',
                                      ),
                                    ],
                                    onTap: () {
                                      print("Tap Event");
                                    },
                                    repeatForever: true,
                                  );
                                }
                            ),
                          ),
                        ],
                      ),
                      GetBuilder<Controller>(
                        builder: (_) {
                          return SizedBox(
                            width: 400,
                            height: 330,
                            child: ListView(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                dragStartBehavior: DragStartBehavior.start,
                                padding: EdgeInsets.only(left: 12, top: 2),
                                children: buildListCardsH(
                                    controller.products, context)
                            ),
                          );
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text("Recently Booked",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold)
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 135),
                            child: TextButton(
                              onPressed: () {
                                print("Text Button");
                              },
                              child: const Text("See more",
                                  style: TextStyle(
                                      color: Color(0xff6dc62f),
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),),
                          )
                        ],
                      ),
                      GetBuilder<Controller>(
                          builder: (_) {
                            return SizedBox(
                              width: 400,
                              child: ListView(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: const EdgeInsets.only(left: 10),
                                  children: buildListCardsV(_.products, context)),
                            );
                          }
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
     );
  }
}