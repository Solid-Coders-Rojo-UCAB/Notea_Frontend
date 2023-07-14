class VOColorEtiqueta {
  String color;

  VOColorEtiqueta(this.color);


  static VOColorEtiqueta crearcolorEtiqueta(String color) {
    return VOColorEtiqueta(color);
  }

  String getColorEtiqueta() {
    return color;
  }
}
