import 'package:ecotripapp/profile.dart';
import 'package:ecotripapp/upload.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'package:ecotripapp/editProfile.dart';
import 'firebase_options.dart';
import 'home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ApplicationHomeState()),
        ChangeNotifierProvider(create: (context) => ApplicationState()),
        ChangeNotifierProvider(create: (context) => EditState()),
        ChangeNotifierProvider(create: (context) => ApplicationUploadState()),
      ],
      child: const TravelApp(),
    ),
  );
}