// ignore_for_file: file_names
class VOIdGrupoNota {
  String idGrupo;

  VOIdGrupoNota(this.idGrupo);

  static VOIdGrupoNota crearIdGrupoNota(String idGrupo) {
    return VOIdGrupoNota(idGrupo);
  }

  String getIdGrupoNota() {
    return idGrupo;
  }
}
