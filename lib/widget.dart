import 'package:cached_network_image/cached_network_image.dart';
import 'package:floating_bottom_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

import 'model.dart';

class Event extends StatelessWidget {
  const Event({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorLight,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(title),
    );
  }
}

class DayHeader extends StatelessWidget {
  const DayHeader({
    Key? key,
    required this.day,
  }) : super(key: key);

  final int day;

  @override
  Widget build(BuildContext context) {
    late final String dayString;

    switch (day) {
      case 0:
        dayString = 'Day1';
        break;
      case 1:
        dayString = 'Day2';
        break;
      case 2:
        dayString = 'Day3';
        break;
      case 3:
        dayString = 'Day4';
        break;
      case 4:
        dayString = 'Day5';
        break;
    }
    return Container(
      margin: const EdgeInsets.only(left: 20),
      width: 100,
      height: 30,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(dayString),
    );
  }
}

// List Horizon
List<Card> buildListCardsH(List<Product> products, BuildContext context) {
  if (products.isEmpty) {
    return const <Card>[];
  }

  return products.map((product) {
    return Card(
        color: Colors.transparent,
        elevation: 0.0,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => DetailPage(product),
            //   ),
            // );
          },
          child: SizedBox(
            width: 300,
            height: 370,
            child: Stack(
              children: [
                Positioned(
                    child: SizedBox(
                  width: 270,
                  height: 350,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40.0),
                    child: CachedNetworkImage(
                      progressIndicatorBuilder: (context, url, progress) =>
                          Center(
                            child: CircularProgressIndicator(
                              value: progress.progress,
                            ),
                          ),
                      imageUrl: product.imageURL,
                      fit: BoxFit.cover,
                    ),
                  ),
                )),
                Positioned(
                    top: 220,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(35, 0, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.title,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 25),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            product.description,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                                fontSize: 17),
                          ),
                          // const SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "?????",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 25),
                              ),
                              const SizedBox(
                                width: 100,
                              ),
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.bookmark_added_outlined,
                                    color: Colors.white,
                                    size: 28,
                                  )),
                            ],
                          )
                        ],
                      ),
                    )),
                Positioned(
                  right: 50,
                  top: 30,
                  child: Container(
                      width: 60,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Color(0xff6dc62f),
                        borderRadius: BorderRadius.all(
                          Radius.circular(11),
                        ),
                      ),
                      child: Row(
                        children: const [
                          SizedBox(
                            width: 12,
                          ),
                          Icon(
                            Icons.star,
                            color: Colors.white,
                            size: 16,
                          ),
                          Text(
                            "4.8",
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ],
                      )),
                )
              ],
            ),
          ),
        ));
  }).toList();
}

// List Vertical
List<Card> buildListCardsV(List<Product> products, BuildContext context) {
  if (products.isEmpty) {
    return const <Card>[];
  }

  return products.map((product) {
    return Card(
        color: Colors.transparent,
        elevation: 0.0,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => DetailPage(product),
            //   ),
            // );
          },
          child: Padding(
            padding: EdgeInsets.only(bottom: 15),
            child: Container(
                width: 300,
                height: 120,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(11),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          width: 100,
                          height: 100,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: CachedNetworkImage(
                              progressIndicatorBuilder: (context, url, progress) =>
                                  Center(
                                    child: CircularProgressIndicator(
                                      value: progress.progress,
                                    ),
                                  ),
                              imageUrl: product.imageURL,
                              fit: BoxFit.cover,
                            ),
                          )),
                      Padding(
                        padding: EdgeInsets.only(left: 10, top: 10, right: 10),
                        child: SizedBox(
                          width: 130,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(product.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                              const SizedBox(height: 10,),
                              Text(product.description, style: TextStyle(fontWeight: FontWeight.w300, fontSize: 13),),
                              const SizedBox(height: 10,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: const TextSpan(
                                      children: [
                                        TextSpan(
                                            text: "\u{2b50} 4.8",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          const SizedBox(height: 10,),
                          const Text("data",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xff6dc62f)),),
                          const SizedBox(height: 15,),
                          IconButton(
                              onPressed: () {
                                print("Button");
                              },
                              icon: const Icon(
                                Icons.bookmark_added_outlined,
                                color: Colors.black,
                                size: 28,
                              )),
                        ],
                      )
                    ],
                  ),
                )),
          ),
        ));
  }).toList();
}
Widget floatingBar(BuildContext context) {
  return AnimatedBottomNavigationBar(
    bottomBarItems: [
      BottomBarItemsModel(
        icon: const Icon(Icons.home, color: Colors.black),
        iconSelected: const Icon(Icons.home, color: Colors.green),
        dotColor: Colors.green,
        onTap: () => {
          Navigator.pushNamed(context, '/home'),
        },
      ),
      BottomBarItemsModel(
        icon: Icon(Icons.search, color: Colors.black),
        iconSelected: Icon(Icons.search, color: Colors.green),
        dotColor: Colors.green,
        onTap: () => {},
      ),
      BottomBarItemsModel(
        icon: Icon(Icons.person, color: Colors.black),
        iconSelected: Icon(Icons.person, color: Colors.green),
        dotColor: Colors.green,
        onTap: () => {
          Navigator.pushNamed(context, '/profile')
        },
      ),
      BottomBarItemsModel(
        icon: Icon(Icons.settings, color: Colors.black),
        iconSelected: Icon(Icons.settings, color: Colors.green),
        dotColor: Colors.green,
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
            Navigator.pushNamed(context, '/upload');
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
  );
}
void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}