// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moor_db.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: type=lint
class MoorNotaData extends DataClass implements Insertable<MoorNotaData> {
  final String id;
  final String titulo;
  final String contenido;
  final DateTime? fechaCreacion;
  final int latitud;
  final int longitud;
  final String estado;
  final String idGrupo;
  final String etiquetas;
  final int server;
  MoorNotaData(
      {required this.id,
      required this.titulo,
      required this.contenido,
      this.fechaCreacion,
      required this.latitud,
      required this.longitud,
      required this.estado,
      required this.idGrupo,
      required this.etiquetas,
      required this.server});
  factory MoorNotaData.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return MoorNotaData(
      id: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      titulo: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}titulo'])!,
      contenido: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}contenido'])!,
      fechaCreacion: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}fecha_creacion']),
      latitud: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}latitud'])!,
      longitud: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}longitud'])!,
      estado: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}estado'])!,
      idGrupo: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id_grupo'])!,
      etiquetas: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}etiquetas'])!,
      server: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}server'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['titulo'] = Variable<String>(titulo);
    map['contenido'] = Variable<String>(contenido);
    if (!nullToAbsent || fechaCreacion != null) {
      map['fecha_creacion'] = Variable<DateTime?>(fechaCreacion);
    }
    map['latitud'] = Variable<int>(latitud);
    map['longitud'] = Variable<int>(longitud);
    map['estado'] = Variable<String>(estado);
    map['id_grupo'] = Variable<String>(idGrupo);
    map['etiquetas'] = Variable<String>(etiquetas);
    map['server'] = Variable<int>(server);
    return map;
  }

  MoorNotaCompanion toCompanion(bool nullToAbsent) {
    return MoorNotaCompanion(
      id: Value(id),
      titulo: Value(titulo),
      contenido: Value(contenido),
      fechaCreacion: fechaCreacion == null && nullToAbsent
          ? const Value.absent()
          : Value(fechaCreacion),
      latitud: Value(latitud),
      longitud: Value(longitud),
      estado: Value(estado),
      idGrupo: Value(idGrupo),
      etiquetas: Value(etiquetas),
      server: Value(server),
    );
  }

  factory MoorNotaData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return MoorNotaData(
      id: serializer.fromJson<String>(json['id']),
      titulo: serializer.fromJson<String>(json['titulo']),
      contenido: serializer.fromJson<String>(json['contenido']),
      fechaCreacion: serializer.fromJson<DateTime?>(json['fechaCreacion']),
      latitud: serializer.fromJson<int>(json['latitud']),
      longitud: serializer.fromJson<int>(json['longitud']),
      estado: serializer.fromJson<String>(json['estado']),
      idGrupo: serializer.fromJson<String>(json['idGrupo']),
      etiquetas: serializer.fromJson<String>(json['etiquetas']),
      server: serializer.fromJson<int>(json['server']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'titulo': serializer.toJson<String>(titulo),
      'contenido': serializer.toJson<String>(contenido),
      'fechaCreacion': serializer.toJson<DateTime?>(fechaCreacion),
      'latitud': serializer.toJson<int>(latitud),
      'longitud': serializer.toJson<int>(longitud),
      'estado': serializer.toJson<String>(estado),
      'idGrupo': serializer.toJson<String>(idGrupo),
      'etiquetas': serializer.toJson<String>(etiquetas),
      'server': serializer.toJson<int>(server),
    };
  }

  MoorNotaData copyWith(
          {String? id,
          String? titulo,
          String? contenido,
          DateTime? fechaCreacion,
          int? latitud,
          int? longitud,
          String? estado,
          String? idGrupo,
          String? etiquetas,
          int? server}) =>
      MoorNotaData(
        id: id ?? this.id,
        titulo: titulo ?? this.titulo,
        contenido: contenido ?? this.contenido,
        fechaCreacion: fechaCreacion ?? this.fechaCreacion,
        latitud: latitud ?? this.latitud,
        longitud: longitud ?? this.longitud,
        estado: estado ?? this.estado,
        idGrupo: idGrupo ?? this.idGrupo,
        etiquetas: etiquetas ?? this.etiquetas,
        server: server ?? this.server,
      );
  @override
  String toString() {
    return (StringBuffer('MoorNotaData(')
          ..write('id: $id, ')
          ..write('titulo: $titulo, ')
          ..write('contenido: $contenido, ')
          ..write('fechaCreacion: $fechaCreacion, ')
          ..write('latitud: $latitud, ')
          ..write('longitud: $longitud, ')
          ..write('estado: $estado, ')
          ..write('idGrupo: $idGrupo, ')
          ..write('etiquetas: $etiquetas, ')
          ..write('server: $server')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, titulo, contenido, fechaCreacion, latitud,
      longitud, estado, idGrupo, etiquetas, server);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MoorNotaData &&
          other.id == this.id &&
          other.titulo == this.titulo &&
          other.contenido == this.contenido &&
          other.fechaCreacion == this.fechaCreacion &&
          other.latitud == this.latitud &&
          other.longitud == this.longitud &&
          other.estado == this.estado &&
          other.idGrupo == this.idGrupo &&
          other.etiquetas == this.etiquetas &&
          other.server == this.server);
}

