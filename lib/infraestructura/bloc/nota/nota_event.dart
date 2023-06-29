part of 'nota_bloc.dart';

@immutable
abstract class NotaEvent  {}

//generamos los distintos eventos que puede tener el bloc
class NotaCatchEvent extends NotaEvent {
  NotaCatchEvent();
}

class CreateNotaEvent extends NotaEvent {
  final String tituloNota;
  final List<dynamic> listInfo;
  final dynamic grupo;
  final List<dynamic> etiquetas;
  CreateNotaEvent({required this.tituloNota, required this.listInfo, required this.grupo, required this.etiquetas});
}