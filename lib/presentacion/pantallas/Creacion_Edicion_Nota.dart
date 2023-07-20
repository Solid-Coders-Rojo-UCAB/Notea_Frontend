// ignore_for_file: must_be_immutable, library_private_types_in_public_api, file_names, avoid_print, unnecessary_null_comparison, avoid_init_to_null

import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/material.dart';
import 'package:notea_frontend/dominio/agregados/etiqueta.dart';
import 'package:notea_frontend/dominio/agregados/grupo.dart';
import 'package:notea_frontend/infraestructura/bloc/nota/nota_bloc.dart';
import 'package:notea_frontend/infraestructura/bloc/usuario/usuario_bloc.dart';
import 'package:notea_frontend/presentacion/pantallas/Container_Editor_Nota.dart';
import 'package:notea_frontend/presentacion/pantallas/HomeScreenWithDrawer.dart';
import 'package:notea_frontend/presentacion/pantallas/home_screen.dart';
import 'package:notea_frontend/presentacion/pantallas/navigation_provider.dart';
import 'package:notea_frontend/presentacion/widgets/Boton_Gru_Eti.dart';
import 'package:notea_frontend/presentacion/widgets/ImageBlock.dart';
import 'package:notea_frontend/presentacion/widgets/TareaBlock.dart';
import 'package:notea_frontend/presentacion/widgets/TextBlock.dart';
import '../../dominio/agregados/usuario.dart';
import 'mapaView.dart';

class AccionesConNota extends StatefulWidget {
  final String accion;
  final List<Grupo>? gruposGeneral;
  final Grupo? grupoNota;
  final List<Etiqueta>? etiquetasGeneral;
  final List<Etiqueta>? etiquetasNota;

  final String? titulo;
  final String? idNota;
  final List<dynamic>? contenidoTotal1;
  final double? latitud;
  final double? longitud;
  final Usuario usuario;

  const AccionesConNota(
      {Key? key,
      required this.accion,
      required this.gruposGeneral,
      this.idNota,
      this.titulo,
      this.contenidoTotal1,
      this.etiquetasGeneral,
      this.grupoNota,
      this.etiquetasNota,
      required this.usuario,
      this.latitud,
      this.longitud
      })
      : super(key: key);

  @override
  _AccionesConNotaState createState() => _AccionesConNotaState();
}

class _AccionesConNotaState extends State<AccionesConNota> {
  late TextEditingController _tituloController;
  String receivedData = '';

  late List<dynamic> recivedDataList = [];
  late List<Etiqueta>? recivedDataEitquetas =
      []; //ACA HAY QUE SETEAR LAS ETIQUETAS QUE TIENE LA NOTA
  late Grupo? receivedDataGrupo = null;

  bool hayGrupo = false;
  bool hayEtiquetas = false;

  List<double> ubicacionList = [0,0];
  Placemark? placemark = Placemark();
  String? ciudad;

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(text: widget.titulo ?? '');

      ubicacionList = [widget.latitud ?? 0, widget.longitud ?? 0];

    if (ubicacionList[0] != 0 && ubicacionList[1] != 0) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
        placemark = await _loadCurrentLocation();
        setState(() {
          ciudad = placemark!.locality;
        });
      });
    }
  }

  @override
  void dispose() {
    _tituloController.dispose();
    super.dispose();
  }

  void pop(context) {
    _tituloController.dispose();
    context.read<NavigationProvider>().toMessagesScreen();
  }

  Future<Placemark> _loadCurrentLocation() async {
    print("load current location");
    return (await placemarkFromCoordinates(
        ubicacionList[0], ubicacionList[1]))[0];
  }

  //Traemos de la lista de Text, Image, Tarea ...Block los hijos para tener la informacion que conforma la nota
  void handleDataReceived(String data, List<dynamic> dataList) {
    receivedData = data;
    recivedDataList = dataList;
  }

