import 'package:flutter_app/models/orders.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  var orders = <Orders>[].obs;
  var orderAll = <Orders>[].obs;

  void addOrder(Orders order) {
    orders.add(order);
  }

  void updateOrder(Orders updatedOrder) {
    int index = orders.indexWhere((o) => o.id == updatedOrder.id);
    if (index != -1) {
      orders[index] = updatedOrder;
    }
  }

  void deleteOrder(String orderId) {
    orders.removeWhere((order) => order.id == orderId);
  }

  void addOrderAll(Orders order) {
    orderAll.add(order);
  }

  void updateOrderAll(Orders updatedOrder) {
    int index = orderAll.indexWhere((o) => o.id == updatedOrder.id);
    if (index != -1) {
      orderAll[index] = updatedOrder;
    }
  }

  void deleteOrderAll(String orderId) {
    orderAll.removeWhere((order) => order.id == orderId);
  }
}
