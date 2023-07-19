import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notea_frontend/dominio/agregados/VOUsuario/apellidoUsuario.dart';
import 'package:notea_frontend/dominio/agregados/VOUsuario/claveUsuario.dart';
import 'package:notea_frontend/dominio/agregados/VOUsuario/emailUsuario.dart';
import 'package:notea_frontend/dominio/agregados/VOUsuario/nombreUsuario.dart';
import 'package:notea_frontend/infraestructura/Repositorio/repositorioUsuarioImpl.dart';
import 'package:notea_frontend/infraestructura/conectivityChecker/checker.dart';
import 'package:notea_frontend/infraestructura/db/databaseHandler.dart';
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
      if (event.accion != 'local') {
        await Future.delayed(const Duration(milliseconds: 300));
        //realizamos la logica de negocio para el login
        final repositorio = RepositorioUsuarioImpl(remoteDataSource: RemoteDataUsuarioImp(client: http.Client()));
        final usuario = await repositorio.loginUsuario(event.email, event.password);

        usuario.isLeft() ?  emit(UsuarioSuccessState(usuario: usuario.left!))  //emitimos el estado de exito
          : emit(const UsuarioFailureState()); //emitimos el estado de error
      }else {
        final usuario = await NoteaDatabase.instance.login(event.email, event.password);
        if (usuario.isLeft()) {
          emit(UsuarioSuccessState(usuario: usuario.left!));
        }else{
          emit(const UsuarioFailureState());
        }
      }
    });

    on<RegisterEvent>((event, emit) async {
      emit(const UsuarioLoadingState());
      final existEmail = await NoteaDatabase.instance.existEmail(event.email);
      if(existEmail.isLeft()){        //Aca se le indica que ya el email ha sido tomado
        emit(const UsuarioEmailTakedState());
      }else{
        if (event.accion != 'local') {
          await Future.delayed(const Duration(milliseconds: 300));
          final repositorio = RepositorioUsuarioImpl(remoteDataSource: RemoteDataUsuarioImp(client: http.Client()));
          final newUser = Usuario.crearUsuario(event.nombre, event.apellido, event.email, event.password, event.suscripcion, "0", 1);
          final response = await repositorio.crearUsuario(newUser);
          if (response.isLeft()) {
            newUser.setId(response.left!);
            emit(UsuarioSuccessState(usuario: newUser));
          } else {
            emit(const UsuarioFailureState());
            await Future.delayed(const Duration(milliseconds: 500));
            emit(const UsuarioInitialState());
          }
        }else{
          final newUser = Usuario.crearUsuario(event.nombre, event.apellido, event.email, event.password, event.suscripcion, "0", 0);
          final usuario = await NoteaDatabase.instance.createUsuario(newUser);
          if (usuario.isLeft()) {
            newUser.setId(usuario.left!);
            emit(UsuarioSuccessState(usuario: newUser, accion: 'local'));
          } else {
            emit(const UsuarioFailureState());
            await Future.delayed(const Duration(milliseconds: 500));
            emit(const UsuarioInitialState());
          }
        }
      }
    });

    on<PrintEvent>((event, emit) async {
      print('Entro al print');
        final usuarios = await NoteaDatabase.instance.getAllUsuarios();
          usuarios.forEach((usuario) {
          print('ID: ${usuario.getId().toString()}');
          print('Nombre: ${usuario.getNombre().toString()}');
          print('Apellido: ${usuario.getApellido().toString()}');
          print('Email: ${usuario.getEmail().toString()}');
          print('---');
        });

      print('-----------------');
      final grupos =  await NoteaDatabase.instance.getAllGrupos();
      grupos.forEach((element) {
        print(element.idGrupo);
        print(element.nombre.getNombreGrupo());
        print(element.idUsuario);
      });
    });
  }
}