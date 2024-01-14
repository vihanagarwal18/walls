// import 'package:flutter/material.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'firebase_Storage_services.dart';
// // ignore_for_file: prefer_const_constructors

// class Homepage extends StatefulWidget {
//   const Homepage({super.key});

//   @override
//   State<Homepage> createState() => _HomepageState();
// }

// class _HomepageState extends State<Homepage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Center(child: Text("hello")),
//       ),
//       body: MasonryGridView.builder(
//         itemCount: 15,
//         gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//         ),
//         itemBuilder: (context, index) => Padding(
//           padding: const EdgeInsets.all(5.0),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(18),
//             child: FutureBuilder(
//               future: _getImage(context, (index + 1).toString() + '.png'),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.done &&
//                     snapshot.hasData) {
//                   //print(1);
//                   return Column(
//                     children: [
//                       //Text("test"),
//                       Container(
//                         width: MediaQuery.of(context).size.width / 1.2,
//                         height: MediaQuery.of(context).size.width / 1.2,
//                         child: snapshot.data,
//                       ),
//                     ],
//                   );
//                 } else if (snapshot.connectionState == ConnectionState.waiting) {
//                   //print(snapshot.connectionState.toString());
//                   return Container(
//                     width: MediaQuery.of(context).size.width / 1.2,
//                     height: MediaQuery.of(context).size.width / 1.2,
//                     child: Center(
//                       child: CircularProgressIndicator(),
//                     ),
//                   );
//                 } else {
//                   return Container(
//                     color: Colors.red,
//                   );
//                 }
//               },
//             ),
//           ),
//         ),
//       ),
//       backgroundColor: Colors.green,
//     );
//   }

//   Future<Widget> _getImage(BuildContext context, String imageName) async {
//     try {
//       String imageUrl = await FirebaseStorageService.loadImage(
//         context,
//         imageName,
//       );
//       return Image.network(
//         imageUrl,
//         fit: BoxFit.scaleDown,
//       );
//     } catch (e) {
//       print('Error loading image: $e');
//       return Container(color: Colors.red);
//     }
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'firebase_Storage_services.dart';
// ignore_for_file: prefer_const_constructors

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
      ),
      body: MasonryGridView.builder(
        itemCount: 15,
        gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(5.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: InkWell(
              onTap: () {
                _navigateToFullScreenImage(context, index);
              },
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
        fit: BoxFit.scaleDown,
      );
    } catch (e) {
      print('Error loading image: $e');
      return Container(color: Colors.red);
    }
  }

  void _navigateToFullScreenImage(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImage(index: index),
      ),
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final int index;

  FullScreenImage({required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Full Screen Image"),
      ),
      body: Center(
        child: FutureBuilder(
          future: _getImage(context, (index + 1).toString() + '.png'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              return Image.network(snapshot.data as String);
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else {
              return Container(color: Colors.red);
            }
          },
        ),
      ),
    );
  }

  Future<String> _getImage(BuildContext context, String imageName) async {
    try {
      return await FirebaseStorageService.loadImage(
        context,
        imageName,
      );
    } catch (e) {
      print('Error loading image: $e');
      return '';
    }
  }
}
