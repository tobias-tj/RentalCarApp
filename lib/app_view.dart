import 'package:car_repository/car_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_repository/order_repository.dart';
import 'package:rental_car_app/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:rental_car_app/screens/auth/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:rental_car_app/screens/auth/views/welcome_screen.dart';
import 'package:rental_car_app/screens/calendar/blocs/get_orders_by_user_id_bloc/get_orders_by_user_id_bloc.dart';
import 'package:rental_car_app/screens/home/blocs/get_car_bloc/get_car_bloc.dart';
import 'package:rental_car_app/screens/home/views/home_screen.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<CarRepo>(
          create: (context) => FirebaseCarRepo(),
        ),
        RepositoryProvider<OrderRepo>(
          create: (context) => FirebaseOrderRepo(),
        ),
      ],
      child: MaterialApp(
        title: 'Rental Cars',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.light(
            background: Colors.grey.shade100, // Fondo suave y claro
            primary: Colors
                .blueGrey.shade900, // Azul gris oscuro para mayor contraste
            onPrimary: Colors.white, // Texto blanco sobre botones primarios
            secondary:
                Colors.blueGrey.shade300, // Colores secundarios más claros
            onSecondary:
                Colors.blueGrey.shade800, // Texto oscuro sobre secundarios
            surface:
                Colors.white, // Color de fondo para tarjetas o áreas elevadas
            onSurface: Colors.grey.shade900, // Texto sobre superficies claras
            error: Colors.red.shade600, // Color para errores
            onError: Colors.white, // Texto sobre color de error
          ),
          scaffoldBackgroundColor: Colors.grey.shade50, // Fondo general claro
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.blueGrey.shade900,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
            titleTextStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          textTheme: TextTheme(
            bodyLarge: TextStyle(
              color: Colors.grey.shade900,
              fontSize: 16,
            ),
            bodyMedium: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 14,
            ),
            bodySmall: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
            labelLarge: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          buttonTheme: ButtonThemeData(
            buttonColor: Colors.blueGrey.shade900,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state.status == AuthenticationStatus.authenticated) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => SignInBloc(
                      context.read<AuthenticationBloc>().userRepository,
                    ),
                  ),
                  BlocProvider(
                    create: (context) =>
                        GetCarBloc(context.read<CarRepo>())..add(GetCar()),
                  ),
                  BlocProvider(
                    create: (context) =>
                        GetOrdersByUserIdBloc(context.read<OrderRepo>()),
                  )
                ],
                child: const HomeScreen(),
              );
            } else {
              return const WelcomeScreen();
            }
          },
        ),
      ),
    );
  }
}
