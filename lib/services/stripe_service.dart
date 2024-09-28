import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:order_repository/order_repository.dart';
import 'package:rental_car_app/consts.dart';

class StripeService {
  StripeService._();

  static final StripeService instance = StripeService._();
  final OrderRepo _orderRepo = FirebaseOrderRepo();

  Future<void> makePayment(Order order, String email) async {
    try {
      int priceTotal = double.parse(order.totalAmount).toInt();

      // 1. Crear el PaymentIntent y obtener el clientSecret
      String? paymentIntentClientSecret =
          await _createPaymentIntent(priceTotal, "usd", email);
      if (paymentIntentClientSecret == null) return;

      // 2. Inicializar la hoja de pago
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentIntentClientSecret,
        merchantDisplayName: "Rental Car App",
      ));

      // 3. Procesar el pago
      await _processPayment();

      // 4. Crear la orden en Firestore
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        // Crear la orden con estado 'Pending'
        await _createOrder(currentUser.uid, order.orderId, order.carId,
            order.carName, priceTotal, order.orderDate, order.orderEndDate);

        // 5. Actualizar el estado de la orden a 'confirmed'
        await _updateOrder(
            currentUser.uid, order.orderId, order.carId, "confirmed");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<String?> _createCustomer(String email) async {
    try {
      final Dio dio = Dio();
      var response = await dio.post("https://api.stripe.com/v1/customers",
          data: {
            "email": email,
          },
          options: Options(
            contentType: Headers.formUrlEncodedContentType,
            headers: {
              "Authorization": "Bearer $stripeSecretKey",
              "Content-type": 'application/x-www-form-urlencoded'
            },
          ));
      if (response.data != null) {
        return response.data["id"]; // Retorna el customer ID
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<String?> _createPaymentIntent(
      int amount, String currency, String email) async {
    try {
      final Dio dio = Dio();

      String? customerId = await _createCustomer(email);
      if (customerId == null) return null;
      Map<String, dynamic> data = {
        "amount": _calculateAmount(amount),
        "currency": currency,
        "customer": customerId
      };
      var response = await dio.post("https://api.stripe.com/v1/payment_intents",
          data: data,
          options: Options(
            contentType: Headers.formUrlEncodedContentType,
            headers: {
              "Authorization": "Bearer $stripeSecretKey",
              "Content-type": 'application/x-www-form-urlencoded'
            },
          ));
      if (response.data != null) {
        return response.data["client_secret"];
      }
      return null;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<void> _createOrder(
      String userId,
      String orderId,
      String carId,
      String carName,
      int amount,
      DateTime orderDate,
      DateTime orderEndDate) async {
    final now = DateTime.now();
    final order = Order(
        orderId: orderId,
        carId: carId,
        carName: carName,
        userId: userId,
        orderDate: orderDate,
        orderEndDate: orderEndDate,
        status: 'Pending',
        totalAmount: amount.toString(),
        createdAt: now,
        updatedAt: now);

    try {
      await _orderRepo.addOrder(order);
    } catch (e) {
      print("Error creating order : $e");
    }
  }

  Future<void> _processPayment() async {
    try {
      // Presentar la hoja de pago y confirmar el pago en un solo paso
      await Stripe.instance.presentPaymentSheet();
      print("Payment success!");
    } catch (e) {
      print('Error presenting payment sheet: $e');
    }
  }

  Future<void> _updateOrder(
      String userId, String orderId, String carId, String status) async {
    try {
      await _orderRepo.updateStatusPaymentOrder(userId, carId, orderId, status);
    } catch (e) {
      print("Error update status order: $e");
    }
  }

  String _calculateAmount(int amount) {
    final calculatedAmount = amount * 100;
    return calculatedAmount.toString();
  }
}
