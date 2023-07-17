// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notea_frontend/dominio/agregados/etiqueta.dart';
import 'package:notea_frontend/dominio/agregados/grupo.dart';
import 'package:notea_frontend/dominio/agregados/usuario.dart';
import 'package:notea_frontend/infraestructura/bloc/Grupo/grupo_bloc.dart';
import 'package:notea_frontend/presentacion/pantallas/Creacion_Edicion_Nota.dart';


class MyFloatingButton extends StatefulWidget {
  final List<Grupo>? grupos;
  final List<Etiqueta>? etiquetas;
  final Usuario usuario;
  const MyFloatingButton({Key? key, required Null Function() onPressed, required this.grupos, required this.etiquetas , required this.usuario,});
  @override
  State<MyFloatingButton> createState() => FloatingButtonState();
}

class FloatingButtonState extends State<MyFloatingButton> {
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20, right: 20),
      alignment: Alignment.bottomRight,
      child: FloatingActionButton(
        onPressed: () {
          // Navegar a otra pantalla
          final grupoBloc = BlocProvider.of<GrupoBloc>(context);
          grupoBloc.add(GrupoReload());

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AccionesConNota(accion: 'Creando Nota', gruposGeneral: widget.grupos, etiquetasGeneral: widget.etiquetas, usuario: widget.usuario,)),
          );
        },
        // child: const Icon(Icons.addchart_sharp),
        child: const Icon(Icons.post_add_rounded),
      ),
    );
  }
}

