import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_car_app/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:rental_car_app/screens/auth/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:rental_car_app/screens/auth/blocs/sign_up_bloc/sign_up_bloc.dart';
import 'package:rental_car_app/screens/auth/views/sign_in_screen.dart';
import 'package:rental_car_app/screens/auth/views/sign_up_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(initialIndex: 0, length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context).colorScheme.background, // Fondo minimalista
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50.0),
                      child: TabBar(
                        controller: tabController,
                        unselectedLabelColor: Colors.black.withOpacity(0.5),
                        labelColor: Colors
                            .black, // Letra negra cuando está seleccionada
                        indicatorColor: Theme.of(context)
                            .colorScheme
                            .primary, // Indicador sutil
                        indicatorSize: TabBarIndicatorSize
                            .tab, // Indicador del tamaño del tab
                        labelStyle: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w800),
                        tabs: const [
                          Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Text(
                              'Sign Up',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Expanded(
                      child: TabBarView(
                        controller: tabController,
                        children: [
                          // Pantalla de Sign In
                          BlocProvider<SignInBloc>(
                            create: (context) => SignInBloc(context
                                .read<AuthenticationBloc>()
                                .userRepository),
                            child: const SignInScreen(),
                          ),
                          // Pantalla de Sign Up
                          BlocProvider<SignUpBloc>(
                            create: (context) => SignUpBloc(context
                                .read<AuthenticationBloc>()
                                .userRepository),
                            child: const SignUpScreen(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
