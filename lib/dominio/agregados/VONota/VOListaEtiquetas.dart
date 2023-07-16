class VOIdEtiquetas {
  final List<dynamic> ids;

  VOIdEtiquetas(this.ids);

  static VOIdEtiquetas crearListaIdEtiquetas(List<dynamic> ids) {
    return VOIdEtiquetas(ids);
  }

  List<dynamic> getEtiquetas() {
    return ids;
  }
}