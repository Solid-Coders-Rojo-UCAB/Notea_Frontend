import 'package:notea_frontend/dominio/agregados/grupo.dart';
import 'package:notea_frontend/dominio/agregados/usuario.dart';
import 'package:notea_frontend/utils/Either.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';


class NoteaDatabase {
  static final NoteaDatabase instance = NoteaDatabase._init();

  //Patron singleton, garantizamos que
  //solo exista una instancia de la clase
  static Database? _database;

  NoteaDatabase._init();

  NoteaDatabase();
  //Creamos la base de datos
  Future<Database> get database async {
    if (_database != null) return _database!;
    print('INICIA LA BASE DE DATOS');
    _database = await _initDB('notea.db');    //Si no existe, pues se crea todo
    return _database!;
  }

  //Obtenemos la instancia de la base de datos
  Future<Database> _initDB(String dbName) async {
    final dbRuta = await getDatabasesPath();          //Obtenemos la ruta de la carpeta de las bases de datos del dispositivo
    final dbPath = join(dbRuta, dbName);              //Concatenamos la ruta anterior, con el nombre de la base de datos (notea.db)

    return await openDatabase(dbPath, version: 16, onUpgrade: _actualizarDB);    //Sino existe la base de datos pues la crea suno la abre
  }

  Future _crearDB(Database db, int version) async {
    print('CREA LA BASE DE DATOS');
    const idType = 'TEXT PRIMARY KEY ';
    const textType = 'TEXT ';
    const integerType = 'INTEGER ';
    await db.execute('''
      CREATE TABLE $tableUsuarioName (
        ${UsuarioColumnas.id} $idType,
        ${UsuarioColumnas.nombre} $textType,
        ${UsuarioColumnas.apellido} $textType,
        ${UsuarioColumnas.email} $textType UNIQUE,
        ${UsuarioColumnas.clave} $textType,
        ${UsuarioColumnas.suscripcion} $integerType,
        ${UsuarioColumnas.server} $integerType
        )
      ''');
    //Se colocan aca las nuevas bases
    await db.execute('''
      CREATE TABLE $tableGrupoName (
        ${GrupoColumnas.idGrupo} $idType,
        ${GrupoColumnas.nombre} $textType,
        ${GrupoColumnas.idUsuario} $textType
        )
      ''');
  }

  // UPGRADE DATABASE TABLES
  void _actualizarDB(Database db, int oldVersion, int newVersion) async {
    print('ACTUALIZA LA BASE DE DATOS');
    if (oldVersion < newVersion) {
      const idType = 'TEXT PRIMARY KEY UNIQUE';
      const textType = 'TEXT ';
      const integerType = 'INTEGER ';
      await db.execute('''
        DROP TABLE IF EXISTS $tableUsuarioName
      ''');
    await db.execute('''
      CREATE TABLE $tableUsuarioName (
        ${UsuarioColumnas.id} $idType,
        ${UsuarioColumnas.nombre} $textType,
        ${UsuarioColumnas.apellido} $textType,
        ${UsuarioColumnas.email} $textType UNIQUE,
        ${UsuarioColumnas.clave} $textType,
        ${UsuarioColumnas.suscripcion} $integerType,
        ${UsuarioColumnas.server} $integerType
        )
      ''');
    }
  }

  Future close() async {
    final db = await database;
    db.close();
  }

  //###########################USUARIOS###########################
  Future<List<Usuario>> getAllUsuarios() async {
    final db = await instance.database;
    // final result =
    //     await db.rawQuery('SELECT * FROM $tableNotes ORDER BY $orderBy');
    final result = await db.query(tableUsuarioName);
    return result.map((json) => Usuario.fromJsonOffLine(json)).toList();
  }

  Future<Usuario?> getUsuario(String id) async {
    final db = await instance.database;
    final result = await db.query(
      tableUsuarioName,
      where: '${UsuarioColumnas.id} = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return Usuario.fromJsonOffLine(result.first);
    } else {
      return null;
    }
  }

  Future<Either<bool, Exception>> existEmail(String email) async {
    final db = await instance.database;
    final result = await db.query(
      tableUsuarioName,
      where: '${UsuarioColumnas.email} = ?',
      whereArgs: [email],
      limit: 1,
    );
    if (result.isNotEmpty) {
      return Either.left(true);
    } else {
      return Either.right(Exception("Email tomado"));
    }
  }

  Future<Either<String, Exception>> createUsuario(Usuario usuario) async {
    usuario.setId(generateUUID());
    final db = await instance.database;
    final id = await db.insert(tableUsuarioName, usuario.toJson());
    if (id != 0){
      return Either.left(usuario.getId());
    }
    return Either.right(Exception("Usuario no creado"));
  }


  Future<int> update(Usuario usuario) async {
    final db = await instance.database;

    return db.update(
      tableUsuarioName,
      usuario.toJson(),
      where: '${UsuarioColumnas.id} = ?',
      whereArgs: [usuario.id],
    );
  }

  Future<int> delete(String id) async {
    final db = await database;

    return await db.delete(
      tableUsuarioName,
      where: '${UsuarioColumnas.id} = ?',
      whereArgs: [id],
    );
  }

  Future<Either<Usuario, dynamic>> login(String email, String clave) async {
    final db = await instance.database;
    final result = await db.query(
      tableUsuarioName,
      where: 'email = ? AND clave = ?',
      whereArgs: [email, clave],
    );
    if (result.isNotEmpty) {
      return  Either.left(Usuario.fromJsonOffLine(result.first));
    } else {
      return Either.right(Exception("Usuario no encontrado"));
    }
  }

  Future<List<Usuario>> imprimeUsuarios() async {
    final db = await instance.database;
    // final result =
    //     await db.rawQuery('SELECT * FROM $tableNotes ORDER BY $orderBy');
    final result = await db.query(tableUsuarioName);
    return result.map((json) => Usuario.fromJsonOffLine(json)).toList();
  }

  //###########################GRUPOS###########################
  Future<Either<String, Exception>> createGrupo(Grupo grupo) async {
    grupo.setId(generateUUID());
    final db = await instance.database;
    final id = await db.insert(tableGrupoName, grupo.toJson());
    if (id != 0){
      return Either.left(grupo.getId());
    }
    return Either.right(Exception("Grupo no creado"));
  }

  Future<List<Grupo>> getAllGrupos() async {
    final db = await instance.database;
    final result = await db.query(tableGrupoName);

    return result.map((json) => Grupo.fromJsonOffLine(json)).toList();
  }

}
String generateUUID() {
  const uuid = Uuid();
  return uuid.v4();
}

