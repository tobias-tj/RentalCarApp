class Car {
  String carId;
  String userId;
  String name;
  String cv;
  String transmission;
  String people;
  String photo;
  String priceDay;
  String engine;
  String type;
  bool isPublish;
  DateTime createdAt;
  DateTime updateAt;

  Car({
    required this.carId,
    required this.userId,
    required this.name,
    required this.cv,
    required this.transmission,
    required this.people,
    required this.photo,
    required this.priceDay,
    required this.engine,
    required this.type,
    required this.isPublish,
    required this.createdAt,
    required this.updateAt,
  });
}
