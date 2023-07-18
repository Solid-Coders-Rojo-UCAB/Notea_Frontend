import 'package:moor/moor.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:notea_frontend/dominio/agregados/VONota/EstadoEnum.dart';
import 'package:notea_frontend/dominio/agregados/VONota/VOContenidoNota.dart';
import 'package:notea_frontend/dominio/agregados/VONota/VOListaEtiquetas.dart';
import 'package:notea_frontend/dominio/agregados/VONota/VOTituloNota.dart';
import 'package:notea_frontend/dominio/agregados/VONota/VOUbicacionNota.dart';
import 'package:notea_frontend/dominio/agregados/VONota/VOidGrupo.dart';
import 'package:notea_frontend/dominio/agregados/VOUsuario/apellidoUsuario.dart';
import 'package:notea_frontend/dominio/agregados/VOUsuario/claveUsuario.dart';
import 'package:notea_frontend/dominio/agregados/VOUsuario/emailUsuario.dart';
import 'package:notea_frontend/dominio/agregados/VOUsuario/nombreUsuario.dart';
import 'package:notea_frontend/dominio/agregados/nota.dart';
import 'package:notea_frontend/dominio/agregados/usuario.dart';

// Moor works by source gen. This file will all the generated code.
part 'moor_db.g.dart';

// Se usa el ORM Moor, de modo que se puedan mapear objetos de esta aplicacion
// a tablas de la base de datos.

// Moor nos permite interactuar con la base de datos utilizando objetos y metodos
// Dart sin necesidad de escribir consultas de SQL directamente.

class MoorNota extends Table {

  TextColumn get id => text()();
  TextColumn get titulo => text()();
  TextColumn get contenido => text()();
  DateTimeColumn get fechaCreacion => dateTime().nullable()();
  IntColumn get latitud => integer()();
  IntColumn get longitud => integer()();
  TextColumn get estado => text()();
  TextColumn get idGrupo => text()();
  TextColumn get etiquetas => text()();
  IntColumn get server => integer()();

  //Para booleanos
  // BoolColumn get completed => boolean().withDefault(const Constant(false))();

  //Llaves primarias
  // @override
  // Set<Column> get primaryKey => {id, contenido};
}

class MoorUsuario extends Table {
  TextColumn get id => text()();
  TextColumn get nombre => text()();
  TextColumn get apellido => text()();
  TextColumn get email => text()();
  TextColumn get clave => text()();
  BoolColumn get suscripcion => boolean().withDefault(const Constant(false))();
  IntColumn get server => integer()();
}

@UseMoor(tables: [MoorNota, MoorUsuario], daos: [NotaDao, UsuarioDao])
class NoteaDataBase extends _$NoteaDataBase {
  NoteaDataBase()
    : super(FlutterQueryExecutor.inDatabaseFolder(
    path: 'notea_db.sqlite',
    logStatements: true
  ));

  @override
  int get schemaVersion => 1;
}

// Se hace uso de los DAOS de modo que podamos interactuar con la base de datos
// y asi poder realizar operaciones de consulta, insercion , actualizacion y
// eliminacion de datos.
@UseDao(tables: [MoorNota])

class NotaDao extends DatabaseAccessor<NoteaDataBase> with _$NotaDaoMixin {

  final NoteaDataBase db;
  NotaDao(this.db) : super(db);

  Future<List<MoorNotaData>> findAllNotas() => select(moorNota).get();

  Future<List<MoorNotaData>> findNotaById(String id) =>
    (select(moorNota)..where((tbl) => tbl.id.equals(id))).get();

  Future<int> insertNota(Insertable<MoorNotaData> nota) =>
    into(moorNota).insert(nota);

  Future<bool> updateNota(String id, Insertable<MoorNotaData> nota) =>
  (update(moorNota)..where((tbl) => tbl.id.equals(id))).replace(nota);

  Future deleteNota(String id) =>
    Future.value((delete(moorNota)..where((tbl) => tbl.id.equals(id))).go());
}



@UseDao(tables: [MoorUsuario])

class UsuarioDao extends DatabaseAccessor<NoteaDataBase> with _$UsuarioDaoMixin {

  final NoteaDataBase db;
  UsuarioDao(this.db) : super(db);

  Future<List<MoorUsuarioData>> findAllUsuarios() => select(moorUsuario).get();

  Future<List<MoorUsuarioData>> findUsuarioById(String id) =>
    (select(moorUsuario)..where((tbl) => tbl.id.equals(id))).get();

  Future<int> insertUsuario(Insertable<MoorUsuarioData> usuario) =>
    into(moorUsuario).insert(usuario);

  Future<bool> updateUsuario(String id, Insertable<MoorUsuarioData> usuario) =>
    (update(moorUsuario)..where((tbl) => tbl.id.equals(id))).replace(usuario);

  Future deleteUsuario(String id) =>
    Future.value((delete(moorUsuario)..where((tbl) => tbl.id.equals(id))).go());
}

//Metodos de conversion de datos - NOTAS
Nota moorNotaToNota(MoorNotaData nota) {
  return Nota(
    id: nota.id,
    titulo: VOTituloNota(nota.titulo),
    contenido: VOContenidoNota(nota.contenido),
    fechaCreacion: nota.fechaCreacion!,
    ubicacion: VOUbicacionNota(nota.latitud, nota.longitud),
    estado: EstadoEnum.values.byName(nota.estado),
    idGrupo: VOIdGrupoNota(nota.idGrupo),
    etiquetas: VOIdEtiquetas(extractValuesFromString(nota.etiquetas)),
  );
}

Insertable<MoorNotaData> notaToInsertableMoorNota(Nota nota) {
  return MoorNotaCompanion.insert(
    id: nota.id,
    titulo: nota.getTitulo(),
    contenido: nota.getContenido(),
    latitud: nota.getLatitud(),
    longitud: nota.getLongitud(),
    estado: nota.getEstado(),
    idGrupo: nota.getIdGrupoNota(),
    etiquetas: nota.getEtiquetas().toString(),
    server: nota.server!,
  );
}

List<dynamic> extractValuesFromString(String inputString) {
  // Eliminamos los corchetes al inicio y al final del string
  final cleanedString = inputString.replaceAll('[', '').replaceAll(']', '');
  // Dividimos la cadena por las comas y eliminamos los espacios en blanco
  final valuesList = cleanedString.split(',').map((value) => value.trim()).toList();
  // Retornamos la lista de valores
  return valuesList;
}
//Metodos de conversion de datos -  USUARIO
Usuario moorUsuarioToUsuario(MoorUsuarioData usuario) {
  return Usuario(
    id: usuario.id,
    nombre: NombreUsuario(usuario.nombre),
    apellido: ApellidoUsuario(usuario.apellido),
    email: EmailUsuario(usuario.email),
    clave: ClaveUsuario(usuario.clave),
    suscripcion: usuario.suscripcion,
  );
}

Insertable<MoorUsuarioData> usuarioToInsertableMoorUsuario(Usuario usuario) {
  return MoorUsuarioCompanion.insert(
    id: usuario.id,
    nombre: usuario.getNombre(),
    apellido: usuario.getApellido(),
    email: usuario.getEmail(),
    clave: usuario.getEmail(),
    server: usuario.server!,
  );
}
