import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:order_repository/order_repository.dart';
import 'package:rental_car_app/screens/animations/create_route_effect.dart';
import 'package:rental_car_app/screens/auth/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:rental_car_app/screens/calendar/blocs/get_orders_by_user_id_bloc/get_orders_by_user_id_bloc.dart';
import 'package:rental_car_app/screens/calendar/views/calendar_screen.dart';
import 'package:rental_car_app/screens/favorite/views/favorite_screen.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize; // Necesario para definir el tamaño del AppBar

  const CustomAppBar({super.key})
      : preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.background,
      centerTitle: true,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/icon-app-rental.png',
            width: 30,
            height: 30,
          ),
          const SizedBox(width: 10),
          Text(
            'Rental Car',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            // Acción para mostrar los favoritos del usuario con animación
            Navigator.push(
              context,
              createRoute(const FavoriteScreen()),
            );
          },
          icon: Icon(
            LucideIcons.heart,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          tooltip: 'Carrito',
        ),
        IconButton(
          onPressed: () {
            // Acción para mostrar el calendario de autos agendados con animación
            Navigator.push(
              context,
              createRoute(
                BlocProvider(
                  create: (context) =>
                      GetOrdersByUserIdBloc(context.read<OrderRepo>()),
                  child: const CalendarScreen(),
                ),
              ),
            );
          },
          icon: Icon(
            CupertinoIcons.calendar,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          tooltip: 'Calendario',
        ),
        IconButton(
          onPressed: () {
            // Acción para cerrar sesión
            context.read<SignInBloc>().add(SignOutRequired());
          },
          icon: Icon(
            CupertinoIcons.power,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          tooltip: 'Cerrar Sesión',
        ),
      ],
    );
  }
}
