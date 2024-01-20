// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class ListNames extends StatefulWidget {
  const ListNames({Key? key}) : super(key: key);
  @override
  State<ListNames> createState() => _ListNamesState();
}

class _ListNamesState extends State<ListNames> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Data Example'),
      ),
    );
  }
  Future<List<String>> getItemList() async {
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
      return aff;
    } else {
      print("Failed to fetch data. Status code: ${response.statusCode}");
      return [];
    }
  }
}

