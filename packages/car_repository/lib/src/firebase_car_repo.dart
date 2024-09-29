import 'dart:developer';
import 'dart:io';
import 'package:car_repository/car_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseCarRepo implements CarRepo {
  final carsCollection = FirebaseFirestore.instance.collection('cars');
  final storage = FirebaseStorage.instance;

  @override
  Future<List<Car>> getCars() async {
    try {
      return await carsCollection.get().then((value) => value.docs
          .map((e) => CarEntity.fromDocument(e.data()).toModel())
          .toList());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> addCar(Car car) async {
    try {
      CarEntity carEntity = CarEntity.fromModel(car);
      await carsCollection.doc(car.carId).set(carEntity.toDocument());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> updateCar(Car car) async {
    try {
      CarEntity carEntity = CarEntity.fromModel(car);
      await carsCollection.doc(car.carId).update(carEntity.toDocument());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> deleteCar(String carId) async {
    try {
      await carsCollection.doc(carId).delete();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<Car?> getCarById(String carId) async {
    try {
      final carDoc = await carsCollection.doc(carId).get();
      if (carDoc.exists) {
        return CarEntity.fromDocument(carDoc.data()!).toModel();
      } else {
        return null;
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<String> uploadImage(File imageFile, String carId) async {
    try {
      // Definir la ruta donde se guardará la imagen
      final storageRef = storage.ref().child('cars/$carId.jpg');
      // Subir la imagen
      await storageRef.putFile(imageFile);
      // Obtener la URL de descarga de la imagen
      final downloadUrl = await storageRef.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> updateCarPublishState(String carId, bool isPublish) async {
    await carsCollection.doc(carId).update({'isPublish': isPublish});
  }
}
