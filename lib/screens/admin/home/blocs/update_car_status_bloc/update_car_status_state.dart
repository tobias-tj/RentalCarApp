part of 'update_car_status_bloc.dart';

sealed class UpdateCarStatusState extends Equatable {
  const UpdateCarStatusState();

  @override
  List<Object> get props => [];
}

final class UpdateCarStatusInitial extends UpdateCarStatusState {}

final class UpdateCarStatusFailure extends UpdateCarStatusState {}

final class UpdateCarStatusLoading extends UpdateCarStatusState {}

final class UpdateCarStatusSuccess extends UpdateCarStatusState {}
