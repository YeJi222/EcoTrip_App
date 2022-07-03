import 'dart:io';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'cotroller.dart';
import 'firebase_options.dart';

String profile_url = '';

class EditState extends ChangeNotifier{
  EditState(){
    init();
  }

  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FirebaseAuth.instance.userChanges().listen((user) async {
      if (user != null) {
        final doc_user = await FirebaseFirestore.instance
            .collection('user')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();
        if(doc_user.exists == true){
          _profile_url = doc_user.get('profile_url');
          print(_profile_url);
        }
        notifyListeners();
      }
      notifyListeners();
    });
  }

  String _profile_url = '';
  String get profile_url => _profile_url;
}

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key, String? title,}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {

  final LoginController loginController = Get.put(LoginController());

  bool isDarkModeEnabled = false;

  final _nameController = TextEditingController();
  final _genderController = TextEditingController();
  final _ageController = TextEditingController();
  final _addressController = TextEditingController();

  PickedFile? _image;
  int defaultFlag = 0;
  String url = '';
  String origin_url = '';
  var image;
  var oldImg;
  int timestamp = DateTime.now().millisecondsSinceEpoch;

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
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Color(0xfff9fff8),
        appBar: AppBar(
          backgroundColor: Color(0xfff9fff8),
          leading: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                width: 10,
              ),
              Image.asset(
                'img/leaf.png',
                height: 35,
              ),
              const SizedBox(
                width: 8,
              ),
              DefaultTextStyle(
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                child: AnimatedTextKit(
                  animatedTexts: [
                    WavyAnimatedText('EcoTrip'),
                  ],
                  isRepeatingAnimation: true,
                  repeatForever: true,
                  onTap: () {
                    print("Tap Event");
                  },
                ),
              ),
            ],
          ),
          leadingWidth: 250,
          elevation: 0.0,
          actions: [
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.notifications_none_outlined,
                  color: Colors.black,
                  size: 28,
                )),
            // IconButton(
            //     onPressed: () {},
            //     icon: const Icon(
            //       Icons.bookmark_added_outlined,
            //       color: Colors.black,
            //       size: 28,
            //     )),
            SizedBox(
              width: 10,
            )
          ],
        ),
        extendBodyBehindAppBar: true,
        body: ListView(
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: [
                Positioned(
                    top: 5.0,
                    left: 20,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                        size: 30,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                ),
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 120,
                        // child: Image.asset(
                        //   'img/profile_back.png',
                        //   fit: BoxFit.fill,
                        // ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 25.0,
                  child: CircleAvatar(
                    radius: 80,
                    backgroundColor: Colors.white,
                    child: Consumer<EditState>(
                        builder: (context, appState, _) {
                          origin_url = appState.profile_url;
                          if(defaultFlag == 0){
                            return Container(
                              width: 150,
                              height: 150,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100.0),
                                child: Image.network(
                                  appState.profile_url,
                                  // 'https://lh3.googleusercontent.com/a-/AOh14GhIF7h_cMzyLADYmzEvtkAB4qeZPb_sKWl9DF15=s96-c',
                                  // '${FirebaseAuth.instance.currentUser?.photoURL}',
                                  // photoURL ?? default_url,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          } else{
                            return Container(
                              width: 150,
                              height: 150,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100.0),
                                child: Image.file(
                                  File(_image!.path),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          }
                        }
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 65),
            Padding(
              padding: EdgeInsets.only(left: 30, right: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: TextButton.icon(
                      onPressed: () {
                        getGalleryImage();
                      },
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.green,
                      ),
                      label: const Text(
                        'Change Photo',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25.0),
                  Container(
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black38,
                          blurRadius: 5,
                          offset: Offset(0, 7),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: (loginController.name=="") ? 'Name' : loginController.name,
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                        // enabledBorder: OutlineInputBorder(
                        //   borderSide: const BorderSide(width: 2, color: Colors.green),
                        // ),
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
                  const SizedBox(height: 20.0),
                  Container(
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black38,
                          blurRadius: 5,
                          offset: Offset(0, 7),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _genderController,
                      decoration: InputDecoration(
                        hintText: (loginController.gender=="") ? 'Gender' : loginController.gender,
                        hintStyle: const TextStyle(
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
                  const SizedBox(height: 20.0),
                  Container(
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black38,
                          blurRadius: 5,
                          offset: Offset(0, 7),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _ageController,
                      decoration: InputDecoration(
                        hintText: (loginController.age=="") ? 'Age' : loginController.age,
                        hintStyle: const TextStyle(
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
                  const SizedBox(height: 20.0),
                  Container(
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black38,
                          blurRadius: 5,
                          offset: Offset(0, 7),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        hintText: (loginController.address=="") ? 'Address' : loginController.address,
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      maxLines: 5,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                      ),
                    ),
                  ),
                  const SizedBox(height: 55.0),
                  Center(
                    child: TextButton(
                      onPressed: () async {
                        if(_nameController.text == "" || _genderController.text == ""
                            || _ageController.text == "" || _addressController.text == ""){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('You should fill all the blanks!')));
                        } else{
                          var snackBar = SnackBar(
                            elevation: 0,
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.transparent,
                            content: AwesomeSnackbarContent(
                              title: '프로필 수정 완료!',
                              message:
                              '잠시 후 프로질 페이지로 돌아갑니다.',
                              contentType: ContentType.warning,
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);

                          final storageRef = FirebaseStorage.instance
                              .ref()
                              .child('${timestamp}.png');

                          if (_image != null) {
                            File file = File(_image!.path);
                            await storageRef.putFile(file);

                            url = await storageRef.getDownloadURL();
                          }

                          if(url == '') url = origin_url;

                          await FirebaseFirestore.instance
                              .collection('user')
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .update(<String, dynamic>{
                            'name': _nameController.text,
                            'profile_url': url,
                            'gender': _genderController.text,
                            'age': _ageController.text,
                            'address': _addressController.text,
                          });

                          loginController.changeProfile(url,_nameController.text,_genderController.text,_ageController.text, _addressController.text);

                          Timer(
                              const Duration(seconds: 2),
                                  () => Navigator.pop(context)
                          );
                        }
                      },
                      child: Container(
                        width: 300,
                        height: 50,
                        decoration: const BoxDecoration(
                            color: Color(0xff69f81b),
                            gradient: LinearGradient(
                              colors: [Color(0xffbff5ad), Color(0xff54c737)],
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(20))),
                        child: const Center(
                          child: Text(
                            'Save & Logout',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        // bottomNavigationBar: floatingBar(context),
      ),
    );
  }
}