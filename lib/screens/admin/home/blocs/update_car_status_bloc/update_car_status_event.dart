part of 'update_car_status_bloc.dart';

sealed class UpdateCarStatusEvent extends Equatable {
  const UpdateCarStatusEvent();

  @override
  List<Object> get props => [];
}

class UpdateCarStatus extends UpdateCarStatusEvent {
  final String carId;
  final bool isPublish;

  const UpdateCarStatus(this.carId, this.isPublish);

  @override
  // TODO: implement props
  List<Object> get props => [carId, isPublish];
}
