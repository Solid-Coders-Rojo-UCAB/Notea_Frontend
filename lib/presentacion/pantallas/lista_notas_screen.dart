// ignore_for_file: unrelated_type_equality_checks, unnecessary_null_comparison, iterable_contains_unrelated_type

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notea_frontend/dominio/agregados/VONota/EstadoEnum.dart';
import 'package:notea_frontend/dominio/agregados/etiqueta.dart';
import 'package:notea_frontend/dominio/agregados/grupo.dart';
import 'package:notea_frontend/dominio/agregados/nota.dart';
import 'package:notea_frontend/infraestructura/bloc/nota/nota_bloc.dart';
import 'package:notea_frontend/presentacion/pantallas/HomeScreenWithDrawer.dart';
import 'package:notea_frontend/presentacion/pantallas/home_screen.dart';
import 'package:notea_frontend/presentacion/widgets/card.dart';
import 'package:notea_frontend/presentacion/widgets/desplegable.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import '../../dominio/agregados/usuario.dart';
import '../../infraestructura/bloc/Grupo/grupo_bloc.dart';
import '../../infraestructura/bloc/etiqueta/etiqueta_bloc.dart';
import '../../infraestructura/bloc/usuario/usuario_bloc.dart';
import 'navigation_provider.dart';

// ignore: must_be_immutable
class MyDropdown extends StatefulWidget {
  final List<Grupo>? grupos;
  final List<Etiqueta>? etiquetas;
  final Usuario usuario;


  MyDropdown(
      {Key? key,
      this.grupos,
      required this.usuario,
      this.etiquetas,
      }) // Añade esto
      : super(key: key);

  @override
  _MyDropdownState createState() => _MyDropdownState();
}

class _MyDropdownState extends State<MyDropdown> {
  List<Nota>? notas = [];
  String cantNotas = '';

  Map<String, dynamic> convertStringToMap(String jsonString) {
    print('-----------------------------------------------------------dddddddddddd');
    print(jsonDecode(jsonString));
    print('-----------------------------------------------------------dddddddddddd');
    return jsonDecode(jsonString);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      final notaBloc = BlocProvider.of<NotaBloc>(context);
      notaBloc.add(NotaCatchEvent(grupos: widget.grupos!));
    });
  }
void handleDelete(Nota nota) {
    BlocProvider.of<NotaBloc>(context)
     .add(ModificarEstadoNotaEvent(idNota: nota.id, estado: "PAPELERA", grupos: widget.grupos!));

    BlocProvider.of<NotaBloc>(context).add(NotaCatchEvent(grupos:widget.grupos!));
}

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotaBloc, NotaState>(builder: (context, state) {

      notas = state.notas;
      if (state is CeroNotasFailureState) {
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
                  animatedTexts: [
                    TypewriterAnimatedText(
                      "No tienes notas, créala ⤵",
                      textStyle: const TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0XFF21579C),
                      ),
                      speed: const Duration(milliseconds: 100),
                    )
                  ],
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
                    animatedTexts: [
                      TypewriterAnimatedText(
                        "Error al obtener tus notas ⤵",
                        textStyle: const TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0XFF21579C),
                        ),
                        speed: const Duration(milliseconds: 100),
                      )
                    ],
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
        // print('Entra - > For1');
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
        final cant =
            notas?.where((nota) => (nota.getEstado() == "GUARDADO")).toList();
        return cant!.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/new_note.png',
                      width: 250,
                      height: 250,
                    ),
                    AnimatedTextKit(
                        animatedTexts: [
                          TypewriterAnimatedText(
                            "No tienes notas, créala ⤵",
                            textStyle: const TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0XFF21579C),
                            ),
                            speed: const Duration(milliseconds: 100),
                          )
                        ],
                        onTap: () {
                          //
                        }),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: gruposPapelera.length,
                itemBuilder: (context, index) {
                  // print('Entro a la lista de view');
                  final grupo = gruposPapelera[
                      index]; //Tenemos el grupo que se renderizará
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
                                    // print('CONTENIDO DE LA NOTA-------------------------');
                                    // print(nota.getContenido());

                                    // print('------------------------ETIQUETAS----------------------------');
                                    // grupoTomado(widget.grupos, nota.getIdGrupoNota());
                                    // print('------------------------ETIQUETAS----------------------------');

                                return SizedBox(
                                    child: CartaWidget(
                                        idNota: nota.id,
                                        habilitado: false,
                                        usuario: widget.usuario,
                                        fecha: nota.getFechaCreacion(),
                                        titulo: nota.titulo.getTituloNota(),
                                        contenidoTotal1:  jsonDecode(nota.getContenido()),
                                        tags: listaEtiquetasTomadas(widget.etiquetas, nota.getEtiquetas()),
                                        gruposGeneral: widget.grupos,       //GRUPOS GENERALES
                                        grupoNota: grupoTomado(widget.grupos, nota.getIdGrupoNota()),
                                        etiqeutasGeneral: widget.etiquetas, //ETIQUETAS GENERALES
                                        etiquetasNota: listaEtiquetasTomadas(widget.etiquetas, nota.getEtiquetas()),
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
                                                    handleDelete(nota);
                                                    Navigator.pop(context);

                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => HomeScreenWithDrawer(usuario : widget.usuario)),
                                                    );
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
    });
  }
}
List<Etiqueta> listaEtiquetasTomadas(List<Etiqueta>? listaEtiquetasGeneral, List<dynamic> listaEtiquetasId){
  List<Etiqueta> etiquetasCoincidentes = [];

  for (Etiqueta etiqueta in listaEtiquetasGeneral!) {
    if (listaEtiquetasId.contains(etiqueta.idEtiqueta)) {
      etiquetasCoincidentes.add(etiqueta);
    }
  }
  return etiquetasCoincidentes;
}

Grupo? grupoTomado(List<Grupo>? listaGrupoGeneral, String idGrupo){
  for (Grupo grupo in listaGrupoGeneral!) {
    if (grupo.idGrupo == idGrupo) {
      return grupo;
    }
  }
  return null;
}