class MoorNotaCompanion extends UpdateCompanion<MoorNotaData> {
  final Value<String> id;
  final Value<String> titulo;
  final Value<String> contenido;
  final Value<DateTime?> fechaCreacion;
  final Value<int> latitud;
  final Value<int> longitud;
  final Value<String> estado;
  final Value<String> idGrupo;
  final Value<String> etiquetas;
  final Value<int> server;
  const MoorNotaCompanion({
    this.id = const Value.absent(),
    this.titulo = const Value.absent(),
    this.contenido = const Value.absent(),
    this.fechaCreacion = const Value.absent(),
    this.latitud = const Value.absent(),
    this.longitud = const Value.absent(),
    this.estado = const Value.absent(),
    this.idGrupo = const Value.absent(),
    this.etiquetas = const Value.absent(),
    this.server = const Value.absent(),
  });
  MoorNotaCompanion.insert({
    required String id,
    required String titulo,
    required String contenido,
    this.fechaCreacion = const Value.absent(),
    required int latitud,
    required int longitud,
    required String estado,
    required String idGrupo,
    required String etiquetas,
    required int server,
  })  : id = Value(id),
        titulo = Value(titulo),
        contenido = Value(contenido),
        latitud = Value(latitud),
        longitud = Value(longitud),
        estado = Value(estado),
        idGrupo = Value(idGrupo),
        etiquetas = Value(etiquetas),
        server = Value(server);
  static Insertable<MoorNotaData> custom({
    Expression<String>? id,
    Expression<String>? titulo,
    Expression<String>? contenido,
    Expression<DateTime?>? fechaCreacion,
    Expression<int>? latitud,
    Expression<int>? longitud,
    Expression<String>? estado,
    Expression<String>? idGrupo,
    Expression<String>? etiquetas,
    Expression<int>? server,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (titulo != null) 'titulo': titulo,
      if (contenido != null) 'contenido': contenido,
      if (fechaCreacion != null) 'fecha_creacion': fechaCreacion,
      if (latitud != null) 'latitud': latitud,
      if (longitud != null) 'longitud': longitud,
      if (estado != null) 'estado': estado,
      if (idGrupo != null) 'id_grupo': idGrupo,
      if (etiquetas != null) 'etiquetas': etiquetas,
      if (server != null) 'server': server,
    });
  }

  MoorNotaCompanion copyWith(
      {Value<String>? id,
      Value<String>? titulo,
      Value<String>? contenido,
      Value<DateTime?>? fechaCreacion,
      Value<int>? latitud,
      Value<int>? longitud,
      Value<String>? estado,
      Value<String>? idGrupo,
      Value<String>? etiquetas,
      Value<int>? server}) {
    return MoorNotaCompanion(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      contenido: contenido ?? this.contenido,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      latitud: latitud ?? this.latitud,
      longitud: longitud ?? this.longitud,
      estado: estado ?? this.estado,
      idGrupo: idGrupo ?? this.idGrupo,
      etiquetas: etiquetas ?? this.etiquetas,
      server: server ?? this.server,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (titulo.present) {
      map['titulo'] = Variable<String>(titulo.value);
    }
    if (contenido.present) {
      map['contenido'] = Variable<String>(contenido.value);
    }
    if (fechaCreacion.present) {
      map['fecha_creacion'] = Variable<DateTime?>(fechaCreacion.value);
    }
    if (latitud.present) {
      map['latitud'] = Variable<int>(latitud.value);
    }
    if (longitud.present) {
      map['longitud'] = Variable<int>(longitud.value);
    }
    if (estado.present) {
      map['estado'] = Variable<String>(estado.value);
    }
    if (idGrupo.present) {
      map['id_grupo'] = Variable<String>(idGrupo.value);
    }
    if (etiquetas.present) {
      map['etiquetas'] = Variable<String>(etiquetas.value);
    }
    if (server.present) {
      map['server'] = Variable<int>(server.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MoorNotaCompanion(')
          ..write('id: $id, ')
          ..write('titulo: $titulo, ')
          ..write('contenido: $contenido, ')
          ..write('fechaCreacion: $fechaCreacion, ')
          ..write('latitud: $latitud, ')
          ..write('longitud: $longitud, ')
          ..write('estado: $estado, ')
          ..write('idGrupo: $idGrupo, ')
          ..write('etiquetas: $etiquetas, ')
          ..write('server: $server')
          ..write(')'))
        .toString();
  }
}

class $MoorNotaTable extends MoorNota
    with TableInfo<$MoorNotaTable, MoorNotaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MoorNotaTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String?> id = GeneratedColumn<String?>(
      'id', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _tituloMeta = const VerificationMeta('titulo');
  @override
  late final GeneratedColumn<String?> titulo = GeneratedColumn<String?>(
      'titulo', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _contenidoMeta = const VerificationMeta('contenido');
  @override
  late final GeneratedColumn<String?> contenido = GeneratedColumn<String?>(
      'contenido', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _fechaCreacionMeta =
      const VerificationMeta('fechaCreacion');
  @override
  late final GeneratedColumn<DateTime?> fechaCreacion =
      GeneratedColumn<DateTime?>('fecha_creacion', aliasedName, true,
          type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _latitudMeta = const VerificationMeta('latitud');
  @override
  late final GeneratedColumn<int?> latitud = GeneratedColumn<int?>(
      'latitud', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _longitudMeta = const VerificationMeta('longitud');
  @override
  late final GeneratedColumn<int?> longitud = GeneratedColumn<int?>(
      'longitud', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _estadoMeta = const VerificationMeta('estado');
  @override
  late final GeneratedColumn<String?> estado = GeneratedColumn<String?>(
      'estado', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _idGrupoMeta = const VerificationMeta('idGrupo');
  @override
  late final GeneratedColumn<String?> idGrupo = GeneratedColumn<String?>(
      'id_grupo', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _etiquetasMeta = const VerificationMeta('etiquetas');
  @override
  late final GeneratedColumn<String?> etiquetas = GeneratedColumn<String?>(
      'etiquetas', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _serverMeta = const VerificationMeta('server');
  @override
  late final GeneratedColumn<int?> server = GeneratedColumn<int?>(
      'server', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        titulo,
        contenido,
        fechaCreacion,
        latitud,
        longitud,
        estado,
        idGrupo,
        etiquetas,
        server
      ];
  @override
  String get aliasedName => _alias ?? 'moor_nota';
  @override
  String get actualTableName => 'moor_nota';
  @override
  VerificationContext validateIntegrity(Insertable<MoorNotaData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('titulo')) {
      context.handle(_tituloMeta,
          titulo.isAcceptableOrUnknown(data['titulo']!, _tituloMeta));
    } else if (isInserting) {
      context.missing(_tituloMeta);
    }
    if (data.containsKey('contenido')) {
      context.handle(_contenidoMeta,
          contenido.isAcceptableOrUnknown(data['contenido']!, _contenidoMeta));
    } else if (isInserting) {
      context.missing(_contenidoMeta);
    }
    if (data.containsKey('fecha_creacion')) {
      context.handle(
          _fechaCreacionMeta,
          fechaCreacion.isAcceptableOrUnknown(
              data['fecha_creacion']!, _fechaCreacionMeta));
    }
    if (data.containsKey('latitud')) {
      context.handle(_latitudMeta,
          latitud.isAcceptableOrUnknown(data['latitud']!, _latitudMeta));
    } else if (isInserting) {
      context.missing(_latitudMeta);
    }
    if (data.containsKey('longitud')) {
      context.handle(_longitudMeta,
          longitud.isAcceptableOrUnknown(data['longitud']!, _longitudMeta));
    } else if (isInserting) {
      context.missing(_longitudMeta);
    }
    if (data.containsKey('estado')) {
      context.handle(_estadoMeta,
          estado.isAcceptableOrUnknown(data['estado']!, _estadoMeta));
    } else if (isInserting) {
      context.missing(_estadoMeta);
    }
    if (data.containsKey('id_grupo')) {
      context.handle(_idGrupoMeta,
          idGrupo.isAcceptableOrUnknown(data['id_grupo']!, _idGrupoMeta));
    } else if (isInserting) {
      context.missing(_idGrupoMeta);
    }
    if (data.containsKey('etiquetas')) {
      context.handle(_etiquetasMeta,
          etiquetas.isAcceptableOrUnknown(data['etiquetas']!, _etiquetasMeta));
    } else if (isInserting) {
      context.missing(_etiquetasMeta);
    }
    if (data.containsKey('server')) {
      context.handle(_serverMeta,
          server.isAcceptableOrUnknown(data['server']!, _serverMeta));
    } else if (isInserting) {
      context.missing(_serverMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => <GeneratedColumn>{};
  @override
  MoorNotaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    return MoorNotaData.fromData(data, attachedDatabase,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $MoorNotaTable createAlias(String alias) {
    return $MoorNotaTable(attachedDatabase, alias);
  }
}

class MoorUsuarioData extends DataClass implements Insertable<MoorUsuarioData> {
  final String id;
  final String nombre;
  final String apellido;
  final String email;
  final String clave;
  final bool suscripcion;
  final int server;
  MoorUsuarioData(
      {required this.id,
      required this.nombre,
      required this.apellido,
      required this.email,
      required this.clave,
      required this.suscripcion,
      required this.server});
  factory MoorUsuarioData.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return MoorUsuarioData(
      id: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      nombre: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}nombre'])!,
      apellido: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}apellido'])!,
      email: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}email'])!,
      clave: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}clave'])!,
      suscripcion: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}suscripcion'])!,
      server: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}server'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nombre'] = Variable<String>(nombre);
    map['apellido'] = Variable<String>(apellido);
    map['email'] = Variable<String>(email);
    map['clave'] = Variable<String>(clave);
    map['suscripcion'] = Variable<bool>(suscripcion);
    map['server'] = Variable<int>(server);
    return map;
  }

  MoorUsuarioCompanion toCompanion(bool nullToAbsent) {
    return MoorUsuarioCompanion(
      id: Value(id),
      nombre: Value(nombre),
      apellido: Value(apellido),
      email: Value(email),
      clave: Value(clave),
      suscripcion: Value(suscripcion),
      server: Value(server),
    );
  }

  factory MoorUsuarioData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return MoorUsuarioData(
      id: serializer.fromJson<String>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      apellido: serializer.fromJson<String>(json['apellido']),
      email: serializer.fromJson<String>(json['email']),
      clave: serializer.fromJson<String>(json['clave']),
      suscripcion: serializer.fromJson<bool>(json['suscripcion']),
      server: serializer.fromJson<int>(json['server']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nombre': serializer.toJson<String>(nombre),
      'apellido': serializer.toJson<String>(apellido),
      'email': serializer.toJson<String>(email),
      'clave': serializer.toJson<String>(clave),
      'suscripcion': serializer.toJson<bool>(suscripcion),
      'server': serializer.toJson<int>(server),
    };
  }

  MoorUsuarioData copyWith(
          {String? id,
          String? nombre,
          String? apellido,
          String? email,
          String? clave,
          bool? suscripcion,
          int? server}) =>
      MoorUsuarioData(
        id: id ?? this.id,
        nombre: nombre ?? this.nombre,
        apellido: apellido ?? this.apellido,
        email: email ?? this.email,
        clave: clave ?? this.clave,
        suscripcion: suscripcion ?? this.suscripcion,
        server: server ?? this.server,
      );
  @override
  String toString() {
    return (StringBuffer('MoorUsuarioData(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('apellido: $apellido, ')
          ..write('email: $email, ')
          ..write('clave: $clave, ')
          ..write('suscripcion: $suscripcion, ')
          ..write('server: $server')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, nombre, apellido, email, clave, suscripcion, server);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MoorUsuarioData &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.apellido == this.apellido &&
          other.email == this.email &&
          other.clave == this.clave &&
          other.suscripcion == this.suscripcion &&
          other.server == this.server);
}

class MoorUsuarioCompanion extends UpdateCompanion<MoorUsuarioData> {
  final Value<String> id;
  final Value<String> nombre;
  final Value<String> apellido;
  final Value<String> email;
  final Value<String> clave;
  final Value<bool> suscripcion;
  final Value<int> server;
  const MoorUsuarioCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.apellido = const Value.absent(),
    this.email = const Value.absent(),
    this.clave = const Value.absent(),
    this.suscripcion = const Value.absent(),
    this.server = const Value.absent(),
  });
  MoorUsuarioCompanion.insert({
    required String id,
    required String nombre,
    required String apellido,
    required String email,
    required String clave,
    this.suscripcion = const Value.absent(),
    required int server,
  })  : id = Value(id),
        nombre = Value(nombre),
        apellido = Value(apellido),
        email = Value(email),
        clave = Value(clave),
        server = Value(server);
  static Insertable<MoorUsuarioData> custom({
    Expression<String>? id,
    Expression<String>? nombre,
    Expression<String>? apellido,
    Expression<String>? email,
    Expression<String>? clave,
    Expression<bool>? suscripcion,
    Expression<int>? server,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (apellido != null) 'apellido': apellido,
      if (email != null) 'email': email,
      if (clave != null) 'clave': clave,
      if (suscripcion != null) 'suscripcion': suscripcion,
      if (server != null) 'server': server,
    });
  }

  MoorUsuarioCompanion copyWith(
      {Value<String>? id,
      Value<String>? nombre,
      Value<String>? apellido,
      Value<String>? email,
      Value<String>? clave,
      Value<bool>? suscripcion,
      Value<int>? server}) {
    return MoorUsuarioCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      apellido: apellido ?? this.apellido,
      email: email ?? this.email,
      clave: clave ?? this.clave,
      suscripcion: suscripcion ?? this.suscripcion,
      server: server ?? this.server,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (apellido.present) {
      map['apellido'] = Variable<String>(apellido.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (clave.present) {
      map['clave'] = Variable<String>(clave.value);
    }
    if (suscripcion.present) {
      map['suscripcion'] = Variable<bool>(suscripcion.value);
    }
    if (server.present) {
      map['server'] = Variable<int>(server.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MoorUsuarioCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('apellido: $apellido, ')
          ..write('email: $email, ')
          ..write('clave: $clave, ')
          ..write('suscripcion: $suscripcion, ')
          ..write('server: $server')
          ..write(')'))
        .toString();
  }
}

class $MoorUsuarioTable extends MoorUsuario
    with TableInfo<$MoorUsuarioTable, MoorUsuarioData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MoorUsuarioTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String?> id = GeneratedColumn<String?>(
      'id', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String?> nombre = GeneratedColumn<String?>(
      'nombre', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _apellidoMeta = const VerificationMeta('apellido');
  @override
  late final GeneratedColumn<String?> apellido = GeneratedColumn<String?>(
      'apellido', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String?> email = GeneratedColumn<String?>(
      'email', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _claveMeta = const VerificationMeta('clave');
  @override
  late final GeneratedColumn<String?> clave = GeneratedColumn<String?>(
      'clave', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _suscripcionMeta =
      const VerificationMeta('suscripcion');
  @override
  late final GeneratedColumn<bool?> suscripcion = GeneratedColumn<bool?>(
      'suscripcion', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (suscripcion IN (0, 1))',
      defaultValue: const Constant(false));
  final VerificationMeta _serverMeta = const VerificationMeta('server');
  @override
  late final GeneratedColumn<int?> server = GeneratedColumn<int?>(
      'server', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, nombre, apellido, email, clave, suscripcion, server];
  @override
  String get aliasedName => _alias ?? 'moor_usuario';
  @override
  String get actualTableName => 'moor_usuario';
  @override
  VerificationContext validateIntegrity(Insertable<MoorUsuarioData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(_nombreMeta,
          nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta));
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('apellido')) {
      context.handle(_apellidoMeta,
          apellido.isAcceptableOrUnknown(data['apellido']!, _apellidoMeta));
    } else if (isInserting) {
      context.missing(_apellidoMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('clave')) {
      context.handle(
          _claveMeta, clave.isAcceptableOrUnknown(data['clave']!, _claveMeta));
    } else if (isInserting) {
      context.missing(_claveMeta);
    }
    if (data.containsKey('suscripcion')) {
      context.handle(
          _suscripcionMeta,
          suscripcion.isAcceptableOrUnknown(
              data['suscripcion']!, _suscripcionMeta));
    }
    if (data.containsKey('server')) {
      context.handle(_serverMeta,
          server.isAcceptableOrUnknown(data['server']!, _serverMeta));
    } else if (isInserting) {
      context.missing(_serverMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => <GeneratedColumn>{};
  @override
  MoorUsuarioData map(Map<String, dynamic> data, {String? tablePrefix}) {
    return MoorUsuarioData.fromData(data, attachedDatabase,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $MoorUsuarioTable createAlias(String alias) {
    return $MoorUsuarioTable(attachedDatabase, alias);
  }
}

abstract class _$NoteaDataBase extends GeneratedDatabase {
  _$NoteaDataBase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $MoorNotaTable moorNota = $MoorNotaTable(this);
  late final $MoorUsuarioTable moorUsuario = $MoorUsuarioTable(this);
  late final NotaDao notaDao = NotaDao(this as NoteaDataBase);
  late final UsuarioDao usuarioDao = UsuarioDao(this as NoteaDataBase);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [moorNota, moorUsuario];
}

// **************************************************************************
// DaoGenerator
// **************************************************************************

mixin _$NotaDaoMixin on DatabaseAccessor<NoteaDataBase> {
  $MoorNotaTable get moorNota => attachedDatabase.moorNota;
}
mixin _$UsuarioDaoMixin on DatabaseAccessor<NoteaDataBase> {
  $MoorUsuarioTable get moorUsuario => attachedDatabase.moorUsuario;
}
