import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/login_response.dart';
import 'package:flutter_app/utils/showSnackBar.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path/path.dart';
import 'package:flutter_app/controllers/auth_controller.dart';
import 'package:flutter_app/models/product_response.dart';
import 'package:flutter_app/models/products.dart';
import 'package:flutter_app/utils/api_constants.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ProductService {
  Future<ProductResponse> fetchProducts(Map<String, dynamic> data) async {
    final storage = GetStorage();
    final userData = Map<String, dynamic>.from(storage.read('user'));
    final loginResponse = LoginResponse.fromJson(userData);
    final token = loginResponse.token;

    Uri uri = Uri.parse(
      '${ApiConstants.baseUrl}/api/product/list',
    ).replace(queryParameters: data.map((key, value) => MapEntry(key, value.toString())));

    final response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json; charset=UTF-8', 'Authorization': token},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> dataResponse = jsonDecode(response.body);
      return ProductResponse.fromJson(dataResponse);
    } else {
      throw Exception("Error fetching products");
    }
  }

  Future<List<Products>> fetchAllProducts() async {
    final AuthController user = Get.find<AuthController>();
    final token = user.user.value?.token;
    Uri uri = Uri.parse('${ApiConstants.baseUrl}/api/product');

    final response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json; charset=UTF-8', 'Authorization': '$token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> dataResponse = jsonDecode(response.body)['products'];
      return dataResponse.map((e) => Products.fromJson(e)).toList();
    } else {
      throw Exception("Error fetching products");
    }
  }

  Future<bool> deleteProductById(String id) async {
    final AuthController user = Get.find<AuthController>();
    final token = user.user.value?.token;
    Uri uri = Uri.parse('${ApiConstants.baseUrl}/api/product/delete/$id');

    final response = await http.delete(
      uri,
      headers: {'Content-Type': 'application/json; charset=UTF-8', 'Authorization': '$token'},
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception("Error fetching products");
    }
  }

  Future<Products> addProduct({
    required String sku,
    required String name,
    required String description,
    required String price,
    required String quantity,
    required bool isActive,
    File? file,
    String? taxable = '0',
    String? brand = '681e02dddaffec1a9c0ac0c0',
  }) async {
    final AuthController user = Get.find<AuthController>();
    final token = user.user.value?.token;
    Uri uri = Uri.parse('${ApiConstants.baseUrl}/api/product/add');

    final request = http.MultipartRequest('POST', uri)..headers['Authorization'] = '$token';

    request.fields['sku'] = sku;
    request.fields['name'] = name;
    request.fields['description'] = description;
    request.fields['price'] = price;
    request.fields['quantity'] = quantity;
    request.fields['isActive'] = isActive ? 'true' : 'false';
    request.fields['taxable'] = taxable ?? '0';
    request.fields['brand'] = brand ?? '';

    if (file != null) {
      request.files.add(await http.MultipartFile.fromPath('image', file.path, filename: basename(file.path)));
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return Products.fromJson(jsonDecode(response.body)['product']);
    } else {
      showSnackBar(message: jsonDecode(response.body)['error'], backgroundColor: Colors.red);
      throw Exception('Lỗi gửi sản phẩm: ${response.statusCode} - ${response.body}');
    }
  }

  Future<Products> updateProduct({
    required String id,
    required String sku,
    required String name,
    required String description,
    required String price,
    required String quantity,
    required bool isActive,
    File? file,
    bool? taxable = false,
    List<String>? brand = const ["681e02dddaffec1a9c0ac0c0"],
    bool removeImage = false,
  }) async {
    final AuthController user = Get.find<AuthController>();
    final token = user.user.value?.token;
    Uri uri = Uri.parse('${ApiConstants.baseUrl}/api/product/$id');

    final request = http.MultipartRequest('PUT', uri)..headers['Authorization'] = '$token';

    request.fields['sku'] = sku;
    request.fields['name'] = name;
    request.fields['description'] = description;
    request.fields['price'] = price;
    request.fields['quantity'] = quantity;
    request.fields['isActive'] = isActive ? 'true' : 'false';
    request.fields['taxable'] = (taxable ?? false) ? '1' : '0';
    request.fields['brand'] = (brand ?? []).join(',');
    request.fields['removeImage'] = removeImage.toString();

    if (file != null) {
      request.files.add(await http.MultipartFile.fromPath('image', file.path, filename: basename(file.path)));
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return Products.fromJson(jsonDecode(response.body)['product']);
    } else {
      showSnackBar(message: jsonDecode(response.body)['error'], backgroundColor: Colors.red);
      throw Exception('Error update: ${response.statusCode} - ${response.body}');
    }
  }
}
