// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wallpaper/fullscreen_image.dart';
import 'package:wallpaper/liked_images.dart';
import 'firebase_Storage_services.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("hello")),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LikedWallpapersPage()),
              );
            },
          ),
        ],
      ),
      body: MasonryGridView.builder(
        itemCount: 15,
        gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            _showFullScreenImage(context, (index + 1).toString() + '.png');
          },
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: FutureBuilder(
                future: _getImage(context, (index + 1).toString() + '.png'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    return Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 1.2,
                          height: MediaQuery.of(context).size.width / 1.2,
                          child: snapshot.data,
                        ),
                      ],
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      height: MediaQuery.of(context).size.width / 1.2,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else {
                    return Container(
                      color: Colors.red,
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.green,
    );
  }

  Future<Widget> _getImage(BuildContext context, String imageName) async {
    try {
      String imageUrl = await FirebaseStorageService.loadImage(
        context,
        imageName,
      );
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
      );
    } catch (e) {
      print('Error loading image: $e');
      return Container(color: Colors.red);
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
