import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:order_repository/order_repository.dart';
import 'package:rental_car_app/main.dart';
import 'package:rental_car_app/screens/calendar/blocs/get_orders_by_user_id_bloc/get_orders_by_user_id_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  Map<DateTime, List> _events = {};
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadCalendarByUserId();
  }

  Future<void> _loadCalendarByUserId() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      // Despachar evento para obtener órdenes por userId
      context
          .read<GetOrdersByUserIdBloc>()
          .add(GetOrderByUserId(currentUser.uid));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se ha iniciado sesión')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onBackground,
        title: const Text('Calendario'),
      ),
      body: BlocBuilder<GetOrdersByUserIdBloc, GetOrdersByUserIdBlocState>(
          builder: (context, state) {
        if (state is GetOrdersByUserIdBlocSuccess) {
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: state.orders.length,
            itemBuilder: (context, index) {
              final order = state.orders[index];
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                margin: const EdgeInsets.only(bottom: 16.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Vehículo: ${order.carName}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.calendar_month_outlined,
                              size: 16, color: Colors.blue),
                          const SizedBox(width: 8),
                          Text(
                            'Inicio de reserva: ${DateFormat('dd/MM/yyyy').format(order.orderDate)}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.edit_calendar_outlined,
                              size: 16, color: Colors.red),
                          const SizedBox(width: 8),
                          Text(
                            'Devolución: ${DateFormat('dd/MM/yyyy').format(order.orderEndDate)}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          const Icon(Icons.mobile_friendly_outlined,
                              size: 16, color: Colors.green),
                          const SizedBox(width: 8),
                          Text(
                            'Total pagado: ${order.totalAmount} \$',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else if (state is GetOrdersByUserIdBlocLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return const Center(
            child: Text('An error has ocurred...'),
          );
        }
      }),
    );
  }
}
