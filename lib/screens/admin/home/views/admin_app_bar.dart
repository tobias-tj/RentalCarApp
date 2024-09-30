import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:order_repository/order_repository.dart';
import 'package:rental_car_app/screens/admin/ventas/blocs/get_all_orders_bloc/get_all_orders_bloc.dart';
import 'package:rental_car_app/screens/admin/ventas/views/ventas_screen.dart';
import 'package:rental_car_app/screens/animations/create_route_effect.dart';
import 'package:rental_car_app/screens/auth/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  const AdminAppBar({super.key})
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
          const SizedBox(
            width: 10,
          ),
          Text(
            'Admin Rental Car',
            style: Theme.of(context)
                .textTheme
                .headlineLarge
                ?.copyWith(fontWeight: FontWeight.bold, fontSize: 18),
          )
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            // Acción para mostrar los favoritos del usuario con animación
            Navigator.push(
              context,
              createRoute(
                BlocProvider(
                  create: (context) =>
                      GetAllOrdersBloc(context.read<OrderRepo>())
                        ..add(GetAllOrders()),
                  child: const VentasScreen(),
                ),
              ),
            );
          },
          icon: Icon(
            LucideIcons.fileBarChart2,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          tooltip: 'Ventas',
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
