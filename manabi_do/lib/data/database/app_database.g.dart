// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $KanjisTable extends Kanjis with TableInfo<$KanjisTable, Kanji> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KanjisTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _characterMeta = const VerificationMeta(
    'character',
  );
  @override
  late final GeneratedColumn<String> character = GeneratedColumn<String>(
    'character',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _meaningMeta = const VerificationMeta(
    'meaning',
  );
  @override
  late final GeneratedColumn<String> meaning = GeneratedColumn<String>(
    'meaning',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _onReadingMeta = const VerificationMeta(
    'onReading',
  );
  @override
  late final GeneratedColumn<String> onReading = GeneratedColumn<String>(
    'on_reading',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kunReadingMeta = const VerificationMeta(
    'kunReading',
  );
  @override
  late final GeneratedColumn<String> kunReading = GeneratedColumn<String>(
    'kun_reading',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jlptLevelMeta = const VerificationMeta(
    'jlptLevel',
  );
  @override
  late final GeneratedColumn<String> jlptLevel = GeneratedColumn<String>(
    'jlpt_level',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    character,
    meaning,
    onReading,
    kunReading,
    jlptLevel,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'kanjis';
  @override
  VerificationContext validateIntegrity(
    Insertable<Kanji> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('character')) {
      context.handle(
        _characterMeta,
        character.isAcceptableOrUnknown(data['character']!, _characterMeta),
      );
    } else if (isInserting) {
      context.missing(_characterMeta);
    }
    if (data.containsKey('meaning')) {
      context.handle(
        _meaningMeta,
        meaning.isAcceptableOrUnknown(data['meaning']!, _meaningMeta),
      );
    } else if (isInserting) {
      context.missing(_meaningMeta);
    }
    if (data.containsKey('on_reading')) {
      context.handle(
        _onReadingMeta,
        onReading.isAcceptableOrUnknown(data['on_reading']!, _onReadingMeta),
      );
    } else if (isInserting) {
      context.missing(_onReadingMeta);
    }
    if (data.containsKey('kun_reading')) {
      context.handle(
        _kunReadingMeta,
        kunReading.isAcceptableOrUnknown(data['kun_reading']!, _kunReadingMeta),
      );
    } else if (isInserting) {
      context.missing(_kunReadingMeta);
    }
    if (data.containsKey('jlpt_level')) {
      context.handle(
        _jlptLevelMeta,
        jlptLevel.isAcceptableOrUnknown(data['jlpt_level']!, _jlptLevelMeta),
      );
    } else if (isInserting) {
      context.missing(_jlptLevelMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Kanji map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Kanji(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      character: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}character'],
      )!,
      meaning: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meaning'],
      )!,
      onReading: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}on_reading'],
      )!,
      kunReading: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kun_reading'],
      )!,
      jlptLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}jlpt_level'],
      )!,
    );
  }

  @override
  $KanjisTable createAlias(String alias) {
    return $KanjisTable(attachedDatabase, alias);
  }
}

