// ignore_for_file: unrelated_type_equality_checks

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notea_frontend/dominio/agregados/grupo.dart';
import 'package:notea_frontend/dominio/agregados/nota.dart';
import 'package:notea_frontend/infraestructura/bloc/Grupo/grupo_bloc.dart';
import 'package:notea_frontend/infraestructura/bloc/nota/nota_bloc.dart';
import 'package:notea_frontend/presentacion/pantallas/papelera_home.dart';
import 'package:notea_frontend/presentacion/widgets/BottomBar.dart';
import 'package:notea_frontend/presentacion/widgets/card.dart';
import 'package:notea_frontend/presentacion/widgets/desplegable.dart';
import '../../dominio/agregados/usuario.dart';
import '../../infraestructura/bloc/usuario/usuario_bloc.dart';

// ignore: must_be_immutable
class Papelera extends StatefulWidget {
  List<Grupo>? grupos;
  final Usuario usuario;

  Papelera({super.key, required this.grupos, required this.usuario});

  @override
  // ignore: library_private_types_in_public_api
  _PapeleraState createState() => _PapeleraState();
}

class _PapeleraState extends State<Papelera> {
  List<Nota>? notas = [];
  String? cantidadNotas;
  AlignmentGeometry alignment = Alignment.center;
  bool stopScaleAnimtion = false;
  String? cantidadGrupos;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Map<String, dynamic> contenido = {
    "contenido": [
      {
        "texto": {"cuerpo": "Este es un texto con estilo 1"}
      },
      {
        "texto": {"cuerpo": "Este es un texto con estilo 2"}
      },
      {
        "tarea": {
          "value": [
            {
              "id": {"id": "c75b914c-4e14-4a92-8462-28ea357b5b3e"},
              "titulo": "Contenido Tarea 1 de 1",
              "check": false
            },
            {
              "id": {"id": "c1151004-e0b9-4177-a222-4b90d402f38e"},
              "titulo": "Contenido Tarea 1 de 2",
              "check": false
            }
          ],
          "assigned": true
        }
      },
      {
        "texto": {"cuerpo": "Este es un texto con estilo 2"}
      },
      {
        "tarea": {
          "value": [
            {
              "id": {"id": "ae01c6b6-b69b-4011-a1b0-8eb9602b4378"},
              "titulo": "Contenido Tarea 2 de 1",
              "check": false
            },
            {
              "id": {"id": "a471a6b1-5b06-4c0c-afeb-aeec7dc4e37b"},
              "titulo": "Contenido Tarea 2 de 2",
              "check": false
            }
          ],
          "assigned": true
        }
      }
    ],
    "assigned": true
  };

