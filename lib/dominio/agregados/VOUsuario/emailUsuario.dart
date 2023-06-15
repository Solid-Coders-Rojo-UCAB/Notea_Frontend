export 'emailUsuario.dart';

class EmailUsuario {
  String value;

  EmailUsuario(this.value);

  String getValue() {
    return value;
  }

  static EmailUsuario crearEmailUsuario(String email) {
    return EmailUsuario(email);
  }
}