import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:car_repository/car_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'create_car_event.dart';
part 'create_car_state.dart';

class CreateCarBloc extends Bloc<CreateCarEvent, CreateCarState> {
  final CarRepo _carRepo;
  CreateCarBloc(this._carRepo) : super(CreateCarInitial()) {
    on<CreateCarRequired>((event, emit) async {
      emit(CreateCarLoading());
      try {
        String photoUrl =
            await _carRepo.uploadImage(event.imageFile, event.carId);
        final currentUser = FirebaseAuth.instance.currentUser;

        // Crear auto
        final car = Car(
            carId: event.carId,
            name: event.name,
            cv: event.cv,
            type: event.type,
            transmission: event.transmission,
            people: event.people,
            priceDay: event.priceDay,
            photo: photoUrl,
            createdAt: DateTime.now(),
            updateAt: DateTime.now(),
            isPublish: true,
            userId: currentUser!.uid,
            engine: event.engine);
        await _carRepo.addCar(car);
        emit(CreateCarSuccess());
      } catch (e) {
        emit(CreateCarFailure());
      }
    });
  }
}
