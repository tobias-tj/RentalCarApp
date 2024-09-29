part of 'create_car_bloc.dart';

sealed class CreateCarState extends Equatable {
  const CreateCarState();

  @override
  List<Object> get props => [];
}

final class CreateCarInitial extends CreateCarState {}

class CreateCarSuccess extends CreateCarState {}

class CreateCarFailure extends CreateCarState {}

class CreateCarLoading extends CreateCarState {}
