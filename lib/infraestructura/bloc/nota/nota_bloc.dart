import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notea_frontend/infraestructura/Repositorio/repositorioNotaImpl.dart';
import 'package:notea_frontend/infraestructura/api/remoteDataNota.dart';
import '../../../dominio/agregados/nota.dart';

part 'nota_event.dart';
part 'nota_state.dart';
class NotaBloc extends  Bloc<NotaEvent, NotaState> {

  NotaBloc() : super(const NotaInitialState()){

   //generamos los comportamientos del bloc

    on<NotaCatchEvent>((event, emit) async { //para que el bloc escuche el evento Login
      print('---------Llamando al evento de obtencion de notas---------');
      emit(const NotaInitialState()); //emitimos el estado de cargando
      
      //Hacemos la peticion a nuestra API
      // await Future.delayed(const Duration(seconds: 2));
      final repositorio = RepositorioNotaImpl(remoteDataSource: RemoteDataNotaImp(client: http.Client()));
      final notas = await repositorio.buscarNotas();

      notas.isLeft() ?  emit(NotasSuccessState(notas: notas.left!)): emit(const NotasFailureState());
    }
    );
  }
}