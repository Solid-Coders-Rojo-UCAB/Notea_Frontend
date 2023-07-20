part of 'grupo_bloc.dart';

@immutable
abstract class GrupoEvent {}

class GrupoCatchEvent extends GrupoEvent {
  final String idUsuarioDueno;

  GrupoCatchEvent({required this.idUsuarioDueno});
}

class GrupoCreateEvent extends GrupoEvent {
  final String nombre;

  final String idUsuario;
  GrupoCreateEvent({required this.nombre, required this.idUsuario});
}

class GrupoPatchEvent extends GrupoEvent {
  final String idUsuario;
  final String id;
  final String nombre;

  GrupoPatchEvent({required this.id, required this.nombre,required this.idUsuario});
}

class GrupoDeleteEvent extends GrupoEvent {
  final String grupoId;

  GrupoDeleteEvent({required this.grupoId});
}

class GrupoReload extends GrupoEvent {
  GrupoReload();
}
