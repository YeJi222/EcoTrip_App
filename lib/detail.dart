import 'dart:async';
import 'dart:io';
import 'package:ecotripapp/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:scroll_page_view/pager/page_controller.dart';
import 'package:scroll_page_view/pager/scroll_page_view.dart';
import 'package:dynamic_timeline/dynamic_timeline.dart';
import 'package:intl/intl.dart';
import 'model.dart';
import 'widget.dart';

class DetailPage extends StatefulWidget {
  const DetailPage(this.product, {Key? key}) : super(key: key);
  final Product product;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {

  late final ScrollController verticalController;
  late final ScrollController horizontalController;

  late Product product = const Product(
      title: "",
      description: "",
      imageURL: "",
      location: "",
      items: [],
      duration: '0');

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
    'https://firebasestorage.googleapis.com/v0/b/fluttercamp-67707.appspot.com/o/1656048076693.png?alt=media&token=b69d6890-93a8-45bc-84c9-4eb4ab6d4588',
    'https://firebasestorage.googleapis.com/v0/b/fluttercamp-67707.appspot.com/o/1656048260589.png?alt=media&token=8c73edf3-db2d-4e58-9d58-87c43d2c5fd5',
    'https://firebasestorage.googleapis.com/v0/b/fluttercamp-67707.appspot.com/o/1656336591838.png?alt=media&token=3e95b51c-0da7-4691-97d5-7087c7e762e6',
  ];

  Future<void> precache() async {
    for (var image in _images) {
      precacheImage(NetworkImage(image), context);
    }
  }

  @override
  void initState() {
    verticalController = ScrollController();
    horizontalController = ScrollController();
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
    print(product.items);
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
                            color: Colors.black,
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
                            color: Colors.black,
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
                            color: Colors.black,
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // SizedBox(
                                //   width: 420,
                                //   height: 420,
                                //   child: Stack(
                                //     children: [
                                //       Positioned(
                                //         top: -20,
                                //         left: -15,
                                //         child: SizedBox(
                                //           width: 420,
                                //           height: 420,
                                //           child: CachedNetworkImage(
                                //             progressIndicatorBuilder: (context, url, progress) =>
                                //                 Center(
                                //                   child: CircularProgressIndicator(
                                //                     value: progress.progress,
                                //                   ),
                                //                 ),
                                //             imageUrl: product.imageURL,
                                //             fit: BoxFit.cover,
                                //           ),
                                //         ),
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: SizedBox(
                                    height: 520,
                                    width: 400,
                                    child: Scrollbar(
                                      thumbVisibility: true,
                                      controller: horizontalController,
                                      child: Scrollbar(
                                        controller: verticalController,
                                        child: SingleChildScrollView(
                                          controller: horizontalController,
                                          scrollDirection: Axis.horizontal,
                                          child: SingleChildScrollView(
                                            controller: verticalController,
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    const SizedBox(width: 60),
                                                    ...List.generate(
                                                      int.parse(product.duration),
                                                          (index) => DayHeader(day: index),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 20),
                                                DynamicTimeline(
                                                  firstDateTime: DateTime(2000, 01, 01, 7),
                                                  lastDateTime: DateTime(2000, 01, 01, 22),
                                                  labelBuilder: DateFormat('HH:mm').format,
                                                  intervalDuration: const Duration(hours: 1),
                                                  crossAxisCount: int.parse(product.duration),
                                                  intervalExtent: 40,
                                                  items: product.items,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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