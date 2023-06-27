// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notea_frontend/dominio/agregados/grupo.dart';
import 'package:notea_frontend/dominio/agregados/nota.dart';
import 'package:notea_frontend/infraestructura/bloc/nota/nota_bloc.dart';
import 'package:notea_frontend/presentacion/widgets/card.dart';
import 'package:notea_frontend/presentacion/widgets/desplegable.dart';

// ignore: must_be_immutable
class MyDropdown extends StatefulWidget {
  List<Grupo>? grupos;
  MyDropdown({super.key, required this.grupos});

  @override
  // ignore: library_private_types_in_public_api
  _MyDropdownState createState() => _MyDropdownState();
}

class _MyDropdownState extends State<MyDropdown> {
  List<Nota>? notas = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notaBloc = BlocProvider.of<NotaBloc>(context);
      notaBloc.add(NotaCatchEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return BlocBuilder<NotaBloc, NotaState>(
      builder: (context, state) {
        if (state is NotasSuccessState) {
          notas = state.notas;
            return ListView.builder(
              itemCount: widget.grupos?.length,
              itemBuilder: (context, index){
                final grupo = widget.grupos![index]; //Tenemos el grupo que se renderizará
                final notasDeGrupo = notas?.where((nota) => nota.idGrupo.getIdGrupoNota() == grupo.idGrupo
                && !(nota.getEstado() == "PAPELERA")).toList();
              if (notasDeGrupo != null && notasDeGrupo.isNotEmpty) {
                return Column(
                  children: <Widget>[
                    Tooltip(
                      message: grupo.idGrupo,
                      child: Desplegable(
                        titulo: grupo.nombre.nombre,
                        contenido: Column(
                            children: notasDeGrupo.map((nota) {
                          return SizedBox(
                              child: CartaWidget(
                            fecha: nota.getFechaCreacion(),
                            titulo: nota.titulo.tituloNota,
                            contenido: nota.contenido.contenidoNota,
                            tags: const ['Tag1', 'Tag2', 'Tag3sssssss'],
                            onDeletePressed: () {
                              // Lógica para eliminar la nota
                            },
                          ));
                        }).toList()),
                      ),
                    ),

                    const SizedBox(
                        height: 8.0), // Separación entre los desplegables
                  ],
                );
              }
            });
      } else {
        // No mostrar el grupo si no tiene notas que pertenecen a él
        return const SizedBox.shrink();
      }
    });
  }
}

          // notas?.forEach((nota) {
          //   print('Título: ${nota.titulo.tituloNota}');
          //   print('Contenido: ${nota.contenido.contenidoNota}');
          //   print('Fecha de creación: ${nota.fechaCreacion}');
          //   print('Estado: ${nota.estado.name}');
          //   print('Ubicación Latitud: ${nota.ubicacion.latitud}');
          //   print('Ubicación Longitud: ${nota.ubicacion.longitud}');
          //   print('ID: ${nota.id}');
          //   print('---------------------');
          // });
          // print('--------------------------');
          // print('--------------------------');

                  //   notasDeGrupo?.forEach((nota) {
                  //   print('Título: ${nota.titulo.tituloNota}');
                  //   print('Contenido: ${nota.contenido.contenidoNota}');
                  //   print('Fecha de creación: ${nota.fechaCreacion}');
                  //   print('Estado: ${nota.estado.name}');
                  //   print('Ubicación Latitud: ${nota.ubicacion.latitud}');
                  //   print('Ubicación Longitud: ${nota.ubicacion.longitud}');
                  //   print('ID grupo: ${nota.idGrupo.getIdGrupoNota()}');
                  //   print('ID: ${nota.id}');
                  //   print('---------------------');
                  // });
