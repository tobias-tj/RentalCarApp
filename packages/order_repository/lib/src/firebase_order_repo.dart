import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:order_repository/order_repository.dart';
import 'package:order_repository/src/entities/entities.dart' as entities;
import 'package:order_repository/src/models/order.dart'
    as models; // Alias para Order del modelo

class FirebaseOrderRepo implements OrderRepo {
  final ordersCollection =
      firestore.FirebaseFirestore.instance.collection('orders');

  @override
  Future<List<models.Order>> getOrders() async {
    try {
      final querySnapshot = await ordersCollection.get();
      return querySnapshot.docs
          .map((doc) => entities.OrderEntity.fromDocument(doc.data()).toModel())
          .toList();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> addOrder(models.Order order) async {
    try {
      final orderEntity = entities.OrderEntity.fromModel(order);
      await ordersCollection.doc(order.orderId).set(orderEntity.toDocument());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> updateOrder(models.Order order) async {
    try {
      final orderEntity = entities.OrderEntity.fromModel(order);
      await ordersCollection
          .doc(order.orderId)
          .update(orderEntity.toDocument());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> deleteOrder(String orderId) async {
    try {
      await ordersCollection.doc(orderId).delete();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> updateStatusPaymentOrder(
      String userId, String carId, String orderId, String status) async {
    try {
      final orderDoc = ordersCollection
          .where('userId', isEqualTo: userId)
          .where('carId', isEqualTo: carId)
          .where('orderId', isEqualTo: orderId);
      final querySnapshot = await orderDoc.get();
      if (querySnapshot.docs.isNotEmpty) {
        final orderDocId = querySnapshot.docs.first.id;
        await ordersCollection.doc(orderDocId).update({'status': status});
        print('Order status updated to $status');
      } else {
        log('Order not found');
      }
    } catch (e) {
      print('Error updating order status: $e');
    }
  }

  @override
  Future<List<Order>> getOrdersByUserId(String userId) async {
    try {
      final querySnapshot =
          await ordersCollection.where('userId', isEqualTo: userId).get();
      return querySnapshot.docs
          .map((doc) => entities.OrderEntity.fromDocument(doc.data()).toModel())
          .toList();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
