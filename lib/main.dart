import 'package:flutter/material.dart';
import 'homepage.dart';
import '../firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// ignore_for_file: prefer_const_constructors

void main() async { 
  
  
    WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  
  runApp(MaterialApp(

  

  debugShowCheckedModeBanner: false,
  home: Homepage(),
));
}