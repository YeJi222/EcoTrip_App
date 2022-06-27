import 'dart:async';
import 'dart:io';
import 'package:ecotripapp/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:scroll_page_view/pager/page_controller.dart';
import 'package:scroll_page_view/pager/scroll_page_view.dart';

class DetailPage extends StatefulWidget {
  const DetailPage(this.product, {Key? key}) : super(key: key);
  final Product product;

  @override
  State<StatefulWidget> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final _screenshotController = ScreenshotController();
  Future<void> shareScreenshot() async {
    final directory;
    if (Platform.isAndroid) {
      directory = await getExternalStorageDirectory();
    } else {
      directory = await getApplicationDocumentsDirectory();
    }
    final String localPath =
        '${directory!.path}/${product.title}/${DateTime.now()}.png';
    print(localPath);

    await _screenshotController.captureAndSave(localPath);

    await FlutterShare.shareFile(
        title: 'Compartilhar comprovante',
        filePath: localPath,
        fileType: 'image/png'
    );
  }

  static const _images = [
    'https://firebasestorage.googleapis.com/v0/b/fluttercamp-67707.appspot.com/o/1656285583450.png?alt=media&token=20b7c448-29b3-4f76-8fe1-92a44d7e32a9',
    'https://firebasestorage.googleapis.com/v0/b/fluttercamp-67707.appspot.com/o/1656285583450.png?alt=media&token=20b7c448-29b3-4f76-8fe1-92a44d7e32a9',
    'https://firebasestorage.googleapis.com/v0/b/fluttercamp-67707.appspot.com/o/1656285583450.png?alt=media&token=20b7c448-29b3-4f76-8fe1-92a44d7e32a9',
    'https://firebasestorage.googleapis.com/v0/b/fluttercamp-67707.appspot.com/o/1656285583450.png?alt=media&token=20b7c448-29b3-4f76-8fe1-92a44d7e32a9',
  ];

  Future<void> precache() async {
    for (var image in _images) {
      precacheImage(NetworkImage(image), context);
    }
  }

  late Product product = const Product(
      title: '',
      location: '',
      description: '',
      imageURL: ''
  );

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      precache();
      WidgetsBinding.instance.addPostFrameCallback((_) { // null check
        setState(() {
          product = widget.product;
          // latitudeS = double.parse(product.latitude);
          // longtitudeS = double.parse(product.longitude);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Screenshot(
        controller: _screenshotController,
        child: Scaffold(
            body: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Stack(
                    children: [
                      SizedBox(
                        height: 330,
                        child: ScrollPageView(
                          checkedIndicatorColor: Colors.green,
                          delay: Duration(seconds: 3),
                          controller: ScrollPageController(),
                          children: _images.map((image) => _imageView(image)).toList(),
                        ),
                      ),
                      Positioned(
                        top: 50,
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: (){
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      Positioned(
                        top: 50,
                        right: 40,
                        child: IconButton(
                          icon: Icon(
                            Icons.bookmark_added_outlined,
                            color: Colors.white,
                          ),
                          onPressed: (){
                            Navigator.pushNamed(context, '/favorite');
                          },
                        ),
                      ),
                      Positioned(
                        top: 50,
                        right: 5,
                        child: IconButton(
                          onPressed: shareScreenshot,
                          icon: const Icon(
                            Icons.file_upload_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 350),
                            Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Text(
                                product.title,
                                style: const TextStyle(
                                  // fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                  fontFamily: 'jua',
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Colors.redAccent,
                                ),
                                const SizedBox(
                                  width: 2,
                                ),
                                Text(
                                  product.location,
                                  style: const TextStyle(
                                    // fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    fontFamily: 'jua',
                                  ),
                                ),
                              ]
                            ),
                            Divider(
                              height: 30,
                              thickness: 1.5,
                              indent: 2,
                              endIndent: 10,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ),
      ),
    );
  }

  Widget _imageView(String image) {
    return Image.network(image, fit: BoxFit.cover);
  }
}