// ignore_for_file: unrelated_type_equality_checks

import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notea_frontend/dominio/agregados/etiqueta.dart';
import 'package:notea_frontend/infraestructura/Repositorio/repositorioNotaImpl.dart';
import 'package:notea_frontend/infraestructura/api/remoteDataNota.dart';
import 'package:notea_frontend/presentacion/widgets/ImageBlock.dart';
import 'package:notea_frontend/presentacion/widgets/TareaBlock.dart';
import 'package:notea_frontend/presentacion/widgets/TextBlock.dart';
import '../../../dominio/agregados/grupo.dart';
import '../../../dominio/agregados/nota.dart';

part 'nota_event.dart';
part 'nota_state.dart';

class NotaBloc extends Bloc<NotaEvent, NotaState> {
  NotaBloc() : super(const NotaInitialState()) {
    //generamos los comportamientos del bloc

    on<NotaCatchEvent>((event, emit) async {
      emit(const NotaInitialState());
      final repositorio = RepositorioNotaImpl(
          remoteDataSource: RemoteDataNotaImp(client: http.Client()));
      final notas = await repositorio.buscarNotasGrupos(event.grupos);
      if (notas.isLeft()) {
        //Ver que les parece esta manera de devolver
        emit(NotasCatchSuccessState(notas: notas.left!));
      } else {
        emit(const NotasFailureState());
      }
    });

    on<ModificarEstadoNotaEvent>((event, emit) async {
      emit(const NotaInitialState());
      final repositorio = RepositorioNotaImpl(
          remoteDataSource: RemoteDataNotaImp(client: http.Client()));

      final nota =
          await repositorio.modificarEstadoNota(event.idNota, event.estado);

      if (nota.isLeft()) {
        final notas = await repositorio.buscarNotasGrupos(event.grupos);
        if (notas.isLeft()) {
          //Ver que les parece esta manera de devolver
          if (notas.left!.isEmpty) {
            emit(NotasCatchSuccessState(notas: notas.left!));
          }
        } else {
          emit(const NotasFailureState());
        }
      } else {
        emit(const NotasFailureState());
      }
    });

    on<DeleteNoteEvent>((event, emit) async {
      emit(const NotaInitialState());
        final repositorio = RepositorioNotaImpl(
            remoteDataSource: RemoteDataNotaImp(client: http.Client()));
        final eliminado = await repositorio.borrarNota(event.idNota);

        await Future.delayed(const Duration(seconds: 1));

        if (eliminado.isLeft()) {
          final notas = await repositorio.buscarNotasGrupos(event.grupos);
          if (notas.isLeft()) {
            //Ver que les parece esta manera de devolver
            if (notas.left!.isEmpty) {
              emit(NotasCatchSuccessState(notas: notas.left!));
            }
          } else {
            emit(const NotasFailureState());
          }
        } else {
          emit(const NotasFailureState());
        }
      },
    );

    on<CreateNotaEvent>((event, emit) async {
      emit(const NotaInitialState());
      final repositorio = RepositorioNotaImpl(
          remoteDataSource: RemoteDataNotaImp(client: http.Client()));
      final nota = await repositorio.crearNota(
          event.tituloNota,
          await mapContenido(event.listInfo),
          etiqeutasListId(event.etiquetas),
          event.grupo);

      await Future.delayed(const Duration(milliseconds: 300));
      nota!.isLeft()
          ? emit(const NotasCreateSuccessState())
          : emit(const NotasFailureState()); //emitimos el estado de error
    });

    on<EditarNotaEvent>((event, emit) async {
      emit(const NotaInitialState());

      emit(const NotasCreateSuccessState());

      // final repositorio = RepositorioNotaImpl(remoteDataSource: RemoteDataNotaImp(client: http.Client()));
      // final nota = await repositorio.editarNota(event.idNota ,event.tituloNota, await mapContenido(event.listInfo), event.etiquetas, event.grupo);

      // await Future.delayed(const Duration(milliseconds: 300));
      // nota!.isLeft() ?  emit(const NotasCreateSuccessState()): emit(const NotasFailureState());//emitimos el estado de error
    });
  }
}

// Future<void> pintaLista() async {
//     print('-------ReciveddataList---------');
//     print(recivedDataList.length);
//     print('-------ReciveddataList---------');
//     for (var element in recivedDataList) {
//       if(element is TextBlockPrueba1){
//         final textBlock = element;
//         print('------------');
//         String? html = await textBlock.editorKey.currentState?.getHtml();         //Aca captamos el codigo de la lista
//         print(html);
//         print('------------');
//       }else if(element is ImageBlock) {
//         print('-----');
//         print('Esto es una IMAGEN');
//         print(element.controller.getSelectedImage());//Esto me devuelve el objeto imagen
//         NetworkImage networkImage = element.controller.getSelectedImage()!.image as NetworkImage;   //NetworkImage acepta la ruta de la imagen
//         String imageUrl = networkImage.url;   //Obtenemos el url de la imagen
//         Uint8List? imageBuffer = await downloadImage(imageUrl);     //Se convierte la imagen a buffer
//         if (imageBuffer != null) {
//           String base64Image = base64Encode(imageBuffer);
//           // Aquí tienes la imagen codificada en base64
//           print('Imagen codificada en base64: $base64Image');     //Esto es lo que se guarda en la base de datos //https://codebeautify.org/base64-to-image-converter
//           print('Se guardo el buffer');
//         } else {
//           // Ocurrió un error al descargar la imagen
//           print('Erro mi pana');
//         }
//         print(element.controller.getImageName());
//         print('-----');
//       }else if(element is TareaBlock){
//         print('-----');
//         print('Esto es una TAREA');
//         final tareaBlock = element; // Crea una instancia del widget TextBlock
//         print(tareaBlock.controller1.listaTareas);
//         for (var element in tareaBlock.controller1.listaTareas) {
//           print('--------');
//           print(element.description);
//           print(element.completed);
//           print('--------');
//         }
//       }
//     }
//   }

Future<Map<String, dynamic>> mapContenido(List<dynamic> listInfo) async {
  List<Map<String, dynamic>> contenidoList = [];
  int cant = 0;
  for (var element in listInfo) {
    cant = cant + 1;
    if (element is TextBlocPrueba3) {
      final textBlock = element;
      String? html = await textBlock.editorKey.getText();

      contenidoList.add({
        'texto': {'cuerpo': html},
        'orden': cant,
      });
    } else if (element is TareaBlock) {
      final tareaBlock = element;
      List<Task> tasks = tareaBlock.controller1.listaTareas;

      List<Map<String, dynamic>> tareaValue = [];
      for (var task in tasks) {
        tareaValue.add({
          'titulo': task.description,
          'check': task.completed,
        });
      }
      contenidoList.add({
        'tarea': {
          'value': tareaValue,
        },
        'orden': cant,
      });
    } else if (element is ImageBlock) {
      contenidoList.add({
        'imagen': {
          'buffer': element.controller.getBase64(),
          'nombre': element.controller.getImageName()
        },
        'orden': cant,
      });
      // Resto del código...
    }
  }
  Map<String, dynamic> contenido = {'contenido': contenidoList};

  //print('Contenido oooooooooooooooooooooooooooooooooooooooo');

  //print(contenido);

  return contenido;
}

List<String> etiqeutasListId(List<Etiqueta>? etiquetas) {
  return etiquetas!.map((etiqueta) => etiqueta.idEtiqueta).toList();
}
