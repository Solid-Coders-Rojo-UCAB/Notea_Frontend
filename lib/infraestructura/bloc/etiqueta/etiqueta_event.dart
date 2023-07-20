part of 'etiqueta_bloc.dart';

@immutable
abstract class EtiquetaEvent  {}

class EtiquetaCatchEvent extends EtiquetaEvent {
  final String idUsuarioDueno;

  EtiquetaCatchEvent({required this.idUsuarioDueno});
}
class EtiquetaDeleteEvent extends EtiquetaEvent {
  final String etiquetaId;
 

  EtiquetaDeleteEvent({required this.etiquetaId});
}
class EtiquetaCreateEvent extends EtiquetaEvent {
  final String nombre;
  final String color;
  final String idUsuarioDueno;
  EtiquetaCreateEvent({required this.nombre, required this.color, required this.idUsuarioDueno});
}

class EtiquetaPatchEvent extends EtiquetaEvent {
  final String id;
  final String nombre;
  final String color;

  EtiquetaPatchEvent({required this.id, required this.nombre, required this.color});
}

class EtiquetaReload extends EtiquetaEvent {
  EtiquetaReload();
}