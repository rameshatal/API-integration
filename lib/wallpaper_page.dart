import 'dart:convert';

import 'package:api_example/models/wallpaperModel/data_photo_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WallpaperPage extends StatefulWidget {
  const WallpaperPage({super.key});

  @override
  State<WallpaperPage> createState() => _WallpaperPageState();
}

class _WallpaperPageState extends State<WallpaperPage> {
  late Future<DataPhotoModel> dataPhotoModel;
  @override
  void initState() {
    super.initState();
    dataPhotoModel = getWallpaper('Car');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wllpaper'),
      ),
      body: FutureBuilder<DataPhotoModel>(
          future: dataPhotoModel,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error:${snapshot.error}'),
                );
              } else if (snapshot.hasData) {
                return GridView.builder(
                  itemCount: snapshot.data!.photos!.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 11,
                      mainAxisSpacing: 11,
                      childAspectRatio: 16 / 9),
                  itemBuilder: (context, index) {
                    var eachWallpaper =
                        snapshot.data!.photos![index].src!.portrait!;
                    return Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(21),
                          image: DecorationImage(
                              image: NetworkImage(eachWallpaper),
                              fit: BoxFit.cover)),
                    );
                  },
                );
              }
            }
            return Container();
          }),
    );
  }

  Future<DataPhotoModel> getWallpaper(String query) async {
    String url = 'https://api.pexels.com/v1/search?query=$query&per_page=20';
    var res = await http.get(Uri.parse(url), headers: {
      "Authorization":
          "PfcDSJscGDs056dK4Smv6ngnpXjtnVPylXsqvDSR5sewe8ZPkIs03Se0"
    });
    if (res.statusCode == 200) {
      var mData = jsonDecode(res.body);
      return DataPhotoModel.fromJson(mData);
    } else {
      return DataPhotoModel();
    }
  }
}
