// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notea_frontend/dominio/agregados/grupo.dart';
import 'package:notea_frontend/dominio/agregados/nota.dart';
import 'package:notea_frontend/infraestructura/bloc/nota/nota_bloc.dart';
import 'package:notea_frontend/presentacion/widgets/BottomBar.dart';
import 'package:notea_frontend/presentacion/widgets/card.dart';
import 'package:notea_frontend/presentacion/widgets/desplegable.dart';

// ignore: must_be_immutable
class Papelera extends StatefulWidget {
  List<Grupo>? grupos;
  Papelera({super.key, required this.grupos});

  @override
  // ignore: library_private_types_in_public_api
  _PapeleraState createState() => _PapeleraState();
}

class _PapeleraState extends State<Papelera> {
  List<Nota>? notas = [];
  String? cantidadNotas;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
    return BlocBuilder<NotaBloc, NotaState>(builder: (context, state) {
      if (state is NotasCatchSuccessState) {
        notas = state.notas;
        int? suma = 0;

        for (int i = 0; i < widget.grupos!.length; i++) {
          final grupo = widget.grupos![i]; //Tenemos el grupo que se renderizará
          final cant = notas
              ?.where((nota) =>
                  nota.idGrupo.getIdGrupoNota() == grupo.idGrupo &&
                  (nota.getEstado() == "PAPELERA"))
              .toList();
          suma = (suma! + cant!.length);
        }

        cantidadNotas = suma.toString();

        return Scaffold(
            bottomNavigationBar: BottomBar(scaffoldKey: _scaffoldKey),
            body: Padding(
                padding: const EdgeInsets.only(top: 60),
                child: Column(children: [
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
                      child: ListView.builder(
                          itemCount: widget.grupos?.length,
                          itemBuilder: (context, index) {
                            final grupo = widget.grupos![
                                index]; //Tenemos el grupo que se renderizará
                            final notasDeGrupo = notas
                                ?.where((nota) =>
                                    nota.idGrupo.getIdGrupoNota() ==
                                        grupo.idGrupo &&
                                    (nota.getEstado() == "PAPELERA"))
                                .toList();
                            if (notasDeGrupo != null &&
                                notasDeGrupo.isNotEmpty) {
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
                                          contenido:
                                              nota.contenido.contenidoNota,
                                          tags: const [
                                            'Tag1',
                                            'Tag2',
                                            'Tag3sssssss'
                                          ],
                                          onDeletePressed: () {
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
                                                                grupo: grupo
                                                                    .idGrupo,
                                                                estado:
                                                                    "GUARDADO"));
                                                        Navigator.pop(context);
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
