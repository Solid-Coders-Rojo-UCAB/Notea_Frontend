// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notea_frontend/infraestructura/bloc/Grupo/grupo_bloc.dart';
import 'package:notea_frontend/presentacion/pantallas/home_screen.dart';
import 'package:notea_frontend/presentacion/pantallas/papelera_home.dart';
import 'package:notea_frontend/presentacion/pantallas/papelera_screen.dart';
import '../../dominio/agregados/usuario.dart';

class BottomBar extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Usuario usuario;

  const BottomBar({Key? key, required this.scaffoldKey, required this.usuario})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: const Color(0xFF21579C), // Establece el color deseado
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(
                Icons.book,
                size: 30,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MessagesScreen(
                              usuario: usuario,
                            )));
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.delete,
                size: 30,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PapeleraHomeScreen(
                            usuario: usuario,
                          )),
                );
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.person,
                size: 30,
                color: Colors.white,
              ),
              onPressed: () {
                scaffoldKey.currentState?.openDrawer();
              },
            )
          ],
        ),
      ),
    );
  }
}
