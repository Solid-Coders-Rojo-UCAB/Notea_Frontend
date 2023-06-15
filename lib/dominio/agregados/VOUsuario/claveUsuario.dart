export 'claveUsuario.dart';

class ClaveUsuario {
  String value;

  ClaveUsuario(this.value);

  String getValue() {
    return value;
  }

  static ClaveUsuario crearClaveUsuario(String clave) {
    return ClaveUsuario(clave);
  }
}
