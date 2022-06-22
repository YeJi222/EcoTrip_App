import 'package:ecotripapp/widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Product> products = [
    const Product(
        name: "name",
        description: "description",
        imageURL:
        "https://imgnn.seoul.co.kr/img//upload/2021/03/16/SSI_20210316152606_V.jpg"),
    const Product(
        name: "name",
        description: "description",
        imageURL: "https://cdn.dailytnews.kr/news/photo/201811/35_37_5744.jpg")
  ];

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
      backgroundColor: Color(0xfffafafa),
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
          SizedBox(
            width: 10,
          )
        ],
      ),
      body: ListView(
          padding: EdgeInsets.all(20),
          scrollDirection: Axis.vertical,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                          text: "Hello User \u{1f44a}",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                SizedBox(
                  width: 400,
                  height: 370,
                  child: ListView(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      dragStartBehavior: DragStartBehavior.start,
                      padding: const EdgeInsets.all(16.0),
                      children: buildListCardsH(products, context)),
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
                SizedBox(
                  width: 400,
                  child: ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16.0),
                      children: buildListCardsV(products, context)),
                ),
              ],
            ),
          ]),
    );
  }
}