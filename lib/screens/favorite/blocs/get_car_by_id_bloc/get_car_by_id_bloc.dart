import 'package:bloc/bloc.dart';
import 'package:car_repository/car_repository.dart';
import 'package:equatable/equatable.dart';

part 'get_car_by_id_event.dart';
part 'get_car_by_id_state.dart';

class GetCarByIdBloc extends Bloc<GetCarByIdEvent, GetCarByIdState> {
  final CarRepo _carRepo;
  GetCarByIdBloc(this._carRepo) : super(GetCarByIdInitial()) {
    on<GetCarById>((event, emit) async {
      emit(GetCarByIdLoading());
      try {
        final car = await _carRepo.getCarById(event.carId);
        emit(GetCarByIdSuccess(car!));
      } catch (e) {
        emit(GetCarByIdFailure());
      }
    });
  }
}
