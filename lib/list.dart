// // ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
class ListNames extends StatefulWidget {
  const ListNames({Key? key}) : super(key: key);

  @override
  State<ListNames> createState() => _ListNamesState();
}

class _ListNamesState extends State<ListNames> {
  DatabaseReference _databaseReference =
  FirebaseDatabase.instance.ref().child("data");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Data Example'),
      ),
      body: FutureBuilder<DataSnapshot>(
        future: _databaseReference.once() as Future<DataSnapshot>,
        builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
          if (snapshot.hasData) {
            List<dynamic> data = (snapshot.data!.value as List<dynamic>);
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> item = data[index];
                return ListTile(
                  title: Text(item['name']),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

// class ListNames extends StatefulWidget {
//   const ListNames({Key? key}) : super(key: key);
//   @override
//   State<ListNames> createState() => _ListNamesState();
// }
//
// class _ListNamesState extends State<ListNames> {
//   DatabaseReference _databaseReference =
//   FirebaseDatabase.instance.ref().child("data");
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Firebase Data Example'),
//       ),
//       body: FutureBuilder<DataSnapshot>(
//         future: _databaseReference.once() as Future<DataSnapshot>,
//         builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
//           if (snapshot.hasData) {
//             Map<dynamic, dynamic> data =
//             (snapshot.data!.value as Map<dynamic, dynamic>);
//             return ListView.builder(
//               itemCount: data.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(data.values.elementAt(index)['name']),
//                   // Replace 'yourField' with the actual field you want to display.
//                 );
//               },
//             );
//           } else if (snapshot.hasError) {
//             return Center(
//               child: Text('Error: ${snapshot.error}'),
//             );
//           } else {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//         },
//       ),
//     );
//   }
// }

