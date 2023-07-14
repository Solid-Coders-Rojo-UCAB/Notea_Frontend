// ignore_for_file: unrelated_type_equality_checks, unnecessary_null_comparison

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notea_frontend/dominio/agregados/VONota/EstadoEnum.dart';
import 'package:notea_frontend/dominio/agregados/etiqueta.dart';
import 'package:notea_frontend/dominio/agregados/grupo.dart';
import 'package:notea_frontend/dominio/agregados/nota.dart';
import 'package:notea_frontend/infraestructura/bloc/nota/nota_bloc.dart';
import 'package:notea_frontend/presentacion/pantallas/home_screen.dart';
import 'package:notea_frontend/presentacion/widgets/card.dart';
import 'package:notea_frontend/presentacion/widgets/desplegable.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import '../../dominio/agregados/usuario.dart';
import '../../infraestructura/bloc/Grupo/grupo_bloc.dart';
import '../../infraestructura/bloc/etiqueta/etiqueta_bloc.dart';
import '../../infraestructura/bloc/usuario/usuario_bloc.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotaBloc, NotaState>(builder: (context, state) {
      notas = state.notas;
      if (state is CeroNotasFailureState ) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/new_note.png',
                width: 250,
                height: 250,
              ),
              AnimatedTextKit(
                  animatedTexts: [TypewriterAnimatedText(
                    "No tienes notas, créala ⤵",
                    textStyle: const TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0XFF21579C),
                    ),
                    speed: const Duration(milliseconds: 100),
                  )],
                onTap: () {
                //
                }),
            ],
          ),
        );
      }
      if (state is NotasFailureState) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/error_500.png',
                  width: 250,
                  height: 250,
                ),
                AnimatedTextKit(
                    animatedTexts: [TypewriterAnimatedText(
                      "Error al obtener tus notas ⤵",
                      textStyle: const TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0XFF21579C),
                      ),
                      speed: const Duration(milliseconds: 100),
                    )],
                  onTap: () {
                  //
                  }),
              ],
            ),
          ),
        );
      }

      if (state is NotasCatchSuccessState) {
        List<Grupo> gruposPapelera = [];
        int cantNotasTotal = 0;
        for (int i = 0; i < widget.grupos!.length; i++) {
          final grupo = widget.grupos![i]; //Tenemos el grupo que se renderizará
          final cant = notas
              ?.where((nota) =>
                  nota.idGrupo.getIdGrupoNota() == grupo.idGrupo &&
                  !(nota.getEstado() == "PAPELERA"))
              .toList();
          cantNotasTotal += cantNotasTotal + cant!.length;
          if (cant.isNotEmpty) {
            gruposPapelera.add(widget.grupos![i]);
          }
        }
        final cant = notas?.where((nota) =>(nota.getEstado() == "GUARDADO")).toList();
          return cant!.isEmpty
          ?
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/new_note.png',
                    width: 250,
                    height: 250,
                  ),
                  AnimatedTextKit(
                      animatedTexts: [TypewriterAnimatedText(
                        "No tienes notas, créala ⤵",
                        textStyle: const TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0XFF21579C),
                        ),
                        speed: const Duration(milliseconds: 100),
                      )],
                    onTap: () {
                    //
                    }),
                ],
              ),
            )
          :
          ListView.builder(
              itemCount: gruposPapelera.length,
              itemBuilder: (context, index) {
                final grupo =
                    gruposPapelera[index]; //Tenemos el grupo que se renderizará
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
                                idNota: nota.id,
                                habilitado: false,
                                fecha: nota.getFechaCreacion(),
                                titulo: nota.titulo.tituloNota,
                                // contenidoTotal1: cont,
                                contenidoTotal1: convertStringToMap(nota
                                    .getContenido()), //Esto hace que se me muera toda la aplicacion
                                tags: const ['Tag1', 'Tag2', 'Tag3sssssss'],                              //Aca llenamos con las etiquetas que trae la nota
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

                                              Navigator.pop(context);
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        MessagesScreen(
                                                            usuario: context
                                                                .read<
                                                                    UsuarioBloc>()
                                                                .state
                                                                .usuario!)),
                                              );
                                              // mover a la papelera
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  // Lógica para eliminar la nota
                                },
                                onChangePressed: null,
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
    }
    
    
    
    
    
    );
  }
}
