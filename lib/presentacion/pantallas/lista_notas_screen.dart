// ignore_for_file: unrelated_type_equality_checks, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notea_frontend/dominio/agregados/VONota/EstadoEnum.dart';
import 'package:notea_frontend/dominio/agregados/grupo.dart';
import 'package:notea_frontend/dominio/agregados/nota.dart';
import 'package:notea_frontend/infraestructura/bloc/nota/nota_bloc.dart';
import 'package:notea_frontend/presentacion/pantallas/home_screen.dart';
import 'package:notea_frontend/presentacion/widgets/card.dart';
import 'package:notea_frontend/presentacion/widgets/desplegable.dart';

import '../../dominio/agregados/usuario.dart';

// ignore: must_be_immutable
class MyDropdown extends StatefulWidget {
  List<Grupo>? grupos;
  final Usuario usuario;

  MyDropdown({super.key, required this.grupos, required this.usuario});

  @override
  // ignore: library_private_types_in_public_api
  _MyDropdownState createState() => _MyDropdownState();
}

class _MyDropdownState extends State<MyDropdown> {
  List<Nota>? notas = [];
  String cantNotas = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notaBloc = BlocProvider.of<NotaBloc>(context);
      notaBloc.add(NotaCatchEvent(grupos: widget.grupos!));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotaBloc, NotaState>(builder: (context, state) {
      if (state is NotasCatchSuccessState) {
        notas = state.notas;
        return ListView.builder(
            itemCount: widget.grupos?.length,
            itemBuilder: (context, index) {
              final grupo =
                  widget.grupos![index]; //Tenemos el grupo que se renderizará
              final notasDeGrupo = notas
                  ?.where((nota) =>
                      nota.getIdGrupoNota() == grupo.idGrupo &&
                      !(nota.getEstado() == "PAPELERA"))
                  .toList();
              if (notasDeGrupo != null && notasDeGrupo.isNotEmpty) {
                return FractionallySizedBox(
                  widthFactor: 0.9, // Establece
                  child: Column(
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
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Confirmación'),
                                      content: const Text(
                                          '¿Estás seguro de que deseas mover a la papelera?'),
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
                                            BlocProvider.of<NotaBloc>(context)
                                                .add(ModificarEstadoNotaEvent(
                                                    idNota: nota.id,
                                                    estado: "PAPELERA"));
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        MessagesScreen(
                                                          usuario:
                                                              widget.usuario,
                                                        )));
                                            // mover a la papelera
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                                // Lógica para eliminar la nota
                              },
                            ));
                          }).toList()),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      // Separación entre los desplegables
                    ],
                  ),
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
