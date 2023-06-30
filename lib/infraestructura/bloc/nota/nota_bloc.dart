import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notea_frontend/infraestructura/Repositorio/repositorioNotaImpl.dart';
import 'package:notea_frontend/infraestructura/api/remoteDataNota.dart';
import '../../../dominio/agregados/VONota/EstadoEnum.dart';
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
      final notas = await repositorio.buscarNotas();
      notas.isLeft()
          ? emit(NotasCatchSuccessState(notas: notas.left!))
          : emit(const NotasFailureState());
    });

    on<ModificarEstadoNotaEvent>((event, emit) async {
      emit(const NotaInitialState());
      final repositorio = RepositorioNotaImpl(
          remoteDataSource: RemoteDataNotaImp(client: http.Client()));
      final notas = await repositorio.modificarEstadoNota(
          event.idNota, event.grupo, event.estado);
      notas.isLeft()
          ? emit(NotaModifyStateSuccessSate(status: notas.isLeft()))
          : emit(const NotasFailureState());
    });

    on<DeleteNoteEvent>(
      (event, emit) async {
        final repositorio = RepositorioNotaImpl(
            remoteDataSource: RemoteDataNotaImp(client: http.Client()));
        final eliminado = await repositorio.borrarNota(event.idNota);
        eliminado.isLeft()
            ? emit(NotaDeleteSuccessState(status: eliminado.isLeft()))
            : emit(const NotasFailureState());
      },
    );

    on<CreateNotaEvent>((event, emit) async {
      emit(const NotaInitialState());
      // await Future.delayed(const Duration(seconds: 2));

      final repositorio = RepositorioNotaImpl(
          remoteDataSource: RemoteDataNotaImp(client: http.Client()));
      // final notas = await repositorio.crearNota(event);

      // usuario.isLeft() ?  emit(UsuarioSuccessState(usuario: usuario.left!))  //emitimos el estado de exito
      //   : emit(const UsuarioFailureState()); //emitimos el estado de error
    });
  }
}
