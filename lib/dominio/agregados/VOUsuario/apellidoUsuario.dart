export 'apellidoUsuario.dart';

class ApellidoUsuario {
  String value;

  ApellidoUsuario(this.value);

  String getValue() {
    return value;
  }

  static ApellidoUsuario crearApellidoUsuario(String apellido) {
    return ApellidoUsuario(apellido);
  }

}
