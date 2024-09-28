import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:rental_car_app/app.dart';
import 'package:rental_car_app/consts.dart';
import 'package:rental_car_app/simple_bloc_observer.dart';
import 'package:user_repository/user_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await _setup();
  Bloc.observer = SimpleBlocObserver();
  runApp(MyApp(FirebaseUserRepo()));
}

Future<void> _setup() async {
  Stripe.publishableKey = stripePublishableKey;
}
