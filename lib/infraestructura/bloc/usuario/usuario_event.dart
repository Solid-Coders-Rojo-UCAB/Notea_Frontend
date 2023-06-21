part of 'usuario_bloc.dart';

@immutable
abstract class UsuarioEvent  {}

//generamos los distintos eventos que puede tener el bloc
class LoginEvent extends UsuarioEvent { 
  final String email;
  final String password;

  LoginEvent({required this.email, required this.password});
}