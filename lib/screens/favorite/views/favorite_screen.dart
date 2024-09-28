import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:rental_car_app/screens/favorite/blocs/get_car_by_id_bloc/get_car_by_id_bloc.dart';
import 'package:rental_car_app/screens/favorite/views/info_item.dart';
import 'package:rental_car_app/screens/home/views/card_car.dart';
import 'package:rental_car_app/screens/home/views/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:car_repository/car_repository.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<dynamic> favoriteList = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String? favorites = prefs.getString('favorites');

    if (favorites != null) {
      setState(() {
        favoriteList = json.decode(favorites);
      });
    }
  }

  // Eliminar el coche de favoritos y actualizar la lista
  Future<void> _toggleFavorite(String carId) async {
    final prefs = await SharedPreferences.getInstance();
    final String? favorites = prefs.getString('favorites');
    List<dynamic> favoriteList = [];
    if (favorites != null) {
      favoriteList = json.decode(favorites);
    }

    setState(() {
      favoriteList.remove(carId);
    });

    // Guardar la lista actualizada en SharedPreferences
    prefs.setString('favorites', json.encode(favoriteList));

    // Actualizamos la lista de favoritos
    _loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
        backgroundColor: Theme.of(context).colorScheme.onBackground,
      ),
      body: favoriteList.isEmpty
          ? const Center(child: Text('No tienes favoritos.'))
          : ListView.builder(
              itemCount: favoriteList.length,
              itemBuilder: (context, index) {
                final carId =
                    favoriteList[index]; // Obtener el carId de la lista

                return BlocProvider(
                  create: (context) {
                    final carRepo = RepositoryProvider.of<CarRepo>(context);
                    return GetCarByIdBloc(carRepo)
                      ..add(GetCarById(carId)); // Enviar el evento con el carId
                  },
                  child: BlocBuilder<GetCarByIdBloc, GetCarByIdState>(
                    builder: (context, state) {
                      if (state is GetCarByIdLoading) {
                        return const ListTile(
                          title: Text('Cargando...'),
                        );
                      } else if (state is GetCarByIdSuccess) {
                        final car = state.car;
                        return Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    car.photo,
                                    width: 150,
                                    height: 120,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(LucideIcons.bug, size: 120);
                                    },
                                  ),
                                ),
                                const SizedBox(width: 20),
                                // Car details
                                Expanded(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      car.name,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Wrap(
                                        spacing: 20,
                                        runSpacing: 20,
                                        children: [
                                          InfoItem(
                                              icon: LucideIcons.dollarSign,
                                              text: '${car.priceDay} /día'),
                                          InfoItem(
                                              icon: LucideIcons.wrench,
                                              text: car.transmission),
                                          InfoItem(
                                              icon: LucideIcons.fuel,
                                              text: car.engine),
                                        ],
                                      ),
                                    ),
                                  ],
                                )),
                                IconButton(
                                    onPressed: () {
                                      _toggleFavorite(car.carId);
                                    },
                                    icon: Icon(CupertinoIcons.heart_fill,
                                        color: Colors.red))
                              ],
                            ),
                          ),
                        );
                      } else if (state is GetCarByIdFailure) {
                        return const ListTile(
                          title: Text('Error al cargar el auto'),
                        );
                      }
                      return const ListTile(
                        title: Text('Cargando...'),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
