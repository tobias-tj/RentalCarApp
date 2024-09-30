import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:rental_car_app/screens/home/blocs/get_car_bloc/get_car_bloc.dart';
import 'package:rental_car_app/screens/home/views/card_car.dart';
import 'package:rental_car_app/screens/home/views/custom_app_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _refreshData(BuildContext context) async {
    BlocProvider.of<GetCarBloc>(context).add(GetCar());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const CustomAppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: RefreshIndicator(
            onRefresh: () => _refreshData(context),
            child:
                BlocBuilder<GetCarBloc, GetCarState>(builder: (context, state) {
              if (state is GetCarSuccess) {
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 4 / 11,
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
                          transmission: state.cars[i].transmission),
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
    );
  }
}
