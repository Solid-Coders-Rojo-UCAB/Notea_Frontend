import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notea_frontend/infraestructura/bloc/Grupo/grupo_bloc.dart';
import 'package:notea_frontend/infraestructura/bloc/etiqueta/etiqueta_bloc.dart';
import 'package:notea_frontend/infraestructura/bloc/nota/nota_bloc.dart';
import 'package:notea_frontend/infraestructura/bloc/usuario/usuario_bloc.dart';
import 'package:notea_frontend/presentacion/pantallas/login_screen.dart';
import 'package:provider/provider.dart';
import 'aplicacion/Notifications.dart';
import 'presentacion/pantallas/HomeScreenWithDrawer.dart';
import 'presentacion/pantallas/navigation_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
//dsONZ8-5SzeEhmXgDkqK7g:APA91bHgnavDb0jY60bwVA8JypHRZwyMH7lcT_bE9RNOOZ5EGC5-4Ga4SJhsTix2su9TZQSiHqyzNAVcBBXJ7WNVkR-pPpSq2V9NV1GzAd3j6Z291bt0vtrLKFkj1-Tu7r8Ggm7H-q25
//TOKEN DE MI TELEFONO NO ELIMINAR DE MOMENTO POR FAVOR :D

final GlobalKey<NavigatorState> naviKey = GlobalKey();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  FirebaseMessaging.instance.getToken().then((value) {
    print('token : ${value}');
  });

  // Si la app se encuentra en segundo plano
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    print("onMesaggeOpenedApp :${message}");
    Navigator.pushNamed(naviKey.currentState!.context, '/login', arguments: {
      "message",
      json.encode(message.data),
    });
  });
  // Si la app se encuentra cerrada
  FirebaseMessaging.instance.getInitialMessage().then(
    (RemoteMessage? message) {
      if (message != null) {
        Navigator.pushNamed(naviKey.currentState!.context, '/login',
            arguments: {
              "message",
              json.encode(message.data),
            });
      }
    },
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackGroundHandler);
//----------------------------------------------------------------------------//
  await InitNotifications();
  runApp(const MyApp());
}

Future<void> _firebaseMessagingBackGroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('_firebaseMessagingBackGroundHandler : ${message}');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) => UsuarioBloc()), //las instancias pasan al contexto
        BlocProvider(
            create: (_) => GrupoBloc()), //las instancias pasan al contexto
        BlocProvider(
            create: (_) => NotaBloc()), //las instancias pasan al contexto
        BlocProvider(
            create: (_) => EtiquetaBloc()), //las instancias pasan al contexto
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Notea App',
        navigatorKey: naviKey,
        routes: {
          '/login': (context) => const MyApp(),
        },
        theme: ThemeData(
          primaryColor: const Color(0XFF21579C),
          colorScheme: ColorScheme.fromSwatch()
              .copyWith(secondary: const Color(0XFF6188D3)),
          highlightColor: const Color(0XFFD6A319),
          shadowColor: const Color(0XFFE4F0FF),
          textTheme: const TextTheme(
            displayLarge: TextStyle(
              fontSize: 35.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFFFFFF),
            ),
            displayMedium: TextStyle(
              fontSize: 36.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2196F3),
            ),
            displaySmall: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFF589FDE),
            ),
            bodyLarge: TextStyle(
              fontSize: 20.0,
              color: Color(0XFFB7B7D2),
            ),
            bodyMedium: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2196F3),
            ),
            titleMedium: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
            titleSmall: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
        ),
        home: BlocBuilder<UsuarioBloc, UsuarioState>(
          builder: (context, state) {
            if (state is UsuarioSuccessState) {
              return ChangeNotifierProvider(
                create: (_) => NavigationProvider(usuario: state.usuario),
                child: Builder(
                  builder: (context) =>
                      HomeScreenWithDrawer(usuario: state.usuario),
                ),
              );
            } else {
              return const LoginScreen();
            }
          },
        ),
      ),
    );
  }
}
