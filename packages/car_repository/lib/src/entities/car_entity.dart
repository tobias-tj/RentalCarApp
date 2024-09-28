// entity/car_entity.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/car.dart';

class CarEntity {
  final String carId;
  final String userId;
  final String name;
  final String cv;
  final String transmission;
  final String people;
  final String photo;
  final String priceDay;
  final String engine;
  final String type;
  final bool isPublish;
  final DateTime createdAt;
  final DateTime updateAt;

  CarEntity({
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

  Map<String, Object?> toDocument() {
    return {
      'carId': carId,
      'userId': userId,
      'name': name,
      'cv': cv,
      'transmission': transmission,
      'people': people,
      'photo': photo,
      'priceDay': priceDay,
      'engine': engine,
      'type': type,
      'isPublish': isPublish,
      'createdAt': createdAt,
      'updateAt': updateAt,
    };
  }

  static CarEntity fromDocument(Map<String, dynamic> doc) {
    return CarEntity(
      carId:
          doc['carId'] ?? '', // Manejar valores nulos con un valor por defecto
      userId: doc['userId'] ?? '',
      name: doc['name'] ?? 'Unknown Car',
      cv: doc['cv'] ?? '0',
      transmission: doc['transmission'] ?? 'Unknown',
      people: doc['people'] ?? '0',
      photo: doc['photo'] ??
          '', // Asegúrate de que las imágenes tengan un valor por defecto
      priceDay: doc['priceDay'] ??
          '0', // Convierte los números a cadenas si es necesario
      engine: doc['engine'] ?? 'Unknown',
      type: doc['type'] ?? 'Unknown',
      isPublish:
          doc['isPublish'] ?? false, // Valores booleanos pueden ser nulos
      createdAt: (doc['createdAt'] as Timestamp?)?.toDate() ??
          DateTime.now(), // Manejar fechas
      updateAt: (doc['updateAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // Método para convertir la entidad a modelo Car
  Car toModel() {
    return Car(
      carId: carId,
      userId: userId,
      name: name,
      cv: cv,
      transmission: transmission,
      people: people,
      photo: photo,
      priceDay: priceDay,
      engine: engine,
      type: type,
      isPublish: isPublish,
      createdAt: createdAt,
      updateAt: updateAt,
    );
  }

  // Método para crear una entidad a partir de un modelo Car
  static CarEntity fromModel(Car car) {
    return CarEntity(
      carId: car.carId,
      userId: car.userId,
      name: car.name,
      cv: car.cv,
      transmission: car.transmission,
      people: car.people,
      photo: car.photo,
      priceDay: car.priceDay,
      engine: car.engine,
      type: car.type,
      isPublish: car.isPublish,
      createdAt: car.createdAt,
      updateAt: car.updateAt,
    );
  }
}
