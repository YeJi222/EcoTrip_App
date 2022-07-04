import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'cotroller.dart';
import 'detail.dart';
import 'detail_checkbox.dart';
import 'package:get/get.dart';
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
  final LoginController loginController = Get.put(LoginController());
  final Controller controller = Get.put(Controller());


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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailPage(product),
              ),
            );
          },
          child: SizedBox(
            width: 280,
            // height: 200,
            child: Stack(
              children: [
                Positioned(
                  child: SizedBox(
                    width: 250,
                    height: 320,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40.0),
                      child: CachedNetworkImage(
                        progressIndicatorBuilder: (context, url, progress) =>
                            Center(
                          child: CircularProgressIndicator(
                            value: progress.progress,
                          ),
                        ),
                        imageUrl: product.imageURL[0],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                    top: 200,
                    left: -25,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(35, 0, 0, 0),
                      child: Container(
                        width: 240,
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
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15),
                            ),
                            // const SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text(
                                  "Top 1",
                                  style: TextStyle(
                                      color: Colors.lightGreenAccent,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 25),
                                ),
                                const SizedBox(
                                  width: 120,
                                ),
                                IconButton(
                                    onPressed: () {
                                      // print(product.isStored);

                                      if (product.isStored) {
                                        FirebaseFirestore.instance
                                            .collection('user')
                                            .doc(loginController.uid)
                                            .collection('favorite')
                                            .where('title',
                                                isEqualTo: product.title)
                                            .get()
                                            .then((value) {
                                          for (final document in value.docs) {
                                            document.reference.delete();
                                          }
                                        });
                                      } else {
                                        DocumentReference copyFrom =
                                            FirebaseFirestore.instance
                                                .collection('products')
                                                .doc(product.timestamp);
                                        DocumentReference copyTo =
                                            FirebaseFirestore.instance
                                                .collection('user')
                                                .doc(loginController.uid)
                                                .collection('favorite')
                                                .doc();

                                        copyFrom.get().then((value) =>
                                            {copyTo.set(value.data())});
                                      }
                                      controller.changeIsStored(product);
                                    },
                                    icon: Icon(
                                      Icons.bookmark_added_outlined,
                                      color: (product.isStored)
                                          ? const Color(0xff6dc62f)
                                          : Colors.black,
                                      size: 25,
                                    )),
                              ],
                            )
                          ],
                        ),
                      ),
                    )),
                Positioned(
                  right: 50,
                  top: 20,
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
                            width: 10,
                          ),
                          Icon(
                            Icons.star,
                            color: Colors.white,
                            size: 16,
                          ),
                          SizedBox(
                            width: 4,
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
List<Card> buildListCardsV(List<Product> products, BuildContext context, int flag) {
  final LoginController loginController = Get.put(LoginController());
  final Controller controller = Get.put(Controller());

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
            if(flag == 0){ // go to detail.dart
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPage(product),
                ),
              );
            } else{ // go to detail_checkbox.dart
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CheckBoxPage(product),
                ),
              );
            }
          },
          child: Padding(
            padding: EdgeInsets.only(bottom: 10),
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
                  padding: const EdgeInsets.only(
                    left: 10.0,
                    top: 10,
                    bottom: 10,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          width: 100,
                          height: 100,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: CachedNetworkImage(
                              progressIndicatorBuilder:
                                  (context, url, progress) => Center(
                                child: CircularProgressIndicator(
                                  value: progress.progress,
                                ),
                              ),
                              imageUrl: product.imageURL[0],
                              fit: BoxFit.cover,
                            ),
                          )),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 10,
                          top: 3,
                        ),
                        child: SizedBox(
                          width: 180,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                product.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w300, fontSize: 13),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
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
                          const SizedBox(
                            height: 6,
                          ),
                          const Text(
                            "data",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Color(0xff6dc62f)),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          IconButton(
                            visualDensity: const VisualDensity(horizontal: -4),
                            onPressed: () {
                              if (product.isStored) {
                                FirebaseFirestore.instance
                                    .collection('user')
                                    .doc(loginController.uid)
                                    .collection('favorite')
                                    .where('title', isEqualTo: product.title)
                                    .get()
                                    .then((value) {
                                  for (final document in value.docs) {
                                    document.reference.delete();
                                  }
                                });
                              } else {
                                DocumentReference copyFrom = FirebaseFirestore
                                    .instance
                                    .collection('products')
                                    .doc(product.timestamp);
                                DocumentReference copyTo = FirebaseFirestore
                                    .instance
                                    .collection('user')
                                    .doc(loginController.uid)
                                    .collection('favorite')
                                    .doc();
                                copyFrom.get().then(
                                        (value) => {copyTo.set(value.data())});
                              }
                              controller.changeIsStored(product);
                            },
                            icon: Icon(
                              Icons.bookmark_added_outlined,
                              color: (product.isStored)
                                  ? const Color(0xff6dc62f)
                                  : Colors.black,
                              size: 25,
                            ),
                            splashColor: Colors.blue,
                          ),
                        ],
                      )
                    ],
                  ),
                )),
          ),
        ));
  }).toList();
}

