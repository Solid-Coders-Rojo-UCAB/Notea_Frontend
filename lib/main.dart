import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notea_frontend/infraestructura/bloc/Grupo/grupo_bloc.dart';
import 'package:notea_frontend/infraestructura/bloc/etiqueta/etiqueta_bloc.dart';
import 'package:notea_frontend/infraestructura/bloc/nota/nota_bloc.dart';
import 'package:notea_frontend/infraestructura/bloc/usuario/usuario_bloc.dart';
import 'package:notea_frontend/presentacion/pantallas/login_screen.dart';
import 'package:provider/provider.dart';
// import 'aplicacion/Notifications.dart';
import 'presentacion/pantallas/HomeScreenWithDrawer.dart';
import 'presentacion/pantallas/navigation_provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await InitNotifications();
  runApp(const MyApp());
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
