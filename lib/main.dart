import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:graduateproject/app.dart';
import 'package:graduateproject/features/Notifications/notifications_services.dart';
import 'package:graduateproject/features/authentication/controllers/auth_controller.dart';
import 'package:graduateproject/views/payment/stripe_payment/stripe_keys.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((value) => Get.put(AuthController()));
  Stripe.publishableKey = ApiKeys.publishableKey;
  initializeDateFormatting().then((_) => runApp(const MyApp()));
  NotificationsServices().init();


}
