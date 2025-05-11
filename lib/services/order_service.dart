import 'dart:convert';

import 'package:flutter_app/controllers/auth_controller.dart';
import 'package:flutter_app/models/login_response.dart';
import 'package:flutter_app/models/order_response.dart';
import 'package:flutter_app/models/orders.dart';
import 'package:flutter_app/utils/api_constants.dart';
import 'package:flutter_app/utils/string.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

class OrderService {
  Future<OrderResponse> getOrderByUser({required int page, required int limit}) async {
    final token = getToken();

    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/api/order/me?page=${page}&limit=${limit}'),
      headers: {'Authorization': token.toString(), 'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return OrderResponse.fromJson(jsonData);
    } else {
      throw Exception('Failed to load orders: ${response.statusCode}');
    }
  }

  Future<OrderResponse> getOrderAll({required int page, required int limit}) async {
    final AuthController user = Get.find<AuthController>();
    final token = user.user.value?.token;

    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/api/order?page=${page}&limit=${limit}'),
      headers: {'Authorization': token.toString(), 'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return OrderResponse.fromJson(jsonData);
    } else {
      throw Exception('Failed to load orders: ${response.statusCode}');
    }
  }

  Future<Orders> getOrderById({required String id}) async {
    final storage = GetStorage();
    final userData = Map<String, dynamic>.from(storage.read('user'));
    final loginResponse = LoginResponse.fromJson(userData);
    final token = loginResponse.token;

    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/api/order/$id'),
      headers: {'Authorization': token.toString(), 'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body)['order'];
      return Orders.fromJson(jsonData);
    } else {
      throw Exception('Failed to load orders: ${response.statusCode}');
    }
  }

  Future<String> addOrder({required String cartId, required int total}) async {
    final AuthController user = Get.find<AuthController>();
    final token = user.user.value?.token;

    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/api/order/add'),
      headers: {'Authorization': token.toString(), 'Content-Type': 'application/json'},
      body: jsonEncode({'cartId': cartId, 'total': total}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body)['order'];
      return responseData['_id'];
    } else {
      throw Exception('Failed to add orders: ${response.statusCode}');
    }
  }

  Future<bool> deleteOrder({required String orderId}) async {
    final AuthController user = Get.find<AuthController>();
    final token = user.user.value?.token;

    final response = await http.delete(
      Uri.parse('${ApiConstants.baseUrl}/api/order/cancel/$orderId'),
      headers: {'Authorization': token.toString(), 'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to delete orders: ${response.statusCode}');
    }
  }

  Future<bool> updateStatusOrder({
    required String orderId,
    required String cartId,
    required String status,
    required String productId,
  }) async {
    final AuthController user = Get.find<AuthController>();
    final token = user.user.value?.token;

    final response = await http.put(
      Uri.parse('${ApiConstants.baseUrl}/api/order/status/item/$productId'),
      headers: {'Authorization': token.toString(), 'Content-Type': 'application/json'},
      body: jsonEncode({'cartId': cartId, 'orderId': orderId, 'status': status}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to delete orders: ${response.statusCode}');
    }
  }
}
