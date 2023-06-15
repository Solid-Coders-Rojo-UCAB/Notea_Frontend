class IdNota {
  String value;

  IdNota(this.value);

  static IdNota crearIdNota(String? id) {
    return IdNota(id ?? '');
  }

  String getValue() {
    return value;
  }
}
