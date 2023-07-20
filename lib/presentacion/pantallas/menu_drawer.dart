import '../../dominio/agregados/grupo.dart';
import 'package:notea_frontend/infraestructura/bloc/Grupo/grupo_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../dominio/agregados/usuario.dart';
import 'navigation_provider.dart'; // importa el navigation provider

class MENU_SCREEN extends StatefulWidget {
  final Usuario usuario;

  const MENU_SCREEN({Key? key, required this.usuario}) : super(key: key);

  @override
  _MENU_SCREENState createState() => _MENU_SCREENState();
}

class _MENU_SCREENState extends State<MENU_SCREEN> {
  int _selectedOption = 0;

  final List<String> _options = [
    'Inicio',
    'Etiquetas',
    'Grupos',
    'Papelera',
    'Cuenta',
    'Ajustes'
  ];
  final List<IconData> _icons = [
    Icons.home,
    Icons.auto_fix_high_sharp,
    Icons.all_inbox,
    Icons.delete,
    Icons.upgrade,
    Icons.settings
  ];

  @override
  Widget build(BuildContext context) {
    var navigationProvider = Provider.of<NavigationProvider>(context);

    return Container(
      color: const Color(0XFF21579C),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 220,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 35,
                          child: Icon(Icons.flutter_dash,
                              color: Color.fromARGB(255, 0, 0, 0), size: 55),
                        ),
                        const SizedBox(height: 15),
                        Text(
                            '${widget.usuario.getNombre()} ${widget.usuario.getApellido()}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                decoration: TextDecoration.none)),
                        Text(
                          widget.usuario.isSuscribed()
                              ? 'Premium User'
                              : 'Free User',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: widget.usuario.isSuscribed()
                                ? Colors.green
                                : Colors.yellow,
                            fontSize: 12,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 350, // adjust this to fit your needs
              child: ListView.builder(
                itemCount: _options.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3.0),
                    child: Material(
                      color: index == _selectedOption
                          ? const Color.fromARGB(255, 18, 63, 121)
                          : const Color(0XFF21579C),
                      child: ListTile(
                        leading: Icon(_icons[index], color: Colors.white),
                        title: Text(_options[index],
                            style: const TextStyle(
                                color: Colors.white, fontSize: 14)),
                        onTap: () {
                          setState(() {
                            _selectedOption = index;
                          });
                          if (index == 0) {
                            context
                                .read<NavigationProvider>()
                                .toMessagesScreen();
                          }
                          if (index == 3) {
                            List<Grupo>? grupos =
                                context.read<GrupoBloc>().state.grupos;
                            navigationProvider.toPapelera(grupos!);
                          }
                          if (index == 1) {
                            navigationProvider.toEtiquetasScreen();
                          }
                          if (index == 4) {
                            navigationProvider.toSuscripcionScreen();
                          }
                          if (index == 2) {
                            navigationProvider.toGrupoScreen();
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Material(
                color: const Color(0XFF21579C),
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Confirmación'),
                          content: const Text(
                              '¿Estás seguro de que deseas cerrar la sesión?'),
                          actions: [
                            TextButton(
                              child: const Text('Cancelar'),
                              onPressed: () {
                                Navigator.pop(
                                    context); // Cerrar el cuadro de diálogo
                              },
                            ),
                            TextButton(
                              child: const Text('Aceptar'),
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, '/login'); // Cerrar sesión
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                    height: 50,
                    width: 120,
                    alignment: Alignment.center,
                    padding:
                        const EdgeInsets.all(4.5), // El padding está aquí ahora
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red, width: 2.5),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.logout, color: Colors.red),
                        SizedBox(width: 1),
                        Text(
                          'Salir',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
