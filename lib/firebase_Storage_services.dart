import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';


class FirebaseStorageService extends ChangeNotifier{
  FirebaseStorageService();
  static Future<dynamic> loadImage(BuildContext context,String Image)async{
    return await FirebaseStorage.instance.ref().child(Image).getDownloadURL();
  }
}

//widget which is getting images is in homepage.dart