import 'package:bloc/bloc.dart';
import 'package:car_repository/car_repository.dart';
import 'package:equatable/equatable.dart';

part 'update_car_status_event.dart';
part 'update_car_status_state.dart';

class UpdateCarStatusBloc
    extends Bloc<UpdateCarStatusEvent, UpdateCarStatusState> {
  final CarRepo _carRepo;
  UpdateCarStatusBloc(this._carRepo) : super(UpdateCarStatusInitial()) {
    on<UpdateCarStatus>((event, emit) async {
      emit(UpdateCarStatusLoading());
      try {
        await _carRepo.updateCarPublishState(event.carId, event.isPublish);
        emit(UpdateCarStatusSuccess());
      } catch (e) {
        emit(UpdateCarStatusFailure());
      }
    });
  }
}
