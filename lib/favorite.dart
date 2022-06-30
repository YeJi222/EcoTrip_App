import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:ecotripapp/widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'cotroller.dart';
import 'model.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {

  final LoginController loginController = Get.put(LoginController());
  Stream<int> loadStream = Stream<int>.periodic(const Duration(seconds: 2), (x) => 100);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff9fff8),
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
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 626,
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(8),
              children: [
                StreamBuilder<int>(
                    stream: loadStream,
                    builder: (context, snapshot) {
                      return GetBuilder<Controller>(builder: (_) {
                        return SizedBox(
                          width: 400,
                          child: ListView(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              children: buildListCardsV(loginController.likeProducts, context)),
                        );
                      });
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
