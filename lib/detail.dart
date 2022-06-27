import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamic_timeline/dynamic_timeline.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  @override
  void initState() {
    super.initState();
    verticalController = ScrollController();
    horizontalController = ScrollController();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      // null check
      setState(() {
        product = widget.product;
      });
    });
    print(product.items);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff9fff8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            // Navigator.pop(context);
            print(product.items.first.startDateTime);
            print(product.items.first.endDateTime);
          },
        ),
        elevation: 0.0,
      ),
      extendBodyBehindAppBar: true,
      body: ListView(children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 420,
              height: 420,
              child: Stack(
                children: [
                  Positioned(
                    top: -20,
                    left: -15,
                    child: SizedBox(
                      width: 420,
                      height: 420,
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
                  ),
                ],
              ),
            ),
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
                                const SizedBox(width: 30),
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
      ]),
    );
  }
}
