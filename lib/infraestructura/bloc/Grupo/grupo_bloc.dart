import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notea_frontend/infraestructura/Repositorio/repositorioGrupoImpl.dart';
import 'package:notea_frontend/infraestructura/api/remoteDataGrupo.dart';
import '../../../dominio/agregados/grupo.dart';
part 'grupo_event.dart';
part 'grupo_state.dart';

class GrupoBloc extends  Bloc<GrupoEvent, GrupoState> {

  GrupoBloc() : super(const GrupoInitialState()){

    on<GrupoReload>((event,emit) async {
      emit(const GrupoInitialState());
    });

    on<GrupoCatchEvent>((event, emit) async {//Este sera el evento que se llamara cuando se entre en la pantalla principal
      print('---------Llamando al evento de obtencion de grupos---------');
      emit(const GrupoInitialState());  //Luego de que se procesa el evento, pues se emite el primer estado de los grupos
      
      //Hacemos la peticion a nuestra API
      final repositorio = RepositorioGrupoImpl(remoteDataSource: RemoteDataGrupoImp(client: http.Client()));
      final grupos = await repositorio.buscarGrupos(event.idUsuarioDueno);

      await Future.delayed(const Duration(seconds: 2));
      grupos.isLeft() ?  emit(GruposSuccessState(grupos: grupos.left!)): emit(const GruposFailureState());  //Se mite el estado de SUCCESS o FAILURE
    });
  }
}