//Traemos de la lista de etiquetas, las etiquetas que seleccione el usuario
  void handleDataEtiquetas(List<Etiqueta> dataEiquetas) {
    recivedDataEitquetas = dataEiquetas;
    if (recivedDataEitquetas!.isEmpty) {
      hayEtiquetas = false;
    } else {
      hayEtiquetas = true;
    }
    setState(() {
      recivedDataEitquetas = recivedDataEitquetas;
    });
  }

  //Traemos de la lista de grupos el grupo seleccionado
  void handleDataGrupo(Grupo dataGrupo) {
    receivedDataGrupo = dataGrupo;
    hayGrupo = true;
    setState(() {
      receivedDataGrupo = receivedDataGrupo;
    });
  }

  Future<Uint8List?> downloadImage(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        print('Failed to download image: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error downloading image: $e');
      return null;
    }
  }

  // Evento de regresar
  void _regresar() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => HomeScreenWithDrawer(usuario : widget.usuario)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.accion),
        backgroundColor: const Color(0xFF21579C),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 24, bottom: 40),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextFormField(
                    autofocus: false,
                    controller: _tituloController,
                    decoration: InputDecoration(
                      hintText: 'Ingrese el título de la nota',
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 16.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Colors.black12,
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Colors.blue,
                          width: 2.0,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height:
                        500, //Se cambia de tamano al contenedor del contenido de las notas
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black12,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ContainerEditorNota(
                        onDataReceived: handleDataReceived,
                        contenidoTotal1: widget.contenidoTotal1,
                        usuario: widget.usuario,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12.0),
                Column(
                  children: [
                    (ubicacionList[0] != 0 || widget.accion == 'Creando Nota') ?
                      ElevatedButton(
                        onPressed: () async {
                          ubicacionList = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MapaView(
                                        latitud: ubicacionList[0],
                                        longitud: ubicacionList[1],
                                        creando: widget.accion == 'Creando Nota' ? true : false,
                                      )));
                          if (ubicacionList[0] != 0 && ubicacionList[1] != 0) {
                          placemark = await _loadCurrentLocation();
                          ciudad = placemark!.locality;
                          } else {
                            ciudad = null;
                          }
                          setState(() {
                            //update UI
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0),
                          ),
                          backgroundColor: ciudad != null
                              ? Color.fromARGB(255, 109, 231, 115)
                              : const Color(0xFF21579C),
                        ),
                        child: SizedBox(
                          width: ciudad != null
                              ? ciudad!.length.toDouble() * 11
                              : 80,
                          child: Row(
                            children: [
                              const Icon(Icons.location_on_sharp),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: ciudad != null
                                    ? Text(ciudad!)
                                    : const Text("Ubicacion"),
                              ),
                            ],
                          ),
                        )) : const Text(''),
                    Text(
                        'Etiquetas seleccionadas: ${recivedDataEitquetas!.length}'),
                    const SizedBox(height: 8.0),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: recivedDataEitquetas!.map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 4.0),
                          decoration: BoxDecoration(
                            color: getColorTag(tag.getColorEtiqueta()),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Text(
                            tag.getNombre(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16.0),
                    Column(
                      children: [
                        const Text('Grupo seleccionado:'),
                        hayGrupo
                            ? Chip(
                                avatar: CircleAvatar(
                                  backgroundColor: Colors.grey.shade800,
                                  child: Text(
                                      obtenerPrimerasDosLetrasMayusculas(
                                          receivedDataGrupo!.getNombre())),
                                ),
                                label: Text(receivedDataGrupo!.getNombre()),
                              )
                            : const Text(''),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                widget.accion == 'Creando Nota'
                    ? AnimatedButton(
                        onDataReceivedGrupo: handleDataGrupo,
                        onDataReceivedEtiqueta: handleDataEtiquetas,
                        puedeCrear: hayGrupo && hayEtiquetas ? true : false,
                        grupo: receivedDataGrupo,
                        listInfo: recivedDataList,
                        tituloNota: _tituloController.text,
                        gruposGeneral: widget.gruposGeneral,
                        etiquetasGeneral: widget.etiquetasGeneral,
                        accion: widget.accion,
                      )
                    : AnimatedButton(
                        onDataReceivedGrupo: handleDataGrupo,
                        onDataReceivedEtiqueta: handleDataEtiquetas,
                        puedeCrear: hayGrupo && hayEtiquetas ? true : false,
                        grupo: receivedDataGrupo,
                        listInfo: recivedDataList,
                        tituloNota: _tituloController.text,
                        gruposGeneral: widget.gruposGeneral,
                        etiquetasGeneral: widget.etiquetasGeneral,
                        etiquetasNota: widget.etiquetasNota,
                        grupoNota: widget.grupoNota,
                        accion: widget.accion,
                      ),
                if (hayEtiquetas &&
                    hayGrupo &&
                    recivedDataList.isNotEmpty &&
                    _tituloController.text.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(
                        right: 40,
                        bottom: 50), // Margen de 16.0 en todos los lados
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: FloatingActionButton(
                        heroTag: 'btnGuardar',
                        onPressed: () {
                          if (widget.accion == 'Creando Nota') {
                            BlocProvider.of<NotaBloc>(context).add(
                              CreateNotaEvent(
                                tituloNota: _tituloController.text,
                                listInfo: recivedDataList,
                                grupo: receivedDataGrupo,
                                etiquetas: recivedDataEitquetas,
                                latitud: ubicacionList[0],
                                longitud: ubicacionList[1],
                              ),
                            );
                          } else {
                            print('recivedDataEitquetas-----------');
                            print(recivedDataEitquetas);
                            print('recivedDataEitquetas-----------');
                            BlocProvider.of<NotaBloc>(context).add(
                              EditarNotaEvent(
                                idNota: widget.idNota,
                                tituloNota: _tituloController.text,
                                listInfo: recivedDataList,
                                grupo: receivedDataGrupo,
                                etiquetas: recivedDataEitquetas,
                                grupoGeneral: widget.gruposGeneral,
                              ),
                            );
                          }
                          _regresar();
                        },
                        backgroundColor: const Color(0XFFD6A319),
                        child: const Icon(
                          Icons.sd_storage_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String obtenerPrimerasDosLetrasMayusculas(String texto) {
  if (texto.length >= 2) {
    final primerasDosLetras = texto.substring(0, 2);
    final primerasDosLetrasMayusculas = primerasDosLetras.toUpperCase();
    return primerasDosLetrasMayusculas;
  } else {
    return texto.toUpperCase();
  }
}

Color getColorTag(String color) {
  switch (color) {
    case 'AMBER':
      return Colors.amber;
    case 'BLUE':
      return Colors.blue;
    case 'RED':
      return Colors.red;
    case 'PURPLE':
      return Colors.purple;
    case 'GREEN':
      return Colors.green;
    case 'INDIGO':
      return Colors.indigo;
    case 'BLACK':
      return Colors.black;
    case 'ORANGE':
      return Colors.orange;
    default:
      return Colors
          .grey; // Color predeterminado si no se encuentra el nombre de color
  }
}
