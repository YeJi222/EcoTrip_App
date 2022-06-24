import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamic_timeline/dynamic_timeline.dart';
import 'package:awesome_calendar/awesome_calendar.dart';
import 'package:ecotripapp/cotroller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'widget.dart';
import 'package:intl/intl.dart';
import 'package:direct_select/direct_select.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
  final items = <TimelineItem>[];
  var days = <String>[];
  var time = <String>[
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20',
    '21',
    '22',
  ];
  final Controller controller = Get.put(Controller());

  String dropdownvalue = '1';
  int selectedDays = 0;
  int selectedEndTime = 0;
  int selectedStartTime = 0;
  TextEditingController titleController = TextEditingController();
  final _nameController = TextEditingController();
  final _locController = TextEditingController();
  final _descController = TextEditingController();

  List<Widget> _buildDays() {
    return days
        .map((val) => MySelectionItem(
              title: val,
            ))
        .toList();
  }

  List<Widget> _buildTime() {
    return time
        .map((val) => MySelectionItem(
              title: val,
            ))
        .toList();
  }

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

        for (int i = 0; i < picked.length; i++) {
          date_format?[i] =
              DateFormat("yyyy년 MM월 dd일").format(multiOrRangeSelect![i]);
        }
        date_len = multiOrRangeSelect!.length;
        print(date_len);

        setState(() {
          days = [];
          for (int i = 0; i < date_len; i++) {
            days.add((i + 1).toString());
          }
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    verticalController = ScrollController();
    horizontalController = ScrollController();
    print('initState is called');
  }

  @override
  void dispose() {
    super.dispose();
    verticalController.dispose();
    horizontalController.dispose();
    print('dispose is called');
  }

  PickedFile? _image;
  String url = '';
  String creator_name = '';
  int defaultFlag = 0;
  int timestamp = DateTime.now().millisecondsSinceEpoch;
  var image;
  var oldImg;

  Future getGalleryImage() async {
    image = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );
    // if (image != null) {
    //   oldImg = image;
    // }

    setState(() {
      _image = image;
      // if (_image != null)
      //   defaultFlag = 1;
      // else {
      //   _image = oldImg;
      // }
    });
  }

  String default_url = '';
  String select_url = '';

  // Stream<String> img_url() async* {
  //   Future<String> downloadURL() async {
  //     String downloadURL = await FirebaseStorage.instance
  //         .ref("upload_default.png")
  //         .getDownloadURL();
  //
  //     return downloadURL;
  //   }
  //
  //   default_url = await (await downloadURL()).toString();
  //
  //   Future<String> imgURL() async {
  //     String imgURL = await FirebaseStorage.instance
  //         .ref('${timestamp}.png')
  //         .getDownloadURL();
  //
  //     return imgURL;
  //   }
  //
  //   select_url = await (await imgURL()).toString();
  // }

  late final ScrollController verticalController;
  late final ScrollController horizontalController;

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
        body: Container(
          width: 500,
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 25, right: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Add a trip-related image!\n'
                      '(File types supported: JPG, PNG, GIF, SVG, MP4, WEBM,\nMP3, WAV, OGG, GLB, GLTF, Max size: 40 MB)',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: _image==null ? AspectRatio(
                          aspectRatio: 18 / 10,
                          child: CachedNetworkImage(
                            progressIndicatorBuilder: (context, url, progress) =>
                                Center(
                                  child: CircularProgressIndicator(
                                    value: progress.progress,
                                  ),
                                ),
                            imageUrl: controller.default_url,
                            fit: BoxFit.cover,
                          ),
                        ) : AspectRatio(
                          aspectRatio: 18 / 10,
                          child: Image.file(
                            File(_image!.path),
                            fit: BoxFit.fitWidth,
                          ),
                        )
                // child: StreamBuilder(
                //   stream: img_url(),
                //   builder: (context, snapshot) {
                //     if (snapshot.connectionState == ConnectionState.done) {
                //
                //       _image==null ? AspectRatio(
                //         aspectRatio: 18 / 10,
                //         child: CachedNetworkImage(
                //           progressIndicatorBuilder: (context, url, progress) =>
                //               Center(
                //                 child: CircularProgressIndicator(
                //                   value: progress.progress,
                //                 ),
                //               ),
                //           imageUrl: default_url,
                //           fit: BoxFit.cover,
                //         ),
                //       ) : AspectRatio(
                //         aspectRatio: 18 / 10,
                //         child: Image.file(
                //           File(_image!.path),
                //           fit: BoxFit.fitWidth,
                //         ),
                //       );
                //
                //     }
                //     return const CircularProgressIndicator();
                //   },
                // ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton.icon(
                      onPressed: () {
                        getGalleryImage();
                      },
                      icon: const Icon(
                        Icons.cloud_upload_rounded,
                        color: Color(0xff5ac21d),
                      ),
                      label: const Text(
                        'Upload',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color(0xff5ac21d),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        hintText: 'Title',
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
                      controller: _locController,
                      decoration: const InputDecoration(
                        hintText: 'Loaction',
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
                      controller: _descController,
                      decoration: const InputDecoration(
                        hintText: 'Description',
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
                      maxLines: 4,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25),
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
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 15, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
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
                    const SizedBox(
                      width: 10,
                    ),
                    TextButton.icon(
                      onPressed: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => StatefulBuilder(
                          builder: (context, setState) => AlertDialog(
                            title: const Text('Add Plan'),
                            content: Padding(
                              padding: const EdgeInsets.all(5),
                              child: SizedBox(
                                height: 300,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        const Text('Choose Day'),
                                        const SizedBox(
                                          width: 100,
                                        ),
                                        // DropdownButton(
                                        //   value: dropdownvalue,
                                        //   icon: const Icon(Icons.keyboard_arrow_down),
                                        //   items:days.map((String items) {
                                        //     return DropdownMenuItem(
                                        //         value: items,
                                        //         child: Text(items)
                                        //     );
                                        //   }
                                        //   ).toList(),
                                        //   onChanged: (String? newValue){
                                        //     setState(() {
                                        //       dropdownvalue = newValue!;
                                        //     });
                                        //   },
                                        // ),
                                        DirectSelect(
                                            itemExtent: 35.0,
                                            selectedIndex: selectedDays,
                                            onSelectedItemChanged: (index) {
                                              setState(() {
                                                selectedDays = index!;
                                              });
                                            },
                                            items: _buildDays(),
                                            child: MySelectionItem(
                                              isForList: false,
                                              title: days[selectedDays],
                                            )),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        const Text('Start Time'),
                                        const SizedBox(
                                          width: 111,
                                        ),
                                        DirectSelect(
                                            itemExtent: 35.0,
                                            selectedIndex: selectedStartTime,
                                            onSelectedItemChanged: (index) {
                                              setState(() {
                                                selectedStartTime = index!;
                                              });
                                            },
                                            items: _buildTime(),
                                            child: MySelectionItem(
                                              isForList: false,
                                              title: time[selectedStartTime],
                                            )),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        const Text('End Time'),
                                        const SizedBox(
                                          width: 119,
                                        ),
                                        DirectSelect(
                                            itemExtent: 35.0,
                                            selectedIndex: selectedEndTime,
                                            onSelectedItemChanged: (index) {
                                              setState(() {
                                                selectedEndTime = index!;
                                              });
                                            },
                                            items: _buildTime(),
                                            child: MySelectionItem(
                                              isForList: false,
                                              title: time[selectedEndTime],
                                            )),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    TextField(
                                      controller: titleController,
                                      decoration: const InputDecoration(
                                        labelText: 'Title',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'Cancel'),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context, 'Okay');
                                  setState(() {
                                    items.add(
                                      TimelineItem(
                                        startDateTime: DateTime(1970, 1, 1,
                                            int.parse(time[selectedStartTime])),
                                        endDateTime: DateTime(1970, 1, 1,
                                            int.parse(time[selectedEndTime])),
                                        position:
                                            int.parse(days[selectedDays]) - 1,
                                        child: const Event(title: 'title'),
                                      ),
                                    );
                                  });
                                  print(items);
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        ),
                      ).then((_) => setState(() {
                            dropdownvalue = '1';
                            selectedDays = 0;
                            selectedEndTime = 0;
                            selectedStartTime = 0;
                            titleController.text = "";
                          })),
                      icon: const Icon(
                        Icons.insert_invitation_outlined,
                        color: Color(0xff5ac21d),
                        size: 28,
                      ),
                      label: const Text(
                        'Add Plan',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color(0xff5ac21d),
                        ),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 20)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: SizedBox(
                  height: 520,
                  width: 300,
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
                                    date_len,
                                    (index) => DayHeader(day: index),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              DynamicTimeline(
                                firstDateTime: DateTime(1970, 01, 01, 7),
                                lastDateTime: DateTime(1970, 01, 01, 22),
                                labelBuilder: DateFormat('HH:mm').format,
                                intervalDuration: const Duration(hours: 1),
                                crossAxisCount: date_len,
                                intervalExtent: 40,
                                items: items,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5.0),
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
                      String uploadTime = timestamp.toString();
                      final storageRef =
                          FirebaseStorage.instance.ref().child('$uploadTime.png');

                      if (_image != null) {
                        File file = File(_image!.path);
                        await storageRef.putFile(file);

                        url = await storageRef.getDownloadURL();
                      }

                      // controller.addProduct(
                      //     _nameController.text, _locController.text,
                      //     _descController.text, url
                      // );
                      if (url == '') {
                        showSnackBar(context, 'You should upload some Image!');
                      } else {
                        await FirebaseFirestore.instance
                            .collection('products')
                            .doc(uploadTime)
                            .set(<String, dynamic>{
                          'imgURL': url,
                          'title': _nameController.text,
                          'timestamp': uploadTime,
                          'description': _descController.text,
                          'creator_name':
                              FirebaseAuth.instance.currentUser!.displayName,
                          'location': _locController.text
                        });
                      }
                    },
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
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
              ),
            ],
          ),
        ),
        resizeToAvoidBottomInset: false,
      ),
    );
  }
}

class MySelectionItem extends StatelessWidget {
  final String title;
  final bool isForList;

  const MySelectionItem({Key? key, required this.title, this.isForList = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 50.0,
      child: isForList
          ? Padding(
              child: _buildItem(context),
              padding: EdgeInsets.all(0.0),
            )
          : Card(
              margin: EdgeInsets.symmetric(horizontal: 0.0),
              child: Stack(
                children: <Widget>[
                  _buildItem(context),
                ],
              ),
            ),
    );
  }

  _buildItem(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      alignment: Alignment.center,
      child: Text(title),
    );
  }
}
