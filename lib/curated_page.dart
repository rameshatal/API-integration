import 'dart:convert';

import 'package:api_example/models/curated/curated_photo_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CuratedPage extends StatefulWidget {
  const CuratedPage({super.key});

  @override
  State<CuratedPage> createState() => _CuratedPageState();
}

class _CuratedPageState extends State<CuratedPage> {
  late Future<CuratedPhotoModel> photoCuratedModel;
  @override
  void initState() {
    super.initState();
    photoCuratedModel = getCurated('Car');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Curated'),
      ),
      body:  FutureBuilder<CuratedPhotoModel>(
        future: photoCuratedModel,
        builder: (context, snapshot) {
          if(snapshot.connectionState==ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          } else{
            if(snapshot.hasError){
              return Center(child: Text("Error:${snapshot.error}"),);
            } else if(snapshot.hasData){
              return GridView.builder(
                  itemCount: snapshot.data!.photos!.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 11,
                    mainAxisSpacing: 11,
                    childAspectRatio: 16/9
                  ), itemBuilder: (context, index) {
                   var eachCurated = snapshot.data!.photos![index].src!.portrait!;
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(21),
                        image: DecorationImage(
                          image: NetworkImage(eachCurated),
                          fit: BoxFit.fill
                        )
                      ),
                    );
                  },);
            }
          }
          return Container();
        }
      )
    );
  }

  Future<CuratedPhotoModel> getCurated(String query) async {
    String url = 'https://api.pexels.com/v1/curated?$query&per_page=20';
    var res = await http.get(Uri.parse(url), headers: {
      "Authorization":
          "PfcDSJscGDs056dK4Smv6ngnpXjtnVPylXsqvDSR5sewe8ZPkIs03Se0"
    });
    if (res.statusCode == 200) {
      var mData = jsonDecode(res.body);
      return CuratedPhotoModel.fromJson(mData);
    } else {
      return CuratedPhotoModel();
    }
  }
}
