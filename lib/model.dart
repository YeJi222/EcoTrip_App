import 'package:dynamic_timeline/dynamic_timeline.dart';

class Product {
  Product({
    required this.title,
    required this.description,
    // required this.trueChallenge,
    required this.challenges,
    required this.imageURL,
    required this.location,
    required this.items,
    required this.duration,
    required this.timestamp
  });

  final String title;
  final String location;
  final String description;
  // final List<String> trueChallenge;
  final List<SaveChallenge> challenges;
  final List<String> imageURL;
  final List<TimelineItem> items;
  final String duration;
  final String timestamp;

  bool isStored=false;
}

class SaveEvent {
  const SaveEvent(
      {required this.startTime,
      required this.endTime,
      required this.title,
      required this.position});

  final String startTime;
  final String endTime;
  final String title;
  final int position;
}

class SaveChallenge {
  const SaveChallenge(
      {required this.challenge,
        required this.checked});

  final String challenge;
  final bool checked;
}

class TrueChecked {
  TrueChecked({
    required this.challenge,
    required this.checked
  });

  final List<String> challenge;
  final List<bool> checked;

  // final String challenge;
  // final bool checked;

  bool isTrue=false;
}