class Order {
  String orderId;
  String carId;
  String carName;
  String userId;
  DateTime orderDate;
  DateTime orderEndDate;
  String status;
  String totalAmount;
  DateTime createdAt;
  DateTime updatedAt;

  Order({
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
}
