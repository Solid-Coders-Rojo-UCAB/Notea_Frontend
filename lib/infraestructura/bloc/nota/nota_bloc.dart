// ignore_for_file: unrelated_type_equality_checks

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
      final notas = await repositorio.buscarNotasGrupos(event.grupos);
      notas.isLeft()
          ? emit(NotasCatchSuccessState(notas: notas.left!))
          : emit(const NotasFailureState());
    });

    on<ModificarEstadoNotaEvent>((event, emit) async {
      emit(const NotaInitialState());
      final repositorio = RepositorioNotaImpl(
          remoteDataSource: RemoteDataNotaImp(client: http.Client()));
      final notas = await repositorio.modificarEstadoNota(
          event.idNota, event.estado);
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

      final repositorio = RepositorioNotaImpl(remoteDataSource: RemoteDataNotaImp(client: http.Client()));
      final nota = await repositorio.crearNota(event.tituloNota, event.listInfo, event.etiquetas, event.grupo);

      await Future.delayed(const Duration(milliseconds: 300));
      nota!.isLeft() ?  emit(const NotasCreateSuccessState()): emit(const NotasFailureState());//emitimos el estado de error
    });
  }
}
