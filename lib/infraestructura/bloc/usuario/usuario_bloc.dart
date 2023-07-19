import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notea_frontend/infraestructura/Repositorio/repositorioUsuarioImpl.dart';
import '../../../dominio/agregados/usuario.dart';
import '../../api/remoteDataUsuario.dart';
import 'package:http/http.dart' as http;


part 'usuario_event.dart';
part 'usuario_state.dart';

class UsuarioBloc extends  Bloc<UsuarioEvent, UsuarioState> {

  UsuarioBloc() : super(const UsuarioInitialState()){

   //generamos los comportamientos del bloc
    on<LoginEvent>((event, emit) async { //para que el bloc escuche el evento Login
      emit(const UsuarioLoadingState()); //emitimos el estado de cargando
      await Future.delayed(const Duration(milliseconds: 300));
       //realizamos la logica de negocio para el login
      final repositorio = RepositorioUsuarioImpl(remoteDataSource: RemoteDataUsuarioImp(client: http.Client()));
      final usuario = await repositorio.loginUsuario(event.email, event.password);

      if (usuario.isLeft()) {
        emit(UsuarioSuccessState(usuario: usuario.left!));  //emitimos el estado de exito
      } else {
        emit(const UsuarioFailureState()); //emitimos el estado de error
        await Future.delayed(const Duration(milliseconds: 500));
        emit(const UsuarioInitialState()); //volvemos al estado inicial
      }
    },
  );

    on<RegisterEvent>((event, emit) async {
      emit(const UsuarioLoadingState());
      await Future.delayed(const Duration(milliseconds: 300));
      final repositorio = RepositorioUsuarioImpl(remoteDataSource: RemoteDataUsuarioImp(client: http.Client()));
      final newUser = Usuario.crearUsuario(event.nombre, event.apellido, event.email, event.password, event.suscripcion, "0");
      final response = await repositorio.crearUsuario(newUser);

      if (response.isLeft()) {
        newUser.setId(response.left!);
        emit(UsuarioSuccessState(usuario: newUser));
      } else {
        emit(const UsuarioFailureState());
        await Future.delayed(const Duration(milliseconds: 500));
        emit(const UsuarioInitialState());
      }
    });
  }
}