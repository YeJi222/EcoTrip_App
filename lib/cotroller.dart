import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'model.dart';

class Controller extends GetxController {

  Controller() {
    getProduct();
    downloadDefaultURL();
  }

  List<Product> products = <Product>[];
  String default_url = '';

  Future<void> getProduct() async {
    FirebaseFirestore.instance
        .collection('products')
        .snapshots()
        .listen((snapshot) async {
      products=[];
      for (final document in snapshot.docs) {
        products.add(
          Product(
              title: document.data()['title'] as String,
              location: document.data()['location'] as String,
              description: document.data()['description'] as String,
              imageURL: document.data()['imgURL'] as String,
              // creator_name: document.data()['creator_name'] as String,
          ),
        );
      }
    });
    update();
  }

  Future<void> downloadDefaultURL() async {
    default_url = await FirebaseStorage.instance
        .ref("upload_default.png")
        .getDownloadURL();
  }

  void addProduct(
      String name, String location, String description, String imageURL) {
    products.add(Product(
        title: name,
        location: location,
        description: description,
        imageURL: imageURL));
  }
}
