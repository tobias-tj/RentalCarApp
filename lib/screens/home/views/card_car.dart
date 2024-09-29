import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:order_repository/order_repository.dart';
import 'package:rental_car_app/components/select_date_range.dart';
import 'package:rental_car_app/services/stripe_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class CardCar extends StatefulWidget {
  final String id;
  final String photo;
  final bool isPublish;
  final String name;
  final String type;
  final String priceDay;
  final String transmission;
  final String people;
  final String engine;
  final String cv;
  const CardCar(
      {Key? key,
      required this.id,
      required this.photo,
      required this.isPublish,
      required this.name,
      required this.type,
      required this.priceDay,
      required this.transmission,
      required this.people,
      required this.engine,
      required this.cv})
      : super(key: key);

  @override
  State<CardCar> createState() => _CardCarState();
}

class _CardCarState extends State<CardCar> {
  bool isFavorite = false;
  List<dynamic> favoriteList = [];
  DateRange? selectedDateRange;
  String totalAmount = '0';
  final Uuid _uuid = Uuid();

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  // Verifica si el vehiculo esta en el localStorage (favorites)
  Future<void> _checkIfFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    final String? favorites = prefs.getString('favorites');

    if (favorites != null) {
      final List<dynamic> favoriteList = json.decode(favorites);
      setState(() {
        isFavorite = favoriteList.contains(
            widget.id); // Chequeamos si el ID del vehiculo esta en la lista
      });
    }
  }

  // Agrega o elimina el vehiculo de favoritos en el localStorage
  Future<void> _toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    final String? favorites = prefs.getString('favorites');
    List<dynamic> favoriteList = [];

    if (favorites != null) {
      favoriteList = json
          .decode(favorites); // Decodificar la lista de favorites existentes
    }

    setState(() {
      if (isFavorite) {
        favoriteList.remove(widget.id);
      } else {
        favoriteList.add(widget.id);
      }
      isFavorite = !isFavorite; // Alternamos el estado de favorito
    });

    // Guardamos la nueva lista de favoritos
    prefs.setString('favorites', json.encode(favoriteList));
  }

  // Método para obtener el correo del usuario autenticado
  String? getCurrentUserEmail() {
    final User? user = FirebaseAuth.instance.currentUser;
    return user?.email;
  }

  Future<void> _openRangeScreen() async {
    final selectedRange = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SelectDateRangeScreen(
                carId: widget.id,
                carName: widget.name,
                priceDay: widget.priceDay)));

    if (selectedRange != null) {
      setState(() {
        selectedDateRange = selectedRange;
        // Calculamos el total basado en la fecha seleccionada
        final int days =
            selectedDateRange!.end.difference(selectedDateRange!.start).inDays +
                1;
        final double pricePerDay = double.parse(widget.priceDay);
        final double total = days * pricePerDay;
        totalAmount = total.toStringAsFixed(2);
      });
    }
  }

  Future<void> _createProcessOrder() async {
    if (selectedDateRange == null) {
      // Show an error if no date range is selected
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Seleccione el rango de fecha!')),
      );
      return;
    }
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se ha iniciado sesión')),
      );
      return;
    }

    final now = DateTime.now();
    final orderIdGenerate = _uuid.v4();

    final orderId = orderIdGenerate;
    final emailUser = getCurrentUserEmail();

    final carId = widget.id;
    final carName = widget.name;

    final order = Order(
      orderId: orderId,
      carId: carId,
      carName: carName,
      userId: currentUser.uid,
      orderDate: selectedDateRange!.start,
      orderEndDate: selectedDateRange!.end,
      status: 'Pending',
      totalAmount: totalAmount,
      createdAt: now,
      updatedAt: now,
    );

    StripeService.instance.makePayment(order, emailUser!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Imagen redondeada optimizada
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.network(
            widget.photo,
            width: double.infinity,
            height: 100,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: widget.isPublish ? Colors.green : Colors.redAccent,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 8,
                  ),
                  child: Text(
                    widget.isPublish ? 'STOCK' : 'NO-STOCK',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        // Nombre y tipo
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            widget.name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            widget.type,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const SizedBox(height: 7),
        // Precio
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withOpacity(0.1), // Fondo sutil con transparencia
                  borderRadius: BorderRadius.circular(12), // Bordes redondeados
                ),
                child: Text(
                  '${widget.priceDay} \$ /día',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context)
                        .colorScheme
                        .primary, // Color primario del tema
                    fontWeight:
                        FontWeight.w700, // Negrita para resaltar el precio
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(LucideIcons.wrench, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    widget.transmission,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(LucideIcons.users, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    widget.people,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(LucideIcons.fuel, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    widget.engine,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(LucideIcons.gauge, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    widget.cv,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Botón para seleccionar el rango de fechas
              ElevatedButton(
                onPressed: () {
                  widget.isPublish
                      ? {
                          _openRangeScreen() // Llamada al método para seleccionar fechas
                        }
                      : null;
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.background,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  selectedDateRange == null
                      ? 'Seleccionar fechas'
                      : '${DateFormat('dd/MM/yyyy').format(selectedDateRange!.start)} - ${DateFormat('dd/MM/yyyy').format(selectedDateRange!.end)}', // Muestra las fechas seleccionadas
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: ElevatedButton(
                      onPressed: () {
                        widget.isPublish ? {_createProcessOrder()} : null;
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.background,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              12), // Bordes redondeados del botón
                        ),
                      ),
                      child: const Text(
                        textAlign: TextAlign.center,
                        'Reservar Vehículo',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: _toggleFavorite,
                      icon: Icon(
                          isFavorite
                              ? CupertinoIcons.heart_fill
                              : CupertinoIcons.heart,
                          color: isFavorite ? Colors.red : Colors.black)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
