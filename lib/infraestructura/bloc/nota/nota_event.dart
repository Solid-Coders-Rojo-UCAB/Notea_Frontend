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
  // final List<Grupo>? grupoGeneral;
  CreateNotaEvent({
    required this.tituloNota,
    required this.listInfo,
    required this.grupo,
    required this.etiquetas,
    // required this.grupoGeneral
  });
}

class ModificarEstadoNotaEvent extends NotaEvent {
  final String idNota;
  final String estado;
  final List<Grupo> grupos;

  ModificarEstadoNotaEvent({required this.idNota, required this.estado, required this.grupos});
}

class DeleteNoteEvent extends NotaEvent {
  final String idNota;
  final List<Grupo> grupos;

  DeleteNoteEvent({required this.idNota, required this.grupos});
}

class EditarNotaEvent extends NotaEvent {
  final String? idNota;
  final String tituloNota;
  final List<dynamic> listInfo;
  final dynamic grupo;
  final List<Etiqueta>? etiquetas;
  final List<Grupo>? grupoGeneral;
  EditarNotaEvent({
    required this.idNota,
    required this.tituloNota,
    required this.listInfo,
    required this.grupo,
    required this.etiquetas,
    required this.grupoGeneral,
  });
}