List<String> buildList(List<TrueChecked> trueThing, BuildContext context){
  if(trueThing.isEmpty) return [];

  List<String> trueChecked = [];
  // print(trueThing.length);

  for(int i = 0 ; i < trueThing.length ; i++){
    print(trueThing[i].challenge.length);
    for(int j = 0 ; j < trueThing[i].challenge.length ; j++){
      trueChecked.add(trueThing[i].challenge[j]);
    }

    // print(trueThing[1].challenge[0]);
    // trueChecked.add(trueThing[i].challenge[i]);
    // print('all true challenges = ${trueChecked[i]}');
  }

  print('true list = ${trueChecked}');

  return trueChecked;
}

List<Card> buildListTile(List<String> trueThing, BuildContext context) {
  if (trueThing.isEmpty) {
    return <Card>[];
  }

  int idx = 0;
  return trueThing.map((thing) {
    return Card(
        color: Colors.transparent,
        elevation: 0.0,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        child: Padding(
            padding: EdgeInsets.only(right: 10, left: 10, bottom: 10),
            child: Container(
                width: 250,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  // color: Colors.yellow,
                  borderRadius: BorderRadius.all(
                    Radius.circular(11),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 10.0,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 10,
                          top: 10,
                          bottom: 7
                        ),
                        child: Container(
                          // color: Colors.red,
                          color: Colors.white,
                          width: 280,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '🌱 Challenge #${idx+1}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                // thing.challenge[idx++],
                                trueThing[idx++],
                                // 'a',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w300, fontSize: 19
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // SizedBox(width: 100),
                      /*
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(height: 5,),
                          IconButton(
                            onPressed: () {
                              // if (product.isStored) {
                              //   FirebaseFirestore.instance
                              //       .collection('user')
                              //       .doc(loginController.uid)
                              //       .collection('favorite')
                              //       .where('title', isEqualTo: product.title)
                              //       .get()
                              //       .then((value) {
                              //     for (final document in value.docs) {
                              //       document.reference.delete();
                              //     }
                              //   });
                              // } else {
                              //   DocumentReference copyFrom = FirebaseFirestore
                              //       .instance
                              //       .collection('products')
                              //       .doc(product.timestamp);
                              //   DocumentReference copyTo = FirebaseFirestore
                              //       .instance
                              //       .collection('user')
                              //       .doc(loginController.uid)
                              //       .collection('favorite')
                              //       .doc();
                              //   copyFrom.get().then(
                              //           (value) => {copyTo.set(value.data())});
                              // }
                              // controller.changeIsStored(product);


                              // trueThing.removeAt(idx);
                              print('delete');
                            },
                            icon: Icon(
                              // Icons.check_box_outlined,
                              Icons.delete_outline,
                              color: Colors.red,
                              // color: (product.isStored)
                              //     // ? const Color(0xff6dc62f)
                              //     ? Colors.red
                              //     : Colors.black,
                              size: 25,
                            ),
                            splashColor: Colors.blue,
                          ),
                        ],
                      ),
                       */
                    ],
                  ),
                ),
            ),
          ),
        );
  }).toList();
}

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}
