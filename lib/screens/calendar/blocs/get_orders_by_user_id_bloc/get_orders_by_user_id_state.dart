part of 'get_orders_by_user_id_bloc.dart';

sealed class GetOrdersByUserIdBlocState extends Equatable {
  const GetOrdersByUserIdBlocState();

  @override
  List<Object> get props => [];
}

final class GetOdersByUserIdBlocInitial extends GetOrdersByUserIdBlocState {}

final class GetOrdersByUserIdBlocFailure extends GetOrdersByUserIdBlocState {}

final class GetOrdersByUserIdBlocLoading extends GetOrdersByUserIdBlocState {}

final class GetOrdersByUserIdBlocSuccess extends GetOrdersByUserIdBlocState {
  final List<Order> orders;

  const GetOrdersByUserIdBlocSuccess(this.orders);

  @override
  List<Object> get props => [orders];
}
