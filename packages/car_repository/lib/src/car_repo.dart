import 'dart:io';

import 'package:car_repository/src/models/car.dart';

abstract class CarRepo {
  Future<List<Car>> getCars();
  Future<void> addCar(Car car);
  Future<void> updateCar(Car car);
  Future<void> deleteCar(String carId);
  Future<Car?> getCarById(String carId);
  Future<String> uploadImage(File imageFile, String carId);
  Future<void> updateCarPublishState(String carId, bool isPublish);
}
