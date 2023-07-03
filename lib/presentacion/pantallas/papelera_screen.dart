// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notea_frontend/dominio/agregados/grupo.dart';
import 'package:notea_frontend/dominio/agregados/nota.dart';
import 'package:notea_frontend/infraestructura/bloc/nota/nota_bloc.dart';
import 'package:notea_frontend/presentacion/widgets/BottomBar.dart';
import 'package:notea_frontend/presentacion/widgets/card.dart';
import 'package:notea_frontend/presentacion/widgets/desplegable.dart';
import '../../dominio/agregados/usuario.dart';

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
  String? cantidadGrupos;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
            body: Padding(
                padding: const EdgeInsets.only(top: 80),
                child: Column(children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TweenAnimationBuilder<double>(
                        duration: const Duration(seconds: 1),
                        tween: Tween(begin: 0, end: 1),
                        builder: (_, value, __) => Opacity(
                          opacity: value,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 40, right: 40),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Papelera de Notas',
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.85),
                                    fontSize: 30,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Tienes un total de $cantidadNotas notas en la papelera',
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
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

                            if (notasDeGrupo != null &&
                                notasDeGrupo.isNotEmpty) {
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
                                                contenidoTotal: [nota.contenido.contenidoNota,],
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
                                                        title: const Text(
                                                            'Confirmación'),
                                                        content: const Text(
                                                            '¿Estás seguro de que deseas eliminar la nota permanentemente?'),
                                                        actions: [
                                                          TextButton(
                                                            child: const Text(
                                                                'Cancelar'),
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context); // Cerrar el cuadro de diálogo
                                                            },
                                                          ),
                                                          TextButton(
                                                            child:
                                                                const Text('Aceptar'),
                                                            onPressed: () {
                                                              BlocProvider.of<
                                                                          NotaBloc>(
                                                                      context)
                                                                  .add(
                                                                      DeleteNoteEvent(
                                                                idNota: nota.id,
                                                              ));
                              
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              Papelera(
                                                                                grupos:
                                                                                    widget.grupos,
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
                                                onChangePressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return AlertDialog(
                                                        title: const Text(
                                                            'Confirmación'),
                                                        content: const Text(
                                                            '¿Estás seguro de que deseas regresar la nota a la lista de notas?'),
                                                        actions: [
                                                          TextButton(
                                                            child: const Text(
                                                                'Cancelar'),
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context); // Cerrar el cuadro de diálogo
                                                            },
                                                          ),
                                                          TextButton(
                                                            child:
                                                                const Text('Aceptar'),
                                                            onPressed: () {
                                                              BlocProvider.of<
                                                                          NotaBloc>(
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
                                                                              Papelera(
                                                                                grupos:
                                                                                    widget.grupos,
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
                                                },
                                              )
                                          );
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
                          }))
                ])));
      } else {
        // No mostrar el grupo si no tiene notas que pertenecen a él
        return const SizedBox.shrink();
      }
    });
  }
}
