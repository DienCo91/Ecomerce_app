import 'dart:convert';

import 'package:flutter_app/controllers/auth_controller.dart';
import 'package:flutter_app/models/order_response.dart';
import 'package:flutter_app/utils/api_constants.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class OrderService {
  Future<OrderResponse> getOrderByUser({required int page, required int limit}) async {
    final AuthController user = Get.find<AuthController>();
    final token = user.user.value?.token;

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
}
