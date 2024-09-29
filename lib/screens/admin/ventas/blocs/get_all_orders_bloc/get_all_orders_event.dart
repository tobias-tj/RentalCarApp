part of 'get_all_orders_bloc.dart';

sealed class GetAllOrdersEvent extends Equatable {
  const GetAllOrdersEvent();

  @override
  List<Object> get props => [];
}

class GetAllOrders extends GetAllOrdersEvent {}
