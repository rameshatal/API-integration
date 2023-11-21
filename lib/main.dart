import 'dart:convert';

import 'package:api_example/products_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'models/QuoteModel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: ProductsPage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<QuoteModel> data;
  @override
  void initState() {
    super.initState();
    data = getQuotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('API'),
      ),
      body: FutureBuilder<QuoteModel>(
        future: data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.hasError) {
              return Center(
                child: Text('${snapshot.error}'),
              );
            } else if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.quotes!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Text('${index + 1}'),
                    title: Text(snapshot.data!.quotes![index].quote!),
                    subtitle: Text(snapshot.data!.quotes![index].author!),
                  );
                },
              );
            }
          }
          return Container();
        },
      ),
    );
  }

  Future<QuoteModel> getQuotes() async {
    var res = await http.get(Uri.parse("https://dummyjson.com/quotes"));

    if (res.statusCode == 200) {
      var json = jsonDecode(res.body);
      return QuoteModel.fromJson(json);
    } else {
      return QuoteModel();
    }
  }
}
