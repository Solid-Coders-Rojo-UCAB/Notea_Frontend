// ignore_for_file: file_names
import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:notea_frontend/dominio/agregados/etiqueta.dart';
import 'package:notea_frontend/dominio/agregados/grupo.dart';
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
  Future<Either<int, Exception>?> crearNota(
    String titulo,
    Map<String, dynamic> listInfoContenido,
    List<String> etiquetas,
    Grupo grupo) async {

      
      final now = DateTime.now();
      var datetimeString = DateFormat('yyyy-MM-ddTHH:mm:ssZ')
          .format(now); // Formato de fecha 'dd/MM/yyyy'
      // List<File>? listaImagen= await imageToFile(listInfoContenido);

      Map<String, dynamic> notaDTO = {
        "titulo": titulo,
        "fechaCreacion": datetimeString.toString(),
        "grupo": grupo.idGrupo,
        "latitud": '40.0238823', //Colocar aca lo de la ubicacion
        "longitud": '20.0238823',
        "etiquetas": etiquetas,
        "contenido": listInfoContenido,
      };

      var result = await remoteDataSource.crearNotaApiTareas(notaDTO);
      // var result = await remoteDataSource.crearNotaApi(notaDTO, listaImagen);
      return result;
  }

  @override
  Future<Either<List<Nota>, Exception>> buscarNotasGrupos(
      List<Grupo> grupos) async {
    
    List<String> idsGrupos = grupos.map((grupo) => grupo.idGrupo).toList();
    final result = await remoteDataSource.buscarNotasByGruposApi(idsGrupos);

    return result;
  }

  @override
  Future<Either<int, Exception>> modificarEstadoNota(
      String id, String estado) async {
    Map<String, dynamic> notaDTO = {
      "id": id,
      "estado": estado,
    };
    var result = await remoteDataSource.changeStateNotaApi(notaDTO);
    return result;
  }

  @override
  Future<Either<int, Exception>> borrarNota(String id) async {
    Map<String, dynamic> notaDTO = {
      "id": id,
    };
    var result = await remoteDataSource.borrarNotaApi(notaDTO);
    return result;
  }

  @override
  Future<Either<int, Exception>?> editarNota(
      String? idNota,
      String titulo,
      Map<String, dynamic> listInfoContenido,
      List<dynamic> etiquetas,
      Grupo grupo) async {

    Map<String, dynamic> notaDTO = {
      "idNota": idNota,
      "titulo": titulo,
      "contenido": listInfoContenido,
      "grupo": grupo.idGrupo,
    };
    var result = await remoteDataSource.editarNotaApi(notaDTO);
    return result;
  }

}

String obtenerContenidoDelContenidoBlock(List<dynamic> lista) {
  String contenido = '';

  for (dynamic elemento in lista) {
    if (elemento is TextBlocPrueba3) {
      final textBlock = elemento; // Crea una instancia del widget TextBlock
      final texto =
          textBlock.editorKey.getText(); // Obtiene el texto del controlador
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

Future<List<Map<String, dynamic>>?> crearEstructuraImagenesJson(
    List<dynamic> listInfoContenido) async {
  List<Map<String, dynamic>> imagenes = [];
  for (dynamic elemento in listInfoContenido) {
    if (elemento is ImageBlock) {
      NetworkImage networkImage =
          elemento.controller.getSelectedImage()!.image as NetworkImage;
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
      NetworkImage networkImage =
          elemento.controller.getSelectedImage()!.image as NetworkImage;
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

