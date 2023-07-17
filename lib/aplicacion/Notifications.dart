import 'package:flutter_local_notifications/flutter_local_notifications.dart';

//DE MOMENTO, SE INVOCA LA NOTIFCACION DONDE SE REQUIERA
//DE ESTA FORMA, TODA LA CLASE SE ENCARGA DE INICIAR DENTRO DE ANDROID Y IOS
//LAS MANDA A NIVEL LOCAL
//mostrarNotificacion(Titulo,Mensaje);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> InitNotifications() async {
  const AndroidInitializationSettings androidInit =
      AndroidInitializationSettings('app_icon');

  const DarwinInitializationSettings iosInit = DarwinInitializationSettings();

  const InitializationSettings IniciarGeneral = InitializationSettings(
    android: androidInit,
    iOS: iosInit,
  );

  await flutterLocalNotificationsPlugin.initialize(IniciarGeneral);
}

Future<void> mostrarNotificacion(String Titulo, String Mensaje) async {
  const AndroidNotificationDetails detallesAndroid =
      AndroidNotificationDetails('channelId', 'channelName');

  const DarwinNotificationDetails detallesIos = DarwinNotificationDetails();

  const NotificationDetails Notifidetalles = NotificationDetails(
    android: detallesAndroid,
    iOS: detallesIos,
  );

  await flutterLocalNotificationsPlugin.show(
      1, Titulo, Mensaje, Notifidetalles);
}
