class VOUbicacionNota {
  double latitud;
  double longitud;

  VOUbicacionNota(this.latitud, this.longitud);

  static VOUbicacionNota crearUbicacionNota(double latitud, double longitud) {
    return VOUbicacionNota(latitud, longitud);
  }

  double getLatitud() {
    return latitud;
  }

  double getLongitud() {
    return longitud;
  }
}