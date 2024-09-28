part of 'get_car_by_id_bloc.dart';

sealed class GetCarByIdState extends Equatable {
  const GetCarByIdState();

  @override
  List<Object> get props => [];
}

final class GetCarByIdInitial extends GetCarByIdState {}

final class GetCarByIdFailure extends GetCarByIdState {}

final class GetCarByIdLoading extends GetCarByIdState {}

final class GetCarByIdSuccess extends GetCarByIdState {
  final Car car;

  const GetCarByIdSuccess(this.car);

  @override
  List<Object> get props => [car];
}
