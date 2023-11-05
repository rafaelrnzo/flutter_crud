import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_crud/Product.dart';
import 'package:http/http.dart' as http;

Future<List<Product>> fetchApi() async {
  final response =
      await http.get(Uri.parse('http://127.0.0.1:8000/api/product'));

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    List<Product> products =
        data.map((item) => Product.fromJson(item)).toList();
    return products;
  } else {
    throw Exception('Failed to load Products');
  }
}

Future<void> deleteProduct(String id) async {
  final response = await http.get(
    Uri.parse('http://127.0.0.1:8000/api/product/$id/delete'),
  );

  if (response.statusCode == 200) {
    print('Product deleted successfully');
    
    
  } else {
    throw Exception('Failed to delete product');
  }

}

class Homepage extends StatefulWidget {
  const Homepage({Key? key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late Future<List<Product>> product;

  @override
  void initState() {
    super.initState();
    product = fetchApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter CRUD')),
      body: FutureBuilder<List<Product>>(
        future: product,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Display a loading indicator while fetching data
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            final productList = snapshot.data!;
            return Container(
              child: SingleChildScrollView(
                child: Column(
                  children: productList
                      .map((item) => SizedBox(
                            width: double.infinity,
                            child: Card(
                              margin: EdgeInsets.all(16),
                              child: Container(
                                padding: EdgeInsets.all(16),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Image.network(item.photo),
                                    Text(item.name),
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        deleteProduct(item.id.toString());
                                        setState(() {
                                          
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
            );
          } else {
            return Text('No products found.');
          }
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        // Add the action when the FAB is pressed
      }),
    );
  }
}
