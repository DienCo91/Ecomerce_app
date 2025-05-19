import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/app.dart';
import 'package:flutter_app/common/constants.dart';
import 'package:flutter_app/utils/firebase_api.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get_storage/get_storage.dart';

RemoteMessage? initialFirebaseMessage;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseApi().initNotification();
  await GetStorage.init();
  initialFirebaseMessage = await FirebaseMessaging.instance.getInitialMessage();

  Stripe.publishableKey = stripePublishableKey;
  runApp(MyApp());
}
