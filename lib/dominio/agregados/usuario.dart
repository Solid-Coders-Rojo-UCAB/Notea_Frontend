import 'VOUsuario/nombreUsuario.dart';
import 'VOUsuario/apellidoUsuario.dart';
import 'VOUsuario/claveUsuario.dart';
import 'VOUsuario/emailUsuario.dart';

const String tableUsuarioName = 'usuario';

class UsuarioColumnas {
  static const String id = '_id';
  static const String nombre = 'nombre';
  static const String apellido = 'apellido';
  static const String email = 'email';
  static const String clave = 'clave';
  static const String suscripcion = 'suscripcion';
  static const String server = 'server';
}

class Usuario {
  String id;
  NombreUsuario nombre;
  ApellidoUsuario apellido;
  EmailUsuario email;
  ClaveUsuario clave;
  bool suscripcion;
  int? server;

  Usuario({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.email,
    required this.clave,
    required this.suscripcion,
    this.server,
  });

  static Usuario crearUsuario(
    String nombre,
    String apellido,
    String email,
    String clave,
    bool suscripcion,
    String id,
    int? server,
  ) {
    return Usuario(
      nombre: NombreUsuario.crearNombreUsuario(nombre),
      apellido: ApellidoUsuario.crearApellidoUsuario(apellido),
      email: EmailUsuario.crearEmailUsuario(email),
      clave: ClaveUsuario.crearClaveUsuario(clave),
      suscripcion: suscripcion,
      id: id,
      server: server            //0 local , 1 servidor
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

  factory Usuario.fromJsonOffLine(Map<String, dynamic> json) {
    return Usuario(
      nombre: NombreUsuario.crearNombreUsuario(json['nombre'].toString()),
      apellido: ApellidoUsuario.crearApellidoUsuario(json['apellido'].toString()),
      email: EmailUsuario.crearEmailUsuario(json['email'].toString()),
      clave: ClaveUsuario.crearClaveUsuario(json['clave'].toString()),
      suscripcion: json['suscripcion'] == '1' ? true : false,
      id: json['_id'].toString(),
      server: int.parse(json['server'].toString()),
    );
  }

  Map<String, Object?> toJson() => {
        UsuarioColumnas.id: id,
        UsuarioColumnas.nombre: nombre.getValue().toString(),
        UsuarioColumnas.apellido: apellido.getValue().toString(),
        UsuarioColumnas.email: email.getValue().toString(),
        UsuarioColumnas.clave: clave.getValue().toString(),
        UsuarioColumnas.suscripcion: suscripcion ? 1 : 0,
        UsuarioColumnas.server: server,
  };

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



