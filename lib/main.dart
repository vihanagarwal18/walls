import 'package:Walls/firebase_services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'homepage.dart';
import '../firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/services.dart';
// ignore_for_file: prefer_const_constructors

final navigatorKey= GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseApi().initNotifications();

  await Hive.initFlutter();
  await Hive.openBox<bool>('likes');
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(ProviderScope(
      child: MaterialApp(
    debugShowCheckedModeBanner: false,
    //home: Set_as_Wallpaper(),
    navigatorKey: navigatorKey,
    routes: {
      '/home': (context) => Homepage(),
    },
    home: Homepage(),
  )));
}
