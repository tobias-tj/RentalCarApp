import 'package:car_repository/car_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_car_app/screens/admin/create/blocs/create_car/create_car_bloc.dart';
import 'package:rental_car_app/screens/admin/create/views/create_car_screen.dart';
import 'package:rental_car_app/screens/admin/home/blocs/get_car_admin_bloc/get_car_admin_bloc.dart';
import 'package:rental_car_app/screens/admin/home/blocs/update_car_status_bloc/update_car_status_bloc.dart';
import 'package:rental_car_app/screens/admin/home/views/admin_app_bar.dart';
import 'package:rental_car_app/screens/admin/home/views/card_car.dart';
import 'package:rental_car_app/screens/animations/create_route_effect.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  Future<void> _refreshData(BuildContext context) async {
    BlocProvider.of<GetCarAdminBloc>(context).add(GetCarAdmin());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const AdminAppBar(),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: RefreshIndicator(
              onRefresh: () => _refreshData(context),
              child: BlocBuilder<GetCarAdminBloc, GetCarAdminState>(
                  builder: (context, state) {
                if (state is GetCarSuccess) {
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 7 / 12,
                    ),
                    itemCount: state.cars.length,
                    itemBuilder: (context, int i) {
                      return Material(
                        elevation: 3,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: CardCar(
                          id: state.cars[i].carId,
                          photo: state.cars[i].photo,
                          cv: state.cars[i].cv,
                          engine: state.cars[i].engine,
                          isPublish: state.cars[i].isPublish,
                          name: state.cars[i].name,
                          type: state.cars[i].type,
                          people: state.cars[i].people,
                          priceDay: state.cars[i].priceDay,
                          transmission: state.cars[i].transmission,
                          onTogglePublish: () {
                            BlocProvider.of<UpdateCarStatusBloc>(context).add(
                                UpdateCarStatus(state.cars[i].carId,
                                    !state.cars[i].isPublish));
                            _refreshData(context);
                          },
                        ),
                      );
                    },
                  );
                } else if (state is GetCarLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return const Center(
                    child: Text('An Error has occurred..'),
                  );
                }
              }),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Navegamos a la pantalla de crear auto
            Navigator.push(
                context,
                createRoute(BlocProvider(
                    create: (context) => CreateCarBloc(context.read<CarRepo>()),
                    child: const CreateCarScreen())));
          },
          child: const Icon(
            Icons.add, // Icono minimalista para agregar
            size: 28, // Tamaño ligeramente grande para visibilidad
          ),
          backgroundColor:
              Theme.of(context).colorScheme.onBackground, // Color del botón
          tooltip: 'Crear auto', // Tooltip al mantener presionado
        ));
  }
}
