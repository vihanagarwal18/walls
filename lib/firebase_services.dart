import 'package:Walls/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class FirebaseStorageService extends ChangeNotifier {
  FirebaseStorageService();

  static Future<String> loadImage(
      BuildContext context, String imageName) async {
    try {
      final ref = FirebaseStorage.instance.ref().child(imageName);
      final imageUrl = await ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      return '';
    }
  }
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();

    // final fCMToken = await _firebaseMessaging.getToken();
    // print("Token: $fCMToken");


if (defaultTargetPlatform == TargetPlatform.iOS) {
      String? apnsToken = await _firebaseMessaging.getAPNSToken();
      if (apnsToken == null) {
        // Optionally, you could implement a more sophisticated retry logic here
        await Future<void>.delayed(const Duration(seconds: 3));
        apnsToken = await _firebaseMessaging.getAPNSToken();
        if (apnsToken == null) {
          // print('Unable to get APNS token');
          return;
        }
      }
    }

    // Now that we have the APNS token, we can safely get the FCM token
     await Future.delayed(Duration(seconds: 1));
String? fCMToken = await _firebaseMessaging.getToken();
    print("FCM Token: $fCMToken");

    // Subscribe to a topic
    // String personID = ""; // replace with your topic
    // await _firebaseMessaging.subscribeToTopic(personID);
   
  }

  void handleNotifications(RemoteMessage? message) {
    if (message == null) return;

    navigatorKey.currentState?.pushNamed('/home');
  }
}
