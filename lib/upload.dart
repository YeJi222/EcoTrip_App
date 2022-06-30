import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamic_timeline/dynamic_timeline.dart';
import 'package:awesome_calendar/awesome_calendar.dart';
import 'package:ecotripapp/cotroller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'model.dart';
import 'widget.dart';
import 'package:intl/intl.dart';
import 'package:direct_select/direct_select.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

// class ApplicationUploadState extends ChangeNotifier{
//   ApplicationUploadState(){
//     init();
//   }
//
//   Future<void> init() async {
//     await Firebase.initializeApp(
//       options: DefaultFirebaseOptions.currentPlatform,
//     );
//
//     FirebaseAuth.instance.userChanges().listen((user) async {
//       if (user != null) {
//         final doc_user = await FirebaseFirestore.instance
//             .collection('user')
//             .doc(FirebaseAuth.instance.currentUser!.uid)
//             .get();
//         if(doc_user.exists == true){
//           _name = doc_user.get('name');
//         }
//         notifyListeners();
//       }
//       notifyListeners();
//     });
//   }
//
//   String _name = '';
//   String get name => _name;
// }

class UploadPage extends StatefulWidget {
  const UploadPage({
    Key? key,
  }) : super(key: key);

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {

  final LoginController loginController = Get.put(LoginController());

  DateTime initialDate = DateTime.now();
  List<DateTime>? multiOrRangeSelect;
  List<String>? date_format;
  int date_len = 0;
  final items = <TimelineItem>[];
  final saves = <SaveEvent>[];
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

  int challenge_len = 0;
  List<TextEditingController> textfield_list = [];
  // TextEditingController tempController = TextEditingController();

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
        // print(date_len);

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

  int timestamp = DateTime.now().millisecondsSinceEpoch;
  List<XFile>? images_list = [];

  Future getGalleryImage() async {
    images_list = [];
    final List<XFile>? selectedImages = await ImagePicker().pickMultiImage();
    if (selectedImages!.isNotEmpty) {
      images_list!.addAll(selectedImages);
    }
    setState((){});
  }

  String default_url = '';
  String select_url = '';

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
          child: ListView.builder(
            itemCount: 1,
            itemBuilder: (BuildContext context, int idx){
              return Column(
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
                    child: images_list!.isEmpty ? AspectRatio(
                      aspectRatio: 18 / 12,
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
                    )
                        : AspectRatio(
                      aspectRatio: 18 / 12,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: images_list!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Image.file(
                              File(images_list![index].path),
                              fit: BoxFit.fitWidth,
                            );
                          }
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 20),
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
                    padding: const EdgeInsets.only(left: 20, right: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Choose dates for trip*',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                              fontSize: 18,
                              color: Color(0xff5ac21d),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        TextButton.icon(
                          onPressed: () {
                            // print('Add plan button');
                            if(date_len != 0){
                              showDialog<String>(
                                context: context,
                                builder: (BuildContext context) =>
                                    StatefulBuilder(
                                      builder: (context, setState) =>
                                          AlertDialog(
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
                                                            )
                                                        ),
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
                                                            )
                                                        ),
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
                                                onPressed: () =>
                                                    Navigator.pop(context, 'Cancel'),
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context, 'Okay');
                                                  setState(() {
                                                    items.add(
                                                      TimelineItem(
                                                        startDateTime: DateTime(
                                                            1970, 1, 1,
                                                            int.parse(
                                                                time[selectedStartTime])),
                                                        endDateTime: DateTime(
                                                            1970, 1, 1,
                                                            int.parse(
                                                                time[selectedEndTime])),
                                                        position:
                                                        int.parse(
                                                            days[selectedDays]) - 1,
                                                        child: Event(title: '${titleController.text}'),
                                                      ),
                                                    );

                                                    saves.add(
                                                      SaveEvent(
                                                          startTime: DateTime(
                                                              2000,
                                                              1,
                                                              1,
                                                              int.parse(
                                                                  time[selectedStartTime])).millisecondsSinceEpoch.toString(),
                                                          endTime: DateTime(2000, 1, 1,
                                                              int.parse(time[selectedEndTime])).millisecondsSinceEpoch.toString(),
                                                          title: titleController.text,
                                                          position:
                                                          int.parse(days[selectedDays]) -
                                                              1),
                                                    );

                                                  });
                                                  // print(items);
                                                },
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          ),
                                    ),
                              ).then((_) =>
                                  setState(() {
                                    dropdownvalue = '1';
                                    selectedDays = 0;
                                    selectedEndTime = 0;
                                    selectedStartTime = 0;
                                    titleController.text = "";
                                  }
                                  )
                              );
                            } else{
                              showSnackBar(context, 'Choose dates for your trip first!!');
                            }
                          },
                          icon: const Icon(
                            Icons.insert_invitation_outlined,
                            color: Color(0xff5ac21d),
                            size: 28,
                          ),
                          label: const Text(
                            'Add Plan',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Color(0xff5ac21d),
                            ),
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(top: 20)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, top: 5, right: 15, bottom: 20),
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
                                      const SizedBox(width: 60),
                                      ...List.generate(
                                        date_len,
                                            (index) => DayHeader(day: index),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  DynamicTimeline(
                                    firstDateTime: DateTime(1970, 01, 01, 6),
                                    lastDateTime: DateTime(1970, 01, 01, 24),
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
                  Padding(
                    padding: const EdgeInsets.only(left: 20,),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add Challenges List',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 130,),
                        IconButton(
                            onPressed: () {
                              challenge_len++;
                              textfield_list.add(TextEditingController());
                              // print(textfield_list.length);

                              // add_challenges(textfield_list, challenge_len);
                              // temp(tempController);
                              setState(() {});


                              // for(int i = 0 ; i < textfield_list.length ; i++){
                              //   print('${i+1} => ${textfield_list[i]}');
                              // }/
                            },
                            icon: Icon(Icons.add_circle_outline)
                        ),
                      ],
                    ),
                  ),
                  if(challenge_len == 0) Container(),
                  if(challenge_len != 0)
                    for(int i = 0 ; i < challenge_len ; i++)
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                        child: TextField(
                          controller: textfield_list[i],
                          decoration: const InputDecoration(
                            hintText: 'Challenge Content',
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
                      ),
                      // Container(
                      //   color: Colors.green,
                      //   width: 100,
                      //   height: 100,
                      // ),
                  Padding(
                      padding: EdgeInsets.only(left: 30, right: 30),
                      child:TextButton(
                        onPressed: () async {
                          if(_nameController.text == "" || _locController.text == ""
                              || _descController.text == ""){
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('You should fill all the blanks!'))
                            );
                          } else{
                            var snackBar = SnackBar(
                              width: 400,
                              elevation: 0,
                              duration: Duration(seconds: 5),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,
                              content: AwesomeSnackbarContent(
                                title: 'Will be uploaded soon~!',
                                message:
                                'Hold on a minute, please',
                                contentType: ContentType.failure,
                              ),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            // showSnackBar(context, 'It will be uploaded soon. Hold on a minute, please');
                            String uploadTime = timestamp.toString();
                            List<String> urlList = [];
                            if (images_list!.isNotEmpty) {
                              // print("not empty");
                              for(int i = 0 ; i < images_list!.length ; i++){
                                File file = File(images_list![i].path);
                                // print(file);
                                // storageRef.putFile(file);
                                final storageRef =
                                FirebaseStorage.instance.ref().child('$uploadTime/$i.png');
                                await storageRef.putFile(file);
                                print(i);
                                // print(await storageRef.getDownloadURL());
                                urlList.add(await storageRef.getDownloadURL());
                                print(urlList[i]);
                                // url.insert(i, storageRef.getDownloadURL());
                              }
                            }
                            // print(images_list); // url 여러개 저장하기 다시
                            // print(url[0]);
                            // print(url[1]);
                            // print(url[2]);

                            // print(url_list.length);
                            if (urlList.isEmpty) {
                              showSnackBar(context, 'You should upload some Image!');
                            } else {
                              await FirebaseFirestore.instance
                                  .collection('products')
                                  .doc(uploadTime)
                                  .set(<String, dynamic>{
                                'imgURL': [
                                  for(int i = 0 ; i < urlList.length ; i++){
                                    'url' : urlList[i],
                                  },
                                ],
                                'challenges': [
                                  for(int i = 0 ; i < challenge_len ; i++){
                                    'challenge' : textfield_list[i].text,
                                  }
                                ],
                                'events': [
                                  for(int i = 0 ; i < saves.length ; i++){
                                    'startTime' : saves[i].startTime,
                                    'endTime' : saves[i].endTime,
                                    'title' : saves[i].title,
                                    'position' : saves[i].position,
                                  }
                                ],
                                'title': _nameController.text,
                                'timestamp': uploadTime,
                                'description': _descController.text,
                                'creator_name': loginController.name,
                                'location': _locController.text
                              }).then((_) => {
                                Timer(Duration(seconds: 1), () {
                                  showSnackBar(context, 'Upload complete!');
                                  Navigator.popAndPushNamed(context, '/navigator');
                                })
                              });
                            }
                          }
                        },
                        child: Container(
                          width: 700,
                          height: 45,
                          decoration: const BoxDecoration(
                              color: Color(0xff69f81b),
                              gradient: LinearGradient(
                                colors: [Color(0xffbff5ad), Color(0xff54c737)],
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(20))),
                          child: const Center(
                            child: Text(
                              'Next',
                              style: TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                        ),
                      )
                  ),
                ],
              );
            }
          ),
        ),
        resizeToAvoidBottomInset: false,
      ),
    );
  }
}

// TextField add_challenges(List<TextEditingController> textfield_list, int idx) {
//   return TextField(
//     controller: textfield_list[idx],
//     decoration:InputDecoration(
//       labelText: 'Challenge',
//     ),
//   );
// }

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
Widget temp(TextEditingController temp) {
  return Container(
    child: TextField(
      controller: temp,
      decoration:InputDecoration(
        labelText: 'Challenge',
      ),
    ),
  );
}