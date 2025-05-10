import 'package:flutter_app/models/orders.dart';
import 'package:flutter_app/models/product_order.dart';
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

  void updateOrderStatus(String orderId, String newStatus) {
    int index1 = orders.indexWhere((o) => o.id == orderId);
    int index2 = orderAll.indexWhere((o) => o.id == orderId);

    if (index1 != -1) {
      Orders currentOrder = orders[index1];

      List<ProductOrder> updatedProducts =
          currentOrder.products.map((productOrder) {
            return productOrder.copyWith(status: newStatus);
          }).toList();

      orders[index1] = currentOrder.copyWith(products: updatedProducts);
    }

    if (index2 != -1) {
      Orders currentOrderAll = orderAll[index2];

      List<ProductOrder> updatedProducts =
          currentOrderAll.products.map((productOrder) {
            return productOrder.copyWith(status: newStatus);
          }).toList();

      orderAll[index2] = currentOrderAll.copyWith(products: updatedProducts);
    }
  }
}
