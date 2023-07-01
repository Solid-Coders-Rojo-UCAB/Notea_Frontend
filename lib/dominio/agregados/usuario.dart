import 'VOUsuario/nombreUsuario.dart';
import 'VOUsuario/apellidoUsuario.dart';
import 'VOUsuario/claveUsuario.dart';
import 'VOUsuario/emailUsuario.dart';

class Usuario {
  String id;
  NombreUsuario nombre;
  ApellidoUsuario apellido;
  EmailUsuario email;
  ClaveUsuario clave;
  bool suscripcion;

  Usuario({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.email,
    required this.clave,
    required this.suscripcion,
  });

  static Usuario crearUsuario(
    String nombre,
    String apellido,
    String email,
    String clave,
    bool suscripcion,
    String id,
  ) {
    return Usuario(
      nombre: NombreUsuario.crearNombreUsuario(nombre),
      apellido: ApellidoUsuario.crearApellidoUsuario(apellido),
      email: EmailUsuario.crearEmailUsuario(email),
      clave: ClaveUsuario.crearClaveUsuario(clave),
      suscripcion: suscripcion,
      id: id,
    );
  }

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      nombre: NombreUsuario.crearNombreUsuario(json['nombre']['name']),
      apellido: ApellidoUsuario.crearApellidoUsuario(json['apellido']['apellido']),
      email: EmailUsuario.crearEmailUsuario(json['email']['email']),
      clave: ClaveUsuario.crearClaveUsuario(json['clave']['clave']),
      suscripcion: json['suscripcion'],
      id: json['id']['id'],
    );
  }

  String getId() {
    return id;
  }

  String getNombre() {
    return nombre.getValue();
  }

  String getApellido() {
    return apellido.getValue();
  }

  String getEmail() {
    return email.getValue();
  }

  bool isSuscribed() {
    return suscripcion;
  }

  String getClave() {
    return clave.getValue();
  }

  void setId(String id) {
    this.id = id;
  }
}



