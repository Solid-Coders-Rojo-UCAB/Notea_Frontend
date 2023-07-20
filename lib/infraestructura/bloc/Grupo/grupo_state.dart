// ignore_for_file: overridden_fields

part of 'grupo_bloc.dart';

@immutable
abstract class GrupoState {
  final bool existeGrupo;
  final List<Grupo>? grupos;
  final Grupo? grupo;

  const GrupoState({this.grupo, this.existeGrupo = false, this.grupos});
}
class GrupoInitialState extends GrupoState {
  const GrupoInitialState() : super(existeGrupo: false, grupos: null);
}


class GruposSuccessState extends GrupoState {
  @override
  final List<Grupo> grupos;
  const GruposSuccessState({required this.grupos}) : super(existeGrupo: true);
}

class GruposFailureState extends GrupoState {
  const GruposFailureState() : super(existeGrupo: false, grupos: null);
}

class GrupoDeleteSuccessState extends GrupoState {
 

 
}

class GrupoDeleteFailureState extends GrupoState {
 

}


class GrupoCreateSuccessState extends GrupoState {
  


}
class GrupoCreateFailureState extends GrupoState {

  
}
class GrupoPatchSuccessState extends GrupoState {
 


}
class GrupoPatchFailureState extends GrupoState {

  
}
