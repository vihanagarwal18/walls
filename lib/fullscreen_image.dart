// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:like_button/like_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:Walls/firebase_Storage_services.dart';
import 'package:wallpaper/wallpaper.dart';


class FullScreenImage extends StatefulWidget {
  final String imageName;

  FullScreenImage({Key? key, required this.imageName}) : super(key: key);

  @override
  State<FullScreenImage> createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  String? imageUrl;

  String home = "Home Screen",
      lock = "Lock Screen",
      both = "Both Home & Lock Screen";
  late Stream<String> progressString;
  late String res;
  //bool downloading = false;
  var result = "Waiting to set wallpaper";

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black,
      child: Stack(
        //fit: StackFit.expand,
        children: [
          FutureBuilder<String>(
            future: FirebaseStorageService.loadImage(context, widget.imageName),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                imageUrl = snapshot.data;
                return Image.network(
                  snapshot.data!,
                  //fit: BoxFit.cover,
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildLoadingIndicator();
              } else {
                return _buildErrorIndicator();
              }
            },
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () async {
                        var dio = Dio();
                        var tempDir = await getTemporaryDirectory();
                        var tempPath = tempDir.path;
                        var fullPath = '$tempPath/image.png';

                        await dio.download(imageUrl!, fullPath).then((_) {
                          GallerySaver.saveImage(fullPath)
                              .then((bool? success) {
                            print('Image is saved to Gallery');
                          });
                        });
                      },
                      child: Column(
                        children: [
                          Icon(Icons.download),
                          Text('Download'),
                        ],
                      ),
                    ),
                    LikeButton(
                      size: 30,
                      circleColor: CircleColor(
                        start: Color(0xff00ddff),
                        end: Color(0xff0099cc),
                      ),
                      bubblesColor: BubblesColor(
                        dotPrimaryColor: Color(0xff33b5e5),
                        dotSecondaryColor: Color(0xff0099cc),
                      ),
                      onTap: onLikeButtonTapped,
                      likeBuilder: (bool isLiked) {
                        return ValueListenableBuilder(
                          valueListenable: Hive.box<bool>('likes')
                              .listenable(keys: [widget.imageName]),
                          builder: (context, Box<bool> box, _) {
                            var isLikedT = box.get(widget.imageName,
                                    defaultValue: false) ??
                                false;
                            return Icon(
                              Icons.favorite,
                              color: isLikedT ? Colors.red : Colors.grey,
                              size: 25,
                            );
                          },
                        );
                      },
                    ),
                    if (!Platform.isIOS)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          _showOptionsPopupMenu(context);
                        },
                        child: Column(
                          children: [
                            Icon(Icons.wallpaper),
                            Text('Set as Wallpaper'),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> onLikeButtonTapped(bool isLiked) async {
    final box = Hive.box<bool>('likes');
    await box.put(widget.imageName, !isLiked);
    return !isLiked;
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorIndicator() {
    return Container(
      color: Colors.red,
    );
  }

  void _showFullScreenImage(BuildContext context, String imageName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: FullScreenImage(imageName: imageName),
        );
      },
    );
  }

  Future<void> dowloadImage(BuildContext context) async {
    print(1);
    progressString = Wallpaper.imageDownloadProgress(imageUrl!);
    progressString.listen((data) {
      setState(() {
        res = data;
        //downloading = true;
      });
      //print("DataReceived: " + data);
    }, onDone: () async {
      setState(() {
        //downloading = false;
      });
      print("Task Done");
    }, onError: (error) {
      setState(() {
        //downloading = false;
      });
      print("Some Error");
    });
  }

  void _showOptionsPopupMenu(BuildContext context) async {
    //final String? selectedOption = await showMenu<String>(
    await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(100, 100, 0, 0), // will edit this during UI
      items: <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'Home Screen',
          child: Text('Home Screen'),
          onTap: () async{
            await dowloadImage(context);
            print(2);
            home = await Wallpaper.homeScreen(
                //options: RequestSizeOptions.RESIZE_FIT,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
            );
            setState(() {
              //downloading = false;
              home = home;
            });
          },
        ),
        PopupMenuItem<String>(
          value: 'Lock Screen',
          child: Text('Lock Screen'),
          onTap: () async {
            await dowloadImage(context);
            print(3);
            lock = await Wallpaper.lockScreen();
            setState(() {
              //downloading = false;
              lock = lock;
            });
            print("Task Done");
          },
        ),
        PopupMenuItem<String>(
          value: 'Both Home & Lock Screen',
          child: Text('Both Home & Lock Screen'),
          onTap: ()async {
            await dowloadImage(context);
            print(4);
            both = await Wallpaper.bothScreen();
            setState(() {
              //downloading = false;
              both = both;
            });
            print("Task Done");
          },
        ),
      ],
    );
  }
}


