// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:Walls/fullscreen_image.dart';
import 'package:Walls/liked_images.dart';
import 'firebase_Storage_services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';


class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<String> images_list=[];
  @override
  void initState(){
    getItemList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(images_list);
    return AdvancedDrawer(
      backdrop: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blueGrey, Colors.blueGrey.withOpacity(0.2)],
          ),
        ),
      ),
      //controller: _advancedDrawerController,
      disabledGestures: false,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('About the App'),
            ),
            ListTile(
              title: Row(
                children: [
                  Text('About the Developers'),
                ],
              ),
            ),
            ListTile(
              title: Text('Liked Images'),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LikedWallpapersPage()),
                );
              },
            ),
          ],
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Center(child: Text("hello")),
          leading: IconButton(
            onPressed: _handleMenuButtonPressed,
            icon: ValueListenableBuilder<AdvancedDrawerValue>(
              valueListenable: _advancedDrawerController,
              builder: (_, value, __) {
                return AnimatedSwitcher(
                  duration: Duration(milliseconds: 250),
                  child: Icon(
                    value.visible ? Icons.clear : Icons.menu,
                    key: ValueKey<bool>(value.visible),
                  ),
                );
              },
            ),
          ),
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
          //itemCount: 15,
          itemCount: images_list.length,
          gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemBuilder: (context, index) => GestureDetector(
            onTap: () {
              //_showFullScreenImage(context, (index + 1).toString() + '.png');
              _showFullScreenImage(context, images_list[index].toString());
            },
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: FutureBuilder(
                  //future: _getImage(context, (index + 1).toString() + '.png'),
      
                  future: _getImage(context, images_list[index].toString()),
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
      ),
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
  void getItemList() async {
    print("Fetching started");
    String url = "https://walls-1809-default-rtdb.asia-southeast1.firebasedatabase.app/names.json";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body) as List<dynamic>;
      List<String> aff = [];
      for (var item in jsonData) {
        String name = item['pic'];
        aff.add(name);
      }
      //images_list=aff;
      setState(() {
        images_list = aff;
      });
      // return aff;
    } else {
      print("Failed to fetch data. Status code: ${response.statusCode}");
    }
  }
  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }
}
