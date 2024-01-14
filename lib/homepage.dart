// // import 'package:flutter/material.dart';
// // import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// // import 'firebase_Storage_services.dart';
// // // ignore_for_file: prefer_const_constructors

// // class Homepage extends StatefulWidget {
// //   const Homepage({super.key});

// //   @override
// //   State<Homepage> createState() => _HomepageState();
// // }

// // class _HomepageState extends State<Homepage> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Center(child: Text("hello")),
// //       ),
// //       body: MasonryGridView.builder(
// //         itemCount: 15,
// //         gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
// //           crossAxisCount: 2,
// //           ), 
// //         itemBuilder: (context,index)=> Padding(
// //           padding: const EdgeInsets.all(5.0),
// //           child: ClipRRect(
// //             borderRadius: BorderRadius.circular(18),
// //             //child: Image.asset('asset/'+(index+1).toString()+'.png'),
// //             child: FutureBuilder(
// //               future: _getImage(context, (index+1).toString()+'.png'),
// //               builder: (context,snapshot){
// //                 if(snapshot.connectionState==ConnectionState.done){
// //                   print(1);
// //                   return Column(
// //                     children: [
// //                       Text("test"),
// //                       Container(
// //                         width: MediaQuery.of(context).size.width/1.2,
// //                         height: MediaQuery.of(context).size.width/1.2,
// //                         child: snapshot.data,
// //                       ),
// //                     ],
// //                   );
// //                 }
// //                 if(snapshot.connectionState==ConnectionState.waiting){
// //                   print(snapshot.connectionState.toString());
      
// //                   return Container(
// //                     width: MediaQuery.of(context).size.width/1.2,
// //                     height: MediaQuery.of(context).size.width/1.2,
// //                     child: Center(child: Container(width: 50, height: 50, child: CircularProgressIndicator()),),
// //                   );
// //                 }
// //                 return Container(
// //                   color: Colors.red,
// //                 );
// //               },
// //               ),
// //             ),
// //         )    
// //           ),
// //           backgroundColor: Colors.green
          
// //           ,
// //     );
// //   }

// //   Future<Widget> _getImage(BuildContext context,String imagename) async{
// //     Image image=Image.asset('pink-panther.png');
// //     await FirebaseStorageService.loadImage(context, imagename).then((value) {
// //       image=Image.network(
// //         value.toString(),
// //         fit: BoxFit.scaleDown,
// //       );
// //       print(
// //         value.toString()
// //       );
// //     });
// //     return image;
// //   }
// // }

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
            child: FutureBuilder(
              future: _getImage(context, (index + 1).toString() + '.png'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  print(1);
                  return Column(
                    children: [
                      Text("test"),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.2,
                        height: MediaQuery.of(context).size.width / 1.2,
                        child: snapshot.data,
                      ),
                    ],
                  );
                } else if (snapshot.connectionState == ConnectionState.waiting) {
                  print(snapshot.connectionState.toString());
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
}


// import 'package:flutter/material.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'firebase_Storage_services.dart';

// class Homepage extends StatefulWidget {
//   const Homepage({Key? key}) : super(key: key);

//   @override
//   State<Homepage> createState() => _HomepageState();
// }

// class _HomepageState extends State<Homepage> {

//   String imageurl2 = "";

//   @override
//   void initState() {
//     _getImage2(context, '1.png');
//     super.initState();
//   }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Center(child: Text("hello")),
//       ),
//       body: Column(
//         children: [
//           MasonryGridView.builder(
//             itemCount: 15,
//             gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//             ),
//             itemBuilder: (context, index) => Padding(
//               padding: const EdgeInsets.all(5.0),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(18),
//                 child: FutureBuilder<String>(
//                   future: _getImage(context, (index + 1).toString() + '.png'),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.done &&
//                         snapshot.hasData) {
//                       print(1);
//                       return Column(
//                         children: [
//                           Text("test"),
//                           Container(
//                             width: MediaQuery.of(context).size.width / 1.2,
//                             height: MediaQuery.of(context).size.width / 1.2,
//                             child: Image.network(
//                               snapshot.data!,
//                               fit: BoxFit.scaleDown,
//                             ),
//                           ),
//                         ],
//                       );
//                     } else if (snapshot.connectionState ==
//                         ConnectionState.waiting) {
//                       print(snapshot.connectionState.toString());
//                       return Container(
//                         width: MediaQuery.of(context).size.width / 1.2,
//                         height: MediaQuery.of(context).size.width / 1.2,
//                         child: Center(
//                           child: CircularProgressIndicator(),
//                         ),
//                       );
//                     } else {
//                       return Container(
//                         color: Colors.red,
//                       );
//                     }
//                   },
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//       backgroundColor: Colors.green,
//     );
//   }

//   Future<String> _getImage(BuildContext context, String imageName) async {
//     try {
//       String imageUrl =
//           await FirebaseStorageService.loadImage(context, imageName);
//       return imageUrl;
//     } catch (e) {
//       print('Error loading image: $e');
//       return '';
//     }
//   }

//   _getImage2(BuildContext context, String imageName) async {
//     try {
//       String imageUrl =
//           await FirebaseStorageService.loadImage(context, imageName);
      
//       setState(() {
//        imageurl2 = imageUrl;
//       });
//     } catch (e) {
//       print('Error loading image: $e');
     
//     }
//   }
// }