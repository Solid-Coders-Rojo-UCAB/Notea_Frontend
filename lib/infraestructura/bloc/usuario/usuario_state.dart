// ignore_for_file: overridden_fields, annotate_overrides

part of 'usuario_bloc.dart';

@immutable
abstract class UsuarioState {
  final bool existeUsuario;
  final Usuario? usuario;

  const UsuarioState({this.existeUsuario = false, this.usuario});
}

//generamos los distintos estados que puede tener el bloc
class UsuarioInitialState extends UsuarioState {
  const UsuarioInitialState() : super(existeUsuario: false, usuario: null);
}

class UsuarioLoadingState extends UsuarioState {
  const UsuarioLoadingState() : super(existeUsuario: false, usuario: null);
}

class UsuarioSuccessState extends UsuarioState {
  final Usuario usuario;
  final String? accion;
  const UsuarioSuccessState({required this.usuario, this.accion}) : super(existeUsuario: true, usuario: usuario);
}

class UsuarioFailureState extends UsuarioState {
  const UsuarioFailureState() : super(existeUsuario: false, usuario: null);
}

class UsuarioEmailTakedState extends UsuarioState {
  const UsuarioEmailTakedState() : super(existeUsuario: false, usuario: null);
}