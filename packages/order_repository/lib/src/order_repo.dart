import 'package:order_repository/src/models/order.dart';

abstract class OrderRepo {
  Future<List<Order>> getOrders();
  Future<void> addOrder(Order order);
  Future<void> updateOrder(Order order);
  Future<void> deleteOrder(String orderId);
  Future<void> updateStatusPaymentOrder(
      String userId, String carId, String orderId, String status);
  Future<List<Order>> getOrdersByUserId(String userId);
}
