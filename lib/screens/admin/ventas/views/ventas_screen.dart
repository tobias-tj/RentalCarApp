import 'dart:io';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rental_car_app/screens/admin/ventas/blocs/get_all_orders_bloc/get_all_orders_bloc.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

class VentasScreen extends StatelessWidget {
  const VentasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onBackground,
        title: const Text('Ventas'),
      ),
      body: BlocBuilder<GetAllOrdersBloc, GetAllOrdersState>(
          builder: (context, state) {
        if (state is GetAllOrdersLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is GetAllOrdersSuccess) {
          final orders = state.orders;

          // Agrupamos las ordenes por nombre de vehiculo
          final Map<String, double> vehicleIncome = {};
          for (var order in orders) {
            var orderTotalAmount = double.parse(order.totalAmount);
            vehicleIncome.update(
              order.carName,
              (existingValue) => existingValue + orderTotalAmount,
              ifAbsent: () => orderTotalAmount,
            );
          }

          // Obtenemos el total de ingresos para calcular los porcentajes
          final topVehicle = vehicleIncome.entries.reduce((a, b) {
            return a.value > b.value ? a : b;
          });

          // Preparamos los datos para el grafico de barras
          final List<BarChartGroupData> barGroups = [];
          vehicleIncome.forEach((carName, totalAmount) {
            barGroups.add(BarChartGroupData(x: carName.hashCode, barRods: [
              BarChartRodData(toY: totalAmount, color: Colors.blue)
            ]));
          });

          // Funcion para generar PDF
          Future<void> generarPDF() async {
            final pdf = pw.Document();

            pdf.addPage(pw.Page(build: (pw.Context context) {
              return pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Resumen de Ventas',
                        style: pw.TextStyle(fontSize: 24)),
                    pw.SizedBox(height: 20),
                    pw.Text(
                        'Vehiculo con mayor Ingreso: ${topVehicle.key} (\$${topVehicle.value.toStringAsFixed(0)})',
                        style: pw.TextStyle(fontSize: 18)),
                    pw.SizedBox(height: 10),
                    pw.Text('Detalles de las Reservas:',
                        style: pw.TextStyle(fontSize: 18)),
                    pw.SizedBox(height: 10),
                    pw.ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        var order = orders[index];
                        return pw.Container(
                          margin: const pw.EdgeInsets.only(bottom: 8),
                          child: pw.Text(
                            'Vehículo: ${order.carName} | Fecha: ${DateFormat('dd/MM/yyyy').format(order.orderDate)} | Precio Total: \$${order.totalAmount}',
                          ),
                        );
                      },
                    ),
                  ]);
            }));
            // Guardar el pdf
            final outputDir = await getApplicationDocumentsDirectory();
            final file = File("${outputDir.path}/reportes_ventas.pdf");
            await file.writeAsBytes(await pdf.save());

            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('PDF generado en: ${file.path}')));
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Gráfico de barras
                SizedBox(
                  height: 600,
                  child: BarChart(
                    BarChartData(
                      barGroups: barGroups,
                      borderData: FlBorderData(show: false),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final carName = vehicleIncome.keys.firstWhere(
                                (name) => name.hashCode == value,
                                orElse: () => '',
                              );
                              // Limitamis el maximo de caracteres a 10
                              final truncatedName = carName.length > 8
                                  ? '${carName.substring(0, 8)}...'
                                  : carName;
                              return Text(
                                truncatedName,
                                style: TextStyle(fontSize: 11),
                                softWrap: true,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              );
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 50,
                            getTitlesWidget: (value, meta) {
                              return Text('\$${value.toStringAsFixed(0)}');
                            },
                          ),
                        ),
                      ),
                      // Establecer un rango para el eje Y
                      gridData: const FlGridData(show: true),
                      maxY:
                          vehicleIncome.values.reduce((a, b) => a > b ? a : b) *
                              1.1,
                      minY: 0,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Boton para generar PDF
                ElevatedButton(
                    onPressed: generarPDF,
                    child: const Text('Generar PDF del Resumen de Ventas'))
              ],
            ),
          );
        } else {
          return const Center(
            child: Text('Error al cargar las ordenes.'),
          );
        }
      }),
    );
  }
}
