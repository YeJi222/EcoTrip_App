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
        bottomNavigationBar: AnimatedBottomNavigationBar(
          bottomBarItems: [
            BottomBarItemsModel(
              icon: const Icon(Icons.home, color: Colors.black),
              iconSelected: const Icon(Icons.home, color: Colors.green),
              dotColor: Colors.green,
              onTap: () => {
                // Navigator.pushNamed(context, '/home'),
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
                // Navigator.pushNamed(context, '/profile')
                changeActivePage(3),
              },
            ),
          ],
          bottomBarCenterModel: BottomBarCenterModel(
            centerBackgroundColor: Colors.green,
            centerIcon: FloatingCenterButton(
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
      /*
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/upload');
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.red,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        bottomNavigationBar: BubbleBottomBar(
          hasNotch: true,
          fabLocation: BubbleBottomBarFabLocation.end,
          opacity: .2,
          currentIndex: activeIndex,
          onTap: changeActivePage,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(16),
          ), //border radius doesn't work when the notch is enabled.
          elevation: 8,
          tilesPadding: EdgeInsets.symmetric(
            vertical: 8.0,
          ),
          items: <BubbleBottomBarItem>[
            BubbleBottomBarItem(
              showBadge: true,
              badge: Text("5"),
              badgeColor: Colors.deepPurpleAccent,
              backgroundColor: Colors.red,
              icon: Icon(
                Icons.dashboard,
                color: Colors.black,
              ),
              activeIcon: Icon(
                Icons.dashboard,
                color: Colors.red,
              ),
              title: Text("Home"),
            ),
            BubbleBottomBarItem(
                backgroundColor: Colors.deepPurple,
                icon: Icon(
                  Icons.access_time,
                  color: Colors.black,
                ),
                activeIcon: Icon(
                  Icons.access_time,
                  color: Colors.deepPurple,
                ),
                title: Text("Logs")),
            BubbleBottomBarItem(
                backgroundColor: Colors.indigo,
                icon: Icon(
                  Icons.folder_open,
                  color: Colors.black,
                ),
                activeIcon: Icon(
                  Icons.folder_open,
                  color: Colors.indigo,
                ),
                title: Text("Folders")),
            BubbleBottomBarItem(
                backgroundColor: Colors.green,
                icon: Icon(
                  Icons.menu,
                  color: Colors.black,
                ),
                activeIcon: Icon(
                  Icons.menu,
                  color: Colors.green,
                ),
                title: Text("Menu"))
          ],
        ),

       */
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
              )
              // const Text(
              //   "Eco Trip",
              //   style: TextStyle(
              //       color: Colors.black,
              //       fontSize: 18,
              //       fontWeight: FontWeight.bold),
              // ),
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
            SizedBox(width: 10,),
          ],
        ),
        body: ListView(
            padding: EdgeInsets.only(left: 20, right: 20),
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
                                // "${FirebaseAuth.instance.currentUser!.displayName} 👊🏻"
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
                    height: 370,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      dragStartBehavior: DragStartBehavior.start,
                      padding: const EdgeInsets.all(16.0),
                      children: buildListCardsH(controller.products, context)),
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
                            fontWeight: FontWeight.bold)),
                    Padding(
                      padding: EdgeInsets.only(left: 135),
                      child: TextButton(
                        onPressed: () {
                          print("Text Button");
                        },
                        child: Text("See more",
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
                              padding: const EdgeInsets.all(16.0),
                              children: buildListCardsV(_.products, context)),
                        );
                      }
                  ),

                ],
              ),
            ],
          ),
        ),
     );
  }
}