import 'package:flutter/material.dart';
import 'package:wallpaper/wallpaper.dart';
class Set_as_Wallpaper extends StatefulWidget {
  const Set_as_Wallpaper({super.key});

  @override
  State<Set_as_Wallpaper> createState() => _Set_as_WallpaperState();
}

class _Set_as_WallpaperState extends State<Set_as_Wallpaper> {
  String home = "Home Screen",
      lock = "Lock Screen",
      both = "Both Screen";
  late Stream<String> progressString;
  late String res;
  bool downloading = false;
  var result = "Waiting to set wallpaper";
  String imageUrl="https://images.pexels.com/photos/9000160/pexels-photo-9000160.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500";
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          margin: EdgeInsets.only(top: 20),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                 Image.network(imageUrl,
                  fit: BoxFit.fitWidth,
                ),
                ElevatedButton(
                  onPressed: () async {
                    await dowloadImage(context);
                    var width = MediaQuery.of(context).size.width;
                    var height = MediaQuery.of(context).size.height;
                    home = await Wallpaper.homeScreen(
                        options: RequestSizeOptions.RESIZE_FIT,
                        width: width,
                        height: height
                    );
                    setState(() {
                      downloading = false;
                      home = home;
                    });
                    print("Task Done");
                  },
                  child: Text(home),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await dowloadImage(context);
                    lock = await Wallpaper.lockScreen();
                    setState(() {
                      downloading = false;
                      lock = lock;
                    });
                    print("Task Done");
                  },
                  child: Text(lock),
                ),
                ElevatedButton(
                  onPressed:() async {
                    await dowloadImage(context);
                    both = await Wallpaper.bothScreen();
                    setState(() {
                      downloading = false;
                      both = both;
                    });
                    print("Task Done");
                  },
                  child: Text(both),
                ),
              ],
            ),
          )),
    );
  }

  Future<void> dowloadImage(BuildContext context) async {
    progressString = Wallpaper.imageDownloadProgress(imageUrl);
    progressString.listen((data) {
      setState(() {
        res = data;
        downloading = true;
      });
      print("DataReceived: " + data);
    }, onDone: () async {
      setState(() {
        downloading = false;
      });
      print("Task Done");
    }, onError: (error) {
      setState(() {
        downloading = false;
      });
      print("Some Error");
    });
  }
}
