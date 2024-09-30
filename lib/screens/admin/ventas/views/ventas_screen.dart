import 'dart:io';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
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

            // Cargar la fuente personalizada
            final fontData = await rootBundle.load('assets/Roboto-Regular.ttf');
            final fontRoboto = pw.Font.ttf(fontData);

            // Cargar el logo de la aplicación (asegúrate de tenerlo en los assets)
            final logoData =
                await rootBundle.load('assets/icon-app-rental.png');
            final logoImage = pw.MemoryImage(logoData.buffer.asUint8List());

            // Calcular la ganancia total
            double totalGanancia = 0;
            orders.forEach((order) {
              totalGanancia += double.parse(order.totalAmount);
            });

            pdf.addPage(pw.Page(
                margin: const pw.EdgeInsets.all(24),
                build: (pw.Context context) {
                  return pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        // Agregar el logo
                        pw.Center(
                          child: pw.Image(logoImage, width: 100, height: 100),
                        ),
                        pw.SizedBox(height: 20),

                        // Título del PDF
                        pw.Text('Resumen de Ventas',
                            style:
                                pw.TextStyle(fontSize: 24, font: fontRoboto)),

                        pw.SizedBox(height: 20),

                        // Descripción del vehículo con mayor ingreso
                        pw.Text(
                            'Vehiculo con mayor Ingreso: ${topVehicle.key} (\$${topVehicle.value.toStringAsFixed(0)})',
                            style:
                                pw.TextStyle(fontSize: 18, font: fontRoboto)),

                        pw.SizedBox(height: 20),

                        // Título de la tabla
                        pw.Text('Detalles de las Reservas:',
                            style:
                                pw.TextStyle(fontSize: 18, font: fontRoboto)),

                        pw.SizedBox(height: 10),

                        // Tabla de datos
                        pw.Table.fromTextArray(
                          headers: [
                            'Nombre del Vehículo',
                            'Fecha del Pedido',
                            'Precio Total'
                          ],
                          data: orders.map((order) {
                            return [
                              order.carName,
                              DateFormat('dd/MM/yyyy').format(order.orderDate),
                              '\$${order.totalAmount}',
                            ];
                          }).toList(),
                          border: pw.TableBorder.all(),
                          headerStyle:
                              pw.TextStyle(fontSize: 16, font: fontRoboto),
                          cellStyle:
                              pw.TextStyle(fontSize: 14, font: fontRoboto),
                          cellAlignments: {
                            0: pw.Alignment.centerLeft,
                            1: pw.Alignment.center,
                            2: pw.Alignment.centerRight,
                          },
                        ),

                        pw.SizedBox(height: 20),

                        // Total de ganancias
                        pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.end,
                            children: [
                              pw.Text('Total Ganancia: ',
                                  style: pw.TextStyle(
                                      fontSize: 16,
                                      fontWeight: pw.FontWeight.bold,
                                      font: fontRoboto)),
                              pw.Text('\$${totalGanancia.toStringAsFixed(2)}',
                                  style: pw.TextStyle(
                                      fontSize: 16,
                                      fontWeight: pw.FontWeight.bold,
                                      font: fontRoboto)),
                            ]),
                      ]);
                }));

            // Obtener el directorio de "Documentos"
            Directory? directory;
            if (Platform.isAndroid) {
              final externalDirectory = await getExternalStorageDirectory();
              directory =
                  await Directory('${externalDirectory!.path}/Documents')
                      .create();
              print(directory.path);

              if (!(await directory.exists())) {
                await directory.create();
              }
              directory = directory;
            } else if (Platform.isIOS) {
              directory = await getApplicationDocumentsDirectory();
            }

            // Guardar el pdf en la carpeta documents
            final file = File("${directory!.path}/resumen_ventas.pdf");
            await file.writeAsBytes(await pdf.save());

            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('PDF generado en: ${file.path}')));
            // Abrir el PDF
            final result = await OpenFile.open(file.path);
            if (result.type != ResultType.done) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('No se pudo abrir el PDF')));
            }
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 50),
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
                            reservedSize: 50,
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
                                style: TextStyle(fontSize: 10),
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
                            reservedSize: 42,
                            getTitlesWidget: (value, meta) {
                              return Text('\$${value.toStringAsFixed(0)}');
                            },
                          ),
                        ),
                        topTitles: AxisTitles(
                          // Aquí desactivamos los títulos superiores
                          sideTitles: SideTitles(showTitles: false),
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
