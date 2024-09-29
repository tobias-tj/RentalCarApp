import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:order_repository/order_repository.dart';

part 'get_all_orders_event.dart';
part 'get_all_orders_state.dart';

class GetAllOrdersBloc extends Bloc<GetAllOrdersEvent, GetAllOrdersState> {
  final OrderRepo _orderRepo;
  GetAllOrdersBloc(this._orderRepo) : super(GetAllOrdersInitial()) {
    on<GetAllOrdersEvent>((event, emit) async {
      emit(GetAllOrdersLoading());
      try {
        List<Order> orders = await _orderRepo.getOrders();
        emit(GetAllOrdersSuccess(orders));
      } catch (e) {
        print('Error al cargar las ordenes: $e');
        emit(GetAllOrdersFailure());
      }
    });
  }
}
