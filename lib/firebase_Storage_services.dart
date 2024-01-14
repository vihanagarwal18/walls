import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';


// class FirebaseStorageService extends ChangeNotifier{
//   FirebaseStorageService();
//   static Future<dynamic> loadImage(BuildContext context,String Image)async{
//     return await FirebaseStorage.instance.ref().child(Image).getDownloadURL();
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService extends ChangeNotifier {
  FirebaseStorageService();

  static Future<String> loadImage(BuildContext context, String imageName) async {
    try {
      final ref = FirebaseStorage.instance.ref().child(imageName);
      final imageUrl = await ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print('Error loading image: $e');
      return ''; // Return an empty string or handle the error appropriately
    }
  }
}


//widget which is getting images is in homepage.dart