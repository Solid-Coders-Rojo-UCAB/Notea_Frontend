import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notea_frontend/dominio/agregados/etiqueta.dart';
import 'package:notea_frontend/dominio/agregados/grupo.dart';
import 'package:html/parser.dart';

import '../../infraestructura/bloc/Grupo/grupo_bloc.dart';
import '../pantallas/Creacion_Edicion_Nota.dart';

class CartaWidget extends StatelessWidget {
  final DateTime fecha;
  final String titulo;
  final List<String> tags;
  final VoidCallback? onDeletePressed;
  final List<Grupo>? grupos;
  final List<Etiqueta>? etiquetas;
  final List<Etiqueta>? etiquetasTomadas;

  final  Map<String, dynamic> contenidoTotal1;
  final String? idNota;

  final VoidCallback? onChangePressed;
  final bool habilitado;

  const CartaWidget({
    super.key,
    this.idNota,
    required this.fecha,
    required this.titulo,
    required this.contenidoTotal1,
    required this.tags,
    this.grupos,
    this.etiquetas,
    this.etiquetasTomadas,
    this.onDeletePressed,
    this.onChangePressed,
    required this.habilitado,
  });

  @override
  Widget build(BuildContext context) {
    print('CARD => Recibiendo el map de contenido');
    String formattedDate = fecha.month < 9 ? '0${fecha.month} - ${fecha.day}' : '${fecha.month} - ${fecha.day}'; // Formateo de la fecha
    return Center(
      child: GestureDetector(
        onTap: () {
          final grupoBloc = BlocProvider.of<GrupoBloc>(context);
          grupoBloc.add(GrupoReload());
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AccionesConNota(
                idNota: idNota,
                accion: 'Editar Nota',
                grupos: grupos,
                titulo: titulo,
                etiquetas: etiquetas,
                contenidoTotal1: contenidoTotal1,
              )),
          );
        },
        child: FractionallySizedBox(
          widthFactor: 0.95, // Establece
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    constraints: const BoxConstraints(
                      maxWidth:
                          100, // Establece el ancho máximo para el contenedor
                    ),
                    child: Text(
                      formattedDate,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                      overflow: TextOverflow
                          .ellipsis, // Muestra "..." si el texto es demasiado largo
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 24.0,
                        height: 24.0,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors
                              .blue, // Cambiar el color del círculo según tus necesidades
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              constraints: const BoxConstraints(
                                maxWidth:
                                    250, // Establece el ancho máximo para el contenedor
                              ),
                              child: Text(
                                titulo,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                                overflow: TextOverflow
                                    .ellipsis, // Muestra "..." si el texto es demasiado largo
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Container(
                              constraints: const BoxConstraints(
                                maxWidth:
                                    300, // Establece el ancho máximo para el contenedor
                              ),
                              child: Text(
                                convertHtmlToText(contenidoTotal1['contenido'][0]['texto']['cuerpo'].toString()),           //Cambiar por el primer contenido por lo mneos
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                  color: Color.fromARGB(125, 0, 0, 0),
                                ),
                                overflow: TextOverflow
                                    .ellipsis, // Muestra "..." si el texto es demasiado largo
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children:
                            tags.map((tag) => TagWidget(tag: tag)).toList(),
                      ),
                      Expanded(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: const Tooltip(
                                  message: 'Eliminar',
                                  child: Icon(
                                    Icons.delete,
                                    color: Color.fromARGB(255, 20, 18, 18),
                                  ),
                                ),
                                onPressed: onDeletePressed,
                              ),
                              Visibility(
                                visible: habilitado,
                                child: IconButton(
                                  icon: const Tooltip(
                                    message: 'Recuperar',
                                    child: Icon(
                                      Icons.autorenew,
                                      color: Color.fromARGB(255, 20, 18, 18),
                                    ),
                                  ),
                                  onPressed: onChangePressed,
                                ),
                              ),
                            ]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        )
      )
    );
  }

  toList() {}
}

class TagWidget extends StatelessWidget {
  final String tag;
  TagWidget({required this.tag});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 45, // Establece el ancho máximo para el contenedor
      ),
      margin: const EdgeInsets.only(right: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: const Color(0xFF21579C),
      ),
      child: Text(
        tag,
        style: const TextStyle(
            fontSize: 12.0, fontWeight: FontWeight.w300, color: Colors.white),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

String convertHtmlToText(String htmlString) {
  final document = parse(htmlString);
  final plainText = parse(document.body!.text).documentElement!.text;
  return plainText.trim().replaceAll(RegExp(r'\s+'), ' ');
}