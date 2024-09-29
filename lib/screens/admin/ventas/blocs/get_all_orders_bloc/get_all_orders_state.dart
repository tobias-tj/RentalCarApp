part of 'get_all_orders_bloc.dart';

sealed class GetAllOrdersState extends Equatable {
  const GetAllOrdersState();

  @override
  List<Object> get props => [];
}

final class GetAllOrdersInitial extends GetAllOrdersState {}

final class GetAllOrdersFailure extends GetAllOrdersState {}

final class GetAllOrdersLoading extends GetAllOrdersState {}

final class GetAllOrdersSuccess extends GetAllOrdersState {
  final List<Order> orders;
  const GetAllOrdersSuccess(this.orders);

  @override
  List<Object> get props => [orders];
}
