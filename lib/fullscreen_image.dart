// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:Walls/providers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gallery_saver/gallery_saver.dart';
//import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:like_button/like_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:Walls/firebase_services.dart';
import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class FullScreenImage extends ConsumerStatefulWidget {
  final String imageName;
  FullScreenImage({Key? key, required this.imageName}) : super(key: key);

  @override
  ConsumerState<FullScreenImage> createState() => _FullScreenImageState();
}

class _FullScreenImageState extends ConsumerState<FullScreenImage> {
  String? imageUrl;
  String? imagename;
  late bool isLikedT;
  late Future<String?> imageFuture;

  @override
  void initState() {
    super.initState();

    imageFuture = FirebaseStorageService.loadImage(context, widget.imageName);
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    imagename = widget.imageName;
    final isLiked = ref.watch(likeStateProvider(widget.imageName));

    return ClipRRect(
      // Add ClipRRect here
      borderRadius: BorderRadius.circular(14.0), // Set the border radius
      child: Container(
        // width: w * 1 *0.8,  //(width * 0.80 < 1080) ? width * 0.80 : 1080, //double.infinity,
        // height: (w *0.8* 1.4222), // +  171.805,
        width: w * 0.8,
        height: (w * 0.8 * 1.9689),
        color: Colors
            .black, //(w *0.8* 0.355) ,//((16 * width * 0.79639) / 9) + 57.533298, //(16 * width * .60) / 9,
        child: Column(
          //fit: StackFit.expand,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder<String?>(
              future:
                  imageFuture, // FirebaseStorageService.loadImage(context, widget.imageName),
              builder: (context, snapshot) {
                Widget imageWidget;
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  imageUrl = snapshot.data;
                  imageWidget =  CachedNetworkImage(
                      imageUrl: snapshot.data!,
                      fit: BoxFit.fill,
                      placeholder: (context, url) =>
                          Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          Container(color: Colors.red)
                      // return Image.network(
                      //   snapshot.data!,
                      //fit: BoxFit.cover,
                      );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return _buildLoadingIndicator();
                }  else {
                  return _buildErrorIndicator();
                }

                 return Expanded(
                  child: Column(
                    children: [
                      imageWidget,
                      if (snapshot.connectionState == ConnectionState.done)
                        _buildActionButtons(), // Only show buttons if image is loaded
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    final isLiked = ref.watch(likeStateProvider(widget.imageName));
    return Container(
      height: 62.5,
      decoration: BoxDecoration(color: Color.fromARGB(255, 0, 0, 0)),
      child: Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  disabledForegroundColor: Colors.transparent,
                  disabledBackgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  surfaceTintColor: Colors.transparent,
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  var dio = Dio();
                  var tempDir = await getTemporaryDirectory();
                  var tempPath = tempDir.path;
                  var fullPath = '$tempPath/image.png';

                  await dio.download(imageUrl!, fullPath).then((_) {
                    GallerySaver.saveImage(fullPath).then((bool? success) {
                      Fluttertoast.showToast(
                          msg: "😀 Wallpaper saved to gallery!",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      // FloatingSnackBar(
                      //   message: 'Wallpaper saved to gallery!✅',
                      //   context: context,
                      //   textColor: Colors.black,
                      //   textStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                      //   duration: const Duration(milliseconds: 4000),
                      //   backgroundColor: Colors.white,
                      // );
                    });
                  });
                },
                child: Column(
                  children: [
                    Icon(Icons.download),
                    Text(
                      'Save',
                      style: GoogleFonts.getFont(
                        'Lato',
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 7.5),
              child: Column(
                children: [
                  LikeButton(
                    size: 28,
                    circleColor: CircleColor(
                      start: Color(0xff00ddff),
                      end: Color(0xff0099cc),
                    ),
                    bubblesColor: BubblesColor(
                      dotPrimaryColor: Color(0xff33b5e5),
                      dotSecondaryColor: Color(0xff0099cc),
                    ),
                    isLiked: isLiked, // Set the initial state
                    onTap: (bool isLiked) async {
                      // Toggle the like state using Riverpod
                      ref
                          .read(likeStateProvider(widget.imageName).notifier)
                          .toggleLike();
                      return !isLiked;
                    },
                    likeBuilder: (bool isLiked) {
                      return Icon(
                        Icons.favorite,
                        color: isLiked ? Colors.red : Colors.grey,
                        size: 25,
                      );
                    },
                  ),
                  Text(
                    "Like",
                    style: GoogleFonts.getFont(
                      'Lato',
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            // if (!Platform.isIOS)
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  disabledForegroundColor: Colors.transparent,
                  disabledBackgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  surfaceTintColor: Colors.transparent,
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  var file =
                      await DefaultCacheManager().getSingleFile(imageUrl!);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Set Wallpaper'),
                        content:
                            Text('Where would you like to set the wallpaper?'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Home Screen'),
                            onPressed: () async {
                              Navigator.of(context).pop(); // Close the dialog
                              await _setWallpaper(
                                  file.path, AsyncWallpaper.HOME_SCREEN);
                            },
                          ),
                          TextButton(
                            child: Text('Lock Screen'),
                            onPressed: () async {
                              Navigator.of(context).pop(); // Close the dialog
                              await _setWallpaper(
                                  file.path, AsyncWallpaper.LOCK_SCREEN);
                            },
                          ),
                          TextButton(
                            child: Text('Both'),
                            onPressed: () async {
                              Navigator.of(context).pop(); // Close the dialog
                              await _setWallpaper(
                                  file.path, AsyncWallpaper.BOTH_SCREENS);
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Column(
                  children: [
                    Icon(Icons.wallpaper),
                    Text(
                      'Use as',
                      style: GoogleFonts.getFont(
                        'Lato',
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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

  Future<void> _setWallpaper(String filePath, int wallpaperLocation) async {
    String result;
    try {
      result = await AsyncWallpaper.setWallpaperFromFile(
        filePath: filePath,
        wallpaperLocation: wallpaperLocation,
        goToHome: false,
        toastDetails: ToastDetails.success(),
        errorToastDetails: ToastDetails.error(),
      )
          ? 'Wallpaper set'
          : 'Failed to set wallpaper.';
    } on PlatformException {
      result = 'Failed to set wallpaper.';
    }
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
}


//Name of the image

 // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Row(
                    //     children: [
                    //       Text(
                    //         imagename!.split('.').first,
                    //         //imagename!,
                    //         textAlign: TextAlign.left, // not working idk why
                    //         style: TextStyle(
                    //           fontSize: 15,
                    //           color: Colors.white,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),