  Map<String, dynamic> convertStringToMap(String jsonString) {
    return jsonDecode(jsonString);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notaBloc = BlocProvider.of<NotaBloc>(context);
      notaBloc.add(NotaCatchEvent(grupos: widget.grupos!));
    });

    Future.delayed(const Duration(milliseconds: 2500), () {
      setState(() {
        alignment = Alignment.topRight;
        stopScaleAnimtion = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotaBloc, NotaState>(builder: (context, state) {
      if (state is NotasFailureState) {
        return const Center(child: Text('Error al cargar las notas'));
      }

      if (state is NotasCatchSuccessState) {
        notas = state.notas;
        int? suma = 0;
        int? sumaGrupos = 0;
        List<Grupo> gruposPapelera = [];

        for (int i = 0; i < widget.grupos!.length; i++) {
          final grupo = widget.grupos![i]; //Tenemos el grupo que se renderizará
          final cant = notas
              ?.where((nota) =>
                  nota.idGrupo.getIdGrupoNota() == grupo.idGrupo &&
                  (nota.getEstado() == "PAPELERA"))
              .toList();
          if (cant!.length > 0) {
            sumaGrupos = (sumaGrupos! + 1);
            gruposPapelera.add(widget.grupos![i]);
          }
          suma = (suma! + cant!.length);
        }

        cantidadGrupos = sumaGrupos.toString();
        cantidadNotas = suma.toString();

        return Scaffold(
          bottomNavigationBar:
              BottomBar(scaffoldKey: _scaffoldKey, usuario: widget.usuario),
          body: cantidadNotas == "0" //Si no hay ninguna nota en la papelera, pues vulve a la pantalla anterior
              ? 
              Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width /
                          2, // Ancho igual a la mitad de la pantalla
                      height: MediaQuery.of(context).size.height /
                          2, // Alto igual a la mitad de la pantalla
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image:
                              AssetImage('assets/images/notes_not_found.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor:
                            Colors.blue, // Color del texto del botón
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10.0), // Bordes redondeados del botón
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 10.0), // Espaciado interno del botón
                      ),
                      onPressed: () {
                        Navigator.pop(context); // Vuelve a la pantalla anterior
                      },
                      child: const Text('Volver'),
                    ),
                  ],
                )
              : //Si hay alguna nota en la papelera, pues muetrala en pantalla
              Expanded(
                  child: ListView.builder(
                      itemCount: gruposPapelera.length,
                      itemBuilder: (context, index) {
                        final grupo = gruposPapelera[
                            index]; //Tenemos el grupo que se renderizará
                        final notasDeGrupo = notas
                            ?.where((nota) =>
                                nota.getIdGrupoNota() == grupo.idGrupo &&
                                nota.getEstado() == "PAPELERA")
                            .toList();

                        if (notasDeGrupo != null && notasDeGrupo.isNotEmpty) {
                          return FractionallySizedBox(
                            widthFactor: 0.9,
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
                                        habilitado: true,
                                        fecha: nota.getFechaCreacion(),
                                        titulo: nota.titulo.tituloNota,
                                        contenidoTotal1: convertStringToMap(
                                            nota.getContenido()),
                                        tags: const [
                                          'Tag1',
                                          'Tag2',
                                          'Tag3sssssss'
                                        ],
                                        onDeletePressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title:
                                                    const Text('Confirmación'),
                                                content: const Text(
                                                    '¿Estás seguro de que deseas eliminar la nota permanentemente?'),
                                                actions: [
                                                  TextButton(
                                                    child:
                                                        const Text('Cancelar'),
                                                    onPressed: () {
                                                      Navigator.pop(
                                                          context); // Cerrar el cuadro de diálogo
                                                    },
                                                  ),
                                                  TextButton(
                                                    child:
                                                        const Text('Aceptar'),
                                                    onPressed: () {
                                                      BlocProvider.of<NotaBloc>(
                                                              context)
                                                          .add(DeleteNoteEvent(
                                                        idNota: nota.id,
                                                      ));

                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    PapeleraHomeScreen(
                                                                      usuario: context
                                                                          .read<
                                                                              UsuarioBloc>()
                                                                          .state
                                                                          .usuario!,
                                                                     )),
                                                      );
                                                      /* Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                Papelera(
                                                                                  grupos:
                                                                                      widget.grupos,
                                                                                  usuario:
                                                                                      widget.usuario,
                                                                                )));*/

                                                      // mover a la papelera
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                          // Lógica para eliminar la nota
                                        },
                                        onChangePressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title:
                                                    const Text('Confirmación'),
                                                content: const Text(
                                                    '¿Estás seguro de que deseas regresar la nota a la lista de notas?'),
                                                actions: [
                                                  TextButton(
                                                    child:
                                                        const Text('Cancelar'),
                                                    onPressed: () {
                                                      Navigator.pop(
                                                          context); // Cerrar el cuadro de diálogo
                                                    },
                                                  ),
                                                  TextButton(
                                                    child:
                                                        const Text('Aceptar'),
                                                    onPressed: () {
                                                      BlocProvider.of<NotaBloc>(
                                                              context)
                                                          .add(ModificarEstadoNotaEvent(
                                                              idNota: nota.id,
                                                              estado:
                                                                  "GUARDADO"));

                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    PapeleraHomeScreen(
                                                                      usuario: context
                                                                          .read<
                                                                              UsuarioBloc>()
                                                                          .state
                                                                          .usuario!,
                                                                     )),
                                                      );

                                                      /*
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          Papelera(
                                                                            grupos:
                                                                                widget.grupos,
                                                                            usuario:
                                                                                widget.usuario,
                                                                          )));*/

                                                      // mover a la papelera
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      ));
                                    }).toList()),
                                  ),
                                ),

                                const SizedBox(
                                    height:
                                        8.0), // Separación entre los desplegables
                              ],
                            ),
                          );
                        }
                      })),
        );
      }
      // No mostrar el grupo si no tiene notas que pertenecen a él
      return const Center(child: CircularProgressIndicator());
    });
  }
}
