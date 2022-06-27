import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamic_timeline/dynamic_timeline.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:synchronized/synchronized.dart';
import 'package:flutter/material.dart';

import 'model.dart';
import 'widget.dart';

class Controller extends GetxController {
  Controller() {
    getProduct();
    downloadDefaultURL();
  }

  List<Product> products = <Product>[];
  List<TimelineItem> items = <TimelineItem>[];
  String default_url = '';
  int startTime = DateTime.now().millisecondsSinceEpoch;
  int endTime = DateTime.now().millisecondsSinceEpoch;
  String title = "";
  int pos = 0;

  Future<void> getProduct() async {
    var lock = Lock();

    FirebaseFirestore.instance
        .collection('products')
        .snapshots()
        .listen((snapshot) async {
      products = [];
      items = <TimelineItem>[];

      for (final document in snapshot.docs) {
        await lock.synchronized(() async {
          // Only this block can run (once) until done
          document.reference
              .collection('events')
              .snapshots()
              .listen(
                  (event) => {
                    for (final e in event.docs)
                      {
                        startTime = int.parse(e.data()['startTime'] as String),
                        endTime = int.parse(e.data()['endTime'] as String),
                        title = e.data()['title'] as String,
                        // print(DateTime.fromMicrosecondsSinceEpoch(endTime).difference(DateTime.fromMicrosecondsSinceEpoch(startTime))),
                        // print(title),
                        pos = e.data()['pos'] as int,
                        print(DateTime.fromMillisecondsSinceEpoch(startTime)),
                        items.add(
                          TimelineItem(
                            startDateTime:
                                DateTime.fromMillisecondsSinceEpoch(startTime),
                            endDateTime:
                                DateTime.fromMillisecondsSinceEpoch(endTime),
                            position: pos,
                            child: Event(title: title),
                          ),
                        ),
                      }
                  });

          if (items.isNotEmpty) {
            products.add(
              Product(
                  title: document.data()['title'] as String,
                  location: document.data()['location'] as String,
                  description: document.data()['description'] as String,
                  imageURL: document.data()['imgURL'] as String,
                  // duration: document.data()['duration'] as String,
                  duration: '4',
                  items: items
                  // creator_name: document.data()['creator_name'] as String,
                  ),
            );
          }
        });
      }
    });
    update();
  }

  Future<void> downloadDefaultURL() async {
    default_url = await FirebaseStorage.instance
        .ref("upload_default.png")
        .getDownloadURL();
  }

  void addProduct(String name, String location, String description,
      String imageURL, List<TimelineItem> items, String dur) {
    products.add(Product(
        title: name,
        location: location,
        description: description,
        imageURL: imageURL,
        duration: dur,
        items: items));
  }
}
