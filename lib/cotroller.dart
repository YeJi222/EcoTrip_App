import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamic_timeline/dynamic_timeline.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'model.dart';
import 'widget.dart';

class Controller extends GetxController {
  Controller() {
    getProduct();
    downloadDefaultURL();
  }

  List<Product> products = <Product>[];
  String default_url = '';

  // To make getEvent function await.
  Future<List<TimelineItem>> getEvent(
      QueryDocumentSnapshot<Map<String, dynamic>> document) async {
    List<TimelineItem> items = <TimelineItem>[];

    var event_doc = document.data()['events'] as List<dynamic>;

    for (final e in event_doc) {
      items.add(
        TimelineItem(
          startDateTime:
              DateTime.fromMillisecondsSinceEpoch(int.parse(e['startTime'])),
          endDateTime:
              DateTime.fromMillisecondsSinceEpoch(int.parse(e['endTime'])),
          position: e['position'],
          child: Event(title: e['title']),
        ),
      );
    }

    return items;
  }

  Future<List<String>> getChallenges(
      QueryDocumentSnapshot<Map<String, dynamic>> document) async {
    List<String> challenges = <String>[];

    var challenges_db = document.data()['challenges'] as List<dynamic>;

    for (final challenge in challenges_db) {
      challenges.add(challenge['challenge']);
    }

    return challenges;
  }

  Future<List<String>> getImages(
      QueryDocumentSnapshot<Map<String, dynamic>> document) async {
    List<String> images = <String>[];

    var images_db = document.data()['imgURL'] as List<dynamic>;

    for (final img in images_db) {
      images.add(img['url']);
    }

    return images;
  }

  Future<void> getProduct() async {
    FirebaseFirestore.instance
        .collection('products')
        .snapshots()
        .listen((snapshot) async {
      products = [];

      for (final document in snapshot.docs) {
        products.add(
          Product(
            title: document.data()['title'] as String,
            location: document.data()['location'] as String,
            description: document.data()['description'] as String,
            challenges: await getChallenges(document),
            imageURL: await getImages(document),
            duration: document.data()['duration'] as String,
            timestamp: document.data()['timestamp'] as String,
            // By mak getEvent function awaiting, Apps can get data one by one.
            items: await getEvent(document),
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
}

class LoginController extends GetxController {
  LoginController() {}

  List<Product> likeProducts = <Product>[];
  String default_url = '';

  Future<void> getLikeProduct() async {
    FirebaseFirestore.instance
        .collection('user')
        .doc(_uid)
        .collection('favorite')
        .snapshots()
        .listen((event) async {
      likeProducts = <Product>[];
      for (final document in event.docs) {
        Product temp = Product(
          title: document.data()['title'] as String,
          location: document.data()['location'] as String,
          description: document.data()['description'] as String,
          challenges: await getChallenges(document),
          imageURL: await getImages(document),
          duration: document.data()['duration'] as String,
          timestamp: document.data()['timestamp'] as String,
          // By mak getEvent function awaiting, Apps can get data one by one.
          items: await getEvent(document),
        );
        temp.isStored = true;
        likeProducts.add(temp);
      }
      update();
    });
    update();
  }

  Future<List<TimelineItem>> getEvent(
      QueryDocumentSnapshot<Map<String, dynamic>> document) async {
    List<TimelineItem> items = <TimelineItem>[];

    var event_doc = document.data()['events'] as List<dynamic>;

    for (final e in event_doc) {
      items.add(
        TimelineItem(
          startDateTime:
              DateTime.fromMillisecondsSinceEpoch(int.parse(e['startTime'])),
          endDateTime:
              DateTime.fromMillisecondsSinceEpoch(int.parse(e['endTime'])),
          position: e['position'],
          child: Event(title: e['title']),
        ),
      );
    }

    return items;
  }

  Future<List<String>> getChallenges(
      QueryDocumentSnapshot<Map<String, dynamic>> document) async {
    List<String> challenges = <String>[];

    var challenges_db = document.data()['challenges'] as List<dynamic>;

    for (final challenge in challenges_db) {
      challenges.add(challenge['challenge']);
    }

    return challenges;
  }

  Future<List<String>> getImages(
      QueryDocumentSnapshot<Map<String, dynamic>> document) async {
    List<String> images = <String>[];

    var images_db = document.data()['imgURL'] as List<dynamic>;

    for (final img in images_db) {
      images.add(img['url']);
    }

    return images;
  }

  String _name = '';
  String get name => _name;

  String _email = '';
  String get email => _email;

  String _profile_url = '';
  String get profile_url => _profile_url;

  String _uid = '';
  String get uid => _uid;

  String _gender = '';
  String get gender => _gender;

  String _age = '';
  String get age => _age;

  set gender(String value) {
    _gender = value;
  }

  set uid(String value) {
    _uid = value;
  }

  set email(String value) {
    _email = value;
  }

  set profile_url(String value) {
    _profile_url = value;
  }

  set name(String value) {
    _name = value;
  }

  set age(String value) {
    _age = value;
  }
}
