import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:Walls/fullscreen_image.dart';
import 'firebase_Storage_services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class LikedWallpapersPage extends StatefulWidget {
  @override
  _LikedWallpapersPageState createState() => _LikedWallpapersPageState();
}

class _LikedWallpapersPageState extends State<LikedWallpapersPage> {
  @override
  Widget build(BuildContext context) {
    final box = Hive.box<bool>('likes');
    final likedImages = box.keys.where((key) => box.get(key) == true).toList();

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 17, 17, 17),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text('Liked Wallpapers',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        //backgroundColor: Colors.transparent,
        backgroundColor: Color.fromARGB(150, 17, 17, 17),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: MasonryGridView.builder(
          gridDelegate:  SliverSimpleGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemCount: likedImages.length,
          itemBuilder: (context, index) {
            final imageName = likedImages[index];
            return GestureDetector(
              onTap: () {
                _showFullScreenImage(context, imageName);
              },
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: FutureBuilder(
                    future: FirebaseStorageService.loadImage(context, imageName),
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.hasData) {
                        return Image.network(
                          snapshot.data!,
                          fit: BoxFit.cover,
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator(
                          color: Colors.white,
                        ));
                      } else {
                        // Handle the error state
                        return Center(child: Text('Error loading image'));
                      }
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
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
}
