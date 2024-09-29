import 'package:bloc/bloc.dart';
import 'package:car_repository/car_repository.dart';
import 'package:equatable/equatable.dart';

part 'get_car_admin_event.dart';
part 'get_car_admin_state.dart';

class GetCarAdminBloc extends Bloc<GetCarAdminEvent, GetCarAdminState> {
  final CarRepo _carRepo;
  GetCarAdminBloc(this._carRepo) : super(GetCarInitial()) {
    on<GetCarAdminEvent>((event, emit) async {
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
