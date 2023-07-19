import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:notea_frontend/main.dart';
import 'package:notea_frontend/presentacion/pantallas/login_screen.dart';

class FirebaseAPI {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  var naviKey = GlobalKey<NavigatorState>();


  void handleMessage(RemoteMessage? message) {
    if (message == null) {
      return;
    }
    naviKey.currentState?.pushNamed(LoginScreen.route, arguments: message);
  }

  Future initPushNotification() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.instance.getInitialMessage().then((handleMessage));
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging?.onBackgroundMessage(_firebaseMessagingBackGroundHandler);
  }

  Future<void> initFireNotifications() async {
    await firebaseMessaging.requestPermission();
    final FCMToken = await firebaseMessaging.getToken();
    print(FCMToken);
    initPushNotification();
  }

  Future<void> _firebaseMessagingBackGroundHandler(
      RemoteMessage message) async {
    print('_firebaseMessagingBackGroundHandler : ${message}');
  }
}