class Kanji extends DataClass implements Insertable<Kanji> {
  final int id;
  final String character;
  final String meaning;
  final String onReading;
  final String kunReading;
  final String jlptLevel;
  const Kanji({
    required this.id,
    required this.character,
    required this.meaning,
    required this.onReading,
    required this.kunReading,
    required this.jlptLevel,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['character'] = Variable<String>(character);
    map['meaning'] = Variable<String>(meaning);
    map['on_reading'] = Variable<String>(onReading);
    map['kun_reading'] = Variable<String>(kunReading);
    map['jlpt_level'] = Variable<String>(jlptLevel);
    return map;
  }

  KanjisCompanion toCompanion(bool nullToAbsent) {
    return KanjisCompanion(
      id: Value(id),
      character: Value(character),
      meaning: Value(meaning),
      onReading: Value(onReading),
      kunReading: Value(kunReading),
      jlptLevel: Value(jlptLevel),
    );
  }

  factory Kanji.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Kanji(
      id: serializer.fromJson<int>(json['id']),
      character: serializer.fromJson<String>(json['character']),
      meaning: serializer.fromJson<String>(json['meaning']),
      onReading: serializer.fromJson<String>(json['onReading']),
      kunReading: serializer.fromJson<String>(json['kunReading']),
      jlptLevel: serializer.fromJson<String>(json['jlptLevel']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'character': serializer.toJson<String>(character),
      'meaning': serializer.toJson<String>(meaning),
      'onReading': serializer.toJson<String>(onReading),
      'kunReading': serializer.toJson<String>(kunReading),
      'jlptLevel': serializer.toJson<String>(jlptLevel),
    };
  }

  Kanji copyWith({
    int? id,
    String? character,
    String? meaning,
    String? onReading,
    String? kunReading,
    String? jlptLevel,
  }) => Kanji(
    id: id ?? this.id,
    character: character ?? this.character,
    meaning: meaning ?? this.meaning,
    onReading: onReading ?? this.onReading,
    kunReading: kunReading ?? this.kunReading,
    jlptLevel: jlptLevel ?? this.jlptLevel,
  );
  Kanji copyWithCompanion(KanjisCompanion data) {
    return Kanji(
      id: data.id.present ? data.id.value : this.id,
      character: data.character.present ? data.character.value : this.character,
      meaning: data.meaning.present ? data.meaning.value : this.meaning,
      onReading: data.onReading.present ? data.onReading.value : this.onReading,
      kunReading: data.kunReading.present
          ? data.kunReading.value
          : this.kunReading,
      jlptLevel: data.jlptLevel.present ? data.jlptLevel.value : this.jlptLevel,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Kanji(')
          ..write('id: $id, ')
          ..write('character: $character, ')
          ..write('meaning: $meaning, ')
          ..write('onReading: $onReading, ')
          ..write('kunReading: $kunReading, ')
          ..write('jlptLevel: $jlptLevel')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, character, meaning, onReading, kunReading, jlptLevel);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Kanji &&
          other.id == this.id &&
          other.character == this.character &&
          other.meaning == this.meaning &&
          other.onReading == this.onReading &&
          other.kunReading == this.kunReading &&
          other.jlptLevel == this.jlptLevel);
}

class KanjisCompanion extends UpdateCompanion<Kanji> {
  final Value<int> id;
  final Value<String> character;
  final Value<String> meaning;
  final Value<String> onReading;
  final Value<String> kunReading;
  final Value<String> jlptLevel;
  const KanjisCompanion({
    this.id = const Value.absent(),
    this.character = const Value.absent(),
    this.meaning = const Value.absent(),
    this.onReading = const Value.absent(),
    this.kunReading = const Value.absent(),
    this.jlptLevel = const Value.absent(),
  });
  KanjisCompanion.insert({
    this.id = const Value.absent(),
    required String character,
    required String meaning,
    required String onReading,
    required String kunReading,
    required String jlptLevel,
  }) : character = Value(character),
       meaning = Value(meaning),
       onReading = Value(onReading),
       kunReading = Value(kunReading),
       jlptLevel = Value(jlptLevel);
  static Insertable<Kanji> custom({
    Expression<int>? id,
    Expression<String>? character,
    Expression<String>? meaning,
    Expression<String>? onReading,
    Expression<String>? kunReading,
    Expression<String>? jlptLevel,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (character != null) 'character': character,
      if (meaning != null) 'meaning': meaning,
      if (onReading != null) 'on_reading': onReading,
      if (kunReading != null) 'kun_reading': kunReading,
      if (jlptLevel != null) 'jlpt_level': jlptLevel,
    });
  }

  KanjisCompanion copyWith({
    Value<int>? id,
    Value<String>? character,
    Value<String>? meaning,
    Value<String>? onReading,
    Value<String>? kunReading,
    Value<String>? jlptLevel,
  }) {
    return KanjisCompanion(
      id: id ?? this.id,
      character: character ?? this.character,
      meaning: meaning ?? this.meaning,
      onReading: onReading ?? this.onReading,
      kunReading: kunReading ?? this.kunReading,
      jlptLevel: jlptLevel ?? this.jlptLevel,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (character.present) {
      map['character'] = Variable<String>(character.value);
    }
    if (meaning.present) {
      map['meaning'] = Variable<String>(meaning.value);
    }
    if (onReading.present) {
      map['on_reading'] = Variable<String>(onReading.value);
    }
    if (kunReading.present) {
      map['kun_reading'] = Variable<String>(kunReading.value);
    }
    if (jlptLevel.present) {
      map['jlpt_level'] = Variable<String>(jlptLevel.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KanjisCompanion(')
          ..write('id: $id, ')
          ..write('character: $character, ')
          ..write('meaning: $meaning, ')
          ..write('onReading: $onReading, ')
          ..write('kunReading: $kunReading, ')
          ..write('jlptLevel: $jlptLevel')
          ..write(')'))
        .toString();
  }
}

class $KanasTable extends Kanas with TableInfo<$KanasTable, Kana> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KanasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _characterMeta = const VerificationMeta(
    'character',
  );
  @override
  late final GeneratedColumn<String> character = GeneratedColumn<String>(
    'character',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _romajiMeta = const VerificationMeta('romaji');
  @override
  late final GeneratedColumn<String> romaji = GeneratedColumn<String>(
    'romaji',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rowMeta = const VerificationMeta('row');
  @override
  late final GeneratedColumn<String> row = GeneratedColumn<String>(
    'row',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kanaGroupMeta = const VerificationMeta(
    'kanaGroup',
  );
  @override
  late final GeneratedColumn<String> kanaGroup = GeneratedColumn<String>(
    'kana_group',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _slotMeta = const VerificationMeta('slot');
  @override
  late final GeneratedColumn<int> slot = GeneratedColumn<int>(
    'slot',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    character,
    romaji,
    type,
    row,
    kanaGroup,
    slot,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'kanas';
  @override
  VerificationContext validateIntegrity(
    Insertable<Kana> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('character')) {
      context.handle(
        _characterMeta,
        character.isAcceptableOrUnknown(data['character']!, _characterMeta),
      );
    } else if (isInserting) {
      context.missing(_characterMeta);
    }
    if (data.containsKey('romaji')) {
      context.handle(
        _romajiMeta,
        romaji.isAcceptableOrUnknown(data['romaji']!, _romajiMeta),
      );
    } else if (isInserting) {
      context.missing(_romajiMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('row')) {
      context.handle(
        _rowMeta,
        row.isAcceptableOrUnknown(data['row']!, _rowMeta),
      );
    } else if (isInserting) {
      context.missing(_rowMeta);
    }
    if (data.containsKey('kana_group')) {
      context.handle(
        _kanaGroupMeta,
        kanaGroup.isAcceptableOrUnknown(data['kana_group']!, _kanaGroupMeta),
      );
    } else if (isInserting) {
      context.missing(_kanaGroupMeta);
    }
    if (data.containsKey('slot')) {
      context.handle(
        _slotMeta,
        slot.isAcceptableOrUnknown(data['slot']!, _slotMeta),
      );
    } else if (isInserting) {
      context.missing(_slotMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Kana map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Kana(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      character: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}character'],
      )!,
      romaji: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}romaji'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      row: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}row'],
      )!,
      kanaGroup: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kana_group'],
      )!,
      slot: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}slot'],
      )!,
    );
  }

  @override
  $KanasTable createAlias(String alias) {
    return $KanasTable(attachedDatabase, alias);
  }
}

class Kana extends DataClass implements Insertable<Kana> {
  final int id;
  final String character;
  final String romaji;
  final String type;
  final String row;
  final String kanaGroup;
  final int slot;
  const Kana({
    required this.id,
    required this.character,
    required this.romaji,
    required this.type,
    required this.row,
    required this.kanaGroup,
    required this.slot,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['character'] = Variable<String>(character);
    map['romaji'] = Variable<String>(romaji);
    map['type'] = Variable<String>(type);
    map['row'] = Variable<String>(row);
    map['kana_group'] = Variable<String>(kanaGroup);
    map['slot'] = Variable<int>(slot);
    return map;
  }

  KanasCompanion toCompanion(bool nullToAbsent) {
    return KanasCompanion(
      id: Value(id),
      character: Value(character),
      romaji: Value(romaji),
      type: Value(type),
      row: Value(row),
      kanaGroup: Value(kanaGroup),
      slot: Value(slot),
    );
  }

  factory Kana.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Kana(
      id: serializer.fromJson<int>(json['id']),
      character: serializer.fromJson<String>(json['character']),
      romaji: serializer.fromJson<String>(json['romaji']),
      type: serializer.fromJson<String>(json['type']),
      row: serializer.fromJson<String>(json['row']),
      kanaGroup: serializer.fromJson<String>(json['kanaGroup']),
      slot: serializer.fromJson<int>(json['slot']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'character': serializer.toJson<String>(character),
      'romaji': serializer.toJson<String>(romaji),
      'type': serializer.toJson<String>(type),
      'row': serializer.toJson<String>(row),
      'kanaGroup': serializer.toJson<String>(kanaGroup),
      'slot': serializer.toJson<int>(slot),
    };
  }

  Kana copyWith({
    int? id,
    String? character,
    String? romaji,
    String? type,
    String? row,
    String? kanaGroup,
    int? slot,
  }) => Kana(
    id: id ?? this.id,
    character: character ?? this.character,
    romaji: romaji ?? this.romaji,
    type: type ?? this.type,
    row: row ?? this.row,
    kanaGroup: kanaGroup ?? this.kanaGroup,
    slot: slot ?? this.slot,
  );
  Kana copyWithCompanion(KanasCompanion data) {
    return Kana(
      id: data.id.present ? data.id.value : this.id,
      character: data.character.present ? data.character.value : this.character,
      romaji: data.romaji.present ? data.romaji.value : this.romaji,
      type: data.type.present ? data.type.value : this.type,
      row: data.row.present ? data.row.value : this.row,
      kanaGroup: data.kanaGroup.present ? data.kanaGroup.value : this.kanaGroup,
      slot: data.slot.present ? data.slot.value : this.slot,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Kana(')
          ..write('id: $id, ')
          ..write('character: $character, ')
          ..write('romaji: $romaji, ')
          ..write('type: $type, ')
          ..write('row: $row, ')
          ..write('kanaGroup: $kanaGroup, ')
          ..write('slot: $slot')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, character, romaji, type, row, kanaGroup, slot);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Kana &&
          other.id == this.id &&
          other.character == this.character &&
          other.romaji == this.romaji &&
          other.type == this.type &&
          other.row == this.row &&
          other.kanaGroup == this.kanaGroup &&
          other.slot == this.slot);
}

class KanasCompanion extends UpdateCompanion<Kana> {
  final Value<int> id;
  final Value<String> character;
  final Value<String> romaji;
  final Value<String> type;
  final Value<String> row;
  final Value<String> kanaGroup;
  final Value<int> slot;
  const KanasCompanion({
    this.id = const Value.absent(),
    this.character = const Value.absent(),
    this.romaji = const Value.absent(),
    this.type = const Value.absent(),
    this.row = const Value.absent(),
    this.kanaGroup = const Value.absent(),
    this.slot = const Value.absent(),
  });
  KanasCompanion.insert({
    this.id = const Value.absent(),
    required String character,
    required String romaji,
    required String type,
    required String row,
    required String kanaGroup,
    required int slot,
  }) : character = Value(character),
       romaji = Value(romaji),
       type = Value(type),
       row = Value(row),
       kanaGroup = Value(kanaGroup),
       slot = Value(slot);
  static Insertable<Kana> custom({
    Expression<int>? id,
    Expression<String>? character,
    Expression<String>? romaji,
    Expression<String>? type,
    Expression<String>? row,
    Expression<String>? kanaGroup,
    Expression<int>? slot,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (character != null) 'character': character,
      if (romaji != null) 'romaji': romaji,
      if (type != null) 'type': type,
      if (row != null) 'row': row,
      if (kanaGroup != null) 'kana_group': kanaGroup,
      if (slot != null) 'slot': slot,
    });
  }

  KanasCompanion copyWith({
    Value<int>? id,
    Value<String>? character,
    Value<String>? romaji,
    Value<String>? type,
    Value<String>? row,
    Value<String>? kanaGroup,
    Value<int>? slot,
  }) {
    return KanasCompanion(
      id: id ?? this.id,
      character: character ?? this.character,
      romaji: romaji ?? this.romaji,
      type: type ?? this.type,
      row: row ?? this.row,
      kanaGroup: kanaGroup ?? this.kanaGroup,
      slot: slot ?? this.slot,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (character.present) {
      map['character'] = Variable<String>(character.value);
    }
    if (romaji.present) {
      map['romaji'] = Variable<String>(romaji.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (row.present) {
      map['row'] = Variable<String>(row.value);
    }
    if (kanaGroup.present) {
      map['kana_group'] = Variable<String>(kanaGroup.value);
    }
    if (slot.present) {
      map['slot'] = Variable<int>(slot.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KanasCompanion(')
          ..write('id: $id, ')
          ..write('character: $character, ')
          ..write('romaji: $romaji, ')
          ..write('type: $type, ')
          ..write('row: $row, ')
          ..write('kanaGroup: $kanaGroup, ')
          ..write('slot: $slot')
          ..write(')'))
        .toString();
  }
}

class $VocabularyEntriesTable extends VocabularyEntries
    with TableInfo<$VocabularyEntriesTable, VocabularyEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VocabularyEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _wordMeta = const VerificationMeta('word');
  @override
  late final GeneratedColumn<String> word = GeneratedColumn<String>(
    'word',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _readingMeta = const VerificationMeta(
    'reading',
  );
  @override
  late final GeneratedColumn<String> reading = GeneratedColumn<String>(
    'reading',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _meaningMeta = const VerificationMeta(
    'meaning',
  );
  @override
  late final GeneratedColumn<String> meaning = GeneratedColumn<String>(
    'meaning',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jlptLevelMeta = const VerificationMeta(
    'jlptLevel',
  );
  @override
  late final GeneratedColumn<String> jlptLevel = GeneratedColumn<String>(
    'jlpt_level',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _partOfSpeechMeta = const VerificationMeta(
    'partOfSpeech',
  );
  @override
  late final GeneratedColumn<String> partOfSpeech = GeneratedColumn<String>(
    'part_of_speech',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kanjiIdMeta = const VerificationMeta(
    'kanjiId',
  );
  @override
  late final GeneratedColumn<int> kanjiId = GeneratedColumn<int>(
    'kanji_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES kanjis (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    word,
    reading,
    meaning,
    jlptLevel,
    partOfSpeech,
    kanjiId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vocabulary_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<VocabularyEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('word')) {
      context.handle(
        _wordMeta,
        word.isAcceptableOrUnknown(data['word']!, _wordMeta),
      );
    } else if (isInserting) {
      context.missing(_wordMeta);
    }
    if (data.containsKey('reading')) {
      context.handle(
        _readingMeta,
        reading.isAcceptableOrUnknown(data['reading']!, _readingMeta),
      );
    } else if (isInserting) {
      context.missing(_readingMeta);
    }
    if (data.containsKey('meaning')) {
      context.handle(
        _meaningMeta,
        meaning.isAcceptableOrUnknown(data['meaning']!, _meaningMeta),
      );
    } else if (isInserting) {
      context.missing(_meaningMeta);
    }
    if (data.containsKey('jlpt_level')) {
      context.handle(
        _jlptLevelMeta,
        jlptLevel.isAcceptableOrUnknown(data['jlpt_level']!, _jlptLevelMeta),
      );
    } else if (isInserting) {
      context.missing(_jlptLevelMeta);
    }
    if (data.containsKey('part_of_speech')) {
      context.handle(
        _partOfSpeechMeta,
        partOfSpeech.isAcceptableOrUnknown(
          data['part_of_speech']!,
          _partOfSpeechMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_partOfSpeechMeta);
    }
    if (data.containsKey('kanji_id')) {
      context.handle(
        _kanjiIdMeta,
        kanjiId.isAcceptableOrUnknown(data['kanji_id']!, _kanjiIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VocabularyEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VocabularyEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      word: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}word'],
      )!,
      reading: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reading'],
      )!,
      meaning: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meaning'],
      )!,
      jlptLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}jlpt_level'],
      )!,
      partOfSpeech: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}part_of_speech'],
      )!,
      kanjiId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}kanji_id'],
      ),
    );
  }

  @override
  $VocabularyEntriesTable createAlias(String alias) {
    return $VocabularyEntriesTable(attachedDatabase, alias);
  }
}

class VocabularyEntry extends DataClass implements Insertable<VocabularyEntry> {
  final int id;
  final String word;
  final String reading;
  final String meaning;
  final String jlptLevel;
  final String partOfSpeech;
  final int? kanjiId;
  const VocabularyEntry({
    required this.id,
    required this.word,
    required this.reading,
    required this.meaning,
    required this.jlptLevel,
    required this.partOfSpeech,
    this.kanjiId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['word'] = Variable<String>(word);
    map['reading'] = Variable<String>(reading);
    map['meaning'] = Variable<String>(meaning);
    map['jlpt_level'] = Variable<String>(jlptLevel);
    map['part_of_speech'] = Variable<String>(partOfSpeech);
    if (!nullToAbsent || kanjiId != null) {
      map['kanji_id'] = Variable<int>(kanjiId);
    }
    return map;
  }

  VocabularyEntriesCompanion toCompanion(bool nullToAbsent) {
    return VocabularyEntriesCompanion(
      id: Value(id),
      word: Value(word),
      reading: Value(reading),
      meaning: Value(meaning),
      jlptLevel: Value(jlptLevel),
      partOfSpeech: Value(partOfSpeech),
      kanjiId: kanjiId == null && nullToAbsent
          ? const Value.absent()
          : Value(kanjiId),
    );
  }

  factory VocabularyEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VocabularyEntry(
      id: serializer.fromJson<int>(json['id']),
      word: serializer.fromJson<String>(json['word']),
      reading: serializer.fromJson<String>(json['reading']),
      meaning: serializer.fromJson<String>(json['meaning']),
      jlptLevel: serializer.fromJson<String>(json['jlptLevel']),
      partOfSpeech: serializer.fromJson<String>(json['partOfSpeech']),
      kanjiId: serializer.fromJson<int?>(json['kanjiId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'word': serializer.toJson<String>(word),
      'reading': serializer.toJson<String>(reading),
      'meaning': serializer.toJson<String>(meaning),
      'jlptLevel': serializer.toJson<String>(jlptLevel),
      'partOfSpeech': serializer.toJson<String>(partOfSpeech),
      'kanjiId': serializer.toJson<int?>(kanjiId),
    };
  }

  VocabularyEntry copyWith({
    int? id,
    String? word,
    String? reading,
    String? meaning,
    String? jlptLevel,
    String? partOfSpeech,
    Value<int?> kanjiId = const Value.absent(),
  }) => VocabularyEntry(
    id: id ?? this.id,
    word: word ?? this.word,
    reading: reading ?? this.reading,
    meaning: meaning ?? this.meaning,
    jlptLevel: jlptLevel ?? this.jlptLevel,
    partOfSpeech: partOfSpeech ?? this.partOfSpeech,
    kanjiId: kanjiId.present ? kanjiId.value : this.kanjiId,
  );
  VocabularyEntry copyWithCompanion(VocabularyEntriesCompanion data) {
    return VocabularyEntry(
      id: data.id.present ? data.id.value : this.id,
      word: data.word.present ? data.word.value : this.word,
      reading: data.reading.present ? data.reading.value : this.reading,
      meaning: data.meaning.present ? data.meaning.value : this.meaning,
      jlptLevel: data.jlptLevel.present ? data.jlptLevel.value : this.jlptLevel,
      partOfSpeech: data.partOfSpeech.present
          ? data.partOfSpeech.value
          : this.partOfSpeech,
      kanjiId: data.kanjiId.present ? data.kanjiId.value : this.kanjiId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VocabularyEntry(')
          ..write('id: $id, ')
          ..write('word: $word, ')
          ..write('reading: $reading, ')
          ..write('meaning: $meaning, ')
          ..write('jlptLevel: $jlptLevel, ')
          ..write('partOfSpeech: $partOfSpeech, ')
          ..write('kanjiId: $kanjiId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, word, reading, meaning, jlptLevel, partOfSpeech, kanjiId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VocabularyEntry &&
          other.id == this.id &&
          other.word == this.word &&
          other.reading == this.reading &&
          other.meaning == this.meaning &&
          other.jlptLevel == this.jlptLevel &&
          other.partOfSpeech == this.partOfSpeech &&
          other.kanjiId == this.kanjiId);
}

class VocabularyEntriesCompanion extends UpdateCompanion<VocabularyEntry> {
  final Value<int> id;
  final Value<String> word;
  final Value<String> reading;
  final Value<String> meaning;
  final Value<String> jlptLevel;
  final Value<String> partOfSpeech;
  final Value<int?> kanjiId;
  const VocabularyEntriesCompanion({
    this.id = const Value.absent(),
    this.word = const Value.absent(),
    this.reading = const Value.absent(),
    this.meaning = const Value.absent(),
    this.jlptLevel = const Value.absent(),
    this.partOfSpeech = const Value.absent(),
    this.kanjiId = const Value.absent(),
  });
  VocabularyEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String word,
    required String reading,
    required String meaning,
    required String jlptLevel,
    required String partOfSpeech,
    this.kanjiId = const Value.absent(),
  }) : word = Value(word),
       reading = Value(reading),
       meaning = Value(meaning),
       jlptLevel = Value(jlptLevel),
       partOfSpeech = Value(partOfSpeech);
  static Insertable<VocabularyEntry> custom({
    Expression<int>? id,
    Expression<String>? word,
    Expression<String>? reading,
    Expression<String>? meaning,
    Expression<String>? jlptLevel,
    Expression<String>? partOfSpeech,
    Expression<int>? kanjiId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (word != null) 'word': word,
      if (reading != null) 'reading': reading,
      if (meaning != null) 'meaning': meaning,
      if (jlptLevel != null) 'jlpt_level': jlptLevel,
      if (partOfSpeech != null) 'part_of_speech': partOfSpeech,
      if (kanjiId != null) 'kanji_id': kanjiId,
    });
  }

  VocabularyEntriesCompanion copyWith({
    Value<int>? id,
    Value<String>? word,
    Value<String>? reading,
    Value<String>? meaning,
    Value<String>? jlptLevel,
    Value<String>? partOfSpeech,
    Value<int?>? kanjiId,
  }) {
    return VocabularyEntriesCompanion(
      id: id ?? this.id,
      word: word ?? this.word,
      reading: reading ?? this.reading,
      meaning: meaning ?? this.meaning,
      jlptLevel: jlptLevel ?? this.jlptLevel,
      partOfSpeech: partOfSpeech ?? this.partOfSpeech,
      kanjiId: kanjiId ?? this.kanjiId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (word.present) {
      map['word'] = Variable<String>(word.value);
    }
    if (reading.present) {
      map['reading'] = Variable<String>(reading.value);
    }
    if (meaning.present) {
      map['meaning'] = Variable<String>(meaning.value);
    }
    if (jlptLevel.present) {
      map['jlpt_level'] = Variable<String>(jlptLevel.value);
    }
    if (partOfSpeech.present) {
      map['part_of_speech'] = Variable<String>(partOfSpeech.value);
    }
    if (kanjiId.present) {
      map['kanji_id'] = Variable<int>(kanjiId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VocabularyEntriesCompanion(')
          ..write('id: $id, ')
          ..write('word: $word, ')
          ..write('reading: $reading, ')
          ..write('meaning: $meaning, ')
          ..write('jlptLevel: $jlptLevel, ')
          ..write('partOfSpeech: $partOfSpeech, ')
          ..write('kanjiId: $kanjiId')
          ..write(')'))
        .toString();
  }
}

class $GrammarLessonsTable extends GrammarLessons
    with TableInfo<$GrammarLessonsTable, GrammarLesson> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GrammarLessonsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _localeMeta = const VerificationMeta('locale');
  @override
  late final GeneratedColumn<String> locale = GeneratedColumn<String>(
    'locale',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _chapterMeta = const VerificationMeta(
    'chapter',
  );
  @override
  late final GeneratedColumn<String> chapter = GeneratedColumn<String>(
    'chapter',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMdMeta = const VerificationMeta(
    'contentMd',
  );
  @override
  late final GeneratedColumn<String> contentMd = GeneratedColumn<String>(
    'content_md',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _metadataMeta = const VerificationMeta(
    'metadata',
  );
  @override
  late final GeneratedColumn<String> metadata = GeneratedColumn<String>(
    'metadata',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    locale,
    chapter,
    title,
    contentMd,
    orderIndex,
    metadata,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'grammar_lessons';
  @override
  VerificationContext validateIntegrity(
    Insertable<GrammarLesson> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('locale')) {
      context.handle(
        _localeMeta,
        locale.isAcceptableOrUnknown(data['locale']!, _localeMeta),
      );
    } else if (isInserting) {
      context.missing(_localeMeta);
    }
    if (data.containsKey('chapter')) {
      context.handle(
        _chapterMeta,
        chapter.isAcceptableOrUnknown(data['chapter']!, _chapterMeta),
      );
    } else if (isInserting) {
      context.missing(_chapterMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('content_md')) {
      context.handle(
        _contentMdMeta,
        contentMd.isAcceptableOrUnknown(data['content_md']!, _contentMdMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMdMeta);
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    if (data.containsKey('metadata')) {
      context.handle(
        _metadataMeta,
        metadata.isAcceptableOrUnknown(data['metadata']!, _metadataMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GrammarLesson map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GrammarLesson(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      locale: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}locale'],
      )!,
      chapter: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chapter'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      contentMd: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_md'],
      )!,
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
      metadata: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metadata'],
      )!,
    );
  }

  @override
  $GrammarLessonsTable createAlias(String alias) {
    return $GrammarLessonsTable(attachedDatabase, alias);
  }
}

class GrammarLesson extends DataClass implements Insertable<GrammarLesson> {
  final int id;
  final String locale;
  final String chapter;
  final String title;
  final String contentMd;
  final int orderIndex;
  final String metadata;
  const GrammarLesson({
    required this.id,
    required this.locale,
    required this.chapter,
    required this.title,
    required this.contentMd,
    required this.orderIndex,
    required this.metadata,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['locale'] = Variable<String>(locale);
    map['chapter'] = Variable<String>(chapter);
    map['title'] = Variable<String>(title);
    map['content_md'] = Variable<String>(contentMd);
    map['order_index'] = Variable<int>(orderIndex);
    map['metadata'] = Variable<String>(metadata);
    return map;
  }

  GrammarLessonsCompanion toCompanion(bool nullToAbsent) {
    return GrammarLessonsCompanion(
      id: Value(id),
      locale: Value(locale),
      chapter: Value(chapter),
      title: Value(title),
      contentMd: Value(contentMd),
      orderIndex: Value(orderIndex),
      metadata: Value(metadata),
    );
  }

  factory GrammarLesson.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GrammarLesson(
      id: serializer.fromJson<int>(json['id']),
      locale: serializer.fromJson<String>(json['locale']),
      chapter: serializer.fromJson<String>(json['chapter']),
      title: serializer.fromJson<String>(json['title']),
      contentMd: serializer.fromJson<String>(json['contentMd']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
      metadata: serializer.fromJson<String>(json['metadata']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'locale': serializer.toJson<String>(locale),
      'chapter': serializer.toJson<String>(chapter),
      'title': serializer.toJson<String>(title),
      'contentMd': serializer.toJson<String>(contentMd),
      'orderIndex': serializer.toJson<int>(orderIndex),
      'metadata': serializer.toJson<String>(metadata),
    };
  }

  GrammarLesson copyWith({
    int? id,
    String? locale,
    String? chapter,
    String? title,
    String? contentMd,
    int? orderIndex,
    String? metadata,
  }) => GrammarLesson(
    id: id ?? this.id,
    locale: locale ?? this.locale,
    chapter: chapter ?? this.chapter,
    title: title ?? this.title,
    contentMd: contentMd ?? this.contentMd,
    orderIndex: orderIndex ?? this.orderIndex,
    metadata: metadata ?? this.metadata,
  );
  GrammarLesson copyWithCompanion(GrammarLessonsCompanion data) {
    return GrammarLesson(
      id: data.id.present ? data.id.value : this.id,
      locale: data.locale.present ? data.locale.value : this.locale,
      chapter: data.chapter.present ? data.chapter.value : this.chapter,
      title: data.title.present ? data.title.value : this.title,
      contentMd: data.contentMd.present ? data.contentMd.value : this.contentMd,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
      metadata: data.metadata.present ? data.metadata.value : this.metadata,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GrammarLesson(')
          ..write('id: $id, ')
          ..write('locale: $locale, ')
          ..write('chapter: $chapter, ')
          ..write('title: $title, ')
          ..write('contentMd: $contentMd, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('metadata: $metadata')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, locale, chapter, title, contentMd, orderIndex, metadata);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GrammarLesson &&
          other.id == this.id &&
          other.locale == this.locale &&
          other.chapter == this.chapter &&
          other.title == this.title &&
          other.contentMd == this.contentMd &&
          other.orderIndex == this.orderIndex &&
          other.metadata == this.metadata);
}

class GrammarLessonsCompanion extends UpdateCompanion<GrammarLesson> {
  final Value<int> id;
  final Value<String> locale;
  final Value<String> chapter;
  final Value<String> title;
  final Value<String> contentMd;
  final Value<int> orderIndex;
  final Value<String> metadata;
  const GrammarLessonsCompanion({
    this.id = const Value.absent(),
    this.locale = const Value.absent(),
    this.chapter = const Value.absent(),
    this.title = const Value.absent(),
    this.contentMd = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.metadata = const Value.absent(),
  });
  GrammarLessonsCompanion.insert({
    this.id = const Value.absent(),
    required String locale,
    required String chapter,
    required String title,
    required String contentMd,
    required int orderIndex,
    this.metadata = const Value.absent(),
  }) : locale = Value(locale),
       chapter = Value(chapter),
       title = Value(title),
       contentMd = Value(contentMd),
       orderIndex = Value(orderIndex);
  static Insertable<GrammarLesson> custom({
    Expression<int>? id,
    Expression<String>? locale,
    Expression<String>? chapter,
    Expression<String>? title,
    Expression<String>? contentMd,
    Expression<int>? orderIndex,
    Expression<String>? metadata,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (locale != null) 'locale': locale,
      if (chapter != null) 'chapter': chapter,
      if (title != null) 'title': title,
      if (contentMd != null) 'content_md': contentMd,
      if (orderIndex != null) 'order_index': orderIndex,
      if (metadata != null) 'metadata': metadata,
    });
  }

  GrammarLessonsCompanion copyWith({
    Value<int>? id,
    Value<String>? locale,
    Value<String>? chapter,
    Value<String>? title,
    Value<String>? contentMd,
    Value<int>? orderIndex,
    Value<String>? metadata,
  }) {
    return GrammarLessonsCompanion(
      id: id ?? this.id,
      locale: locale ?? this.locale,
      chapter: chapter ?? this.chapter,
      title: title ?? this.title,
      contentMd: contentMd ?? this.contentMd,
      orderIndex: orderIndex ?? this.orderIndex,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (locale.present) {
      map['locale'] = Variable<String>(locale.value);
    }
    if (chapter.present) {
      map['chapter'] = Variable<String>(chapter.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (contentMd.present) {
      map['content_md'] = Variable<String>(contentMd.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (metadata.present) {
      map['metadata'] = Variable<String>(metadata.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GrammarLessonsCompanion(')
          ..write('id: $id, ')
          ..write('locale: $locale, ')
          ..write('chapter: $chapter, ')
          ..write('title: $title, ')
          ..write('contentMd: $contentMd, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('metadata: $metadata')
          ..write(')'))
        .toString();
  }
}

class $ExercisesTable extends Exercises
    with TableInfo<$ExercisesTable, Exercise> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _localeMeta = const VerificationMeta('locale');
  @override
  late final GeneratedColumn<String> locale = GeneratedColumn<String>(
    'locale',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceIdMeta = const VerificationMeta(
    'sourceId',
  );
  @override
  late final GeneratedColumn<int> sourceId = GeneratedColumn<int>(
    'source_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _promptMeta = const VerificationMeta('prompt');
  @override
  late final GeneratedColumn<String> prompt = GeneratedColumn<String>(
    'prompt',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _answerMeta = const VerificationMeta('answer');
  @override
  late final GeneratedColumn<String> answer = GeneratedColumn<String>(
    'answer',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _distractorsMeta = const VerificationMeta(
    'distractors',
  );
  @override
  late final GeneratedColumn<String> distractors = GeneratedColumn<String>(
    'distractors',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _lessonIdMeta = const VerificationMeta(
    'lessonId',
  );
  @override
  late final GeneratedColumn<int> lessonId = GeneratedColumn<int>(
    'lesson_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES grammar_lessons (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    locale,
    type,
    source,
    sourceId,
    prompt,
    answer,
    distractors,
    lessonId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exercises';
  @override
  VerificationContext validateIntegrity(
    Insertable<Exercise> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('locale')) {
      context.handle(
        _localeMeta,
        locale.isAcceptableOrUnknown(data['locale']!, _localeMeta),
      );
    } else if (isInserting) {
      context.missing(_localeMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('source_id')) {
      context.handle(
        _sourceIdMeta,
        sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceIdMeta);
    }
    if (data.containsKey('prompt')) {
      context.handle(
        _promptMeta,
        prompt.isAcceptableOrUnknown(data['prompt']!, _promptMeta),
      );
    } else if (isInserting) {
      context.missing(_promptMeta);
    }
    if (data.containsKey('answer')) {
      context.handle(
        _answerMeta,
        answer.isAcceptableOrUnknown(data['answer']!, _answerMeta),
      );
    } else if (isInserting) {
      context.missing(_answerMeta);
    }
    if (data.containsKey('distractors')) {
      context.handle(
        _distractorsMeta,
        distractors.isAcceptableOrUnknown(
          data['distractors']!,
          _distractorsMeta,
        ),
      );
    }
    if (data.containsKey('lesson_id')) {
      context.handle(
        _lessonIdMeta,
        lessonId.isAcceptableOrUnknown(data['lesson_id']!, _lessonIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Exercise map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Exercise(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      locale: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}locale'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      sourceId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}source_id'],
      )!,
      prompt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prompt'],
      )!,
      answer: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}answer'],
      )!,
      distractors: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}distractors'],
      )!,
      lessonId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lesson_id'],
      ),
    );
  }

  @override
  $ExercisesTable createAlias(String alias) {
    return $ExercisesTable(attachedDatabase, alias);
  }
}

class Exercise extends DataClass implements Insertable<Exercise> {
  final int id;
  final String locale;
  final String type;
  final String source;
  final int sourceId;
  final String prompt;
  final String answer;
  final String distractors;
  final int? lessonId;
  const Exercise({
    required this.id,
    required this.locale,
    required this.type,
    required this.source,
    required this.sourceId,
    required this.prompt,
    required this.answer,
    required this.distractors,
    this.lessonId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['locale'] = Variable<String>(locale);
    map['type'] = Variable<String>(type);
    map['source'] = Variable<String>(source);
    map['source_id'] = Variable<int>(sourceId);
    map['prompt'] = Variable<String>(prompt);
    map['answer'] = Variable<String>(answer);
    map['distractors'] = Variable<String>(distractors);
    if (!nullToAbsent || lessonId != null) {
      map['lesson_id'] = Variable<int>(lessonId);
    }
    return map;
  }

  ExercisesCompanion toCompanion(bool nullToAbsent) {
    return ExercisesCompanion(
      id: Value(id),
      locale: Value(locale),
      type: Value(type),
      source: Value(source),
      sourceId: Value(sourceId),
      prompt: Value(prompt),
      answer: Value(answer),
      distractors: Value(distractors),
      lessonId: lessonId == null && nullToAbsent
          ? const Value.absent()
          : Value(lessonId),
    );
  }

  factory Exercise.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Exercise(
      id: serializer.fromJson<int>(json['id']),
      locale: serializer.fromJson<String>(json['locale']),
      type: serializer.fromJson<String>(json['type']),
      source: serializer.fromJson<String>(json['source']),
      sourceId: serializer.fromJson<int>(json['sourceId']),
      prompt: serializer.fromJson<String>(json['prompt']),
      answer: serializer.fromJson<String>(json['answer']),
      distractors: serializer.fromJson<String>(json['distractors']),
      lessonId: serializer.fromJson<int?>(json['lessonId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'locale': serializer.toJson<String>(locale),
      'type': serializer.toJson<String>(type),
      'source': serializer.toJson<String>(source),
      'sourceId': serializer.toJson<int>(sourceId),
      'prompt': serializer.toJson<String>(prompt),
      'answer': serializer.toJson<String>(answer),
      'distractors': serializer.toJson<String>(distractors),
      'lessonId': serializer.toJson<int?>(lessonId),
    };
  }

  Exercise copyWith({
    int? id,
    String? locale,
    String? type,
    String? source,
    int? sourceId,
    String? prompt,
    String? answer,
    String? distractors,
    Value<int?> lessonId = const Value.absent(),
  }) => Exercise(
    id: id ?? this.id,
    locale: locale ?? this.locale,
    type: type ?? this.type,
    source: source ?? this.source,
    sourceId: sourceId ?? this.sourceId,
    prompt: prompt ?? this.prompt,
    answer: answer ?? this.answer,
    distractors: distractors ?? this.distractors,
    lessonId: lessonId.present ? lessonId.value : this.lessonId,
  );
  Exercise copyWithCompanion(ExercisesCompanion data) {
    return Exercise(
      id: data.id.present ? data.id.value : this.id,
      locale: data.locale.present ? data.locale.value : this.locale,
      type: data.type.present ? data.type.value : this.type,
      source: data.source.present ? data.source.value : this.source,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      prompt: data.prompt.present ? data.prompt.value : this.prompt,
      answer: data.answer.present ? data.answer.value : this.answer,
      distractors: data.distractors.present
          ? data.distractors.value
          : this.distractors,
      lessonId: data.lessonId.present ? data.lessonId.value : this.lessonId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Exercise(')
          ..write('id: $id, ')
          ..write('locale: $locale, ')
          ..write('type: $type, ')
          ..write('source: $source, ')
          ..write('sourceId: $sourceId, ')
          ..write('prompt: $prompt, ')
          ..write('answer: $answer, ')
          ..write('distractors: $distractors, ')
          ..write('lessonId: $lessonId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    locale,
    type,
    source,
    sourceId,
    prompt,
    answer,
    distractors,
    lessonId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Exercise &&
          other.id == this.id &&
          other.locale == this.locale &&
          other.type == this.type &&
          other.source == this.source &&
          other.sourceId == this.sourceId &&
          other.prompt == this.prompt &&
          other.answer == this.answer &&
          other.distractors == this.distractors &&
          other.lessonId == this.lessonId);
}

class ExercisesCompanion extends UpdateCompanion<Exercise> {
  final Value<int> id;
  final Value<String> locale;
  final Value<String> type;
  final Value<String> source;
  final Value<int> sourceId;
  final Value<String> prompt;
  final Value<String> answer;
  final Value<String> distractors;
  final Value<int?> lessonId;
  const ExercisesCompanion({
    this.id = const Value.absent(),
    this.locale = const Value.absent(),
    this.type = const Value.absent(),
    this.source = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.prompt = const Value.absent(),
    this.answer = const Value.absent(),
    this.distractors = const Value.absent(),
    this.lessonId = const Value.absent(),
  });
  ExercisesCompanion.insert({
    this.id = const Value.absent(),
    required String locale,
    required String type,
    required String source,
    required int sourceId,
    required String prompt,
    required String answer,
    this.distractors = const Value.absent(),
    this.lessonId = const Value.absent(),
  }) : locale = Value(locale),
       type = Value(type),
       source = Value(source),
       sourceId = Value(sourceId),
       prompt = Value(prompt),
       answer = Value(answer);
  static Insertable<Exercise> custom({
    Expression<int>? id,
    Expression<String>? locale,
    Expression<String>? type,
    Expression<String>? source,
    Expression<int>? sourceId,
    Expression<String>? prompt,
    Expression<String>? answer,
    Expression<String>? distractors,
    Expression<int>? lessonId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (locale != null) 'locale': locale,
      if (type != null) 'type': type,
      if (source != null) 'source': source,
      if (sourceId != null) 'source_id': sourceId,
      if (prompt != null) 'prompt': prompt,
      if (answer != null) 'answer': answer,
      if (distractors != null) 'distractors': distractors,
      if (lessonId != null) 'lesson_id': lessonId,
    });
  }

  ExercisesCompanion copyWith({
    Value<int>? id,
    Value<String>? locale,
    Value<String>? type,
    Value<String>? source,
    Value<int>? sourceId,
    Value<String>? prompt,
    Value<String>? answer,
    Value<String>? distractors,
    Value<int?>? lessonId,
  }) {
    return ExercisesCompanion(
      id: id ?? this.id,
      locale: locale ?? this.locale,
      type: type ?? this.type,
      source: source ?? this.source,
      sourceId: sourceId ?? this.sourceId,
      prompt: prompt ?? this.prompt,
      answer: answer ?? this.answer,
      distractors: distractors ?? this.distractors,
      lessonId: lessonId ?? this.lessonId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (locale.present) {
      map['locale'] = Variable<String>(locale.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (sourceId.present) {
      map['source_id'] = Variable<int>(sourceId.value);
    }
    if (prompt.present) {
      map['prompt'] = Variable<String>(prompt.value);
    }
    if (answer.present) {
      map['answer'] = Variable<String>(answer.value);
    }
    if (distractors.present) {
      map['distractors'] = Variable<String>(distractors.value);
    }
    if (lessonId.present) {
      map['lesson_id'] = Variable<int>(lessonId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExercisesCompanion(')
          ..write('id: $id, ')
          ..write('locale: $locale, ')
          ..write('type: $type, ')
          ..write('source: $source, ')
          ..write('sourceId: $sourceId, ')
          ..write('prompt: $prompt, ')
          ..write('answer: $answer, ')
          ..write('distractors: $distractors, ')
          ..write('lessonId: $lessonId')
          ..write(')'))
        .toString();
  }
}

class $ProgressEntriesTable extends ProgressEntries
    with TableInfo<$ProgressEntriesTable, ProgressEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProgressEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _itemTypeMeta = const VerificationMeta(
    'itemType',
  );
  @override
  late final GeneratedColumn<String> itemType = GeneratedColumn<String>(
    'item_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<int> itemId = GeneratedColumn<int>(
    'item_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isKnownMeta = const VerificationMeta(
    'isKnown',
  );
  @override
  late final GeneratedColumn<bool> isKnown = GeneratedColumn<bool>(
    'is_known',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_known" IN (0, 1))',
    ),
  );
  static const VerificationMeta _toggledAtMeta = const VerificationMeta(
    'toggledAt',
  );
  @override
  late final GeneratedColumn<DateTime> toggledAt = GeneratedColumn<DateTime>(
    'toggled_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    itemType,
    itemId,
    isKnown,
    toggledAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'progress_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProgressEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('item_type')) {
      context.handle(
        _itemTypeMeta,
        itemType.isAcceptableOrUnknown(data['item_type']!, _itemTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_itemTypeMeta);
    }
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('is_known')) {
      context.handle(
        _isKnownMeta,
        isKnown.isAcceptableOrUnknown(data['is_known']!, _isKnownMeta),
      );
    } else if (isInserting) {
      context.missing(_isKnownMeta);
    }
    if (data.containsKey('toggled_at')) {
      context.handle(
        _toggledAtMeta,
        toggledAt.isAcceptableOrUnknown(data['toggled_at']!, _toggledAtMeta),
      );
    } else if (isInserting) {
      context.missing(_toggledAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {itemType, itemId},
  ];
  @override
  ProgressEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProgressEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      itemType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_type'],
      )!,
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}item_id'],
      )!,
      isKnown: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_known'],
      )!,
      toggledAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}toggled_at'],
      )!,
    );
  }

  @override
  $ProgressEntriesTable createAlias(String alias) {
    return $ProgressEntriesTable(attachedDatabase, alias);
  }
}

class ProgressEntry extends DataClass implements Insertable<ProgressEntry> {
  final int id;
  final String itemType;
  final int itemId;
  final bool isKnown;
  final DateTime toggledAt;
  const ProgressEntry({
    required this.id,
    required this.itemType,
    required this.itemId,
    required this.isKnown,
    required this.toggledAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['item_type'] = Variable<String>(itemType);
    map['item_id'] = Variable<int>(itemId);
    map['is_known'] = Variable<bool>(isKnown);
    map['toggled_at'] = Variable<DateTime>(toggledAt);
    return map;
  }

  ProgressEntriesCompanion toCompanion(bool nullToAbsent) {
    return ProgressEntriesCompanion(
      id: Value(id),
      itemType: Value(itemType),
      itemId: Value(itemId),
      isKnown: Value(isKnown),
      toggledAt: Value(toggledAt),
    );
  }

  factory ProgressEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProgressEntry(
      id: serializer.fromJson<int>(json['id']),
      itemType: serializer.fromJson<String>(json['itemType']),
      itemId: serializer.fromJson<int>(json['itemId']),
      isKnown: serializer.fromJson<bool>(json['isKnown']),
      toggledAt: serializer.fromJson<DateTime>(json['toggledAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'itemType': serializer.toJson<String>(itemType),
      'itemId': serializer.toJson<int>(itemId),
      'isKnown': serializer.toJson<bool>(isKnown),
      'toggledAt': serializer.toJson<DateTime>(toggledAt),
    };
  }

  ProgressEntry copyWith({
    int? id,
    String? itemType,
    int? itemId,
    bool? isKnown,
    DateTime? toggledAt,
  }) => ProgressEntry(
    id: id ?? this.id,
    itemType: itemType ?? this.itemType,
    itemId: itemId ?? this.itemId,
    isKnown: isKnown ?? this.isKnown,
    toggledAt: toggledAt ?? this.toggledAt,
  );
  ProgressEntry copyWithCompanion(ProgressEntriesCompanion data) {
    return ProgressEntry(
      id: data.id.present ? data.id.value : this.id,
      itemType: data.itemType.present ? data.itemType.value : this.itemType,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      isKnown: data.isKnown.present ? data.isKnown.value : this.isKnown,
      toggledAt: data.toggledAt.present ? data.toggledAt.value : this.toggledAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProgressEntry(')
          ..write('id: $id, ')
          ..write('itemType: $itemType, ')
          ..write('itemId: $itemId, ')
          ..write('isKnown: $isKnown, ')
          ..write('toggledAt: $toggledAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, itemType, itemId, isKnown, toggledAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProgressEntry &&
          other.id == this.id &&
          other.itemType == this.itemType &&
          other.itemId == this.itemId &&
          other.isKnown == this.isKnown &&
          other.toggledAt == this.toggledAt);
}

class ProgressEntriesCompanion extends UpdateCompanion<ProgressEntry> {
  final Value<int> id;
  final Value<String> itemType;
  final Value<int> itemId;
  final Value<bool> isKnown;
  final Value<DateTime> toggledAt;
  const ProgressEntriesCompanion({
    this.id = const Value.absent(),
    this.itemType = const Value.absent(),
    this.itemId = const Value.absent(),
    this.isKnown = const Value.absent(),
    this.toggledAt = const Value.absent(),
  });
  ProgressEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String itemType,
    required int itemId,
    required bool isKnown,
    required DateTime toggledAt,
  }) : itemType = Value(itemType),
       itemId = Value(itemId),
       isKnown = Value(isKnown),
       toggledAt = Value(toggledAt);
  static Insertable<ProgressEntry> custom({
    Expression<int>? id,
    Expression<String>? itemType,
    Expression<int>? itemId,
    Expression<bool>? isKnown,
    Expression<DateTime>? toggledAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (itemType != null) 'item_type': itemType,
      if (itemId != null) 'item_id': itemId,
      if (isKnown != null) 'is_known': isKnown,
      if (toggledAt != null) 'toggled_at': toggledAt,
    });
  }

  ProgressEntriesCompanion copyWith({
    Value<int>? id,
    Value<String>? itemType,
    Value<int>? itemId,
    Value<bool>? isKnown,
    Value<DateTime>? toggledAt,
  }) {
    return ProgressEntriesCompanion(
      id: id ?? this.id,
      itemType: itemType ?? this.itemType,
      itemId: itemId ?? this.itemId,
      isKnown: isKnown ?? this.isKnown,
      toggledAt: toggledAt ?? this.toggledAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (itemType.present) {
      map['item_type'] = Variable<String>(itemType.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<int>(itemId.value);
    }
    if (isKnown.present) {
      map['is_known'] = Variable<bool>(isKnown.value);
    }
    if (toggledAt.present) {
      map['toggled_at'] = Variable<DateTime>(toggledAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProgressEntriesCompanion(')
          ..write('id: $id, ')
          ..write('itemType: $itemType, ')
          ..write('itemId: $itemId, ')
          ..write('isKnown: $isKnown, ')
          ..write('toggledAt: $toggledAt')
          ..write(')'))
        .toString();
  }
}

class $KanjiTranslationsTable extends KanjiTranslations
    with TableInfo<$KanjiTranslationsTable, KanjiTranslation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KanjiTranslationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _kanjiIdMeta = const VerificationMeta(
    'kanjiId',
  );
  @override
  late final GeneratedColumn<int> kanjiId = GeneratedColumn<int>(
    'kanji_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES kanjis (id)',
    ),
  );
  static const VerificationMeta _localeMeta = const VerificationMeta('locale');
  @override
  late final GeneratedColumn<String> locale = GeneratedColumn<String>(
    'locale',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _meaningMeta = const VerificationMeta(
    'meaning',
  );
  @override
  late final GeneratedColumn<String> meaning = GeneratedColumn<String>(
    'meaning',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [kanjiId, locale, meaning];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'kanji_translations';
  @override
  VerificationContext validateIntegrity(
    Insertable<KanjiTranslation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('kanji_id')) {
      context.handle(
        _kanjiIdMeta,
        kanjiId.isAcceptableOrUnknown(data['kanji_id']!, _kanjiIdMeta),
      );
    } else if (isInserting) {
      context.missing(_kanjiIdMeta);
    }
    if (data.containsKey('locale')) {
      context.handle(
        _localeMeta,
        locale.isAcceptableOrUnknown(data['locale']!, _localeMeta),
      );
    } else if (isInserting) {
      context.missing(_localeMeta);
    }
    if (data.containsKey('meaning')) {
      context.handle(
        _meaningMeta,
        meaning.isAcceptableOrUnknown(data['meaning']!, _meaningMeta),
      );
    } else if (isInserting) {
      context.missing(_meaningMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {kanjiId, locale};
  @override
  KanjiTranslation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KanjiTranslation(
      kanjiId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}kanji_id'],
      )!,
      locale: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}locale'],
      )!,
      meaning: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meaning'],
      )!,
    );
  }

  @override
  $KanjiTranslationsTable createAlias(String alias) {
    return $KanjiTranslationsTable(attachedDatabase, alias);
  }
}

class KanjiTranslation extends DataClass
    implements Insertable<KanjiTranslation> {
  final int kanjiId;
  final String locale;
  final String meaning;
  const KanjiTranslation({
    required this.kanjiId,
    required this.locale,
    required this.meaning,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['kanji_id'] = Variable<int>(kanjiId);
    map['locale'] = Variable<String>(locale);
    map['meaning'] = Variable<String>(meaning);
    return map;
  }

  KanjiTranslationsCompanion toCompanion(bool nullToAbsent) {
    return KanjiTranslationsCompanion(
      kanjiId: Value(kanjiId),
      locale: Value(locale),
      meaning: Value(meaning),
    );
  }

  factory KanjiTranslation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KanjiTranslation(
      kanjiId: serializer.fromJson<int>(json['kanjiId']),
      locale: serializer.fromJson<String>(json['locale']),
      meaning: serializer.fromJson<String>(json['meaning']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'kanjiId': serializer.toJson<int>(kanjiId),
      'locale': serializer.toJson<String>(locale),
      'meaning': serializer.toJson<String>(meaning),
    };
  }

  KanjiTranslation copyWith({int? kanjiId, String? locale, String? meaning}) =>
      KanjiTranslation(
        kanjiId: kanjiId ?? this.kanjiId,
        locale: locale ?? this.locale,
        meaning: meaning ?? this.meaning,
      );
  KanjiTranslation copyWithCompanion(KanjiTranslationsCompanion data) {
    return KanjiTranslation(
      kanjiId: data.kanjiId.present ? data.kanjiId.value : this.kanjiId,
      locale: data.locale.present ? data.locale.value : this.locale,
      meaning: data.meaning.present ? data.meaning.value : this.meaning,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KanjiTranslation(')
          ..write('kanjiId: $kanjiId, ')
          ..write('locale: $locale, ')
          ..write('meaning: $meaning')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(kanjiId, locale, meaning);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KanjiTranslation &&
          other.kanjiId == this.kanjiId &&
          other.locale == this.locale &&
          other.meaning == this.meaning);
}

class KanjiTranslationsCompanion extends UpdateCompanion<KanjiTranslation> {
  final Value<int> kanjiId;
  final Value<String> locale;
  final Value<String> meaning;
  final Value<int> rowid;
  const KanjiTranslationsCompanion({
    this.kanjiId = const Value.absent(),
    this.locale = const Value.absent(),
    this.meaning = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  KanjiTranslationsCompanion.insert({
    required int kanjiId,
    required String locale,
    required String meaning,
    this.rowid = const Value.absent(),
  }) : kanjiId = Value(kanjiId),
       locale = Value(locale),
       meaning = Value(meaning);
  static Insertable<KanjiTranslation> custom({
    Expression<int>? kanjiId,
    Expression<String>? locale,
    Expression<String>? meaning,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (kanjiId != null) 'kanji_id': kanjiId,
      if (locale != null) 'locale': locale,
      if (meaning != null) 'meaning': meaning,
      if (rowid != null) 'rowid': rowid,
    });
  }

  KanjiTranslationsCompanion copyWith({
    Value<int>? kanjiId,
    Value<String>? locale,
    Value<String>? meaning,
    Value<int>? rowid,
  }) {
    return KanjiTranslationsCompanion(
      kanjiId: kanjiId ?? this.kanjiId,
      locale: locale ?? this.locale,
      meaning: meaning ?? this.meaning,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (kanjiId.present) {
      map['kanji_id'] = Variable<int>(kanjiId.value);
    }
    if (locale.present) {
      map['locale'] = Variable<String>(locale.value);
    }
    if (meaning.present) {
      map['meaning'] = Variable<String>(meaning.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KanjiTranslationsCompanion(')
          ..write('kanjiId: $kanjiId, ')
          ..write('locale: $locale, ')
          ..write('meaning: $meaning, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VocabTranslationsTable extends VocabTranslations
    with TableInfo<$VocabTranslationsTable, VocabTranslation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VocabTranslationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _vocabIdMeta = const VerificationMeta(
    'vocabId',
  );
  @override
  late final GeneratedColumn<int> vocabId = GeneratedColumn<int>(
    'vocab_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES vocabulary_entries (id)',
    ),
  );
  static const VerificationMeta _localeMeta = const VerificationMeta('locale');
  @override
  late final GeneratedColumn<String> locale = GeneratedColumn<String>(
    'locale',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _meaningMeta = const VerificationMeta(
    'meaning',
  );
  @override
  late final GeneratedColumn<String> meaning = GeneratedColumn<String>(
    'meaning',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [vocabId, locale, meaning];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vocab_translations';
  @override
  VerificationContext validateIntegrity(
    Insertable<VocabTranslation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('vocab_id')) {
      context.handle(
        _vocabIdMeta,
        vocabId.isAcceptableOrUnknown(data['vocab_id']!, _vocabIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vocabIdMeta);
    }
    if (data.containsKey('locale')) {
      context.handle(
        _localeMeta,
        locale.isAcceptableOrUnknown(data['locale']!, _localeMeta),
      );
    } else if (isInserting) {
      context.missing(_localeMeta);
    }
    if (data.containsKey('meaning')) {
      context.handle(
        _meaningMeta,
        meaning.isAcceptableOrUnknown(data['meaning']!, _meaningMeta),
      );
    } else if (isInserting) {
      context.missing(_meaningMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {vocabId, locale};
  @override
  VocabTranslation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VocabTranslation(
      vocabId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}vocab_id'],
      )!,
      locale: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}locale'],
      )!,
      meaning: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meaning'],
      )!,
    );
  }

  @override
  $VocabTranslationsTable createAlias(String alias) {
    return $VocabTranslationsTable(attachedDatabase, alias);
  }
}

class VocabTranslation extends DataClass
    implements Insertable<VocabTranslation> {
  final int vocabId;
  final String locale;
  final String meaning;
  const VocabTranslation({
    required this.vocabId,
    required this.locale,
    required this.meaning,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['vocab_id'] = Variable<int>(vocabId);
    map['locale'] = Variable<String>(locale);
    map['meaning'] = Variable<String>(meaning);
    return map;
  }

  VocabTranslationsCompanion toCompanion(bool nullToAbsent) {
    return VocabTranslationsCompanion(
      vocabId: Value(vocabId),
      locale: Value(locale),
      meaning: Value(meaning),
    );
  }

  factory VocabTranslation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VocabTranslation(
      vocabId: serializer.fromJson<int>(json['vocabId']),
      locale: serializer.fromJson<String>(json['locale']),
      meaning: serializer.fromJson<String>(json['meaning']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'vocabId': serializer.toJson<int>(vocabId),
      'locale': serializer.toJson<String>(locale),
      'meaning': serializer.toJson<String>(meaning),
    };
  }

  VocabTranslation copyWith({int? vocabId, String? locale, String? meaning}) =>
      VocabTranslation(
        vocabId: vocabId ?? this.vocabId,
        locale: locale ?? this.locale,
        meaning: meaning ?? this.meaning,
      );
  VocabTranslation copyWithCompanion(VocabTranslationsCompanion data) {
    return VocabTranslation(
      vocabId: data.vocabId.present ? data.vocabId.value : this.vocabId,
      locale: data.locale.present ? data.locale.value : this.locale,
      meaning: data.meaning.present ? data.meaning.value : this.meaning,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VocabTranslation(')
          ..write('vocabId: $vocabId, ')
          ..write('locale: $locale, ')
          ..write('meaning: $meaning')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(vocabId, locale, meaning);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VocabTranslation &&
          other.vocabId == this.vocabId &&
          other.locale == this.locale &&
          other.meaning == this.meaning);
}

class VocabTranslationsCompanion extends UpdateCompanion<VocabTranslation> {
  final Value<int> vocabId;
  final Value<String> locale;
  final Value<String> meaning;
  final Value<int> rowid;
  const VocabTranslationsCompanion({
    this.vocabId = const Value.absent(),
    this.locale = const Value.absent(),
    this.meaning = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VocabTranslationsCompanion.insert({
    required int vocabId,
    required String locale,
    required String meaning,
    this.rowid = const Value.absent(),
  }) : vocabId = Value(vocabId),
       locale = Value(locale),
       meaning = Value(meaning);
  static Insertable<VocabTranslation> custom({
    Expression<int>? vocabId,
    Expression<String>? locale,
    Expression<String>? meaning,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (vocabId != null) 'vocab_id': vocabId,
      if (locale != null) 'locale': locale,
      if (meaning != null) 'meaning': meaning,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VocabTranslationsCompanion copyWith({
    Value<int>? vocabId,
    Value<String>? locale,
    Value<String>? meaning,
    Value<int>? rowid,
  }) {
    return VocabTranslationsCompanion(
      vocabId: vocabId ?? this.vocabId,
      locale: locale ?? this.locale,
      meaning: meaning ?? this.meaning,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (vocabId.present) {
      map['vocab_id'] = Variable<int>(vocabId.value);
    }
    if (locale.present) {
      map['locale'] = Variable<String>(locale.value);
    }
    if (meaning.present) {
      map['meaning'] = Variable<String>(meaning.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VocabTranslationsCompanion(')
          ..write('vocabId: $vocabId, ')
          ..write('locale: $locale, ')
          ..write('meaning: $meaning, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SrsCardsTable extends SrsCards with TableInfo<$SrsCardsTable, SrsCard> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SrsCardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _itemTypeMeta = const VerificationMeta(
    'itemType',
  );
  @override
  late final GeneratedColumn<String> itemType = GeneratedColumn<String>(
    'item_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<int> itemId = GeneratedColumn<int>(
    'item_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dueMeta = const VerificationMeta('due');
  @override
  late final GeneratedColumn<DateTime> due = GeneratedColumn<DateTime>(
    'due',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cardJsonMeta = const VerificationMeta(
    'cardJson',
  );
  @override
  late final GeneratedColumn<String> cardJson = GeneratedColumn<String>(
    'card_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [itemType, itemId, due, cardJson];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'srs_cards';
  @override
  VerificationContext validateIntegrity(
    Insertable<SrsCard> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('item_type')) {
      context.handle(
        _itemTypeMeta,
        itemType.isAcceptableOrUnknown(data['item_type']!, _itemTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_itemTypeMeta);
    }
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('due')) {
      context.handle(
        _dueMeta,
        due.isAcceptableOrUnknown(data['due']!, _dueMeta),
      );
    } else if (isInserting) {
      context.missing(_dueMeta);
    }
    if (data.containsKey('card_json')) {
      context.handle(
        _cardJsonMeta,
        cardJson.isAcceptableOrUnknown(data['card_json']!, _cardJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_cardJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {itemType, itemId};
  @override
  SrsCard map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SrsCard(
      itemType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_type'],
      )!,
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}item_id'],
      )!,
      due: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due'],
      )!,
      cardJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}card_json'],
      )!,
    );
  }

  @override
  $SrsCardsTable createAlias(String alias) {
    return $SrsCardsTable(attachedDatabase, alias);
  }
}

class SrsCard extends DataClass implements Insertable<SrsCard> {
  final String itemType;
  final int itemId;
  final DateTime due;
  final String cardJson;
  const SrsCard({
    required this.itemType,
    required this.itemId,
    required this.due,
    required this.cardJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['item_type'] = Variable<String>(itemType);
    map['item_id'] = Variable<int>(itemId);
    map['due'] = Variable<DateTime>(due);
    map['card_json'] = Variable<String>(cardJson);
    return map;
  }

  SrsCardsCompanion toCompanion(bool nullToAbsent) {
    return SrsCardsCompanion(
      itemType: Value(itemType),
      itemId: Value(itemId),
      due: Value(due),
      cardJson: Value(cardJson),
    );
  }

  factory SrsCard.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SrsCard(
      itemType: serializer.fromJson<String>(json['itemType']),
      itemId: serializer.fromJson<int>(json['itemId']),
      due: serializer.fromJson<DateTime>(json['due']),
      cardJson: serializer.fromJson<String>(json['cardJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'itemType': serializer.toJson<String>(itemType),
      'itemId': serializer.toJson<int>(itemId),
      'due': serializer.toJson<DateTime>(due),
      'cardJson': serializer.toJson<String>(cardJson),
    };
  }

  SrsCard copyWith({
    String? itemType,
    int? itemId,
    DateTime? due,
    String? cardJson,
  }) => SrsCard(
    itemType: itemType ?? this.itemType,
    itemId: itemId ?? this.itemId,
    due: due ?? this.due,
    cardJson: cardJson ?? this.cardJson,
  );
  SrsCard copyWithCompanion(SrsCardsCompanion data) {
    return SrsCard(
      itemType: data.itemType.present ? data.itemType.value : this.itemType,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      due: data.due.present ? data.due.value : this.due,
      cardJson: data.cardJson.present ? data.cardJson.value : this.cardJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SrsCard(')
          ..write('itemType: $itemType, ')
          ..write('itemId: $itemId, ')
          ..write('due: $due, ')
          ..write('cardJson: $cardJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(itemType, itemId, due, cardJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SrsCard &&
          other.itemType == this.itemType &&
          other.itemId == this.itemId &&
          other.due == this.due &&
          other.cardJson == this.cardJson);
}

class SrsCardsCompanion extends UpdateCompanion<SrsCard> {
  final Value<String> itemType;
  final Value<int> itemId;
  final Value<DateTime> due;
  final Value<String> cardJson;
  final Value<int> rowid;
  const SrsCardsCompanion({
    this.itemType = const Value.absent(),
    this.itemId = const Value.absent(),
    this.due = const Value.absent(),
    this.cardJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SrsCardsCompanion.insert({
    required String itemType,
    required int itemId,
    required DateTime due,
    required String cardJson,
    this.rowid = const Value.absent(),
  }) : itemType = Value(itemType),
       itemId = Value(itemId),
       due = Value(due),
       cardJson = Value(cardJson);
  static Insertable<SrsCard> custom({
    Expression<String>? itemType,
    Expression<int>? itemId,
    Expression<DateTime>? due,
    Expression<String>? cardJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (itemType != null) 'item_type': itemType,
      if (itemId != null) 'item_id': itemId,
      if (due != null) 'due': due,
      if (cardJson != null) 'card_json': cardJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SrsCardsCompanion copyWith({
    Value<String>? itemType,
    Value<int>? itemId,
    Value<DateTime>? due,
    Value<String>? cardJson,
    Value<int>? rowid,
  }) {
    return SrsCardsCompanion(
      itemType: itemType ?? this.itemType,
      itemId: itemId ?? this.itemId,
      due: due ?? this.due,
      cardJson: cardJson ?? this.cardJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (itemType.present) {
      map['item_type'] = Variable<String>(itemType.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<int>(itemId.value);
    }
    if (due.present) {
      map['due'] = Variable<DateTime>(due.value);
    }
    if (cardJson.present) {
      map['card_json'] = Variable<String>(cardJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SrsCardsCompanion(')
          ..write('itemType: $itemType, ')
          ..write('itemId: $itemId, ')
          ..write('due: $due, ')
          ..write('cardJson: $cardJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $KanjisTable kanjis = $KanjisTable(this);
  late final $KanasTable kanas = $KanasTable(this);
  late final $VocabularyEntriesTable vocabularyEntries =
      $VocabularyEntriesTable(this);
  late final $GrammarLessonsTable grammarLessons = $GrammarLessonsTable(this);
  late final $ExercisesTable exercises = $ExercisesTable(this);
  late final $ProgressEntriesTable progressEntries = $ProgressEntriesTable(
    this,
  );
  late final $KanjiTranslationsTable kanjiTranslations =
      $KanjiTranslationsTable(this);
  late final $VocabTranslationsTable vocabTranslations =
      $VocabTranslationsTable(this);
  late final $SrsCardsTable srsCards = $SrsCardsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    kanjis,
    kanas,
    vocabularyEntries,
    grammarLessons,
    exercises,
    progressEntries,
    kanjiTranslations,
    vocabTranslations,
    srsCards,
  ];
}

typedef $$KanjisTableCreateCompanionBuilder =
    KanjisCompanion Function({
      Value<int> id,
      required String character,
      required String meaning,
      required String onReading,
      required String kunReading,
      required String jlptLevel,
    });
typedef $$KanjisTableUpdateCompanionBuilder =
    KanjisCompanion Function({
      Value<int> id,
      Value<String> character,
      Value<String> meaning,
      Value<String> onReading,
      Value<String> kunReading,
      Value<String> jlptLevel,
    });

final class $$KanjisTableReferences
    extends BaseReferences<_$AppDatabase, $KanjisTable, Kanji> {
  $$KanjisTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$VocabularyEntriesTable, List<VocabularyEntry>>
  _vocabularyEntriesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.vocabularyEntries,
        aliasName: $_aliasNameGenerator(
          db.kanjis.id,
          db.vocabularyEntries.kanjiId,
        ),
      );

  $$VocabularyEntriesTableProcessedTableManager get vocabularyEntriesRefs {
    final manager = $$VocabularyEntriesTableTableManager(
      $_db,
      $_db.vocabularyEntries,
    ).filter((f) => f.kanjiId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _vocabularyEntriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$KanjiTranslationsTable, List<KanjiTranslation>>
  _kanjiTranslationsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.kanjiTranslations,
        aliasName: $_aliasNameGenerator(
          db.kanjis.id,
          db.kanjiTranslations.kanjiId,
        ),
      );

  $$KanjiTranslationsTableProcessedTableManager get kanjiTranslationsRefs {
    final manager = $$KanjiTranslationsTableTableManager(
      $_db,
      $_db.kanjiTranslations,
    ).filter((f) => f.kanjiId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _kanjiTranslationsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$KanjisTableFilterComposer
    extends Composer<_$AppDatabase, $KanjisTable> {
  $$KanjisTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get character => $composableBuilder(
    column: $table.character,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get meaning => $composableBuilder(
    column: $table.meaning,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get onReading => $composableBuilder(
    column: $table.onReading,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kunReading => $composableBuilder(
    column: $table.kunReading,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get jlptLevel => $composableBuilder(
    column: $table.jlptLevel,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> vocabularyEntriesRefs(
    Expression<bool> Function($$VocabularyEntriesTableFilterComposer f) f,
  ) {
    final $$VocabularyEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.vocabularyEntries,
      getReferencedColumn: (t) => t.kanjiId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VocabularyEntriesTableFilterComposer(
            $db: $db,
            $table: $db.vocabularyEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> kanjiTranslationsRefs(
    Expression<bool> Function($$KanjiTranslationsTableFilterComposer f) f,
  ) {
    final $$KanjiTranslationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.kanjiTranslations,
      getReferencedColumn: (t) => t.kanjiId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KanjiTranslationsTableFilterComposer(
            $db: $db,
            $table: $db.kanjiTranslations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$KanjisTableOrderingComposer
    extends Composer<_$AppDatabase, $KanjisTable> {
  $$KanjisTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get character => $composableBuilder(
    column: $table.character,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get meaning => $composableBuilder(
    column: $table.meaning,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get onReading => $composableBuilder(
    column: $table.onReading,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kunReading => $composableBuilder(
    column: $table.kunReading,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get jlptLevel => $composableBuilder(
    column: $table.jlptLevel,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$KanjisTableAnnotationComposer
    extends Composer<_$AppDatabase, $KanjisTable> {
  $$KanjisTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get character =>
      $composableBuilder(column: $table.character, builder: (column) => column);

  GeneratedColumn<String> get meaning =>
      $composableBuilder(column: $table.meaning, builder: (column) => column);

  GeneratedColumn<String> get onReading =>
      $composableBuilder(column: $table.onReading, builder: (column) => column);

  GeneratedColumn<String> get kunReading => $composableBuilder(
    column: $table.kunReading,
    builder: (column) => column,
  );

  GeneratedColumn<String> get jlptLevel =>
      $composableBuilder(column: $table.jlptLevel, builder: (column) => column);

  Expression<T> vocabularyEntriesRefs<T extends Object>(
    Expression<T> Function($$VocabularyEntriesTableAnnotationComposer a) f,
  ) {
    final $$VocabularyEntriesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.vocabularyEntries,
          getReferencedColumn: (t) => t.kanjiId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$VocabularyEntriesTableAnnotationComposer(
                $db: $db,
                $table: $db.vocabularyEntries,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> kanjiTranslationsRefs<T extends Object>(
    Expression<T> Function($$KanjiTranslationsTableAnnotationComposer a) f,
  ) {
    final $$KanjiTranslationsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.kanjiTranslations,
          getReferencedColumn: (t) => t.kanjiId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$KanjiTranslationsTableAnnotationComposer(
                $db: $db,
                $table: $db.kanjiTranslations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$KanjisTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $KanjisTable,
          Kanji,
          $$KanjisTableFilterComposer,
          $$KanjisTableOrderingComposer,
          $$KanjisTableAnnotationComposer,
          $$KanjisTableCreateCompanionBuilder,
          $$KanjisTableUpdateCompanionBuilder,
          (Kanji, $$KanjisTableReferences),
          Kanji,
          PrefetchHooks Function({
            bool vocabularyEntriesRefs,
            bool kanjiTranslationsRefs,
          })
        > {
  $$KanjisTableTableManager(_$AppDatabase db, $KanjisTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KanjisTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KanjisTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KanjisTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> character = const Value.absent(),
                Value<String> meaning = const Value.absent(),
                Value<String> onReading = const Value.absent(),
                Value<String> kunReading = const Value.absent(),
                Value<String> jlptLevel = const Value.absent(),
              }) => KanjisCompanion(
                id: id,
                character: character,
                meaning: meaning,
                onReading: onReading,
                kunReading: kunReading,
                jlptLevel: jlptLevel,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String character,
                required String meaning,
                required String onReading,
                required String kunReading,
                required String jlptLevel,
              }) => KanjisCompanion.insert(
                id: id,
                character: character,
                meaning: meaning,
                onReading: onReading,
                kunReading: kunReading,
                jlptLevel: jlptLevel,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$KanjisTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({vocabularyEntriesRefs = false, kanjiTranslationsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (vocabularyEntriesRefs) db.vocabularyEntries,
                    if (kanjiTranslationsRefs) db.kanjiTranslations,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (vocabularyEntriesRefs)
                        await $_getPrefetchedData<
                          Kanji,
                          $KanjisTable,
                          VocabularyEntry
                        >(
                          currentTable: table,
                          referencedTable: $$KanjisTableReferences
                              ._vocabularyEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$KanjisTableReferences(
                                db,
                                table,
                                p0,
                              ).vocabularyEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.kanjiId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (kanjiTranslationsRefs)
                        await $_getPrefetchedData<
                          Kanji,
                          $KanjisTable,
                          KanjiTranslation
                        >(
                          currentTable: table,
                          referencedTable: $$KanjisTableReferences
                              ._kanjiTranslationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$KanjisTableReferences(
                                db,
                                table,
                                p0,
                              ).kanjiTranslationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.kanjiId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$KanjisTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $KanjisTable,
      Kanji,
      $$KanjisTableFilterComposer,
      $$KanjisTableOrderingComposer,
      $$KanjisTableAnnotationComposer,
      $$KanjisTableCreateCompanionBuilder,
      $$KanjisTableUpdateCompanionBuilder,
      (Kanji, $$KanjisTableReferences),
      Kanji,
      PrefetchHooks Function({
        bool vocabularyEntriesRefs,
        bool kanjiTranslationsRefs,
      })
    >;
typedef $$KanasTableCreateCompanionBuilder =
    KanasCompanion Function({
      Value<int> id,
      required String character,
      required String romaji,
      required String type,
      required String row,
      required String kanaGroup,
      required int slot,
    });
typedef $$KanasTableUpdateCompanionBuilder =
    KanasCompanion Function({
      Value<int> id,
      Value<String> character,
      Value<String> romaji,
      Value<String> type,
      Value<String> row,
      Value<String> kanaGroup,
      Value<int> slot,
    });

class $$KanasTableFilterComposer extends Composer<_$AppDatabase, $KanasTable> {
  $$KanasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get character => $composableBuilder(
    column: $table.character,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get romaji => $composableBuilder(
    column: $table.romaji,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get row => $composableBuilder(
    column: $table.row,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kanaGroup => $composableBuilder(
    column: $table.kanaGroup,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get slot => $composableBuilder(
    column: $table.slot,
    builder: (column) => ColumnFilters(column),
  );
}

class $$KanasTableOrderingComposer
    extends Composer<_$AppDatabase, $KanasTable> {
  $$KanasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get character => $composableBuilder(
    column: $table.character,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get romaji => $composableBuilder(
    column: $table.romaji,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get row => $composableBuilder(
    column: $table.row,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kanaGroup => $composableBuilder(
    column: $table.kanaGroup,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get slot => $composableBuilder(
    column: $table.slot,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$KanasTableAnnotationComposer
    extends Composer<_$AppDatabase, $KanasTable> {
  $$KanasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get character =>
      $composableBuilder(column: $table.character, builder: (column) => column);

  GeneratedColumn<String> get romaji =>
      $composableBuilder(column: $table.romaji, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get row =>
      $composableBuilder(column: $table.row, builder: (column) => column);

  GeneratedColumn<String> get kanaGroup =>
      $composableBuilder(column: $table.kanaGroup, builder: (column) => column);

  GeneratedColumn<int> get slot =>
      $composableBuilder(column: $table.slot, builder: (column) => column);
}

class $$KanasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $KanasTable,
          Kana,
          $$KanasTableFilterComposer,
          $$KanasTableOrderingComposer,
          $$KanasTableAnnotationComposer,
          $$KanasTableCreateCompanionBuilder,
          $$KanasTableUpdateCompanionBuilder,
          (Kana, BaseReferences<_$AppDatabase, $KanasTable, Kana>),
          Kana,
          PrefetchHooks Function()
        > {
  $$KanasTableTableManager(_$AppDatabase db, $KanasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KanasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KanasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KanasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> character = const Value.absent(),
                Value<String> romaji = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> row = const Value.absent(),
                Value<String> kanaGroup = const Value.absent(),
                Value<int> slot = const Value.absent(),
              }) => KanasCompanion(
                id: id,
                character: character,
                romaji: romaji,
                type: type,
                row: row,
                kanaGroup: kanaGroup,
                slot: slot,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String character,
                required String romaji,
                required String type,
                required String row,
                required String kanaGroup,
                required int slot,
              }) => KanasCompanion.insert(
                id: id,
                character: character,
                romaji: romaji,
                type: type,
                row: row,
                kanaGroup: kanaGroup,
                slot: slot,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$KanasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $KanasTable,
      Kana,
      $$KanasTableFilterComposer,
      $$KanasTableOrderingComposer,
      $$KanasTableAnnotationComposer,
      $$KanasTableCreateCompanionBuilder,
      $$KanasTableUpdateCompanionBuilder,
      (Kana, BaseReferences<_$AppDatabase, $KanasTable, Kana>),
      Kana,
      PrefetchHooks Function()
    >;
typedef $$VocabularyEntriesTableCreateCompanionBuilder =
    VocabularyEntriesCompanion Function({
      Value<int> id,
      required String word,
      required String reading,
      required String meaning,
      required String jlptLevel,
      required String partOfSpeech,
      Value<int?> kanjiId,
    });
typedef $$VocabularyEntriesTableUpdateCompanionBuilder =
    VocabularyEntriesCompanion Function({
      Value<int> id,
      Value<String> word,
      Value<String> reading,
      Value<String> meaning,
      Value<String> jlptLevel,
      Value<String> partOfSpeech,
      Value<int?> kanjiId,
    });

final class $$VocabularyEntriesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $VocabularyEntriesTable,
          VocabularyEntry
        > {
  $$VocabularyEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $KanjisTable _kanjiIdTable(_$AppDatabase db) => db.kanjis.createAlias(
    $_aliasNameGenerator(db.vocabularyEntries.kanjiId, db.kanjis.id),
  );

  $$KanjisTableProcessedTableManager? get kanjiId {
    final $_column = $_itemColumn<int>('kanji_id');
    if ($_column == null) return null;
    final manager = $$KanjisTableTableManager(
      $_db,
      $_db.kanjis,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_kanjiIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$VocabTranslationsTable, List<VocabTranslation>>
  _vocabTranslationsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.vocabTranslations,
        aliasName: $_aliasNameGenerator(
          db.vocabularyEntries.id,
          db.vocabTranslations.vocabId,
        ),
      );

  $$VocabTranslationsTableProcessedTableManager get vocabTranslationsRefs {
    final manager = $$VocabTranslationsTableTableManager(
      $_db,
      $_db.vocabTranslations,
    ).filter((f) => f.vocabId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _vocabTranslationsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$VocabularyEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $VocabularyEntriesTable> {
  $$VocabularyEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get word => $composableBuilder(
    column: $table.word,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reading => $composableBuilder(
    column: $table.reading,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get meaning => $composableBuilder(
    column: $table.meaning,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get jlptLevel => $composableBuilder(
    column: $table.jlptLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get partOfSpeech => $composableBuilder(
    column: $table.partOfSpeech,
    builder: (column) => ColumnFilters(column),
  );

  $$KanjisTableFilterComposer get kanjiId {
    final $$KanjisTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kanjiId,
      referencedTable: $db.kanjis,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KanjisTableFilterComposer(
            $db: $db,
            $table: $db.kanjis,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> vocabTranslationsRefs(
    Expression<bool> Function($$VocabTranslationsTableFilterComposer f) f,
  ) {
    final $$VocabTranslationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.vocabTranslations,
      getReferencedColumn: (t) => t.vocabId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VocabTranslationsTableFilterComposer(
            $db: $db,
            $table: $db.vocabTranslations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$VocabularyEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $VocabularyEntriesTable> {
  $$VocabularyEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get word => $composableBuilder(
    column: $table.word,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reading => $composableBuilder(
    column: $table.reading,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get meaning => $composableBuilder(
    column: $table.meaning,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get jlptLevel => $composableBuilder(
    column: $table.jlptLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get partOfSpeech => $composableBuilder(
    column: $table.partOfSpeech,
    builder: (column) => ColumnOrderings(column),
  );

  $$KanjisTableOrderingComposer get kanjiId {
    final $$KanjisTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kanjiId,
      referencedTable: $db.kanjis,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KanjisTableOrderingComposer(
            $db: $db,
            $table: $db.kanjis,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VocabularyEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $VocabularyEntriesTable> {
  $$VocabularyEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get word =>
      $composableBuilder(column: $table.word, builder: (column) => column);

  GeneratedColumn<String> get reading =>
      $composableBuilder(column: $table.reading, builder: (column) => column);

  GeneratedColumn<String> get meaning =>
      $composableBuilder(column: $table.meaning, builder: (column) => column);

  GeneratedColumn<String> get jlptLevel =>
      $composableBuilder(column: $table.jlptLevel, builder: (column) => column);

  GeneratedColumn<String> get partOfSpeech => $composableBuilder(
    column: $table.partOfSpeech,
    builder: (column) => column,
  );

  $$KanjisTableAnnotationComposer get kanjiId {
    final $$KanjisTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kanjiId,
      referencedTable: $db.kanjis,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KanjisTableAnnotationComposer(
            $db: $db,
            $table: $db.kanjis,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> vocabTranslationsRefs<T extends Object>(
    Expression<T> Function($$VocabTranslationsTableAnnotationComposer a) f,
  ) {
    final $$VocabTranslationsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.vocabTranslations,
          getReferencedColumn: (t) => t.vocabId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$VocabTranslationsTableAnnotationComposer(
                $db: $db,
                $table: $db.vocabTranslations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$VocabularyEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VocabularyEntriesTable,
          VocabularyEntry,
          $$VocabularyEntriesTableFilterComposer,
          $$VocabularyEntriesTableOrderingComposer,
          $$VocabularyEntriesTableAnnotationComposer,
          $$VocabularyEntriesTableCreateCompanionBuilder,
          $$VocabularyEntriesTableUpdateCompanionBuilder,
          (VocabularyEntry, $$VocabularyEntriesTableReferences),
          VocabularyEntry,
          PrefetchHooks Function({bool kanjiId, bool vocabTranslationsRefs})
        > {
  $$VocabularyEntriesTableTableManager(
    _$AppDatabase db,
    $VocabularyEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VocabularyEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VocabularyEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VocabularyEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> word = const Value.absent(),
                Value<String> reading = const Value.absent(),
                Value<String> meaning = const Value.absent(),
                Value<String> jlptLevel = const Value.absent(),
                Value<String> partOfSpeech = const Value.absent(),
                Value<int?> kanjiId = const Value.absent(),
              }) => VocabularyEntriesCompanion(
                id: id,
                word: word,
                reading: reading,
                meaning: meaning,
                jlptLevel: jlptLevel,
                partOfSpeech: partOfSpeech,
                kanjiId: kanjiId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String word,
                required String reading,
                required String meaning,
                required String jlptLevel,
                required String partOfSpeech,
                Value<int?> kanjiId = const Value.absent(),
              }) => VocabularyEntriesCompanion.insert(
                id: id,
                word: word,
                reading: reading,
                meaning: meaning,
                jlptLevel: jlptLevel,
                partOfSpeech: partOfSpeech,
                kanjiId: kanjiId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$VocabularyEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({kanjiId = false, vocabTranslationsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (vocabTranslationsRefs) db.vocabTranslations,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (kanjiId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.kanjiId,
                                    referencedTable:
                                        $$VocabularyEntriesTableReferences
                                            ._kanjiIdTable(db),
                                    referencedColumn:
                                        $$VocabularyEntriesTableReferences
                                            ._kanjiIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (vocabTranslationsRefs)
                        await $_getPrefetchedData<
                          VocabularyEntry,
                          $VocabularyEntriesTable,
                          VocabTranslation
                        >(
                          currentTable: table,
                          referencedTable: $$VocabularyEntriesTableReferences
                              ._vocabTranslationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$VocabularyEntriesTableReferences(
                                db,
                                table,
                                p0,
                              ).vocabTranslationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.vocabId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$VocabularyEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VocabularyEntriesTable,
      VocabularyEntry,
      $$VocabularyEntriesTableFilterComposer,
      $$VocabularyEntriesTableOrderingComposer,
      $$VocabularyEntriesTableAnnotationComposer,
      $$VocabularyEntriesTableCreateCompanionBuilder,
      $$VocabularyEntriesTableUpdateCompanionBuilder,
      (VocabularyEntry, $$VocabularyEntriesTableReferences),
      VocabularyEntry,
      PrefetchHooks Function({bool kanjiId, bool vocabTranslationsRefs})
    >;
typedef $$GrammarLessonsTableCreateCompanionBuilder =
    GrammarLessonsCompanion Function({
      Value<int> id,
      required String locale,
      required String chapter,
      required String title,
      required String contentMd,
      required int orderIndex,
      Value<String> metadata,
    });
typedef $$GrammarLessonsTableUpdateCompanionBuilder =
    GrammarLessonsCompanion Function({
      Value<int> id,
      Value<String> locale,
      Value<String> chapter,
      Value<String> title,
      Value<String> contentMd,
      Value<int> orderIndex,
      Value<String> metadata,
    });

final class $$GrammarLessonsTableReferences
    extends BaseReferences<_$AppDatabase, $GrammarLessonsTable, GrammarLesson> {
  $$GrammarLessonsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$ExercisesTable, List<Exercise>>
  _exercisesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.exercises,
    aliasName: $_aliasNameGenerator(
      db.grammarLessons.id,
      db.exercises.lessonId,
    ),
  );

  $$ExercisesTableProcessedTableManager get exercisesRefs {
    final manager = $$ExercisesTableTableManager(
      $_db,
      $_db.exercises,
    ).filter((f) => f.lessonId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_exercisesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$GrammarLessonsTableFilterComposer
    extends Composer<_$AppDatabase, $GrammarLessonsTable> {
  $$GrammarLessonsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get locale => $composableBuilder(
    column: $table.locale,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get chapter => $composableBuilder(
    column: $table.chapter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contentMd => $composableBuilder(
    column: $table.contentMd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metadata => $composableBuilder(
    column: $table.metadata,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> exercisesRefs(
    Expression<bool> Function($$ExercisesTableFilterComposer f) f,
  ) {
    final $$ExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.lessonId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableFilterComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GrammarLessonsTableOrderingComposer
    extends Composer<_$AppDatabase, $GrammarLessonsTable> {
  $$GrammarLessonsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get locale => $composableBuilder(
    column: $table.locale,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get chapter => $composableBuilder(
    column: $table.chapter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contentMd => $composableBuilder(
    column: $table.contentMd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metadata => $composableBuilder(
    column: $table.metadata,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GrammarLessonsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GrammarLessonsTable> {
  $$GrammarLessonsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get locale =>
      $composableBuilder(column: $table.locale, builder: (column) => column);

  GeneratedColumn<String> get chapter =>
      $composableBuilder(column: $table.chapter, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get contentMd =>
      $composableBuilder(column: $table.contentMd, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );

  GeneratedColumn<String> get metadata =>
      $composableBuilder(column: $table.metadata, builder: (column) => column);

  Expression<T> exercisesRefs<T extends Object>(
    Expression<T> Function($$ExercisesTableAnnotationComposer a) f,
  ) {
    final $$ExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.lessonId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GrammarLessonsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GrammarLessonsTable,
          GrammarLesson,
          $$GrammarLessonsTableFilterComposer,
          $$GrammarLessonsTableOrderingComposer,
          $$GrammarLessonsTableAnnotationComposer,
          $$GrammarLessonsTableCreateCompanionBuilder,
          $$GrammarLessonsTableUpdateCompanionBuilder,
          (GrammarLesson, $$GrammarLessonsTableReferences),
          GrammarLesson,
          PrefetchHooks Function({bool exercisesRefs})
        > {
  $$GrammarLessonsTableTableManager(
    _$AppDatabase db,
    $GrammarLessonsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GrammarLessonsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GrammarLessonsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GrammarLessonsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> locale = const Value.absent(),
                Value<String> chapter = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> contentMd = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<String> metadata = const Value.absent(),
              }) => GrammarLessonsCompanion(
                id: id,
                locale: locale,
                chapter: chapter,
                title: title,
                contentMd: contentMd,
                orderIndex: orderIndex,
                metadata: metadata,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String locale,
                required String chapter,
                required String title,
                required String contentMd,
                required int orderIndex,
                Value<String> metadata = const Value.absent(),
              }) => GrammarLessonsCompanion.insert(
                id: id,
                locale: locale,
                chapter: chapter,
                title: title,
                contentMd: contentMd,
                orderIndex: orderIndex,
                metadata: metadata,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$GrammarLessonsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({exercisesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (exercisesRefs) db.exercises],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (exercisesRefs)
                    await $_getPrefetchedData<
                      GrammarLesson,
                      $GrammarLessonsTable,
                      Exercise
                    >(
                      currentTable: table,
                      referencedTable: $$GrammarLessonsTableReferences
                          ._exercisesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$GrammarLessonsTableReferences(
                            db,
                            table,
                            p0,
                          ).exercisesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.lessonId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$GrammarLessonsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GrammarLessonsTable,
      GrammarLesson,
      $$GrammarLessonsTableFilterComposer,
      $$GrammarLessonsTableOrderingComposer,
      $$GrammarLessonsTableAnnotationComposer,
      $$GrammarLessonsTableCreateCompanionBuilder,
      $$GrammarLessonsTableUpdateCompanionBuilder,
      (GrammarLesson, $$GrammarLessonsTableReferences),
      GrammarLesson,
      PrefetchHooks Function({bool exercisesRefs})
    >;
typedef $$ExercisesTableCreateCompanionBuilder =
    ExercisesCompanion Function({
      Value<int> id,
      required String locale,
      required String type,
      required String source,
      required int sourceId,
      required String prompt,
      required String answer,
      Value<String> distractors,
      Value<int?> lessonId,
    });
typedef $$ExercisesTableUpdateCompanionBuilder =
    ExercisesCompanion Function({
      Value<int> id,
      Value<String> locale,
      Value<String> type,
      Value<String> source,
      Value<int> sourceId,
      Value<String> prompt,
      Value<String> answer,
      Value<String> distractors,
      Value<int?> lessonId,
    });

final class $$ExercisesTableReferences
    extends BaseReferences<_$AppDatabase, $ExercisesTable, Exercise> {
  $$ExercisesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GrammarLessonsTable _lessonIdTable(_$AppDatabase db) =>
      db.grammarLessons.createAlias(
        $_aliasNameGenerator(db.exercises.lessonId, db.grammarLessons.id),
      );

  $$GrammarLessonsTableProcessedTableManager? get lessonId {
    final $_column = $_itemColumn<int>('lesson_id');
    if ($_column == null) return null;
    final manager = $$GrammarLessonsTableTableManager(
      $_db,
      $_db.grammarLessons,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_lessonIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get locale => $composableBuilder(
    column: $table.locale,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get prompt => $composableBuilder(
    column: $table.prompt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get answer => $composableBuilder(
    column: $table.answer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get distractors => $composableBuilder(
    column: $table.distractors,
    builder: (column) => ColumnFilters(column),
  );

  $$GrammarLessonsTableFilterComposer get lessonId {
    final $$GrammarLessonsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lessonId,
      referencedTable: $db.grammarLessons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GrammarLessonsTableFilterComposer(
            $db: $db,
            $table: $db.grammarLessons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get locale => $composableBuilder(
    column: $table.locale,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get prompt => $composableBuilder(
    column: $table.prompt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get answer => $composableBuilder(
    column: $table.answer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get distractors => $composableBuilder(
    column: $table.distractors,
    builder: (column) => ColumnOrderings(column),
  );

  $$GrammarLessonsTableOrderingComposer get lessonId {
    final $$GrammarLessonsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lessonId,
      referencedTable: $db.grammarLessons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GrammarLessonsTableOrderingComposer(
            $db: $db,
            $table: $db.grammarLessons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get locale =>
      $composableBuilder(column: $table.locale, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<int> get sourceId =>
      $composableBuilder(column: $table.sourceId, builder: (column) => column);

  GeneratedColumn<String> get prompt =>
      $composableBuilder(column: $table.prompt, builder: (column) => column);

  GeneratedColumn<String> get answer =>
      $composableBuilder(column: $table.answer, builder: (column) => column);

  GeneratedColumn<String> get distractors => $composableBuilder(
    column: $table.distractors,
    builder: (column) => column,
  );

  $$GrammarLessonsTableAnnotationComposer get lessonId {
    final $$GrammarLessonsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lessonId,
      referencedTable: $db.grammarLessons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GrammarLessonsTableAnnotationComposer(
            $db: $db,
            $table: $db.grammarLessons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExercisesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExercisesTable,
          Exercise,
          $$ExercisesTableFilterComposer,
          $$ExercisesTableOrderingComposer,
          $$ExercisesTableAnnotationComposer,
          $$ExercisesTableCreateCompanionBuilder,
          $$ExercisesTableUpdateCompanionBuilder,
          (Exercise, $$ExercisesTableReferences),
          Exercise,
          PrefetchHooks Function({bool lessonId})
        > {
  $$ExercisesTableTableManager(_$AppDatabase db, $ExercisesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExercisesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> locale = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<int> sourceId = const Value.absent(),
                Value<String> prompt = const Value.absent(),
                Value<String> answer = const Value.absent(),
                Value<String> distractors = const Value.absent(),
                Value<int?> lessonId = const Value.absent(),
              }) => ExercisesCompanion(
                id: id,
                locale: locale,
                type: type,
                source: source,
                sourceId: sourceId,
                prompt: prompt,
                answer: answer,
                distractors: distractors,
                lessonId: lessonId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String locale,
                required String type,
                required String source,
                required int sourceId,
                required String prompt,
                required String answer,
                Value<String> distractors = const Value.absent(),
                Value<int?> lessonId = const Value.absent(),
              }) => ExercisesCompanion.insert(
                id: id,
                locale: locale,
                type: type,
                source: source,
                sourceId: sourceId,
                prompt: prompt,
                answer: answer,
                distractors: distractors,
                lessonId: lessonId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ExercisesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({lessonId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (lessonId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.lessonId,
                                referencedTable: $$ExercisesTableReferences
                                    ._lessonIdTable(db),
                                referencedColumn: $$ExercisesTableReferences
                                    ._lessonIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ExercisesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExercisesTable,
      Exercise,
      $$ExercisesTableFilterComposer,
      $$ExercisesTableOrderingComposer,
      $$ExercisesTableAnnotationComposer,
      $$ExercisesTableCreateCompanionBuilder,
      $$ExercisesTableUpdateCompanionBuilder,
      (Exercise, $$ExercisesTableReferences),
      Exercise,
      PrefetchHooks Function({bool lessonId})
    >;
typedef $$ProgressEntriesTableCreateCompanionBuilder =
    ProgressEntriesCompanion Function({
      Value<int> id,
      required String itemType,
      required int itemId,
      required bool isKnown,
      required DateTime toggledAt,
    });
typedef $$ProgressEntriesTableUpdateCompanionBuilder =
    ProgressEntriesCompanion Function({
      Value<int> id,
      Value<String> itemType,
      Value<int> itemId,
      Value<bool> isKnown,
      Value<DateTime> toggledAt,
    });

class $$ProgressEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $ProgressEntriesTable> {
  $$ProgressEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get itemType => $composableBuilder(
    column: $table.itemType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isKnown => $composableBuilder(
    column: $table.isKnown,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get toggledAt => $composableBuilder(
    column: $table.toggledAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProgressEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProgressEntriesTable> {
  $$ProgressEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get itemType => $composableBuilder(
    column: $table.itemType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isKnown => $composableBuilder(
    column: $table.isKnown,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get toggledAt => $composableBuilder(
    column: $table.toggledAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProgressEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProgressEntriesTable> {
  $$ProgressEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get itemType =>
      $composableBuilder(column: $table.itemType, builder: (column) => column);

  GeneratedColumn<int> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => column);

  GeneratedColumn<bool> get isKnown =>
      $composableBuilder(column: $table.isKnown, builder: (column) => column);

  GeneratedColumn<DateTime> get toggledAt =>
      $composableBuilder(column: $table.toggledAt, builder: (column) => column);
}

class $$ProgressEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProgressEntriesTable,
          ProgressEntry,
          $$ProgressEntriesTableFilterComposer,
          $$ProgressEntriesTableOrderingComposer,
          $$ProgressEntriesTableAnnotationComposer,
          $$ProgressEntriesTableCreateCompanionBuilder,
          $$ProgressEntriesTableUpdateCompanionBuilder,
          (
            ProgressEntry,
            BaseReferences<_$AppDatabase, $ProgressEntriesTable, ProgressEntry>,
          ),
          ProgressEntry,
          PrefetchHooks Function()
        > {
  $$ProgressEntriesTableTableManager(
    _$AppDatabase db,
    $ProgressEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProgressEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProgressEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProgressEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> itemType = const Value.absent(),
                Value<int> itemId = const Value.absent(),
                Value<bool> isKnown = const Value.absent(),
                Value<DateTime> toggledAt = const Value.absent(),
              }) => ProgressEntriesCompanion(
                id: id,
                itemType: itemType,
                itemId: itemId,
                isKnown: isKnown,
                toggledAt: toggledAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String itemType,
                required int itemId,
                required bool isKnown,
                required DateTime toggledAt,
              }) => ProgressEntriesCompanion.insert(
                id: id,
                itemType: itemType,
                itemId: itemId,
                isKnown: isKnown,
                toggledAt: toggledAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProgressEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProgressEntriesTable,
      ProgressEntry,
      $$ProgressEntriesTableFilterComposer,
      $$ProgressEntriesTableOrderingComposer,
      $$ProgressEntriesTableAnnotationComposer,
      $$ProgressEntriesTableCreateCompanionBuilder,
      $$ProgressEntriesTableUpdateCompanionBuilder,
      (
        ProgressEntry,
        BaseReferences<_$AppDatabase, $ProgressEntriesTable, ProgressEntry>,
      ),
      ProgressEntry,
      PrefetchHooks Function()
    >;
typedef $$KanjiTranslationsTableCreateCompanionBuilder =
    KanjiTranslationsCompanion Function({
      required int kanjiId,
      required String locale,
      required String meaning,
      Value<int> rowid,
    });
typedef $$KanjiTranslationsTableUpdateCompanionBuilder =
    KanjiTranslationsCompanion Function({
      Value<int> kanjiId,
      Value<String> locale,
      Value<String> meaning,
      Value<int> rowid,
    });

final class $$KanjiTranslationsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $KanjiTranslationsTable,
          KanjiTranslation
        > {
  $$KanjiTranslationsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $KanjisTable _kanjiIdTable(_$AppDatabase db) => db.kanjis.createAlias(
    $_aliasNameGenerator(db.kanjiTranslations.kanjiId, db.kanjis.id),
  );

  $$KanjisTableProcessedTableManager get kanjiId {
    final $_column = $_itemColumn<int>('kanji_id')!;

    final manager = $$KanjisTableTableManager(
      $_db,
      $_db.kanjis,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_kanjiIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$KanjiTranslationsTableFilterComposer
    extends Composer<_$AppDatabase, $KanjiTranslationsTable> {
  $$KanjiTranslationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get locale => $composableBuilder(
    column: $table.locale,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get meaning => $composableBuilder(
    column: $table.meaning,
    builder: (column) => ColumnFilters(column),
  );

  $$KanjisTableFilterComposer get kanjiId {
    final $$KanjisTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kanjiId,
      referencedTable: $db.kanjis,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KanjisTableFilterComposer(
            $db: $db,
            $table: $db.kanjis,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$KanjiTranslationsTableOrderingComposer
    extends Composer<_$AppDatabase, $KanjiTranslationsTable> {
  $$KanjiTranslationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get locale => $composableBuilder(
    column: $table.locale,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get meaning => $composableBuilder(
    column: $table.meaning,
    builder: (column) => ColumnOrderings(column),
  );

  $$KanjisTableOrderingComposer get kanjiId {
    final $$KanjisTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kanjiId,
      referencedTable: $db.kanjis,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KanjisTableOrderingComposer(
            $db: $db,
            $table: $db.kanjis,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$KanjiTranslationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $KanjiTranslationsTable> {
  $$KanjiTranslationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get locale =>
      $composableBuilder(column: $table.locale, builder: (column) => column);

  GeneratedColumn<String> get meaning =>
      $composableBuilder(column: $table.meaning, builder: (column) => column);

  $$KanjisTableAnnotationComposer get kanjiId {
    final $$KanjisTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kanjiId,
      referencedTable: $db.kanjis,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KanjisTableAnnotationComposer(
            $db: $db,
            $table: $db.kanjis,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$KanjiTranslationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $KanjiTranslationsTable,
          KanjiTranslation,
          $$KanjiTranslationsTableFilterComposer,
          $$KanjiTranslationsTableOrderingComposer,
          $$KanjiTranslationsTableAnnotationComposer,
          $$KanjiTranslationsTableCreateCompanionBuilder,
          $$KanjiTranslationsTableUpdateCompanionBuilder,
          (KanjiTranslation, $$KanjiTranslationsTableReferences),
          KanjiTranslation,
          PrefetchHooks Function({bool kanjiId})
        > {
  $$KanjiTranslationsTableTableManager(
    _$AppDatabase db,
    $KanjiTranslationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KanjiTranslationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KanjiTranslationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KanjiTranslationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> kanjiId = const Value.absent(),
                Value<String> locale = const Value.absent(),
                Value<String> meaning = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => KanjiTranslationsCompanion(
                kanjiId: kanjiId,
                locale: locale,
                meaning: meaning,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int kanjiId,
                required String locale,
                required String meaning,
                Value<int> rowid = const Value.absent(),
              }) => KanjiTranslationsCompanion.insert(
                kanjiId: kanjiId,
                locale: locale,
                meaning: meaning,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$KanjiTranslationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({kanjiId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (kanjiId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.kanjiId,
                                referencedTable:
                                    $$KanjiTranslationsTableReferences
                                        ._kanjiIdTable(db),
                                referencedColumn:
                                    $$KanjiTranslationsTableReferences
                                        ._kanjiIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$KanjiTranslationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $KanjiTranslationsTable,
      KanjiTranslation,
      $$KanjiTranslationsTableFilterComposer,
      $$KanjiTranslationsTableOrderingComposer,
      $$KanjiTranslationsTableAnnotationComposer,
      $$KanjiTranslationsTableCreateCompanionBuilder,
      $$KanjiTranslationsTableUpdateCompanionBuilder,
      (KanjiTranslation, $$KanjiTranslationsTableReferences),
      KanjiTranslation,
      PrefetchHooks Function({bool kanjiId})
    >;
typedef $$VocabTranslationsTableCreateCompanionBuilder =
    VocabTranslationsCompanion Function({
      required int vocabId,
      required String locale,
      required String meaning,
      Value<int> rowid,
    });
typedef $$VocabTranslationsTableUpdateCompanionBuilder =
    VocabTranslationsCompanion Function({
      Value<int> vocabId,
      Value<String> locale,
      Value<String> meaning,
      Value<int> rowid,
    });

final class $$VocabTranslationsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $VocabTranslationsTable,
          VocabTranslation
        > {
  $$VocabTranslationsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $VocabularyEntriesTable _vocabIdTable(_$AppDatabase db) =>
      db.vocabularyEntries.createAlias(
        $_aliasNameGenerator(
          db.vocabTranslations.vocabId,
          db.vocabularyEntries.id,
        ),
      );

  $$VocabularyEntriesTableProcessedTableManager get vocabId {
    final $_column = $_itemColumn<int>('vocab_id')!;

    final manager = $$VocabularyEntriesTableTableManager(
      $_db,
      $_db.vocabularyEntries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_vocabIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$VocabTranslationsTableFilterComposer
    extends Composer<_$AppDatabase, $VocabTranslationsTable> {
  $$VocabTranslationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get locale => $composableBuilder(
    column: $table.locale,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get meaning => $composableBuilder(
    column: $table.meaning,
    builder: (column) => ColumnFilters(column),
  );

  $$VocabularyEntriesTableFilterComposer get vocabId {
    final $$VocabularyEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vocabId,
      referencedTable: $db.vocabularyEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VocabularyEntriesTableFilterComposer(
            $db: $db,
            $table: $db.vocabularyEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VocabTranslationsTableOrderingComposer
    extends Composer<_$AppDatabase, $VocabTranslationsTable> {
  $$VocabTranslationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get locale => $composableBuilder(
    column: $table.locale,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get meaning => $composableBuilder(
    column: $table.meaning,
    builder: (column) => ColumnOrderings(column),
  );

  $$VocabularyEntriesTableOrderingComposer get vocabId {
    final $$VocabularyEntriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vocabId,
      referencedTable: $db.vocabularyEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VocabularyEntriesTableOrderingComposer(
            $db: $db,
            $table: $db.vocabularyEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VocabTranslationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $VocabTranslationsTable> {
  $$VocabTranslationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get locale =>
      $composableBuilder(column: $table.locale, builder: (column) => column);

  GeneratedColumn<String> get meaning =>
      $composableBuilder(column: $table.meaning, builder: (column) => column);

  $$VocabularyEntriesTableAnnotationComposer get vocabId {
    final $$VocabularyEntriesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.vocabId,
          referencedTable: $db.vocabularyEntries,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$VocabularyEntriesTableAnnotationComposer(
                $db: $db,
                $table: $db.vocabularyEntries,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$VocabTranslationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VocabTranslationsTable,
          VocabTranslation,
          $$VocabTranslationsTableFilterComposer,
          $$VocabTranslationsTableOrderingComposer,
          $$VocabTranslationsTableAnnotationComposer,
          $$VocabTranslationsTableCreateCompanionBuilder,
          $$VocabTranslationsTableUpdateCompanionBuilder,
          (VocabTranslation, $$VocabTranslationsTableReferences),
          VocabTranslation,
          PrefetchHooks Function({bool vocabId})
        > {
  $$VocabTranslationsTableTableManager(
    _$AppDatabase db,
    $VocabTranslationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VocabTranslationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VocabTranslationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VocabTranslationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> vocabId = const Value.absent(),
                Value<String> locale = const Value.absent(),
                Value<String> meaning = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VocabTranslationsCompanion(
                vocabId: vocabId,
                locale: locale,
                meaning: meaning,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int vocabId,
                required String locale,
                required String meaning,
                Value<int> rowid = const Value.absent(),
              }) => VocabTranslationsCompanion.insert(
                vocabId: vocabId,
                locale: locale,
                meaning: meaning,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$VocabTranslationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({vocabId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (vocabId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.vocabId,
                                referencedTable:
                                    $$VocabTranslationsTableReferences
                                        ._vocabIdTable(db),
                                referencedColumn:
                                    $$VocabTranslationsTableReferences
                                        ._vocabIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$VocabTranslationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VocabTranslationsTable,
      VocabTranslation,
      $$VocabTranslationsTableFilterComposer,
      $$VocabTranslationsTableOrderingComposer,
      $$VocabTranslationsTableAnnotationComposer,
      $$VocabTranslationsTableCreateCompanionBuilder,
      $$VocabTranslationsTableUpdateCompanionBuilder,
      (VocabTranslation, $$VocabTranslationsTableReferences),
      VocabTranslation,
      PrefetchHooks Function({bool vocabId})
    >;
typedef $$SrsCardsTableCreateCompanionBuilder =
    SrsCardsCompanion Function({
      required String itemType,
      required int itemId,
      required DateTime due,
      required String cardJson,
      Value<int> rowid,
    });
typedef $$SrsCardsTableUpdateCompanionBuilder =
    SrsCardsCompanion Function({
      Value<String> itemType,
      Value<int> itemId,
      Value<DateTime> due,
      Value<String> cardJson,
      Value<int> rowid,
    });

class $$SrsCardsTableFilterComposer
    extends Composer<_$AppDatabase, $SrsCardsTable> {
  $$SrsCardsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get itemType => $composableBuilder(
    column: $table.itemType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get due => $composableBuilder(
    column: $table.due,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cardJson => $composableBuilder(
    column: $table.cardJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SrsCardsTableOrderingComposer
    extends Composer<_$AppDatabase, $SrsCardsTable> {
  $$SrsCardsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get itemType => $composableBuilder(
    column: $table.itemType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get due => $composableBuilder(
    column: $table.due,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cardJson => $composableBuilder(
    column: $table.cardJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SrsCardsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SrsCardsTable> {
  $$SrsCardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get itemType =>
      $composableBuilder(column: $table.itemType, builder: (column) => column);

  GeneratedColumn<int> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => column);

  GeneratedColumn<DateTime> get due =>
      $composableBuilder(column: $table.due, builder: (column) => column);

  GeneratedColumn<String> get cardJson =>
      $composableBuilder(column: $table.cardJson, builder: (column) => column);
}

class $$SrsCardsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SrsCardsTable,
          SrsCard,
          $$SrsCardsTableFilterComposer,
          $$SrsCardsTableOrderingComposer,
          $$SrsCardsTableAnnotationComposer,
          $$SrsCardsTableCreateCompanionBuilder,
          $$SrsCardsTableUpdateCompanionBuilder,
          (SrsCard, BaseReferences<_$AppDatabase, $SrsCardsTable, SrsCard>),
          SrsCard,
          PrefetchHooks Function()
        > {
  $$SrsCardsTableTableManager(_$AppDatabase db, $SrsCardsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SrsCardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SrsCardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SrsCardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> itemType = const Value.absent(),
                Value<int> itemId = const Value.absent(),
                Value<DateTime> due = const Value.absent(),
                Value<String> cardJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SrsCardsCompanion(
                itemType: itemType,
                itemId: itemId,
                due: due,
                cardJson: cardJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String itemType,
                required int itemId,
                required DateTime due,
                required String cardJson,
                Value<int> rowid = const Value.absent(),
              }) => SrsCardsCompanion.insert(
                itemType: itemType,
                itemId: itemId,
                due: due,
                cardJson: cardJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SrsCardsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SrsCardsTable,
      SrsCard,
      $$SrsCardsTableFilterComposer,
      $$SrsCardsTableOrderingComposer,
      $$SrsCardsTableAnnotationComposer,
      $$SrsCardsTableCreateCompanionBuilder,
      $$SrsCardsTableUpdateCompanionBuilder,
      (SrsCard, BaseReferences<_$AppDatabase, $SrsCardsTable, SrsCard>),
      SrsCard,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$KanjisTableTableManager get kanjis =>
      $$KanjisTableTableManager(_db, _db.kanjis);
  $$KanasTableTableManager get kanas =>
      $$KanasTableTableManager(_db, _db.kanas);
  $$VocabularyEntriesTableTableManager get vocabularyEntries =>
      $$VocabularyEntriesTableTableManager(_db, _db.vocabularyEntries);
  $$GrammarLessonsTableTableManager get grammarLessons =>
      $$GrammarLessonsTableTableManager(_db, _db.grammarLessons);
  $$ExercisesTableTableManager get exercises =>
      $$ExercisesTableTableManager(_db, _db.exercises);
  $$ProgressEntriesTableTableManager get progressEntries =>
      $$ProgressEntriesTableTableManager(_db, _db.progressEntries);
  $$KanjiTranslationsTableTableManager get kanjiTranslations =>
      $$KanjiTranslationsTableTableManager(_db, _db.kanjiTranslations);
  $$VocabTranslationsTableTableManager get vocabTranslations =>
      $$VocabTranslationsTableTableManager(_db, _db.vocabTranslations);
  $$SrsCardsTableTableManager get srsCards =>
      $$SrsCardsTableTableManager(_db, _db.srsCards);
}
