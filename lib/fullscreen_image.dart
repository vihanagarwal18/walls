// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:Walls/providers.dart';
import 'package:dio/dio.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
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

  @override
  Widget build(BuildContext context) {
    imagename = widget.imageName;
    final isLiked = ref.watch(likeStateProvider(widget.imageName));

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
        child: Stack(
          //fit: StackFit.expand,
          children: [
            FutureBuilder<String>(
              future:
                  FirebaseStorageService.loadImage(context, widget.imageName),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  imageUrl = snapshot.data;
                  return CachedNetworkImage(
                      imageUrl: snapshot.data!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Container(color: Colors.red)
                  // return Image.network(
                  //   snapshot.data!,
                    //fit: BoxFit.cover,
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          imagename!.split('.').first,
                          //imagename!,
                          textAlign: TextAlign.left, // not working idk why
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
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
                            Text('Download'),
                          ],
                        ),
                      ),
                      // LikeButton(
                      //   size: 30,
                      //   circleColor: CircleColor(
                      //     start: Color(0xff00ddff),
                      //     end: Color(0xff0099cc),
                      //   ),
                      //   bubblesColor: BubblesColor(
                      //     dotPrimaryColor: Color(0xff33b5e5),
                      //     dotSecondaryColor: Color(0xff0099cc),
                      //   ),
                      //   onTap: onLikeButtonTapped,
                      //   likeBuilder: (bool isLiked) {
                      //     return ValueListenableBuilder(
                      //       valueListenable: Hive.box<bool>('likes')
                      //           .listenable(keys: [widget.imageName]),
                      //       builder: (context, Box<bool> box, _) {
                      //         isLikedT = box.get(widget.imageName) ?? false;
                      //         return Icon(
                      //           Icons.favorite,
                      //           color: isLikedT ? Colors.red : Colors.grey,
                      //           size: 25,
                      //         );
                      //       },
                      //     );
                      //   },
                      // ),
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
                        isLiked: isLiked, // Set the initial state
                        onTap: (bool isLiked) async {
                          // Toggle the like state using Riverpod
                          ref
                              .read(
                                  likeStateProvider(widget.imageName).notifier)
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
                      if (!Platform.isIOS)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () async {
                            var file = await DefaultCacheManager()
                                .getSingleFile(imageUrl!);
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Set Wallpaper'),
                                  content: Text(
                                      'Where would you like to set the wallpaper?'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('Home Screen'),
                                      onPressed: () async {
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                        await _setWallpaper(file.path,
                                            AsyncWallpaper.HOME_SCREEN);
                                      },
                                    ),
                                    TextButton(
                                      child: Text('Lock Screen'),
                                      onPressed: () async {
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                        await _setWallpaper(file.path,
                                            AsyncWallpaper.LOCK_SCREEN);
                                      },
                                    ),
                                    TextButton(
                                      child: Text('Both'),
                                      onPressed: () async {
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                        await _setWallpaper(file.path,
                                            AsyncWallpaper.BOTH_SCREENS);
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
