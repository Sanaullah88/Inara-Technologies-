import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:my_task/model/model.dart';

class Productapi {
  Future<MyProduct?> fetchproduct() async {
    try {
      final response = await http.post(
        Uri.parse("http://10.0.2.2:8000/all-products/"),
      );

      if (response.statusCode == 200) {
        final cjson = response.body;
        MyProduct product = MyProduct.fromJson(json.decode(cjson));
        return product;
      } else {
        print("Failed to fetch product. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }
}
