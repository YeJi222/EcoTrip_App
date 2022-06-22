import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:awesome_calendar/awesome_calendar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_vision/google_ml_vision.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({
    Key? key,
  }) : super(key: key);

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  DateTime initialDate = DateTime.now();
  List<DateTime>? multiOrRangeSelect;
  List<String>? date_format;
  int date_len = 0;

  Future<void> multiOrRangeSelectPicker() async {
    final List<DateTime>? picked = await showDialog<List<DateTime>>(
      context: context,
      builder: (BuildContext context) {
        return const AwesomeCalendarDialog(
          selectionMode: SelectionMode.multi,
          canToggleRangeSelection: true,
        );
      },
    );
    if (picked != null) {
      setState(() {
        multiOrRangeSelect = picked;

        for(int i = 0 ; i < picked.length ; i++) {
          date_format?[i] = DateFormat("yyyy년 MM월 dd일").format(multiOrRangeSelect![i]);
        }
        date_len = multiOrRangeSelect!.length;
        print(date_len);

      });
    }
  }

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

  PickedFile? _image;
  List<String> category = [];
  List<String> savedCategory = [];
  String url = '';
  String creator_name = '';
  int defaultFlag = 0;
  int timestamp = DateTime.now().millisecondsSinceEpoch;
  var image;
  var oldImg;

  GoogleVisionImage? visionImage;
  TextRecognizer textRecognizer = GoogleVision.instance.textRecognizer();
  late VisionText visionText;
  String text = '';

  Future getGalleryImage() async {
    image = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );
    if(image != null){
      oldImg = image;
    }

    setState(() {
      _image = image;
      if(_image != null) defaultFlag = 1;
      else {
        _image = oldImg;
      }
    });

    if(_image != null){
      File file = File(_image!.path);
      visionImage = GoogleVisionImage.fromFile(file);
      visionText = await textRecognizer.processImage(visionImage!);
      text = visionText.text!;
    }

    category=[];
    savedCategory =[];

    final ImageLabeler labeler = GoogleVision.instance.imageLabeler();
    if(_image != null) {
      final List<ImageLabel> labels = await labeler.processImage(visionImage!);

      for (ImageLabel label in labels) {
        final String? text = label.text;

        setState(() {
          category.add(text!);
        });
      }

      labeler.close();
    }
  }

  String default_url = '';
  String select_url = '';

  Stream<String> img_url() async* {
    Future<String> downloadURL() async {
      String downloadURL = await FirebaseStorage.instance
          .ref("upload_default.png")
          .getDownloadURL();

      return downloadURL;
    }

    default_url = await (await downloadURL()).toString();

    Future<String> imgURL() async {
      String imgURL = await FirebaseStorage.instance
          .ref('${timestamp}.png')
          .getDownloadURL();

      return imgURL;
    }

    select_url = await (await imgURL()).toString();
  }

  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: const Color(0xfff9fff8),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text(
            'Upload Trip Plans',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 21,
            ),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          elevation: 0.0,
        ),
        body: ListView(
          children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.only(left: 25, right: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Choose dates for trip*',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  // Text(
                  //   'File types supported: JPG, PNG, GIF, SVG, MP4, WEBM,\nMP3, WAV, OGG, GLB, GLTF, Max size: 40 MB',
                  //   style: TextStyle(
                  //     color: Colors.grey,
                  //     fontSize: 12,
                  //   ),
                  // ),
                ],
              ),
            ),
            // const SizedBox(
            //   height: 10,
            // ),
            // Padding(
            //   padding: EdgeInsets.only(left: 15, right: 15),
            //   child: StreamBuilder(
            //     stream: img_url(),
            //     builder: (context, snapshot) {
            //       if (snapshot.connectionState == ConnectionState.done) {
            //         if (defaultFlag == 0) {
            //           return AspectRatio(
            //             aspectRatio: 18 / 10,
            //             child: Image.network(
            //               default_url,
            //               fit: BoxFit.fitWidth,
            //             ),
            //           );
            //         } else {
            //           return AspectRatio(
            //             aspectRatio: 18 / 10,
            //             child: Image.file(
            //               File(_image!.path),
            //               fit: BoxFit.fitWidth,
            //             ),
            //           );
            //         }
            //       }
            //       return const CircularProgressIndicator();
            //     },
            //   ),
            // ),
            // Padding(
            //   padding: EdgeInsets.only(right: 25),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.end,
            //     children: <Widget>[
            //       TextButton.icon(
            //         onPressed: () {
            //           getGalleryImage();
            //         },
            //         icon: const Icon(
            //           Icons.cloud_upload_rounded,
            //           color: Color(0xff5ac21d),
            //         ),
            //         label: const Text(
            //           'Upload',
            //           style: TextStyle(
            //             fontWeight: FontWeight.bold,
            //             fontSize: 18,
            //             color: Color(0xff5ac21d),
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            Padding(
              padding: EdgeInsets.only(left: 25, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextButton.icon(
                    onPressed: () => multiOrRangeSelectPicker(),
                    icon: const Icon(
                      Icons.date_range,
                      color: Color(0xff5ac21d),
                      size: 28,
                    ),
                    label: const Text(
                      'Choose Dates',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color(0xff5ac21d),
                      ),
                    ),
                  ),
                  // Text(multiOrRangeSelect?.first.toString() ?? ''),
                  // Text(multiOrRangeSelect?.toString() ?? ''),
                  // Text(date_format.toString()),
                  const Padding(padding: EdgeInsets.only(top: 20)),
                ],
              ),
            ),
            SizedBox(
              height: 520,
              child: ListView.builder(
                  itemCount: date_len,
                  itemBuilder: (BuildContext context, int idx){
                    return Container(
                        padding: const EdgeInsets.only(left: 40, right: 40),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'DAY ${idx + 1}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15.0),
                            TextField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                hintText: 'Name',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(width: 2, color: Colors.green),
                                ),
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                fillColor: Colors.white,
                                filled: true,
                              ),
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                              ),
                            ),
                            const SizedBox(height: 12.0),
                            TextField(
                              controller: _priceController,
                              decoration: const InputDecoration(
                                hintText: 'Price',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                ),
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                fillColor: Colors.white,
                                filled: true,
                              ),
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                              ),
                            ),
                            const SizedBox(height: 12.0),
                            TextField(
                              controller: _bioController,
                              decoration: const InputDecoration(
                                hintText: 'Bio',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                ),
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                fillColor: Colors.white,
                                filled: true,
                              ),
                              maxLines: 3,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                              ),
                            ),
                            SizedBox(height: 50),
                          ],
                        ),
                    );
                  }
              ),
            ),
            const SizedBox(height: 20.0),
            Padding(
                padding: EdgeInsets.only(left: 40, right: 40),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color(0xff5ac21d),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: TextButton(
                    onPressed: () async {
                    },
                    child: const Text(
                      'Next',
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ),
          ],
        ),
        resizeToAvoidBottomInset: false,
      ),
    );
  }
}