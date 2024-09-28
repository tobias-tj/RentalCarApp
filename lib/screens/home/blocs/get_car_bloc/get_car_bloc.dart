import 'package:bloc/bloc.dart';
import 'package:car_repository/car_repository.dart';
import 'package:equatable/equatable.dart';

part 'get_car_event.dart';
part 'get_car_state.dart';

class GetCarBloc extends Bloc<GetCarEvent, GetCarState> {
  final CarRepo _carRepo;
  GetCarBloc(this._carRepo) : super(GetCarInitial()) {
    on<GetCarEvent>((event, emit) async {
      emit(GetCarLoading());
      try {
        List<Car> cars = await _carRepo.getCars();
        emit(GetCarSuccess(cars));
      } catch (e) {
        emit(GetCarFailure());
      }
    });
  }
}
