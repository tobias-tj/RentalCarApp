import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:order_repository/order_repository.dart';

part 'get_orders_by_user_id_event.dart';
part 'get_orders_by_user_id_state.dart';

class GetOrdersByUserIdBloc
    extends Bloc<GetOrdersByUserIdBlocEvent, GetOrdersByUserIdBlocState> {
  final OrderRepo _orderRepo;
  GetOrdersByUserIdBloc(this._orderRepo)
      : super(GetOdersByUserIdBlocInitial()) {
    on<GetOrderByUserId>((event, emit) async {
      try {
        final orders = await _orderRepo.getOrdersByUserId(event.userId);
        emit(GetOrdersByUserIdBlocSuccess(orders));
      } catch (e) {
        emit(GetOrdersByUserIdBlocFailure());
      }
    });
  }
}
