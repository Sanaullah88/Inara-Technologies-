import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:my_task/api/productapi.dart';
import 'package:my_task/appbar.dart';
import 'package:my_task/model/model.dart';
import 'package:my_task/productdetail.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  MyProduct? allproduct;
  List<Products> myproduct = [];
  Productapi productsapi = new Productapi();

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
    setState(() {
      fetchproducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _descriptionController =
        TextEditingController();

    Future<void> submitForm(String name, String description) async {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/products/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'name': name,
          'description': description,
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Product submitted successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PrductDetail()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit product'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

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
        products: myproduct.map((product) => product.name.toString()).toList(),
        onProductSelected: (String product) {
          print('Selected product: $product');
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                hintText: 'Enter your name',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                hintText: 'Enter product description',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter product description';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_nameController.text.isEmpty ||
                    _descriptionController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please fill in all fields'),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else {
                  submitForm(_nameController.text, _descriptionController.text);
                  print('Name: ${_nameController.text}');
                  print('Description: ${_descriptionController.text}');
                }
              },
              child: Text('Submit'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PrductDetail()),
                );
              },
              child: Text('View Product'),
            ),
          ],
        ),
      ),
    );
  }
}
