part of 'get_car_by_id_bloc.dart';

sealed class GetCarByIdEvent extends Equatable {
  const GetCarByIdEvent();

  @override
  List<Object> get props => [];
}

class GetCarById extends GetCarByIdEvent {
  final String carId;

  const GetCarById(this.carId);

  @override
  List<Object> get props => [carId];
}
