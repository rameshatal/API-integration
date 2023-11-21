import 'dart:convert';

import 'package:api_example/models/products/ProductModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductsPage extends StatefulWidget {
  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  late Future<ProductModel> dataModel;
  @override
  void initState() {
    super.initState();
    dataModel = getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          title: Text('Products'),
        ),
        body: FutureBuilder<ProductModel>(
          future: dataModel,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.hasError) {
                return Center(
                  child: Text("Erorr:${snapshot.error}"),
                );
              } else if (snapshot.data != null &&
                  snapshot.data!.products != null &&
                  snapshot.data!.products!.isNotEmpty) {
                return ListView.builder(
                  itemCount: snapshot.data!.hashCode!.bitLength,
                  itemBuilder: (context, index) {
                    var eachProduct = snapshot.data!.products![index];
                    return SizedBox(
                      height: 300,
                      child: Card(
                        elevation: 7,
                        child: Column(
                          children: [
                            ListTile(
                              leading: eachProduct.thumbnail != null
                                  ? Image.network(eachProduct.thumbnail!)
                                  : Image.asset("name"),
                              title: Text('${eachProduct.title}'),
                              subtitle: Text('${eachProduct.description}'),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: eachProduct.images!.length,
                                    itemBuilder: (context, subIndex) {
                                    return Image.network(eachProduct.images![subIndex]);
                                    },),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Container(
                  child: Text('No Data'),
                );
              }
            }
          },
        ));
  }

  Future<ProductModel> getProducts() async {
    String url = 'https://dummyjson.com/products';
    var res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);
      return ProductModel.fromJson(data);
    } else {
      return ProductModel();
    }
  }
}
