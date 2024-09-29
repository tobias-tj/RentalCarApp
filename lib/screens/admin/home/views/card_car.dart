import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class CardCar extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Imagen redondeada optimizada
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.network(
            photo,
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
                  color: isPublish ? Colors.green : Colors.redAccent,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 8,
                  ),
                  child: Text(
                    isPublish ? 'STOCK' : 'NO-STOCK',
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
            name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            type,
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
                  '$priceDay \$ /día',
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
                    transmission,
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
                    people,
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
                    engine,
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
                    cv,
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
      ],
    );
  }
}
