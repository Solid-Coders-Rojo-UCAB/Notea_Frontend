part of 'grupo_bloc.dart';

@immutable
abstract class GrupoEvent  {}

class GrupoCatchEvent extends GrupoEvent {
  final String idUsuarioDueno;

  GrupoCatchEvent({required this.idUsuarioDueno});
}

class GrupoReload extends GrupoEvent {
  GrupoReload();
}

class GrupoCreateLocal extends GrupoEvent {
  final Usuario usuario;
  GrupoCreateLocal({required this.usuario});
}