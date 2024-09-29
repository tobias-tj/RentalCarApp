part of 'get_car_admin_bloc.dart';

sealed class GetCarAdminEvent extends Equatable {
  const GetCarAdminEvent();

  @override
  List<Object> get props => [];
}

class GetCarAdmin extends GetCarAdminEvent {}
