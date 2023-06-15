
class IdUsuario  {
  final String id;

  IdUsuario(this.id);

  static IdUsuario crearIdUsuario(String id) {
    return IdUsuario(id);
  }

  bool isValid() {
    return id.isNotEmpty;
  }

  bool equals(IdUsuario vo) {
    return id == vo.id;
  }

  String getValue() {
    return id;
  }
}