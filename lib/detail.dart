import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecotripapp/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:scroll_page_view/pager/page_controller.dart';
import 'package:scroll_page_view/pager/scroll_page_view.dart';
import 'package:dynamic_timeline/dynamic_timeline.dart';
import 'package:intl/intl.dart';
import 'cotroller.dart';
import 'model.dart';
import 'widget.dart';
import 'package:readmore/readmore.dart';

class DetailPage extends StatefulWidget {
  const DetailPage(this.product, {Key? key}) : super(key: key);
  final Product product;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final LoginController loginController = Get.put(LoginController());
  late final ScrollController verticalController;
  late final ScrollController horizontalController;

  late Product product = Product(
      title: "",
      description: "",
      imageURL: [],
      location: "",
      timestamp: "",
      items: [],
      duration: '0'
  );

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

  late List<String> img_url = [];
  @override
  void initState() {
    verticalController = ScrollController();
    horizontalController = ScrollController();

    setState(() {
      product = widget.product;
      for(int i = 0 ; i < product.imageURL.length ; i++){
        img_url.add(product.imageURL[i]);
        // print(img_url);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                // color: Colors.black,
              ),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
            elevation: 0.0,
            actions: [
              IconButton(
                visualDensity: VisualDensity(horizontal: -4),
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.bookmark_add_outlined,
                  // Icons.bookmark_add,
                  // color: Colors.black,
                ),
                onPressed: (){
                  if(product.isStored == false) {
                    DocumentReference copyFrom = FirebaseFirestore.instance
                        .collection('products')
                        .doc(product.timestamp);
                    DocumentReference copyTo = FirebaseFirestore.instance
                        .collection('user')
                        .doc(loginController.uid)
                        .collection('favorite')
                        .doc();

                    copyFrom.get().then((value) => {copyTo.set(value.data())});
                  }
                },
              ),
              IconButton(
                padding: EdgeInsets.only(right: 10),
                onPressed: shareScreenshot,
                icon: const Icon(
                  Icons.file_upload_outlined,
                  // color: Colors.black,
                ),
              ),
            ],
          ),
          extendBodyBehindAppBar: true,
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Screenshot(
                  controller: _screenshotController,
            child: Container(
              color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 330,
                        child: ScrollPageView(
                          checkedIndicatorColor: Colors.green,
                          delay: Duration(seconds: 3),
                          controller: ScrollPageController(),
                          // children: _images.map((image) => _imageView(image)).toList(),
                          children: img_url.map((image) => _imageView(image)).toList(),
                        ),
                      ),
                      SizedBox(height: 15),
                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                                  const Icon(
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
                            const Divider(
                              height: 30,
                              thickness: 1.5,
                              indent: 2,
                              endIndent: 10,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10, bottom: 10, right: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Description',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  ReadMoreText(
                                    product.description,
                                    trimLines: 5,
                                    style: const TextStyle(
                                        color: Colors.black
                                    ),
                                    colorClickableText: Colors.red,
                                    trimMode: TrimMode.Line,
                                    trimCollapsedText: ' Read more',
                                    trimExpandedText: ' ...Briefly',
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Text(
                                    'Trip Plans With Challenges',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20, top: 5, right: 20, bottom: 30),
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
                ),
              ),
            ],
          ),
      ),
    );
  }

  Widget _imageView(String image) {
    return Image.network(image, fit: BoxFit.cover);
  }
}