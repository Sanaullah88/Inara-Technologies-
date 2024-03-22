import 'dart:io';
import 'package:flutter/material.dart';
import 'package:my_task/api/productapi.dart';
import 'package:http/http.dart' as http;
import 'package:my_task/appbar.dart';
import 'package:my_task/model/model.dart';

class PrductDetail extends StatefulWidget {
  const PrductDetail({Key? key}) : super(key: key);

  @override
  State<PrductDetail> createState() => _PrductDetailState();
}

class _PrductDetailState extends State<PrductDetail> {
  Future<void> deleteProduct(BuildContext context, int productId) async {
    bool? confirmed = await showDeleteConfirmationDialog(context);
    if (!confirmed!) return;

    final response = await http.delete(
      Uri.parse('http://10.0.2.2:8000/products/$productId/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 204) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Product deleted successfully'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete product: ${response.statusCode}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<bool?> showDeleteConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this product?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  MyProduct? allproduct;
  List<Products> myproduct = [];
  Productapi productsapi = Productapi();

  Future<void> fetchproducts() async {
    final data = await productsapi.fetchproduct();
    if (data != null) {
      setState(() {
        allproduct = data;
        myproduct = data.products!;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchproducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(
          title: myproduct.length.toString(),
          onClosePressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Confirm Exit'),
                  content: Text('Are you sure you want to exit the app?'),
                  actions: <Widget>[
                    TextButton(
                      child: Text('No'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text('Yes'),
                      onPressed: () {
                        Navigator.of(context).pop();

                        exit(0);
                      },
                    ),
                  ],
                );
              },
            );
          },
          products:
              myproduct.map((product) => product.name.toString()).toList(),
          onProductSelected: (String product) {
            print('Selected product: $product');
          },
        ),
        body: ListView.builder(
          itemCount: myproduct.length,
          itemBuilder: (BuildContext context, int index) {
            final product = myproduct[index];
            return Card(
              elevation: 5.0,
              margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: ListTile(
                title: Text(
                  'Name: ${product.name}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ID: ${product.id}'),
                    Text('Description: ${product.description}'),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => deleteProduct(context, product.id),
                ),
              ),
            );
          },
        ));
  }
}
