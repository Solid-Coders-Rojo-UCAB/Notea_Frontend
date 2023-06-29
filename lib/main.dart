import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notea_frontend/infraestructura/bloc/Grupo/grupo_bloc.dart';
import 'package:notea_frontend/infraestructura/bloc/nota/nota_bloc.dart';
import 'package:notea_frontend/infraestructura/bloc/usuario/usuario_bloc.dart';
import 'package:notea_frontend/presentacion/pantallas/login_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [ //aca se agregan todos los blocs que se van a usar en la app
        BlocProvider(create: ( _ ) => UsuarioBloc()), //las instancias pasan al contexto
        BlocProvider(create: ( _ ) => GrupoBloc()), //las instancias pasan al contexto
        BlocProvider(create: ( _ ) => NotaBloc()), //las instancias pasan al contexto
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

// import 'package:flutter/material.dart';

// class Desplegable extends StatefulWidget {
//   final String titulo;
//   final Widget contenido;

//   Desplegable({required this.titulo, required this.contenido});

//   @override
//   _DesplegableState createState() => _DesplegableState();
// }

// class _DesplegableState extends State<Desplegable> {
//   bool _mostrarContenido = false;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         GestureDetector(
//           onTap: () {
//             setState(() {
//               _mostrarContenido = !_mostrarContenido;
//             });
//           },
//           child: Container(
//             width: MediaQuery.of(context).size.width * 0.7,
//             color: Colors.grey[200],
//             padding: EdgeInsets.all(16.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 Flexible(
//                   child: Text(
//                     widget.titulo,
//                     style: TextStyle(
//                       fontSize: _mostrarContenido ? 16.0 : 18.0,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 Icon(
//                   _mostrarContenido ? Icons.expand_less : Icons.expand_more,
//                   size: 30.0,
//                 ),
//               ],
//             ),
//           ),
//         ),
//         if (_mostrarContenido)
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 16.0),
//             child: widget.contenido,
//           ),
//         SizedBox(height: 16.0), // Separación entre los desplegables
//       ],
//     );
//   }
// }

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Componente Desplegable',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Componente Desplegable'),
//         ),
//         body: Center(
//           child: Column(
//             children: <Widget>[
//               Desplegable(
//                 titulo: 'Desplegable 1',
//                 contenido: Column(
//                   children: <Widget>[
//                     Text('Componente 1'),
//                     Text('Componente 2'),
//                     Text('Componente 3'),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 8.0), // Separación entre los desplegables
//               Desplegable(
//                 titulo: 'Desplegable 2',
//                 contenido: Column(
//                   children: <Widget>[
//                     Text('Componente 4'),
//                     Text('Componente 5'),
//                     Text('Componente 6'),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// Probando el enviar data de un hijo a un padre
// import 'package:flutter/material.dart';
// import 'package:notea_frontend/presentacion/pantallas/angel/wrapper.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Wrapper Example',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: WrapperWidget(),
//     );
//   }
// }

