export 'nombreUsuario.dart';

class NombreUsuario {
  String value;

  NombreUsuario(this.value);

  String getValue() {
    return value;
  }

  static NombreUsuario crearNombreUsuario(String nombre) {
    return NombreUsuario(nombre);
  }
}
