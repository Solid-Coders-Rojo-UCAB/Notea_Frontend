part of 'nota_bloc.dart';

@immutable
abstract class NotaEvent {}

//generamos los distintos eventos que pue
//de tener el bloc
class NotaCatchEvent extends NotaEvent {
  final List<Grupo> grupos;
  NotaCatchEvent({required this.grupos});
}

class CreateNotaEvent extends NotaEvent {
  final String tituloNota;
  final List<dynamic> listInfo;
  final dynamic grupo;
  final List<Etiqueta>? etiquetas;
  CreateNotaEvent({
    required this.tituloNota,
    required this.listInfo,
    required this.grupo,
    required this.etiquetas
  });
}

class ModificarEstadoNotaEvent extends NotaEvent {
  final String idNota;
  final String estado;

  ModificarEstadoNotaEvent({required this.idNota, required this.estado});
}

class DeleteNoteEvent extends NotaEvent {
  final String idNota;

  DeleteNoteEvent({required this.idNota});
}

class EditarNotaEvent extends NotaEvent {
  final String? idNota;
  final String tituloNota;
  final List<dynamic> listInfo;
  final dynamic grupo;
  final List<Etiqueta>? etiquetas;
  EditarNotaEvent({
    required this.idNota,
    required this.tituloNota,
    required this.listInfo,
    required this.grupo,
    required this.etiquetas
  });
}