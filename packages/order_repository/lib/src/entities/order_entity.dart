import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import '../models/order.dart' as models; // Alias para Order del modelo

class OrderEntity {
  final String orderId;
  final String carId;
  final String carName;
  final String userId;
  final DateTime orderDate;
  final DateTime orderEndDate;
  final String status;
  final String totalAmount;
  final DateTime createdAt;
  final DateTime updatedAt;

  OrderEntity({
    required this.orderId,
    required this.carId,
    required this.carName,
    required this.userId,
    required this.orderDate,
    required this.orderEndDate,
    required this.status,
    required this.totalAmount,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convertir a un documento de Firestore
  Map<String, Object?> toDocument() {
    return {
      'orderId': orderId,
      'carId': carId,
      'carName': carName,
      'userId': userId,
      'orderDate': orderDate,
      'orderEndDate': orderEndDate,
      'status': status,
      'totalAmount': totalAmount,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  // Convertir desde un documento de Firestore
  static OrderEntity fromDocument(Map<String, dynamic> doc) {
    return OrderEntity(
      orderId: doc['orderId'],
      carId: doc['carId'],
      carName: doc['carName'],
      userId: doc['userId'],
      orderDate: (doc['orderDate'] as firestore.Timestamp).toDate(),
      orderEndDate: (doc['orderEndDate'] as firestore.Timestamp).toDate(),
      status: doc['status'],
      totalAmount: doc['totalAmount'],
      createdAt: (doc['createdAt'] as firestore.Timestamp).toDate(),
      updatedAt: (doc['updatedAt'] as firestore.Timestamp).toDate(),
    );
  }

  // Convertir a modelo `Order`
  models.Order toModel() {
    return models.Order(
      orderId: orderId,
      carId: carId,
      carName: carName,
      userId: userId,
      orderDate: orderDate,
      orderEndDate: orderEndDate,
      status: status,
      totalAmount: totalAmount,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  // Crear una entidad desde un modelo `Order`
  static OrderEntity fromModel(models.Order order) {
    return OrderEntity(
      orderId: order.orderId,
      carId: order.carId,
      carName: order.carName,
      userId: order.userId,
      orderDate: order.orderDate,
      orderEndDate: order.orderEndDate,
      status: order.status,
      totalAmount: order.totalAmount,
      createdAt: order.createdAt,
      updatedAt: order.updatedAt,
    );
  }
}
