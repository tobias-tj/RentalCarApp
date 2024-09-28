part of 'get_orders_by_user_id_bloc.dart';

sealed class GetOrdersByUserIdBlocEvent extends Equatable {
  const GetOrdersByUserIdBlocEvent();

  @override
  List<Object> get props => [];
}

class GetOrderByUserId extends GetOrdersByUserIdBlocEvent {
  final String userId;

  const GetOrderByUserId(this.userId);

  @override
  List<Object> get props => [userId];
}
