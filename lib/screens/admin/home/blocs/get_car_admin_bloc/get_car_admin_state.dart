part of 'get_car_admin_bloc.dart';

sealed class GetCarAdminState extends Equatable {
  const GetCarAdminState();

  @override
  List<Object> get props => [];
}

final class GetCarInitial extends GetCarAdminState {}

final class GetCarFailure extends GetCarAdminState {}

final class GetCarLoading extends GetCarAdminState {}

final class GetCarSuccess extends GetCarAdminState {
  final List<Car> cars;

  const GetCarSuccess(this.cars);

  @override
  List<Object> get props => [cars];
}
