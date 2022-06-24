import 'package:ecotripapp/cotroller.dart';
import 'package:ecotripapp/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:floating_bottom_bar/animated_bottom_navigation_bar.dart';
import 'package:get/get.dart';

import 'model.dart';

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
    return Scaffold(
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
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.bookmark_added_outlined,
                color: Colors.black,
                size: 28,
              )),
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
                    child: AnimatedTextKit(
                      animatedTexts: [
                        RotateAnimatedText(
                            "${FirebaseAuth.instance.currentUser!.displayName} 👊🏻"
                        ),
                      ],
                      onTap: () {
                        print("Tap Event");
                      },
                      repeatForever: true,
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
          ]),
      bottomNavigationBar: AnimatedBottomNavigationBar(
        bottomBarItems: [
          BottomBarItemsModel(
            icon: const Icon(Icons.home),
            iconSelected: const Icon(Icons.home, color: Colors.green),
            onTap: () => {},
          ),
          BottomBarItemsModel(
            icon: Icon(Icons.search,),
            iconSelected: Icon(Icons.search, color: Colors.green),
            onTap: () => {},
          ),
          BottomBarItemsModel(
            icon: Icon(Icons.person,),
            iconSelected: Icon(Icons.person, color: Colors.green),
            onTap: () => {
              Navigator.pushNamed(context, '/profile')
            },
          ),
          BottomBarItemsModel(
            icon: Icon(Icons.settings,),
            iconSelected: Icon(Icons.settings, color: Colors.green),
            onTap: () => {},
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
                Navigator.pushNamed(context, '/upload').then((_) => setState(() {}));
              },
            ),
            FloatingCenterButtonChild(
              child: const Icon(
                Icons.home,
                color: AppColors.white,
              ),
              onTap: () {

              },
            ),
          ],
        ),
      ),
    );
  }
}
