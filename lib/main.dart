import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:io' show Platform;
import 'homepage.dart';
import '../firebase_options.dart';
import 'firebase_services.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('Running on: ${kIsWeb ? 'Web' : 'Mobile'}');

  try {
    if (kIsWeb) {
      print('Initializing Firebase for Web');
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.web,
      );
    } else {
      print('Initializing Firebase for Mobile');
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  } catch (e) {
    print('Firebase initialization error: $e');
  }

  if (!kIsWeb && Platform.isAndroid) {
    await FirebaseApi().initNotifications();
  }
  
  if (kIsWeb) {
    await Hive.initFlutter('hive');
  } else {
    await Hive.initFlutter();
  }
  
  await Hive.openBox<bool>('likes');
  
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(ProviderScope(
    child: MaterialApp(
      title: "Walls",
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      routes: {
        '/home': (context) => Homepage(),
      },
      home: Homepage(),
    ),
  ));
}

