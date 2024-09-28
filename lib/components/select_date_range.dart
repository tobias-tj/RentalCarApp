import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';

class SelectDateRangeScreen extends StatefulWidget {
  final String carId;
  final String carName;
  final String priceDay;
  const SelectDateRangeScreen({
    Key? key,
    required this.carId,
    required this.carName,
    required this.priceDay,
  }) : super(key: key);

  @override
  _SelectDateRangeScreenState createState() => _SelectDateRangeScreenState();
}

class _SelectDateRangeScreenState extends State<SelectDateRangeScreen> {
  DateRange? selectedDateRange;
  String totalAmount = '0';

  void _calculateTotalAmount() {
    if (selectedDateRange != null &&
        selectedDateRange!.start != null &&
        selectedDateRange!.end != null) {
      final int days =
          selectedDateRange!.end.difference(selectedDateRange!.start).inDays +
              1;
      final double pricePerDay = double.parse(widget.priceDay);
      final double total = days * pricePerDay;
      setState(() {
        totalAmount = total.toStringAsFixed(2);
      });
    } else {
      setState(() {
        totalAmount = '0';
      });
    }
  }

  void _confirmReservation() {
    if (selectedDateRange != null) {
      Navigator.pop(
          context, selectedDateRange); // Devuelve las fechas seleccionadas
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Seleccione un rango de fechas válido')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Seleccionar Fechas'),
          backgroundColor: Theme.of(context).colorScheme.onBackground,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  height: 400,
                  child: DateRangePickerWidget(
                    initialDateRange: selectedDateRange,
                    onDateRangeChanged: (range) {
                      setState(() {
                        selectedDateRange = range;
                        _calculateTotalAmount();
                      });
                    },
                    maximumDateRangeLength: 30,
                    minimumDateRangeLength: 1,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text('Total: \$${totalAmount}',
                  style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: _confirmReservation,
                    child: const Text('Reservar'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(
                          context, null); // No selecciona ninguna fecha
                    },
                    child: const Text('Cancelar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
