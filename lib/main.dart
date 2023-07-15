import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notea_frontend/infraestructura/bloc/Grupo/grupo_bloc.dart';
import 'package:notea_frontend/infraestructura/bloc/etiqueta/etiqueta_bloc.dart';
import 'package:notea_frontend/infraestructura/bloc/nota/nota_bloc.dart';
import 'package:notea_frontend/infraestructura/bloc/usuario/usuario_bloc.dart';
import 'package:notea_frontend/presentacion/pantallas/login_screen.dart';
import 'aplicacion/Notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await InitNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        //aca se agregan todos los blocs que se van a usar en la app
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
          routes: {
            '/login': (context) => const MyApp(),
            // Otras rutas de tu aplicación
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
          home: const LoginScreen()),
    );
  }
}
