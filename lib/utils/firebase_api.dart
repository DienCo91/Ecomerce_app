import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_app/screens/home/index.dart';
import 'package:flutter_app/utils/dialog_firebase.dart';
import 'package:get/get.dart';

@pragma('vm:entry-point')
Future<void> handlerBackgroundMessage(RemoteMessage message) async {}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;

    Get.to(Home(), arguments: message);
  }

  Future initPushNotification() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage); //close app -> mo app
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage); // background
    FirebaseMessaging.onBackgroundMessage(handlerBackgroundMessage); // chay ngam khi kill app
  }

  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print('fCMToken ${fCMToken}');
    FirebaseMessaging.onBackgroundMessage(handlerBackgroundMessage);

    FirebaseMessaging.onMessage.listen((message) {
      final context = Get.context;

      if (context != null) {
        final messageType = message.data['type'];
        final title = message.data['title'];
        final body = message.data['body'];
        final id = message.data['id'];

        if (messageType == "ORDER_CHANGE") {
          showOrderUpdateDialog(title: title, body: body, id: id);
        }
      }
    });
    initPushNotification();
  }

  Future<String?> getFCMToken() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    return fCMToken;
  }
}
