class VONombreGrupo {
  String nombre;

  VONombreGrupo(this.nombre);


  static VONombreGrupo crearNombreGrupo(String nombre) {
    return VONombreGrupo(nombre);
  }

  String getNombreGrupo() {
    return nombre;
  }
}
