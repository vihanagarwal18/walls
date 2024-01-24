// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';

import 'package:Walls/fullscreen_image.dart';
import 'package:Walls/liked_images.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:expandable/expandable.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;

import 'firebase_services.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<String> images_list = [];
  bool ww = false;
  var list1=[
    'Know the Developers',
    'Vihan Agarwal',
    'Gauransh Sharma'
  ];
  var list2=[

  ];

  final _advancedDrawerController = AdvancedDrawerController();
  @override
  void initState() {
    getItemList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //print(images_list);
    return AdvancedDrawer(
      controller: _advancedDrawerController,
      disabledGestures: false,
      animationCurve: Curves.ease,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      backdropColor: Color.fromARGB(255, 17, 17, 17),
      drawer: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 17, 17, 17),
            ),
            child: heading(), //after 3 flickers it would stop
          ),
          ListTile(
            title: Text(
              'Liked Images',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LikedWallpapersPage()),
              );
            },
          ),
          ExpandableNotifier(
              child:Padding(
                padding: EdgeInsets.all(10.0),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: <Widget>[
                      ScrollOnExpand(
                        theme: ExpandableThemeData.defaults,
                        scrollOnExpand: true,
                        scrollOnCollapse: false,
                        child:ExpandablePanel(
                          header: Text(
                              'know the Developers',
                              style:TextStyle(
                                color: Colors.white,
                                backgroundColor:Color.fromARGB(255, 17, 17, 17),
                              ),
                          ),
                          collapsed: Container(),//Text(
                          //   'Know the Developers',
                          //   style:TextStyle(
                          //     color: Colors.white,
                          //   ),
                          // ),
                          expanded: Text(
                              'hello vihan',
                              style:TextStyle(
                                color: Colors.white,
                              )
                          ),
                        ) ,
                      ),
                    ],
                  ),
                ),
              ),
          ),
          ExpandableNotifier(
            child:Padding(
              padding: EdgeInsets.all(10.0),
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: <Widget>[
                    ScrollOnExpand(
                      theme: ExpandableThemeData.defaults,
                      scrollOnExpand: true,
                      scrollOnCollapse: false,
                      child:ExpandablePanel(
                        header: Text(
                          'know the Developers',
                          style:TextStyle(
                            color: Colors.white,
                            backgroundColor:Color.fromARGB(255, 17, 17, 17),
                          ),
                        ),
                        collapsed: Container(),//Text(
                        //   'Know the Developers',
                        //   style:TextStyle(
                        //     color: Colors.white,
                        //   ),
                        // ),
                        expanded: Text(
                            'hello vihan',
                            style:TextStyle(
                              color: Colors.white,
                            )
                        ),
                      ) ,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ListTile(
          //   title: Row(
          //     children: [
          //       Text(
          //         'Know the Developers',
          //         style: TextStyle(
          //           color: Colors.white,
          //         ),
          //       ),
          //     ],
          //   ),
          //   onTap: (){
          //     showAboutAppDialog_developer(context);
          //   },
          // ),
        ],
      ),
      child: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: Scaffold(
          extendBodyBehindAppBar: true,
          //extendBody: true,
          backgroundColor: Color.fromARGB(255, 17, 17, 17),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Color.fromARGB(150, 17, 17, 17),
            //backgroundColor: Colors.transparent,
            title: Text(
              'Walls',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            centerTitle: true,
            leading: IconButton(
              onPressed: _handleMenuButtonPressed,
              icon: ValueListenableBuilder<AdvancedDrawerValue>(
                valueListenable: _advancedDrawerController,
                builder: (_, value, __) {
                  return AnimatedSwitcher(
                    duration: Duration(seconds: 1),
                    child: Icon(
                      color: Colors.white,
                      value.visible ? Icons.clear : Icons.menu,
                      key: ValueKey<bool>(value.visible),
                    ),
                  );
                },
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.favorite, color: Colors.red),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LikedWallpapersPage()),
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
        ),
      ),
    );
  }

  Future<Widget> _getImage(BuildContext context, String imageName) async {
    try {
      String imageUrl = await FirebaseStorageService.loadImage(
        context,
        imageName,
      );
      return CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => Container(color: Colors.red),
      );
    } catch (e) {
      // print('Error loading image: $e');
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
    // print("Fetching started");
    String url =
        "https://walls-1809-default-rtdb.asia-southeast1.firebasedatabase.app/names.json";
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
      ("Failed to fetch data. Status code: ${response.statusCode}");
    }
  }

  void _handleMenuButtonPressed() {
    setState(() {
                ww = false;
              });

    _advancedDrawerController.showDrawer();
  }
  Widget heading() {
  return Center(
    child: ww == false
        ? SizedBox(
            width: 250.0,
            child: DefaultTextStyle(
              style: const TextStyle(
                fontSize: 90,
                color: Colors.white,
                shadows: [
                  Shadow(
                    blurRadius: 7.0,
                    color: Colors.white,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              child: AnimatedTextKit(
                totalRepeatCount: 3,
                animatedTexts: [
                  FlickerAnimatedText('Walls'),
                ],
                onFinished: () {
                  setState(() {
                    ww = true;
                  });
                },
              ),
            ),
          )
        : TextButton(
            onPressed: () {
              setState(() {
                ww = false;
              });
            },
            child: Text(
              'Walls',
              style: TextStyle(
                fontSize: 90,
                color: Colors.white,
                shadows: [
                  Shadow(
                    blurRadius: 7.0,
                    color: Colors.white,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
            ),
          ),
  );
}
}
