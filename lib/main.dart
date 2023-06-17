// import 'package:flutter/material.dart';
// import 'package:notea_frontend/presentacion/pantallas/login_screen.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         debugShowCheckedModeBanner: false,
//         theme: ThemeData(
//           primaryColor: const Color(0XFF21579C),
//           colorScheme: ColorScheme.fromSwatch()
//               .copyWith(secondary: const Color(0XFF6188D3)),
//           highlightColor: const Color(0XFFD6A319),
//           shadowColor: const Color(0XFFE4F0FF),
//           textTheme: const TextTheme(
//             displayLarge: TextStyle(
//               fontSize: 35.0,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFFFFFFFF),
//             ),
//             displayMedium: TextStyle(
//               fontSize: 36.0,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF2196F3),
//             ),
//             displaySmall: TextStyle(
//               fontSize: 20.0,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF589FDE),
//             ),
//             bodyLarge: TextStyle(
//               fontSize: 20.0,
//               color: Color(0XFFB7B7D2),
//             ),
//             bodyMedium: TextStyle(
//               fontSize: 16.0,
//               fontWeight: FontWeight.w600,
//               color: Color(0xFF2196F3),
//             ),
//             titleMedium: TextStyle(
//               fontSize: 16.0,
//               fontWeight: FontWeight.w600,
//               color: Color.fromARGB(255, 0, 0, 0),
//             ),
//             titleSmall: TextStyle(
//               fontSize: 16.0,
//               fontWeight: FontWeight.w600,
//               color: Color.fromARGB(255, 255, 255, 255),
//             ),
//           ),
//         ),
//         home: const LoginScreen());
//   }
// }
            //TODO esto se esta haciendo porque tenemos problemas para manejar el API

import 'package:flutter/material.dart';
import 'package:notea_frontend/dominio/agregados/nota.dart';
import 'package:notea_frontend/presentacion/provider/providerNota.dart';
import 'package:notea_frontend/presentacion/provider/providerUsuario.dart';
import 'package:provider/provider.dart';
// Importa las clases y archivos necesarios


Future<void> main() async {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NotaProvider()),
        ChangeNotifierProvider(create: (_) => UsuarioProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'My App',
      home: MyScreen(),
    );
  }
}

class MyScreen extends StatelessWidget {
  const MyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notaProvider = Provider.of<NotaProvider>(context, listen: true);
    final usuarioProvider = Provider.of<UsuarioProvider>(context, listen: true);

    // Llama al método getNotas() cuando la pantalla se inicie
    Future.delayed(Duration.zero, () => usuarioProvider.getUsuarios());
    Future.delayed(Duration.zero, () => notaProvider.getNotas());

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Screen'),
      ),
      body:  null
      // Container(
      //   child: Column(
      //     children: [
      //       // Muestra el nombre del usuario
      //       const Text('notas'),
      //       // Muestra la lista de notas
      //       Expanded(
      //         child: ListView.builder(
      //           itemCount: notas.length,
      //           itemBuilder: (context, index) {
      //             return ListTile(
      //               title: Text(notas[index].getTitulo()),
      //               subtitle: Text(notas[index].getContenido()),
      //             );
      //           },
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }

}