import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../infraestructura/bloc/usuario/usuario_bloc.dart';
import 'home_screen.dart';

class sucess extends StatefulWidget {
  const sucess({super.key});

  @override
  _successSuscription createState() => _successSuscription();
}

class _successSuscription extends State<sucess> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amberAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //AQUI DEBERIA HABER HABER UNA IMAGEN DE CHECK//POR ALGUNA RAZON INTENTO CARGARLA EN MI COMPU Y NO  LO HACE
            const Text(
              'SUSCRIPCION APROBADA\n DISFRUTA TUS BENEFICIOS!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromARGB(255, 20, 100, 165),
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(255, 20, 100, 165)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(
                              color: Color.fromARGB(255, 20, 100, 165))))),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MessagesScreen(
                        usuario: context
                            .read<UsuarioBloc>()
                            .state
                            .usuario!), // Navega hacia la pantalla del NotaEditor
                  ),
                );
              }, //Se deberia recargar la aplicacion en este boton
              child: const Text("Confirmar"),
            ),
          ],
        ),
      ),
    );
  }
}

//METER EN UN ARCHIVO DE WIDGET
class SubTitle extends StatelessWidget {
  final String confirmasub;
  const SubTitle({
    super.key,
    required this.confirmasub,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        confirmasub,
        style: TextStyle(fontSize: 20, color: Colors.black87),
      ),
    );
  }
}
