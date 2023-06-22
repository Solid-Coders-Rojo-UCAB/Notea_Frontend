part of 'grupo_bloc.dart';

@immutable
abstract class GrupoEvent  {}

class GrupoCatchEvent extends GrupoEvent {
  final String idUsuarioDueno;

  GrupoCatchEvent({required this.idUsuarioDueno});
}