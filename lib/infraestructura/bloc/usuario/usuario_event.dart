part of 'usuario_bloc.dart';

@immutable
abstract class UsuarioEvent  {}

//generamos los distintos eventos que puede tener el bloc
class LoginEvent extends UsuarioEvent { 
  final String email; //parametros que recibe el evento
  final String password;
  final String? accion;

  LoginEvent({required this.email, required this.password, this.accion});
}

class LogoutEvent extends UsuarioEvent { 
  LogoutEvent();
}

class RegisterEvent extends UsuarioEvent { 
  final String email; //parametros que recibe el evento
  final String nombre;
  final String apellido;
  final String password;
  final bool suscripcion;
  final String? accion;

  RegisterEvent({required this.email, required this.password, required this.nombre, required this.apellido, required this.suscripcion, this.accion});
}

class PrintEvent extends UsuarioEvent {
  final String mensaje;
  final String? idUser;
  PrintEvent({required this.mensaje, this.idUser});
}