// ignore_for_file: file_names
import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
import 'dart:ui' as ui;
import 'dart:typed_data';


import 'package:notea_frontend/presentacion/widgets/ImageBlock.dart';
import 'package:notea_frontend/presentacion/widgets/TareaBlock.dart';
import 'package:notea_frontend/presentacion/widgets/TextBlock.dart';

import '../../dominio/agregados/nota.dart';
import '../../dominio/repositorio/repositorioNota.dart';
import '../../infraestructura/api/remoteDataNota.dart';
import '../../utils/Either.dart';

class RepositorioNotaImpl implements INotaRepository {
  final RemoteDataNotaImp remoteDataSource;
  RepositorioNotaImpl({required this.remoteDataSource});

  @override
  Future<Either<List<Nota>, Exception>> buscarNotas() async {
    final result = await remoteDataSource.buscarNotasApi();
    //Aca se guardaria en la base de datos local
    return result;
  }

  @override
  Future<Either<int, Exception>?> crearNota(String titulo, List<dynamic> listInfoContenido, List<dynamic> etiquetas, dynamic grupo) async {
    final now = DateTime.now();
    var datetimeString = DateFormat('yyyy-MM-ddTHH:mm:ssZ').format(now);// Formato de fecha 'dd/MM/yyyy'
    // List<File>? listaImagen= await imageToFile(listInfoContenido);

    Map<String, dynamic> notaDTO = {
      "titulo": titulo,
      "contenido": obtenerContenidoTextBlocks(listInfoContenido),
      "fechaCreacion": datetimeString.toString(),
      "latitud": '40.0238823',        //Colocar aca lo de la ubicacion
      "longitud": '20.0238823',
      "grupo": grupo.nombre,
      "tareas": crearEstructuraTareasJson(listInfoContenido),
    };
    print(notaDTO);
    var result = await remoteDataSource.crearNotaApiTareas(notaDTO);
    // var result = await remoteDataSource.crearNotaApi(notaDTO, listaImagen);
    return result;
  }
}

String obtenerContenidoTextBlocks(List<dynamic> lista) {
  String contenido = '';

  for (dynamic elemento in lista) {
    if (elemento is TextBlock) {
      final textBlock = elemento; // Crea una instancia del widget TextBlock
      final texto = textBlock.controller.text; // Obtiene el texto del controlador
      contenido += '$texto\n';
    }
  }
  return contenido;
}


List<Map<String, dynamic>> crearEstructuraTareasJson(List<dynamic> listInfoContenido) {
  List<Map<String, dynamic>> tareas = [];

  for (dynamic elemento in listInfoContenido) {
    if (elemento is TareaBlock) {
      final tareaElement = elemento; // Crea una instancia del widget TextBlock
      for (var element in tareaElement.controller1.listaTareas) {
        Map<String, dynamic> tareaJson = {
          'titulo': element.description,
          'check': element.completed,
        };
        tareas.add(tareaJson);
      }
    }
  }

  return tareas;
}

Future<List<Map<String, dynamic>>?> crearEstructuraImagenesJson(List<dynamic> listInfoContenido) async {
  List<Map<String, dynamic>> imagenes = [];
  for (dynamic elemento in listInfoContenido) {
    if (elemento is ImageBlock) {
      NetworkImage networkImage = elemento.controller.getSelectedImage()!.image as NetworkImage;
      String imageUrl = networkImage.url;
      Uint8List? imageBuffer = await downloadImage(imageUrl);
      if (imageBuffer != null) {
        String base64Image = base64Encode(imageBuffer);
        Map<String, dynamic> imagen = {
          "name": elemento.controller.getImageName(),
          "url": base64Image,
        };
        imagenes.add(imagen);
      }
    }
  }
  if (imagenes.isNotEmpty) {
    return imagenes;
  }
  return null;
}


  Future<Uint8List?> downloadImage(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }


Future<List<File>> imageToFile(List<dynamic> listInfoContenido) async {
  List<File> imagenesFile = [];
  for (dynamic elemento in listInfoContenido) {
    if (elemento is ImageBlock) {
      NetworkImage networkImage = elemento.controller.getSelectedImage()!.image as NetworkImage;
      String imageUrl = networkImage.url;
      Uint8List? imageBuffer = await downloadImage(imageUrl);

      // final tempDir = await getTemporaryDirectory();
      File file = await File('desktop/image.png').create();
      file.writeAsBytesSync(imageBuffer!);

      imagenesFile.add(file);
    }
  }
  return imagenesFile;
}
