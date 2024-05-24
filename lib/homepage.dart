// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';
import 'dart:io' show Platform;
import 'package:Walls/fullscreen_image.dart';
import 'package:Walls/liked_images.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:expandable/expandable.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'firebase_services.dart';
import 'package:flutter/foundation.dart'; // This provides the kIsWeb constant

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<String> images_list = [];
  bool ww = false;
  // var list1 = ['Know the Developers', 'Vihan Agarwal', 'Gauransh Sharma'];
  // var list2 = [];

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
      drawer: Container(
        child: Column(
          children: [
            Expanded(
              child: ListView(
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
                        MaterialPageRoute(
                            builder: (context) => LikedWallpapersPage()),
                      );
                    },
                  ),
                  Container(
                    color: Color.fromARGB(255, 17, 17, 17),
                    child: ExpandableNotifier(
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          child: Container(
                            color: Color.fromARGB(255, 17, 17, 17),
                            child: Column(
                              children: <Widget>[
                                ScrollOnExpand(
                                  theme: ExpandableThemeData.defaults,
                                  scrollOnExpand: true,
                                  scrollOnCollapse: false,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Column(
                                      children: [
                                        ExpandablePanel(
                                          header: Text(
                                            'Know the Developers',
                                            style: TextStyle(
                                              color: Colors.white,
                                              backgroundColor: Color.fromARGB(
                                                  255, 17, 17, 17),
                                            ),
                                          ),
                                          collapsed: Container(
                                            color:
                                                Color.fromARGB(255, 17, 17, 17),
                                          ),
                                          expanded: Container(
                                            color:
                                                Color.fromARGB(255, 17, 17, 17),
                                            child: Column(
                                              children: [
                                                TextButton(
                                                  onPressed: () async {
                                                    _launchURL(
                                                        'https://github.com/vihanagarwal18',
                                                        'https',
                                                        'github.com',
                                                        '/vihanagarwal18');
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.link,
                                                        color: Colors.white,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 10,
                                                                right: 5),
                                                        child: Text(
                                                          'Vihan Agarwal',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    _launchURL(
                                                        "https://github.com/gauransh18",
                                                        'https',
                                                        'github.com',
                                                        '/gauransh18');
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.link,
                                                        color: Colors.white,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 10,
                                                                right: 5),
                                                        child: Text(
                                                            'Gauransh Sharma',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                            )),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    title: Container(
                      child: kIsWeb
                          ? TextButton(
                              // onPressed: () {},
                              onPressed: () async {
                                Uri apkUrl =Uri.parse('here link will come');
                                if (await canLaunchUrl(apkUrl)) {
                                  await launchUrl(apkUrl);
                                }
                                else {
                                  throw 'Could not launch $apkUrl';
                                }
                              },
                              child: Text(
                                'Download APK',
                                style: TextStyle(
                                  color: Colors.white,
                                  backgroundColor:
                                      Color.fromARGB(255, 17, 17, 17),
                                ),
                              ),
                            )
                          : SizedBox.shrink(),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24.0),
              color: Color.fromARGB(
                  255, 17, 17, 17), // Match the drawer's background color
              child: GestureDetector(
                onTap: () async {
                  _launchURL('https://github.com/vihanagarwal18/walls', 'https',
                      'github.com', '/vihanagarwal18/walls');
                },
                child: Text(
                  "Github • V1.0",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      child: Scaffold(
        // extendBodyBehindAppBar: true,
        // extendBody: true,
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
        body: RefreshIndicator(
          onRefresh: () async {
            setState(() {});
          },
          child: MasonryGridView.builder(
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
        placeholder: (context, url) =>
            Center(child: CircularProgressIndicator()),
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

  // void getItemList() async {
  //   // print("Fetching started");
  //   String url =
  //       "https://walls-1809-default-rtdb.asia-southeast1.firebasedatabase.app/names.json";
  //   var response = await http.get(Uri.parse(url));
  //   if (response.statusCode == 200) {
  //     var jsonData = jsonDecode(response.body) as List<dynamic>;
  //     print(jsonData);
  //     List<String> aff = [];
  //     for (var item in jsonData) {
  //       String name = item['pic'];
  //       aff.add(name);
  //     }
  //     //images_list=aff;
  //     setState(() {
  //       images_list = aff;
  //     });
  //     // return aff;
  //   } else {
  //     ("Failed to fetch data. Status code: ${response.statusCode}");
  //   }
  // }

  void getItemList() async {
    // print("Fetching started");
    String url =
        // "https://walls-1809-default-rtdb.asia-southeast1.firebasedatabase.app/names.json";
        "https://trywallsnow-default-rtdb.asia-southeast1.firebasedatabase.app/names.json";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body) as List<dynamic>;
      List<String> aff = [];
      for (var item in jsonData) {
        // Check if 'pic' is not null before using it
        if (item['pic'] != null) {
          String name = item['pic'];
          aff.insert(0, name);
          //aff.add(name);
        }
      }
      setState(() {
        images_list = aff;
      });
    } else {
      print("Failed to fetch data. Status code: ${response.statusCode}");
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
          ? Center(
              child: Container(
                width: 250.0,
                child: DefaultTextStyle(
                  style: const TextStyle(
                    fontSize: 80,
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
                    totalRepeatCount: 2,
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
              ),
            )
          : Center(
              child: TextButton(
                onPressed: () {
                  setState(() {
                    ww = false;
                  });
                },
                child: Text(
                  'Walls',
                  style: TextStyle(
                    fontSize: 80,
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
            ),
    );
  }

  Future<void> _launchURL(
      String url, String scheme, String host, String path) async {
    final Uri uri = Uri(scheme: scheme, host: host, path: path);
    if (Platform.isAndroid) {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw 'Could not launch $url';
      }
    }

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}
