import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notea_frontend/dominio/agregados/VOUsuario/nombreUsuario.dart';
import 'package:notea_frontend/dominio/agregados/grupo.dart';
import 'package:notea_frontend/dominio/agregados/usuario.dart';
import 'package:notea_frontend/infraestructura/bloc/Grupo/grupo_bloc.dart';
import 'package:notea_frontend/presentacion/pantallas/lista_notas_screen.dart';
import 'package:notea_frontend/presentacion/widgets/BottomBar.dart';
import 'package:notea_frontend/presentacion/widgets/MenuDesplegable.dart';
import 'package:notea_frontend/presentacion/widgets/angel/floating_button.dart';


class MessagesScreen extends StatefulWidget {
  final Usuario usuario;

  const MessagesScreen({Key? key, required this.usuario}) : super(key: key);

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  double loadingBallSize = 1;
  AlignmentGeometry _alignment = Alignment.center;
  bool stopScaleAnimtion = false;
  bool showMessages = true;
  int notesCount = 0;
  bool showNotesCount = true;
  List<Grupo>? grupos = [];


  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      final grupoBloc = BlocProvider.of<GrupoBloc>(context);
      grupoBloc.add(GrupoCatchEvent(idUsuarioDueno: widget.usuario.id));
    });

    Future.delayed(const Duration(milliseconds: 2000), () {
      setState(() {
        _alignment = Alignment.topRight;
        stopScaleAnimtion = true;
      });
    });
  }

@override
Widget build(BuildContext context) {
  return BlocBuilder<GrupoBloc, GrupoState>(
    builder: (context, state) {
      if (state is GruposFailureState){
        return const Center(child: Text('Error al cargar los grupos'));
      }
      if (state is GruposSuccessState) {
        grupos = state.grupos;
        // print(context.read<NombreUsuario>);
      }
      return Scaffold(
        key: _scaffoldKey,
        floatingActionButton: MyFloatingButton(
          onPressed: () {
            // Acciones al presionar el botón de agregar nota
            print('AGREGANDO UNA NOTA  MI PANA ');
          },
        ),
        bottomNavigationBar: BottomBar(scaffoldKey: _scaffoldKey),
        drawer: CustomDrawer(
          username: 'John Doe',
          email: 'johndoe@example.com',
          onBackButtonPressed: () {
            Navigator.pop(context); // Volver a la pantalla anterior
          },
          menuItems: [
            MenuItem(
              icon: Icons.home,
              title: 'Inicio',
              onPressed: () {
                // Acción al presionar el botón de inicio
              },
            ),
            MenuItem(
              icon: Icons.settings,
              title: 'Configuración',
              onPressed: () {
                // Acción al presionar el botón de configuración
              },
            ),
            // Agregar más elementos de menú si es necesario
          ],
          onLogoutPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Confirmación'),
                  content: const Text('¿Estás seguro de que deseas cerrar la sesión?'),
                  actions: [
                    TextButton(
                      child: const Text('Cancelar'),
                      onPressed: () {
                        Navigator.pop(context); // Cerrar el cuadro de diálogo
                      },
                    ),
                    TextButton(
                      child: const Text('Aceptar'),
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/login'); // Cerrar sesión
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
        body:  Padding(
        padding: const EdgeInsets.only(top: 60),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TweenAnimationBuilder<double>(
                  duration: const Duration(seconds: 1),
                  tween: Tween(begin: 0, end: 1),
                  builder: (_, value, __) => Opacity(
                    opacity: value,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hola, ${widget.usuario.nombre.value}',
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.85),
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Tienes un total de ${grupos!.length} grupos',
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 23,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            Expanded(
              child: MyDropdown(grupos: grupos),
            ),
          ],
        ),
      ),




      );
    },
  );
}

}


