// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class Kanjis extends Table with TableInfo<Kanjis, Kanji> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Kanjis(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT',
  );
  static const VerificationMeta _characterMeta = const VerificationMeta(
    'character',
  );
  late final GeneratedColumn<String> character = GeneratedColumn<String>(
    'character',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _meaningMeta = const VerificationMeta(
    'meaning',
  );
  late final GeneratedColumn<String> meaning = GeneratedColumn<String>(
    'meaning',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _onReadingMeta = const VerificationMeta(
    'onReading',
  );
  late final GeneratedColumn<String> onReading = GeneratedColumn<String>(
    'on_reading',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _kunReadingMeta = const VerificationMeta(
    'kunReading',
  );
  late final GeneratedColumn<String> kunReading = GeneratedColumn<String>(
    'kun_reading',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _jlptLevelMeta = const VerificationMeta(
    'jlptLevel',
  );
  late final GeneratedColumn<String> jlptLevel = GeneratedColumn<String>(
    'jlpt_level',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _svgMeta = const VerificationMeta('svg');
  late final GeneratedColumn<String> svg = GeneratedColumn<String>(
    'svg',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    character,
    meaning,
    onReading,
    kunReading,
    jlptLevel,
    svg,
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
    if (data.containsKey('svg')) {
      context.handle(
        _svgMeta,
        svg.isAcceptableOrUnknown(data['svg']!, _svgMeta),
      );
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
      svg: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}svg'],
      ),
    );
  }

  @override
  Kanjis createAlias(String alias) {
    return Kanjis(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class Kanji extends DataClass implements Insertable<Kanji> {
  final int id;
  final String character;
  final String meaning;
  final String onReading;
  final String kunReading;
  final String jlptLevel;
  final String? svg;
  const Kanji({
    required this.id,
    required this.character,
    required this.meaning,
    required this.onReading,
    required this.kunReading,
    required this.jlptLevel,
    this.svg,
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
    if (!nullToAbsent || svg != null) {
      map['svg'] = Variable<String>(svg);
    }
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
      svg: svg == null && nullToAbsent ? const Value.absent() : Value(svg),
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
      onReading: serializer.fromJson<String>(json['on_reading']),
      kunReading: serializer.fromJson<String>(json['kun_reading']),
      jlptLevel: serializer.fromJson<String>(json['jlpt_level']),
      svg: serializer.fromJson<String?>(json['svg']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'character': serializer.toJson<String>(character),
      'meaning': serializer.toJson<String>(meaning),
      'on_reading': serializer.toJson<String>(onReading),
      'kun_reading': serializer.toJson<String>(kunReading),
      'jlpt_level': serializer.toJson<String>(jlptLevel),
      'svg': serializer.toJson<String?>(svg),
    };
  }

  Kanji copyWith({
    int? id,
    String? character,
    String? meaning,
    String? onReading,
    String? kunReading,
    String? jlptLevel,
    Value<String?> svg = const Value.absent(),
  }) => Kanji(
    id: id ?? this.id,
    character: character ?? this.character,
    meaning: meaning ?? this.meaning,
    onReading: onReading ?? this.onReading,
    kunReading: kunReading ?? this.kunReading,
    jlptLevel: jlptLevel ?? this.jlptLevel,
    svg: svg.present ? svg.value : this.svg,
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
      svg: data.svg.present ? data.svg.value : this.svg,
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
          ..write('jlptLevel: $jlptLevel, ')
          ..write('svg: $svg')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    character,
    meaning,
    onReading,
    kunReading,
    jlptLevel,
    svg,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Kanji &&
          other.id == this.id &&
          other.character == this.character &&
          other.meaning == this.meaning &&
          other.onReading == this.onReading &&
          other.kunReading == this.kunReading &&
          other.jlptLevel == this.jlptLevel &&
          other.svg == this.svg);
}

class KanjisCompanion extends UpdateCompanion<Kanji> {
  final Value<int> id;
  final Value<String> character;
  final Value<String> meaning;
  final Value<String> onReading;
  final Value<String> kunReading;
  final Value<String> jlptLevel;
  final Value<String?> svg;
  const KanjisCompanion({
    this.id = const Value.absent(),
    this.character = const Value.absent(),
    this.meaning = const Value.absent(),
    this.onReading = const Value.absent(),
    this.kunReading = const Value.absent(),
    this.jlptLevel = const Value.absent(),
    this.svg = const Value.absent(),
  });
  KanjisCompanion.insert({
    this.id = const Value.absent(),
    required String character,
    required String meaning,
    required String onReading,
    required String kunReading,
    required String jlptLevel,
    this.svg = const Value.absent(),
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
    Expression<String>? svg,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (character != null) 'character': character,
      if (meaning != null) 'meaning': meaning,
      if (onReading != null) 'on_reading': onReading,
      if (kunReading != null) 'kun_reading': kunReading,
      if (jlptLevel != null) 'jlpt_level': jlptLevel,
      if (svg != null) 'svg': svg,
    });
  }

  KanjisCompanion copyWith({
    Value<int>? id,
    Value<String>? character,
    Value<String>? meaning,
    Value<String>? onReading,
    Value<String>? kunReading,
    Value<String>? jlptLevel,
    Value<String?>? svg,
  }) {
    return KanjisCompanion(
      id: id ?? this.id,
      character: character ?? this.character,
      meaning: meaning ?? this.meaning,
      onReading: onReading ?? this.onReading,
      kunReading: kunReading ?? this.kunReading,
      jlptLevel: jlptLevel ?? this.jlptLevel,
      svg: svg ?? this.svg,
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
    if (svg.present) {
      map['svg'] = Variable<String>(svg.value);
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
          ..write('jlptLevel: $jlptLevel, ')
          ..write('svg: $svg')
          ..write(')'))
        .toString();
  }
}

class Kanas extends Table with TableInfo<Kanas, Kana> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Kanas(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT',
  );
  static const VerificationMeta _characterMeta = const VerificationMeta(
    'character',
  );
  late final GeneratedColumn<String> character = GeneratedColumn<String>(
    'character',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _romajiMeta = const VerificationMeta('romaji');
  late final GeneratedColumn<String> romaji = GeneratedColumn<String>(
    'romaji',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _rowMeta = const VerificationMeta('row');
  late final GeneratedColumn<String> row = GeneratedColumn<String>(
    'row',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _kanaGroupMeta = const VerificationMeta(
    'kanaGroup',
  );
  late final GeneratedColumn<String> kanaGroup = GeneratedColumn<String>(
    'kana_group',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _slotMeta = const VerificationMeta('slot');
  late final GeneratedColumn<int> slot = GeneratedColumn<int>(
    'slot',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
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
  Kanas createAlias(String alias) {
    return Kanas(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
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
      kanaGroup: serializer.fromJson<String>(json['kana_group']),
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
      'kana_group': serializer.toJson<String>(kanaGroup),
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

class VocabularyEntries extends Table
    with TableInfo<VocabularyEntries, VocabularyEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  VocabularyEntries(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT',
  );
  static const VerificationMeta _wordMeta = const VerificationMeta('word');
  late final GeneratedColumn<String> word = GeneratedColumn<String>(
    'word',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _readingMeta = const VerificationMeta(
    'reading',
  );
  late final GeneratedColumn<String> reading = GeneratedColumn<String>(
    'reading',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _meaningMeta = const VerificationMeta(
    'meaning',
  );
  late final GeneratedColumn<String> meaning = GeneratedColumn<String>(
    'meaning',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _jlptLevelMeta = const VerificationMeta(
    'jlptLevel',
  );
  late final GeneratedColumn<String> jlptLevel = GeneratedColumn<String>(
    'jlpt_level',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _partOfSpeechMeta = const VerificationMeta(
    'partOfSpeech',
  );
  late final GeneratedColumn<String> partOfSpeech = GeneratedColumn<String>(
    'part_of_speech',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _kanjiIdMeta = const VerificationMeta(
    'kanjiId',
  );
  late final GeneratedColumn<int> kanjiId = GeneratedColumn<int>(
    'kanji_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'REFERENCES kanjis(id)',
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
  VocabularyEntries createAlias(String alias) {
    return VocabularyEntries(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
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
      jlptLevel: serializer.fromJson<String>(json['jlpt_level']),
      partOfSpeech: serializer.fromJson<String>(json['part_of_speech']),
      kanjiId: serializer.fromJson<int?>(json['kanji_id']),
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
      'jlpt_level': serializer.toJson<String>(jlptLevel),
      'part_of_speech': serializer.toJson<String>(partOfSpeech),
      'kanji_id': serializer.toJson<int?>(kanjiId),
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

class KanjiTranslations extends Table
    with TableInfo<KanjiTranslations, KanjiTranslation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  KanjiTranslations(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _kanjiIdMeta = const VerificationMeta(
    'kanjiId',
  );
  late final GeneratedColumn<int> kanjiId = GeneratedColumn<int>(
    'kanji_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES kanjis(id)',
  );
  static const VerificationMeta _localeMeta = const VerificationMeta('locale');
  late final GeneratedColumn<String> locale = GeneratedColumn<String>(
    'locale',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _meaningMeta = const VerificationMeta(
    'meaning',
  );
  late final GeneratedColumn<String> meaning = GeneratedColumn<String>(
    'meaning',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
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
  KanjiTranslations createAlias(String alias) {
    return KanjiTranslations(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const ['PRIMARY KEY(kanji_id, locale)'];
  @override
  bool get dontWriteConstraints => true;
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
      kanjiId: serializer.fromJson<int>(json['kanji_id']),
      locale: serializer.fromJson<String>(json['locale']),
      meaning: serializer.fromJson<String>(json['meaning']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'kanji_id': serializer.toJson<int>(kanjiId),
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

class VocabularyTranslations extends Table
    with TableInfo<VocabularyTranslations, VocabularyTranslation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  VocabularyTranslations(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _vocabularyIdMeta = const VerificationMeta(
    'vocabularyId',
  );
  late final GeneratedColumn<int> vocabularyId = GeneratedColumn<int>(
    'vocabulary_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES vocabulary_entries(id)',
  );
  static const VerificationMeta _localeMeta = const VerificationMeta('locale');
  late final GeneratedColumn<String> locale = GeneratedColumn<String>(
    'locale',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _meaningMeta = const VerificationMeta(
    'meaning',
  );
  late final GeneratedColumn<String> meaning = GeneratedColumn<String>(
    'meaning',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  @override
  List<GeneratedColumn> get $columns => [vocabularyId, locale, meaning];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vocabulary_translations';
  @override
  VerificationContext validateIntegrity(
    Insertable<VocabularyTranslation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('vocabulary_id')) {
      context.handle(
        _vocabularyIdMeta,
        vocabularyId.isAcceptableOrUnknown(
          data['vocabulary_id']!,
          _vocabularyIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_vocabularyIdMeta);
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
  Set<GeneratedColumn> get $primaryKey => {vocabularyId, locale};
  @override
  VocabularyTranslation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VocabularyTranslation(
      vocabularyId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}vocabulary_id'],
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
  VocabularyTranslations createAlias(String alias) {
    return VocabularyTranslations(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
    'PRIMARY KEY(vocabulary_id, locale)',
  ];
  @override
  bool get dontWriteConstraints => true;
}

class VocabularyTranslation extends DataClass
    implements Insertable<VocabularyTranslation> {
  final int vocabularyId;
  final String locale;
  final String meaning;
  const VocabularyTranslation({
    required this.vocabularyId,
    required this.locale,
    required this.meaning,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['vocabulary_id'] = Variable<int>(vocabularyId);
    map['locale'] = Variable<String>(locale);
    map['meaning'] = Variable<String>(meaning);
    return map;
  }

  VocabularyTranslationsCompanion toCompanion(bool nullToAbsent) {
    return VocabularyTranslationsCompanion(
      vocabularyId: Value(vocabularyId),
      locale: Value(locale),
      meaning: Value(meaning),
    );
  }

  factory VocabularyTranslation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VocabularyTranslation(
      vocabularyId: serializer.fromJson<int>(json['vocabulary_id']),
      locale: serializer.fromJson<String>(json['locale']),
      meaning: serializer.fromJson<String>(json['meaning']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'vocabulary_id': serializer.toJson<int>(vocabularyId),
      'locale': serializer.toJson<String>(locale),
      'meaning': serializer.toJson<String>(meaning),
    };
  }

  VocabularyTranslation copyWith({
    int? vocabularyId,
    String? locale,
    String? meaning,
  }) => VocabularyTranslation(
    vocabularyId: vocabularyId ?? this.vocabularyId,
    locale: locale ?? this.locale,
    meaning: meaning ?? this.meaning,
  );
  VocabularyTranslation copyWithCompanion(
    VocabularyTranslationsCompanion data,
  ) {
    return VocabularyTranslation(
      vocabularyId: data.vocabularyId.present
          ? data.vocabularyId.value
          : this.vocabularyId,
      locale: data.locale.present ? data.locale.value : this.locale,
      meaning: data.meaning.present ? data.meaning.value : this.meaning,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VocabularyTranslation(')
          ..write('vocabularyId: $vocabularyId, ')
          ..write('locale: $locale, ')
          ..write('meaning: $meaning')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(vocabularyId, locale, meaning);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VocabularyTranslation &&
          other.vocabularyId == this.vocabularyId &&
          other.locale == this.locale &&
          other.meaning == this.meaning);
}

class VocabularyTranslationsCompanion
    extends UpdateCompanion<VocabularyTranslation> {
  final Value<int> vocabularyId;
  final Value<String> locale;
  final Value<String> meaning;
  final Value<int> rowid;
  const VocabularyTranslationsCompanion({
    this.vocabularyId = const Value.absent(),
    this.locale = const Value.absent(),
    this.meaning = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VocabularyTranslationsCompanion.insert({
    required int vocabularyId,
    required String locale,
    required String meaning,
    this.rowid = const Value.absent(),
  }) : vocabularyId = Value(vocabularyId),
       locale = Value(locale),
       meaning = Value(meaning);
  static Insertable<VocabularyTranslation> custom({
    Expression<int>? vocabularyId,
    Expression<String>? locale,
    Expression<String>? meaning,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (vocabularyId != null) 'vocabulary_id': vocabularyId,
      if (locale != null) 'locale': locale,
      if (meaning != null) 'meaning': meaning,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VocabularyTranslationsCompanion copyWith({
    Value<int>? vocabularyId,
    Value<String>? locale,
    Value<String>? meaning,
    Value<int>? rowid,
  }) {
    return VocabularyTranslationsCompanion(
      vocabularyId: vocabularyId ?? this.vocabularyId,
      locale: locale ?? this.locale,
      meaning: meaning ?? this.meaning,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (vocabularyId.present) {
      map['vocabulary_id'] = Variable<int>(vocabularyId.value);
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
    return (StringBuffer('VocabularyTranslationsCompanion(')
          ..write('vocabularyId: $vocabularyId, ')
          ..write('locale: $locale, ')
          ..write('meaning: $meaning, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class Sentences extends Table with TableInfo<Sentences, Sentence> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Sentences(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT',
  );
  static const VerificationMeta _japaneseMeta = const VerificationMeta(
    'japanese',
  );
  late final GeneratedColumn<String> japanese = GeneratedColumn<String>(
    'japanese',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _targetWordMeta = const VerificationMeta(
    'targetWord',
  );
  late final GeneratedColumn<String> targetWord = GeneratedColumn<String>(
    'target_word',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _vocabularyIdMeta = const VerificationMeta(
    'vocabularyId',
  );
  late final GeneratedColumn<int> vocabularyId = GeneratedColumn<int>(
    'vocabulary_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES vocabulary_entries(id)',
  );
  static const VerificationMeta _furiganaBeforeMeta = const VerificationMeta(
    'furiganaBefore',
  );
  late final GeneratedColumn<String> furiganaBefore = GeneratedColumn<String>(
    'furigana_before',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _furiganaAfterMeta = const VerificationMeta(
    'furiganaAfter',
  );
  late final GeneratedColumn<String> furiganaAfter = GeneratedColumn<String>(
    'furigana_after',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _furiganaMeta = const VerificationMeta(
    'furigana',
  );
  late final GeneratedColumn<String> furigana = GeneratedColumn<String>(
    'furigana',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    japanese,
    targetWord,
    vocabularyId,
    furiganaBefore,
    furiganaAfter,
    furigana,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sentences';
  @override
  VerificationContext validateIntegrity(
    Insertable<Sentence> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('japanese')) {
      context.handle(
        _japaneseMeta,
        japanese.isAcceptableOrUnknown(data['japanese']!, _japaneseMeta),
      );
    } else if (isInserting) {
      context.missing(_japaneseMeta);
    }
    if (data.containsKey('target_word')) {
      context.handle(
        _targetWordMeta,
        targetWord.isAcceptableOrUnknown(data['target_word']!, _targetWordMeta),
      );
    } else if (isInserting) {
      context.missing(_targetWordMeta);
    }
    if (data.containsKey('vocabulary_id')) {
      context.handle(
        _vocabularyIdMeta,
        vocabularyId.isAcceptableOrUnknown(
          data['vocabulary_id']!,
          _vocabularyIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_vocabularyIdMeta);
    }
    if (data.containsKey('furigana_before')) {
      context.handle(
        _furiganaBeforeMeta,
        furiganaBefore.isAcceptableOrUnknown(
          data['furigana_before']!,
          _furiganaBeforeMeta,
        ),
      );
    }
    if (data.containsKey('furigana_after')) {
      context.handle(
        _furiganaAfterMeta,
        furiganaAfter.isAcceptableOrUnknown(
          data['furigana_after']!,
          _furiganaAfterMeta,
        ),
      );
    }
    if (data.containsKey('furigana')) {
      context.handle(
        _furiganaMeta,
        furigana.isAcceptableOrUnknown(data['furigana']!, _furiganaMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Sentence map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Sentence(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      japanese: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}japanese'],
      )!,
      targetWord: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_word'],
      )!,
      vocabularyId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}vocabulary_id'],
      )!,
      furiganaBefore: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}furigana_before'],
      ),
      furiganaAfter: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}furigana_after'],
      ),
      furigana: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}furigana'],
      ),
    );
  }

  @override
  Sentences createAlias(String alias) {
    return Sentences(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class Sentence extends DataClass implements Insertable<Sentence> {
  final int id;
  final String japanese;
  final String targetWord;
  final int vocabularyId;
  final String? furiganaBefore;
  final String? furiganaAfter;
  final String? furigana;
  const Sentence({
    required this.id,
    required this.japanese,
    required this.targetWord,
    required this.vocabularyId,
    this.furiganaBefore,
    this.furiganaAfter,
    this.furigana,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['japanese'] = Variable<String>(japanese);
    map['target_word'] = Variable<String>(targetWord);
    map['vocabulary_id'] = Variable<int>(vocabularyId);
    if (!nullToAbsent || furiganaBefore != null) {
      map['furigana_before'] = Variable<String>(furiganaBefore);
    }
    if (!nullToAbsent || furiganaAfter != null) {
      map['furigana_after'] = Variable<String>(furiganaAfter);
    }
    if (!nullToAbsent || furigana != null) {
      map['furigana'] = Variable<String>(furigana);
    }
    return map;
  }

  SentencesCompanion toCompanion(bool nullToAbsent) {
    return SentencesCompanion(
      id: Value(id),
      japanese: Value(japanese),
      targetWord: Value(targetWord),
      vocabularyId: Value(vocabularyId),
      furiganaBefore: furiganaBefore == null && nullToAbsent
          ? const Value.absent()
          : Value(furiganaBefore),
      furiganaAfter: furiganaAfter == null && nullToAbsent
          ? const Value.absent()
          : Value(furiganaAfter),
      furigana: furigana == null && nullToAbsent
          ? const Value.absent()
          : Value(furigana),
    );
  }

  factory Sentence.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Sentence(
      id: serializer.fromJson<int>(json['id']),
      japanese: serializer.fromJson<String>(json['japanese']),
      targetWord: serializer.fromJson<String>(json['target_word']),
      vocabularyId: serializer.fromJson<int>(json['vocabulary_id']),
      furiganaBefore: serializer.fromJson<String?>(json['furigana_before']),
      furiganaAfter: serializer.fromJson<String?>(json['furigana_after']),
      furigana: serializer.fromJson<String?>(json['furigana']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'japanese': serializer.toJson<String>(japanese),
      'target_word': serializer.toJson<String>(targetWord),
      'vocabulary_id': serializer.toJson<int>(vocabularyId),
      'furigana_before': serializer.toJson<String?>(furiganaBefore),
      'furigana_after': serializer.toJson<String?>(furiganaAfter),
      'furigana': serializer.toJson<String?>(furigana),
    };
  }

  Sentence copyWith({
    int? id,
    String? japanese,
    String? targetWord,
    int? vocabularyId,
    Value<String?> furiganaBefore = const Value.absent(),
    Value<String?> furiganaAfter = const Value.absent(),
    Value<String?> furigana = const Value.absent(),
  }) => Sentence(
    id: id ?? this.id,
    japanese: japanese ?? this.japanese,
    targetWord: targetWord ?? this.targetWord,
    vocabularyId: vocabularyId ?? this.vocabularyId,
    furiganaBefore: furiganaBefore.present
        ? furiganaBefore.value
        : this.furiganaBefore,
    furiganaAfter: furiganaAfter.present
        ? furiganaAfter.value
        : this.furiganaAfter,
    furigana: furigana.present ? furigana.value : this.furigana,
  );
  Sentence copyWithCompanion(SentencesCompanion data) {
    return Sentence(
      id: data.id.present ? data.id.value : this.id,
      japanese: data.japanese.present ? data.japanese.value : this.japanese,
      targetWord: data.targetWord.present
          ? data.targetWord.value
          : this.targetWord,
      vocabularyId: data.vocabularyId.present
          ? data.vocabularyId.value
          : this.vocabularyId,
      furiganaBefore: data.furiganaBefore.present
          ? data.furiganaBefore.value
          : this.furiganaBefore,
      furiganaAfter: data.furiganaAfter.present
          ? data.furiganaAfter.value
          : this.furiganaAfter,
      furigana: data.furigana.present ? data.furigana.value : this.furigana,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Sentence(')
          ..write('id: $id, ')
          ..write('japanese: $japanese, ')
          ..write('targetWord: $targetWord, ')
          ..write('vocabularyId: $vocabularyId, ')
          ..write('furiganaBefore: $furiganaBefore, ')
          ..write('furiganaAfter: $furiganaAfter, ')
          ..write('furigana: $furigana')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    japanese,
    targetWord,
    vocabularyId,
    furiganaBefore,
    furiganaAfter,
    furigana,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Sentence &&
          other.id == this.id &&
          other.japanese == this.japanese &&
          other.targetWord == this.targetWord &&
          other.vocabularyId == this.vocabularyId &&
          other.furiganaBefore == this.furiganaBefore &&
          other.furiganaAfter == this.furiganaAfter &&
          other.furigana == this.furigana);
}

class SentencesCompanion extends UpdateCompanion<Sentence> {
  final Value<int> id;
  final Value<String> japanese;
  final Value<String> targetWord;
  final Value<int> vocabularyId;
  final Value<String?> furiganaBefore;
  final Value<String?> furiganaAfter;
  final Value<String?> furigana;
  const SentencesCompanion({
    this.id = const Value.absent(),
    this.japanese = const Value.absent(),
    this.targetWord = const Value.absent(),
    this.vocabularyId = const Value.absent(),
    this.furiganaBefore = const Value.absent(),
    this.furiganaAfter = const Value.absent(),
    this.furigana = const Value.absent(),
  });
  SentencesCompanion.insert({
    this.id = const Value.absent(),
    required String japanese,
    required String targetWord,
    required int vocabularyId,
    this.furiganaBefore = const Value.absent(),
    this.furiganaAfter = const Value.absent(),
    this.furigana = const Value.absent(),
  }) : japanese = Value(japanese),
       targetWord = Value(targetWord),
       vocabularyId = Value(vocabularyId);
  static Insertable<Sentence> custom({
    Expression<int>? id,
    Expression<String>? japanese,
    Expression<String>? targetWord,
    Expression<int>? vocabularyId,
    Expression<String>? furiganaBefore,
    Expression<String>? furiganaAfter,
    Expression<String>? furigana,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (japanese != null) 'japanese': japanese,
      if (targetWord != null) 'target_word': targetWord,
      if (vocabularyId != null) 'vocabulary_id': vocabularyId,
      if (furiganaBefore != null) 'furigana_before': furiganaBefore,
      if (furiganaAfter != null) 'furigana_after': furiganaAfter,
      if (furigana != null) 'furigana': furigana,
    });
  }

  SentencesCompanion copyWith({
    Value<int>? id,
    Value<String>? japanese,
    Value<String>? targetWord,
    Value<int>? vocabularyId,
    Value<String?>? furiganaBefore,
    Value<String?>? furiganaAfter,
    Value<String?>? furigana,
  }) {
    return SentencesCompanion(
      id: id ?? this.id,
      japanese: japanese ?? this.japanese,
      targetWord: targetWord ?? this.targetWord,
      vocabularyId: vocabularyId ?? this.vocabularyId,
      furiganaBefore: furiganaBefore ?? this.furiganaBefore,
      furiganaAfter: furiganaAfter ?? this.furiganaAfter,
      furigana: furigana ?? this.furigana,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (japanese.present) {
      map['japanese'] = Variable<String>(japanese.value);
    }
    if (targetWord.present) {
      map['target_word'] = Variable<String>(targetWord.value);
    }
    if (vocabularyId.present) {
      map['vocabulary_id'] = Variable<int>(vocabularyId.value);
    }
    if (furiganaBefore.present) {
      map['furigana_before'] = Variable<String>(furiganaBefore.value);
    }
    if (furiganaAfter.present) {
      map['furigana_after'] = Variable<String>(furiganaAfter.value);
    }
    if (furigana.present) {
      map['furigana'] = Variable<String>(furigana.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SentencesCompanion(')
          ..write('id: $id, ')
          ..write('japanese: $japanese, ')
          ..write('targetWord: $targetWord, ')
          ..write('vocabularyId: $vocabularyId, ')
          ..write('furiganaBefore: $furiganaBefore, ')
          ..write('furiganaAfter: $furiganaAfter, ')
          ..write('furigana: $furigana')
          ..write(')'))
        .toString();
  }
}

class SentenceTranslations extends Table
    with TableInfo<SentenceTranslations, SentenceTranslation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  SentenceTranslations(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _sentenceIdMeta = const VerificationMeta(
    'sentenceId',
  );
  late final GeneratedColumn<int> sentenceId = GeneratedColumn<int>(
    'sentence_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES sentences(id)',
  );
  static const VerificationMeta _localeMeta = const VerificationMeta('locale');
  late final GeneratedColumn<String> locale = GeneratedColumn<String>(
    'locale',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _translationMeta = const VerificationMeta(
    'translation',
  );
  late final GeneratedColumn<String> translation = GeneratedColumn<String>(
    'translation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  @override
  List<GeneratedColumn> get $columns => [sentenceId, locale, translation];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sentence_translations';
  @override
  VerificationContext validateIntegrity(
    Insertable<SentenceTranslation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('sentence_id')) {
      context.handle(
        _sentenceIdMeta,
        sentenceId.isAcceptableOrUnknown(data['sentence_id']!, _sentenceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sentenceIdMeta);
    }
    if (data.containsKey('locale')) {
      context.handle(
        _localeMeta,
        locale.isAcceptableOrUnknown(data['locale']!, _localeMeta),
      );
    } else if (isInserting) {
      context.missing(_localeMeta);
    }
    if (data.containsKey('translation')) {
      context.handle(
        _translationMeta,
        translation.isAcceptableOrUnknown(
          data['translation']!,
          _translationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_translationMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {sentenceId, locale};
  @override
  SentenceTranslation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SentenceTranslation(
      sentenceId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sentence_id'],
      )!,
      locale: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}locale'],
      )!,
      translation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}translation'],
      )!,
    );
  }

  @override
  SentenceTranslations createAlias(String alias) {
    return SentenceTranslations(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
    'PRIMARY KEY(sentence_id, locale)',
  ];
  @override
  bool get dontWriteConstraints => true;
}

class SentenceTranslation extends DataClass
    implements Insertable<SentenceTranslation> {
  final int sentenceId;
  final String locale;
  final String translation;
  const SentenceTranslation({
    required this.sentenceId,
    required this.locale,
    required this.translation,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['sentence_id'] = Variable<int>(sentenceId);
    map['locale'] = Variable<String>(locale);
    map['translation'] = Variable<String>(translation);
    return map;
  }

  SentenceTranslationsCompanion toCompanion(bool nullToAbsent) {
    return SentenceTranslationsCompanion(
      sentenceId: Value(sentenceId),
      locale: Value(locale),
      translation: Value(translation),
    );
  }

  factory SentenceTranslation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SentenceTranslation(
      sentenceId: serializer.fromJson<int>(json['sentence_id']),
      locale: serializer.fromJson<String>(json['locale']),
      translation: serializer.fromJson<String>(json['translation']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'sentence_id': serializer.toJson<int>(sentenceId),
      'locale': serializer.toJson<String>(locale),
      'translation': serializer.toJson<String>(translation),
    };
  }

  SentenceTranslation copyWith({
    int? sentenceId,
    String? locale,
    String? translation,
  }) => SentenceTranslation(
    sentenceId: sentenceId ?? this.sentenceId,
    locale: locale ?? this.locale,
    translation: translation ?? this.translation,
  );
  SentenceTranslation copyWithCompanion(SentenceTranslationsCompanion data) {
    return SentenceTranslation(
      sentenceId: data.sentenceId.present
          ? data.sentenceId.value
          : this.sentenceId,
      locale: data.locale.present ? data.locale.value : this.locale,
      translation: data.translation.present
          ? data.translation.value
          : this.translation,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SentenceTranslation(')
          ..write('sentenceId: $sentenceId, ')
          ..write('locale: $locale, ')
          ..write('translation: $translation')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(sentenceId, locale, translation);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SentenceTranslation &&
          other.sentenceId == this.sentenceId &&
          other.locale == this.locale &&
          other.translation == this.translation);
}

class SentenceTranslationsCompanion
    extends UpdateCompanion<SentenceTranslation> {
  final Value<int> sentenceId;
  final Value<String> locale;
  final Value<String> translation;
  final Value<int> rowid;
  const SentenceTranslationsCompanion({
    this.sentenceId = const Value.absent(),
    this.locale = const Value.absent(),
    this.translation = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SentenceTranslationsCompanion.insert({
    required int sentenceId,
    required String locale,
    required String translation,
    this.rowid = const Value.absent(),
  }) : sentenceId = Value(sentenceId),
       locale = Value(locale),
       translation = Value(translation);
  static Insertable<SentenceTranslation> custom({
    Expression<int>? sentenceId,
    Expression<String>? locale,
    Expression<String>? translation,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (sentenceId != null) 'sentence_id': sentenceId,
      if (locale != null) 'locale': locale,
      if (translation != null) 'translation': translation,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SentenceTranslationsCompanion copyWith({
    Value<int>? sentenceId,
    Value<String>? locale,
    Value<String>? translation,
    Value<int>? rowid,
  }) {
    return SentenceTranslationsCompanion(
      sentenceId: sentenceId ?? this.sentenceId,
      locale: locale ?? this.locale,
      translation: translation ?? this.translation,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (sentenceId.present) {
      map['sentence_id'] = Variable<int>(sentenceId.value);
    }
    if (locale.present) {
      map['locale'] = Variable<String>(locale.value);
    }
    if (translation.present) {
      map['translation'] = Variable<String>(translation.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SentenceTranslationsCompanion(')
          ..write('sentenceId: $sentenceId, ')
          ..write('locale: $locale, ')
          ..write('translation: $translation, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class Exercises extends Table with TableInfo<Exercises, Exercise> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Exercises(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT',
  );
  static const VerificationMeta _localeMeta = const VerificationMeta('locale');
  late final GeneratedColumn<String> locale = GeneratedColumn<String>(
    'locale',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _sourceIdMeta = const VerificationMeta(
    'sourceId',
  );
  late final GeneratedColumn<int> sourceId = GeneratedColumn<int>(
    'source_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _promptMeta = const VerificationMeta('prompt');
  late final GeneratedColumn<String> prompt = GeneratedColumn<String>(
    'prompt',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _answerMeta = const VerificationMeta('answer');
  late final GeneratedColumn<String> answer = GeneratedColumn<String>(
    'answer',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _distractorsMeta = const VerificationMeta(
    'distractors',
  );
  late final GeneratedColumn<String> distractors = GeneratedColumn<String>(
    'distractors',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'[]\'',
    defaultValue: const CustomExpression('\'[]\''),
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
    );
  }

  @override
  Exercises createAlias(String alias) {
    return Exercises(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
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
  const Exercise({
    required this.id,
    required this.locale,
    required this.type,
    required this.source,
    required this.sourceId,
    required this.prompt,
    required this.answer,
    required this.distractors,
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
      sourceId: serializer.fromJson<int>(json['source_id']),
      prompt: serializer.fromJson<String>(json['prompt']),
      answer: serializer.fromJson<String>(json['answer']),
      distractors: serializer.fromJson<String>(json['distractors']),
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
      'source_id': serializer.toJson<int>(sourceId),
      'prompt': serializer.toJson<String>(prompt),
      'answer': serializer.toJson<String>(answer),
      'distractors': serializer.toJson<String>(distractors),
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
  }) => Exercise(
    id: id ?? this.id,
    locale: locale ?? this.locale,
    type: type ?? this.type,
    source: source ?? this.source,
    sourceId: sourceId ?? this.sourceId,
    prompt: prompt ?? this.prompt,
    answer: answer ?? this.answer,
    distractors: distractors ?? this.distractors,
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
          ..write('distractors: $distractors')
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
          other.distractors == this.distractors);
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
  const ExercisesCompanion({
    this.id = const Value.absent(),
    this.locale = const Value.absent(),
    this.type = const Value.absent(),
    this.source = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.prompt = const Value.absent(),
    this.answer = const Value.absent(),
    this.distractors = const Value.absent(),
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
          ..write('distractors: $distractors')
          ..write(')'))
        .toString();
  }
}

class GrammarLessons extends Table
    with TableInfo<GrammarLessons, GrammarLessonRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  GrammarLessons(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT',
  );
  static const VerificationMeta _localeMeta = const VerificationMeta('locale');
  late final GeneratedColumn<String> locale = GeneratedColumn<String>(
    'locale',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'en\'',
    defaultValue: const CustomExpression('\'en\''),
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  late final GeneratedColumn<String> level = GeneratedColumn<String>(
    'level',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
    'path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _themeNameMeta = const VerificationMeta(
    'themeName',
  );
  late final GeneratedColumn<String> themeName = GeneratedColumn<String>(
    'theme_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'\'',
    defaultValue: const CustomExpression('\'\''),
  );
  static const VerificationMeta _themeDescriptionMeta = const VerificationMeta(
    'themeDescription',
  );
  late final GeneratedColumn<String> themeDescription = GeneratedColumn<String>(
    'theme_description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'\'',
    defaultValue: const CustomExpression('\'\''),
  );
  static const VerificationMeta _chapterMeta = const VerificationMeta(
    'chapter',
  );
  late final GeneratedColumn<String> chapter = GeneratedColumn<String>(
    'chapter',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _blocksJsonMeta = const VerificationMeta(
    'blocksJson',
  );
  late final GeneratedColumn<String> blocksJson = GeneratedColumn<String>(
    'blocks_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _difficultyMeta = const VerificationMeta(
    'difficulty',
  );
  late final GeneratedColumn<int> difficulty = GeneratedColumn<int>(
    'difficulty',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 1',
    defaultValue: const CustomExpression('1'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    locale,
    level,
    path,
    themeName,
    themeDescription,
    chapter,
    title,
    blocksJson,
    orderIndex,
    difficulty,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'grammar_lessons';
  @override
  VerificationContext validateIntegrity(
    Insertable<GrammarLessonRow> instance, {
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
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    if (data.containsKey('path')) {
      context.handle(
        _pathMeta,
        path.isAcceptableOrUnknown(data['path']!, _pathMeta),
      );
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    if (data.containsKey('theme_name')) {
      context.handle(
        _themeNameMeta,
        themeName.isAcceptableOrUnknown(data['theme_name']!, _themeNameMeta),
      );
    }
    if (data.containsKey('theme_description')) {
      context.handle(
        _themeDescriptionMeta,
        themeDescription.isAcceptableOrUnknown(
          data['theme_description']!,
          _themeDescriptionMeta,
        ),
      );
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
    if (data.containsKey('blocks_json')) {
      context.handle(
        _blocksJsonMeta,
        blocksJson.isAcceptableOrUnknown(data['blocks_json']!, _blocksJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_blocksJsonMeta);
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    if (data.containsKey('difficulty')) {
      context.handle(
        _difficultyMeta,
        difficulty.isAcceptableOrUnknown(data['difficulty']!, _difficultyMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GrammarLessonRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GrammarLessonRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      locale: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}locale'],
      )!,
      level: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}level'],
      )!,
      path: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}path'],
      )!,
      themeName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}theme_name'],
      )!,
      themeDescription: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}theme_description'],
      )!,
      chapter: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chapter'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      blocksJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}blocks_json'],
      )!,
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
      difficulty: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}difficulty'],
      )!,
    );
  }

  @override
  GrammarLessons createAlias(String alias) {
    return GrammarLessons(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class GrammarLessonRow extends DataClass
    implements Insertable<GrammarLessonRow> {
  final int id;
  final String locale;
  final String level;
  final String path;
  final String themeName;
  final String themeDescription;
  final String chapter;
  final String title;
  final String blocksJson;
  final int orderIndex;
  final int difficulty;
  const GrammarLessonRow({
    required this.id,
    required this.locale,
    required this.level,
    required this.path,
    required this.themeName,
    required this.themeDescription,
    required this.chapter,
    required this.title,
    required this.blocksJson,
    required this.orderIndex,
    required this.difficulty,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['locale'] = Variable<String>(locale);
    map['level'] = Variable<String>(level);
    map['path'] = Variable<String>(path);
    map['theme_name'] = Variable<String>(themeName);
    map['theme_description'] = Variable<String>(themeDescription);
    map['chapter'] = Variable<String>(chapter);
    map['title'] = Variable<String>(title);
    map['blocks_json'] = Variable<String>(blocksJson);
    map['order_index'] = Variable<int>(orderIndex);
    map['difficulty'] = Variable<int>(difficulty);
    return map;
  }

  GrammarLessonsCompanion toCompanion(bool nullToAbsent) {
    return GrammarLessonsCompanion(
      id: Value(id),
      locale: Value(locale),
      level: Value(level),
      path: Value(path),
      themeName: Value(themeName),
      themeDescription: Value(themeDescription),
      chapter: Value(chapter),
      title: Value(title),
      blocksJson: Value(blocksJson),
      orderIndex: Value(orderIndex),
      difficulty: Value(difficulty),
    );
  }

  factory GrammarLessonRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GrammarLessonRow(
      id: serializer.fromJson<int>(json['id']),
      locale: serializer.fromJson<String>(json['locale']),
      level: serializer.fromJson<String>(json['level']),
      path: serializer.fromJson<String>(json['path']),
      themeName: serializer.fromJson<String>(json['theme_name']),
      themeDescription: serializer.fromJson<String>(json['theme_description']),
      chapter: serializer.fromJson<String>(json['chapter']),
      title: serializer.fromJson<String>(json['title']),
      blocksJson: serializer.fromJson<String>(json['blocks_json']),
      orderIndex: serializer.fromJson<int>(json['order_index']),
      difficulty: serializer.fromJson<int>(json['difficulty']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'locale': serializer.toJson<String>(locale),
      'level': serializer.toJson<String>(level),
      'path': serializer.toJson<String>(path),
      'theme_name': serializer.toJson<String>(themeName),
      'theme_description': serializer.toJson<String>(themeDescription),
      'chapter': serializer.toJson<String>(chapter),
      'title': serializer.toJson<String>(title),
      'blocks_json': serializer.toJson<String>(blocksJson),
      'order_index': serializer.toJson<int>(orderIndex),
      'difficulty': serializer.toJson<int>(difficulty),
    };
  }

  GrammarLessonRow copyWith({
    int? id,
    String? locale,
    String? level,
    String? path,
    String? themeName,
    String? themeDescription,
    String? chapter,
    String? title,
    String? blocksJson,
    int? orderIndex,
    int? difficulty,
  }) => GrammarLessonRow(
    id: id ?? this.id,
    locale: locale ?? this.locale,
    level: level ?? this.level,
    path: path ?? this.path,
    themeName: themeName ?? this.themeName,
    themeDescription: themeDescription ?? this.themeDescription,
    chapter: chapter ?? this.chapter,
    title: title ?? this.title,
    blocksJson: blocksJson ?? this.blocksJson,
    orderIndex: orderIndex ?? this.orderIndex,
    difficulty: difficulty ?? this.difficulty,
  );
  GrammarLessonRow copyWithCompanion(GrammarLessonsCompanion data) {
    return GrammarLessonRow(
      id: data.id.present ? data.id.value : this.id,
      locale: data.locale.present ? data.locale.value : this.locale,
      level: data.level.present ? data.level.value : this.level,
      path: data.path.present ? data.path.value : this.path,
      themeName: data.themeName.present ? data.themeName.value : this.themeName,
      themeDescription: data.themeDescription.present
          ? data.themeDescription.value
          : this.themeDescription,
      chapter: data.chapter.present ? data.chapter.value : this.chapter,
      title: data.title.present ? data.title.value : this.title,
      blocksJson: data.blocksJson.present
          ? data.blocksJson.value
          : this.blocksJson,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
      difficulty: data.difficulty.present
          ? data.difficulty.value
          : this.difficulty,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GrammarLessonRow(')
          ..write('id: $id, ')
          ..write('locale: $locale, ')
          ..write('level: $level, ')
          ..write('path: $path, ')
          ..write('themeName: $themeName, ')
          ..write('themeDescription: $themeDescription, ')
          ..write('chapter: $chapter, ')
          ..write('title: $title, ')
          ..write('blocksJson: $blocksJson, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('difficulty: $difficulty')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    locale,
    level,
    path,
    themeName,
    themeDescription,
    chapter,
    title,
    blocksJson,
    orderIndex,
    difficulty,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GrammarLessonRow &&
          other.id == this.id &&
          other.locale == this.locale &&
          other.level == this.level &&
          other.path == this.path &&
          other.themeName == this.themeName &&
          other.themeDescription == this.themeDescription &&
          other.chapter == this.chapter &&
          other.title == this.title &&
          other.blocksJson == this.blocksJson &&
          other.orderIndex == this.orderIndex &&
          other.difficulty == this.difficulty);
}

class GrammarLessonsCompanion extends UpdateCompanion<GrammarLessonRow> {
  final Value<int> id;
  final Value<String> locale;
  final Value<String> level;
  final Value<String> path;
  final Value<String> themeName;
  final Value<String> themeDescription;
  final Value<String> chapter;
  final Value<String> title;
  final Value<String> blocksJson;
  final Value<int> orderIndex;
  final Value<int> difficulty;
  const GrammarLessonsCompanion({
    this.id = const Value.absent(),
    this.locale = const Value.absent(),
    this.level = const Value.absent(),
    this.path = const Value.absent(),
    this.themeName = const Value.absent(),
    this.themeDescription = const Value.absent(),
    this.chapter = const Value.absent(),
    this.title = const Value.absent(),
    this.blocksJson = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.difficulty = const Value.absent(),
  });
  GrammarLessonsCompanion.insert({
    this.id = const Value.absent(),
    this.locale = const Value.absent(),
    required String level,
    required String path,
    this.themeName = const Value.absent(),
    this.themeDescription = const Value.absent(),
    required String chapter,
    required String title,
    required String blocksJson,
    required int orderIndex,
    this.difficulty = const Value.absent(),
  }) : level = Value(level),
       path = Value(path),
       chapter = Value(chapter),
       title = Value(title),
       blocksJson = Value(blocksJson),
       orderIndex = Value(orderIndex);
  static Insertable<GrammarLessonRow> custom({
    Expression<int>? id,
    Expression<String>? locale,
    Expression<String>? level,
    Expression<String>? path,
    Expression<String>? themeName,
    Expression<String>? themeDescription,
    Expression<String>? chapter,
    Expression<String>? title,
    Expression<String>? blocksJson,
    Expression<int>? orderIndex,
    Expression<int>? difficulty,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (locale != null) 'locale': locale,
      if (level != null) 'level': level,
      if (path != null) 'path': path,
      if (themeName != null) 'theme_name': themeName,
      if (themeDescription != null) 'theme_description': themeDescription,
      if (chapter != null) 'chapter': chapter,
      if (title != null) 'title': title,
      if (blocksJson != null) 'blocks_json': blocksJson,
      if (orderIndex != null) 'order_index': orderIndex,
      if (difficulty != null) 'difficulty': difficulty,
    });
  }

  GrammarLessonsCompanion copyWith({
    Value<int>? id,
    Value<String>? locale,
    Value<String>? level,
    Value<String>? path,
    Value<String>? themeName,
    Value<String>? themeDescription,
    Value<String>? chapter,
    Value<String>? title,
    Value<String>? blocksJson,
    Value<int>? orderIndex,
    Value<int>? difficulty,
  }) {
    return GrammarLessonsCompanion(
      id: id ?? this.id,
      locale: locale ?? this.locale,
      level: level ?? this.level,
      path: path ?? this.path,
      themeName: themeName ?? this.themeName,
      themeDescription: themeDescription ?? this.themeDescription,
      chapter: chapter ?? this.chapter,
      title: title ?? this.title,
      blocksJson: blocksJson ?? this.blocksJson,
      orderIndex: orderIndex ?? this.orderIndex,
      difficulty: difficulty ?? this.difficulty,
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
    if (level.present) {
      map['level'] = Variable<String>(level.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (themeName.present) {
      map['theme_name'] = Variable<String>(themeName.value);
    }
    if (themeDescription.present) {
      map['theme_description'] = Variable<String>(themeDescription.value);
    }
    if (chapter.present) {
      map['chapter'] = Variable<String>(chapter.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (blocksJson.present) {
      map['blocks_json'] = Variable<String>(blocksJson.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<int>(difficulty.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GrammarLessonsCompanion(')
          ..write('id: $id, ')
          ..write('locale: $locale, ')
          ..write('level: $level, ')
          ..write('path: $path, ')
          ..write('themeName: $themeName, ')
          ..write('themeDescription: $themeDescription, ')
          ..write('chapter: $chapter, ')
          ..write('title: $title, ')
          ..write('blocksJson: $blocksJson, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('difficulty: $difficulty')
          ..write(')'))
        .toString();
  }
}

class GrammarExercises extends Table
    with TableInfo<GrammarExercises, GrammarExerciseRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  GrammarExercises(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT',
  );
  static const VerificationMeta _lessonPathMeta = const VerificationMeta(
    'lessonPath',
  );
  late final GeneratedColumn<String> lessonPath = GeneratedColumn<String>(
    'lesson_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _dataJsonMeta = const VerificationMeta(
    'dataJson',
  );
  late final GeneratedColumn<String> dataJson = GeneratedColumn<String>(
    'data_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    lessonPath,
    orderIndex,
    type,
    dataJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'grammar_exercises';
  @override
  VerificationContext validateIntegrity(
    Insertable<GrammarExerciseRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('lesson_path')) {
      context.handle(
        _lessonPathMeta,
        lessonPath.isAcceptableOrUnknown(data['lesson_path']!, _lessonPathMeta),
      );
    } else if (isInserting) {
      context.missing(_lessonPathMeta);
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('data_json')) {
      context.handle(
        _dataJsonMeta,
        dataJson.isAcceptableOrUnknown(data['data_json']!, _dataJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_dataJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GrammarExerciseRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GrammarExerciseRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      lessonPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lesson_path'],
      )!,
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      dataJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}data_json'],
      )!,
    );
  }

  @override
  GrammarExercises createAlias(String alias) {
    return GrammarExercises(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class GrammarExerciseRow extends DataClass
    implements Insertable<GrammarExerciseRow> {
  final int id;
  final String lessonPath;
  final int orderIndex;
  final String type;
  final String dataJson;
  const GrammarExerciseRow({
    required this.id,
    required this.lessonPath,
    required this.orderIndex,
    required this.type,
    required this.dataJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['lesson_path'] = Variable<String>(lessonPath);
    map['order_index'] = Variable<int>(orderIndex);
    map['type'] = Variable<String>(type);
    map['data_json'] = Variable<String>(dataJson);
    return map;
  }

  GrammarExercisesCompanion toCompanion(bool nullToAbsent) {
    return GrammarExercisesCompanion(
      id: Value(id),
      lessonPath: Value(lessonPath),
      orderIndex: Value(orderIndex),
      type: Value(type),
      dataJson: Value(dataJson),
    );
  }

  factory GrammarExerciseRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GrammarExerciseRow(
      id: serializer.fromJson<int>(json['id']),
      lessonPath: serializer.fromJson<String>(json['lesson_path']),
      orderIndex: serializer.fromJson<int>(json['order_index']),
      type: serializer.fromJson<String>(json['type']),
      dataJson: serializer.fromJson<String>(json['data_json']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'lesson_path': serializer.toJson<String>(lessonPath),
      'order_index': serializer.toJson<int>(orderIndex),
      'type': serializer.toJson<String>(type),
      'data_json': serializer.toJson<String>(dataJson),
    };
  }

  GrammarExerciseRow copyWith({
    int? id,
    String? lessonPath,
    int? orderIndex,
    String? type,
    String? dataJson,
  }) => GrammarExerciseRow(
    id: id ?? this.id,
    lessonPath: lessonPath ?? this.lessonPath,
    orderIndex: orderIndex ?? this.orderIndex,
    type: type ?? this.type,
    dataJson: dataJson ?? this.dataJson,
  );
  GrammarExerciseRow copyWithCompanion(GrammarExercisesCompanion data) {
    return GrammarExerciseRow(
      id: data.id.present ? data.id.value : this.id,
      lessonPath: data.lessonPath.present
          ? data.lessonPath.value
          : this.lessonPath,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
      type: data.type.present ? data.type.value : this.type,
      dataJson: data.dataJson.present ? data.dataJson.value : this.dataJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GrammarExerciseRow(')
          ..write('id: $id, ')
          ..write('lessonPath: $lessonPath, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('type: $type, ')
          ..write('dataJson: $dataJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, lessonPath, orderIndex, type, dataJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GrammarExerciseRow &&
          other.id == this.id &&
          other.lessonPath == this.lessonPath &&
          other.orderIndex == this.orderIndex &&
          other.type == this.type &&
          other.dataJson == this.dataJson);
}

class GrammarExercisesCompanion extends UpdateCompanion<GrammarExerciseRow> {
  final Value<int> id;
  final Value<String> lessonPath;
  final Value<int> orderIndex;
  final Value<String> type;
  final Value<String> dataJson;
  const GrammarExercisesCompanion({
    this.id = const Value.absent(),
    this.lessonPath = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.type = const Value.absent(),
    this.dataJson = const Value.absent(),
  });
  GrammarExercisesCompanion.insert({
    this.id = const Value.absent(),
    required String lessonPath,
    required int orderIndex,
    required String type,
    required String dataJson,
  }) : lessonPath = Value(lessonPath),
       orderIndex = Value(orderIndex),
       type = Value(type),
       dataJson = Value(dataJson);
  static Insertable<GrammarExerciseRow> custom({
    Expression<int>? id,
    Expression<String>? lessonPath,
    Expression<int>? orderIndex,
    Expression<String>? type,
    Expression<String>? dataJson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lessonPath != null) 'lesson_path': lessonPath,
      if (orderIndex != null) 'order_index': orderIndex,
      if (type != null) 'type': type,
      if (dataJson != null) 'data_json': dataJson,
    });
  }

  GrammarExercisesCompanion copyWith({
    Value<int>? id,
    Value<String>? lessonPath,
    Value<int>? orderIndex,
    Value<String>? type,
    Value<String>? dataJson,
  }) {
    return GrammarExercisesCompanion(
      id: id ?? this.id,
      lessonPath: lessonPath ?? this.lessonPath,
      orderIndex: orderIndex ?? this.orderIndex,
      type: type ?? this.type,
      dataJson: dataJson ?? this.dataJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (lessonPath.present) {
      map['lesson_path'] = Variable<String>(lessonPath.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (dataJson.present) {
      map['data_json'] = Variable<String>(dataJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GrammarExercisesCompanion(')
          ..write('id: $id, ')
          ..write('lessonPath: $lessonPath, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('type: $type, ')
          ..write('dataJson: $dataJson')
          ..write(')'))
        .toString();
  }
}

class GrammarLessonProgress extends Table
    with TableInfo<GrammarLessonProgress, GrammarLessonProgressRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  GrammarLessonProgress(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _lessonPathMeta = const VerificationMeta(
    'lessonPath',
  );
  late final GeneratedColumn<String> lessonPath = GeneratedColumn<String>(
    'lesson_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _readAtMeta = const VerificationMeta('readAt');
  late final GeneratedColumn<DateTime> readAt = GeneratedColumn<DateTime>(
    'read_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  @override
  List<GeneratedColumn> get $columns => [lessonPath, readAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'grammar_lesson_progress';
  @override
  VerificationContext validateIntegrity(
    Insertable<GrammarLessonProgressRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('lesson_path')) {
      context.handle(
        _lessonPathMeta,
        lessonPath.isAcceptableOrUnknown(data['lesson_path']!, _lessonPathMeta),
      );
    } else if (isInserting) {
      context.missing(_lessonPathMeta);
    }
    if (data.containsKey('read_at')) {
      context.handle(
        _readAtMeta,
        readAt.isAcceptableOrUnknown(data['read_at']!, _readAtMeta),
      );
    } else if (isInserting) {
      context.missing(_readAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {lessonPath};
  @override
  GrammarLessonProgressRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GrammarLessonProgressRow(
      lessonPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lesson_path'],
      )!,
      readAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}read_at'],
      )!,
    );
  }

  @override
  GrammarLessonProgress createAlias(String alias) {
    return GrammarLessonProgress(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const ['PRIMARY KEY(lesson_path)'];
  @override
  bool get dontWriteConstraints => true;
}

class GrammarLessonProgressRow extends DataClass
    implements Insertable<GrammarLessonProgressRow> {
  final String lessonPath;
  final DateTime readAt;
  const GrammarLessonProgressRow({
    required this.lessonPath,
    required this.readAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['lesson_path'] = Variable<String>(lessonPath);
    map['read_at'] = Variable<DateTime>(readAt);
    return map;
  }

  GrammarLessonProgressCompanion toCompanion(bool nullToAbsent) {
    return GrammarLessonProgressCompanion(
      lessonPath: Value(lessonPath),
      readAt: Value(readAt),
    );
  }

  factory GrammarLessonProgressRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GrammarLessonProgressRow(
      lessonPath: serializer.fromJson<String>(json['lesson_path']),
      readAt: serializer.fromJson<DateTime>(json['read_at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'lesson_path': serializer.toJson<String>(lessonPath),
      'read_at': serializer.toJson<DateTime>(readAt),
    };
  }

  GrammarLessonProgressRow copyWith({String? lessonPath, DateTime? readAt}) =>
      GrammarLessonProgressRow(
        lessonPath: lessonPath ?? this.lessonPath,
        readAt: readAt ?? this.readAt,
      );
  GrammarLessonProgressRow copyWithCompanion(
    GrammarLessonProgressCompanion data,
  ) {
    return GrammarLessonProgressRow(
      lessonPath: data.lessonPath.present
          ? data.lessonPath.value
          : this.lessonPath,
      readAt: data.readAt.present ? data.readAt.value : this.readAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GrammarLessonProgressRow(')
          ..write('lessonPath: $lessonPath, ')
          ..write('readAt: $readAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(lessonPath, readAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GrammarLessonProgressRow &&
          other.lessonPath == this.lessonPath &&
          other.readAt == this.readAt);
}

class GrammarLessonProgressCompanion
    extends UpdateCompanion<GrammarLessonProgressRow> {
  final Value<String> lessonPath;
  final Value<DateTime> readAt;
  final Value<int> rowid;
  const GrammarLessonProgressCompanion({
    this.lessonPath = const Value.absent(),
    this.readAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GrammarLessonProgressCompanion.insert({
    required String lessonPath,
    required DateTime readAt,
    this.rowid = const Value.absent(),
  }) : lessonPath = Value(lessonPath),
       readAt = Value(readAt);
  static Insertable<GrammarLessonProgressRow> custom({
    Expression<String>? lessonPath,
    Expression<DateTime>? readAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (lessonPath != null) 'lesson_path': lessonPath,
      if (readAt != null) 'read_at': readAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GrammarLessonProgressCompanion copyWith({
    Value<String>? lessonPath,
    Value<DateTime>? readAt,
    Value<int>? rowid,
  }) {
    return GrammarLessonProgressCompanion(
      lessonPath: lessonPath ?? this.lessonPath,
      readAt: readAt ?? this.readAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (lessonPath.present) {
      map['lesson_path'] = Variable<String>(lessonPath.value);
    }
    if (readAt.present) {
      map['read_at'] = Variable<DateTime>(readAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GrammarLessonProgressCompanion(')
          ..write('lessonPath: $lessonPath, ')
          ..write('readAt: $readAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class GrammarLessonStarts extends Table
    with TableInfo<GrammarLessonStarts, GrammarLessonStartRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  GrammarLessonStarts(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _lessonPathMeta = const VerificationMeta(
    'lessonPath',
  );
  late final GeneratedColumn<String> lessonPath = GeneratedColumn<String>(
    'lesson_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  @override
  List<GeneratedColumn> get $columns => [lessonPath];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'grammar_lesson_starts';
  @override
  VerificationContext validateIntegrity(
    Insertable<GrammarLessonStartRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('lesson_path')) {
      context.handle(
        _lessonPathMeta,
        lessonPath.isAcceptableOrUnknown(data['lesson_path']!, _lessonPathMeta),
      );
    } else if (isInserting) {
      context.missing(_lessonPathMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {lessonPath};
  @override
  GrammarLessonStartRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GrammarLessonStartRow(
      lessonPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lesson_path'],
      )!,
    );
  }

  @override
  GrammarLessonStarts createAlias(String alias) {
    return GrammarLessonStarts(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const ['PRIMARY KEY(lesson_path)'];
  @override
  bool get dontWriteConstraints => true;
}

class GrammarLessonStartRow extends DataClass
    implements Insertable<GrammarLessonStartRow> {
  final String lessonPath;
  const GrammarLessonStartRow({required this.lessonPath});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['lesson_path'] = Variable<String>(lessonPath);
    return map;
  }

  GrammarLessonStartsCompanion toCompanion(bool nullToAbsent) {
    return GrammarLessonStartsCompanion(lessonPath: Value(lessonPath));
  }

  factory GrammarLessonStartRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GrammarLessonStartRow(
      lessonPath: serializer.fromJson<String>(json['lesson_path']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'lesson_path': serializer.toJson<String>(lessonPath),
    };
  }

  GrammarLessonStartRow copyWith({String? lessonPath}) =>
      GrammarLessonStartRow(lessonPath: lessonPath ?? this.lessonPath);
  GrammarLessonStartRow copyWithCompanion(GrammarLessonStartsCompanion data) {
    return GrammarLessonStartRow(
      lessonPath: data.lessonPath.present
          ? data.lessonPath.value
          : this.lessonPath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GrammarLessonStartRow(')
          ..write('lessonPath: $lessonPath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => lessonPath.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GrammarLessonStartRow && other.lessonPath == this.lessonPath);
}

class GrammarLessonStartsCompanion
    extends UpdateCompanion<GrammarLessonStartRow> {
  final Value<String> lessonPath;
  final Value<int> rowid;
  const GrammarLessonStartsCompanion({
    this.lessonPath = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GrammarLessonStartsCompanion.insert({
    required String lessonPath,
    this.rowid = const Value.absent(),
  }) : lessonPath = Value(lessonPath);
  static Insertable<GrammarLessonStartRow> custom({
    Expression<String>? lessonPath,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (lessonPath != null) 'lesson_path': lessonPath,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GrammarLessonStartsCompanion copyWith({
    Value<String>? lessonPath,
    Value<int>? rowid,
  }) {
    return GrammarLessonStartsCompanion(
      lessonPath: lessonPath ?? this.lessonPath,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (lessonPath.present) {
      map['lesson_path'] = Variable<String>(lessonPath.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GrammarLessonStartsCompanion(')
          ..write('lessonPath: $lessonPath, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class GrammarChapterUnlocks extends Table
    with TableInfo<GrammarChapterUnlocks, GrammarChapterUnlockRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  GrammarChapterUnlocks(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _chapterKeyMeta = const VerificationMeta(
    'chapterKey',
  );
  late final GeneratedColumn<String> chapterKey = GeneratedColumn<String>(
    'chapter_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  @override
  List<GeneratedColumn> get $columns => [chapterKey];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'grammar_chapter_unlocks';
  @override
  VerificationContext validateIntegrity(
    Insertable<GrammarChapterUnlockRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('chapter_key')) {
      context.handle(
        _chapterKeyMeta,
        chapterKey.isAcceptableOrUnknown(data['chapter_key']!, _chapterKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_chapterKeyMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {chapterKey};
  @override
  GrammarChapterUnlockRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GrammarChapterUnlockRow(
      chapterKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chapter_key'],
      )!,
    );
  }

  @override
  GrammarChapterUnlocks createAlias(String alias) {
    return GrammarChapterUnlocks(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const ['PRIMARY KEY(chapter_key)'];
  @override
  bool get dontWriteConstraints => true;
}

class GrammarChapterUnlockRow extends DataClass
    implements Insertable<GrammarChapterUnlockRow> {
  final String chapterKey;
  const GrammarChapterUnlockRow({required this.chapterKey});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['chapter_key'] = Variable<String>(chapterKey);
    return map;
  }

  GrammarChapterUnlocksCompanion toCompanion(bool nullToAbsent) {
    return GrammarChapterUnlocksCompanion(chapterKey: Value(chapterKey));
  }

  factory GrammarChapterUnlockRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GrammarChapterUnlockRow(
      chapterKey: serializer.fromJson<String>(json['chapter_key']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'chapter_key': serializer.toJson<String>(chapterKey),
    };
  }

  GrammarChapterUnlockRow copyWith({String? chapterKey}) =>
      GrammarChapterUnlockRow(chapterKey: chapterKey ?? this.chapterKey);
  GrammarChapterUnlockRow copyWithCompanion(
    GrammarChapterUnlocksCompanion data,
  ) {
    return GrammarChapterUnlockRow(
      chapterKey: data.chapterKey.present
          ? data.chapterKey.value
          : this.chapterKey,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GrammarChapterUnlockRow(')
          ..write('chapterKey: $chapterKey')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => chapterKey.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GrammarChapterUnlockRow && other.chapterKey == this.chapterKey);
}

class GrammarChapterUnlocksCompanion
    extends UpdateCompanion<GrammarChapterUnlockRow> {
  final Value<String> chapterKey;
  final Value<int> rowid;
  const GrammarChapterUnlocksCompanion({
    this.chapterKey = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GrammarChapterUnlocksCompanion.insert({
    required String chapterKey,
    this.rowid = const Value.absent(),
  }) : chapterKey = Value(chapterKey);
  static Insertable<GrammarChapterUnlockRow> custom({
    Expression<String>? chapterKey,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (chapterKey != null) 'chapter_key': chapterKey,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GrammarChapterUnlocksCompanion copyWith({
    Value<String>? chapterKey,
    Value<int>? rowid,
  }) {
    return GrammarChapterUnlocksCompanion(
      chapterKey: chapterKey ?? this.chapterKey,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (chapterKey.present) {
      map['chapter_key'] = Variable<String>(chapterKey.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GrammarChapterUnlocksCompanion(')
          ..write('chapterKey: $chapterKey, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class ProgressEntries extends Table
    with TableInfo<ProgressEntries, ProgressEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  ProgressEntries(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT',
  );
  static const VerificationMeta _itemTypeMeta = const VerificationMeta(
    'itemType',
  );
  late final GeneratedColumn<String> itemType = GeneratedColumn<String>(
    'item_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  late final GeneratedColumn<int> itemId = GeneratedColumn<int>(
    'item_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _isKnownMeta = const VerificationMeta(
    'isKnown',
  );
  late final GeneratedColumn<bool> isKnown = GeneratedColumn<bool>(
    'is_known',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (is_known IN (0, 1))',
  );
  static const VerificationMeta _toggledAtMeta = const VerificationMeta(
    'toggledAt',
  );
  late final GeneratedColumn<DateTime> toggledAt = GeneratedColumn<DateTime>(
    'toggled_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
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
  ProgressEntries createAlias(String alias) {
    return ProgressEntries(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const ['UNIQUE(item_type, item_id)'];
  @override
  bool get dontWriteConstraints => true;
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
      itemType: serializer.fromJson<String>(json['item_type']),
      itemId: serializer.fromJson<int>(json['item_id']),
      isKnown: serializer.fromJson<bool>(json['is_known']),
      toggledAt: serializer.fromJson<DateTime>(json['toggled_at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'item_type': serializer.toJson<String>(itemType),
      'item_id': serializer.toJson<int>(itemId),
      'is_known': serializer.toJson<bool>(isKnown),
      'toggled_at': serializer.toJson<DateTime>(toggledAt),
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

class SrsCards extends Table with TableInfo<SrsCards, SrsCard> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  SrsCards(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _itemTypeMeta = const VerificationMeta(
    'itemType',
  );
  late final GeneratedColumn<String> itemType = GeneratedColumn<String>(
    'item_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  late final GeneratedColumn<int> itemId = GeneratedColumn<int>(
    'item_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _dueMeta = const VerificationMeta('due');
  late final GeneratedColumn<DateTime> due = GeneratedColumn<DateTime>(
    'due',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _firstSeenAtMeta = const VerificationMeta(
    'firstSeenAt',
  );
  late final GeneratedColumn<DateTime> firstSeenAt = GeneratedColumn<DateTime>(
    'first_seen_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _cardJsonMeta = const VerificationMeta(
    'cardJson',
  );
  late final GeneratedColumn<String> cardJson = GeneratedColumn<String>(
    'card_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  @override
  List<GeneratedColumn> get $columns => [
    itemType,
    itemId,
    due,
    firstSeenAt,
    cardJson,
  ];
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
    if (data.containsKey('first_seen_at')) {
      context.handle(
        _firstSeenAtMeta,
        firstSeenAt.isAcceptableOrUnknown(
          data['first_seen_at']!,
          _firstSeenAtMeta,
        ),
      );
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
      firstSeenAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}first_seen_at'],
      ),
      cardJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}card_json'],
      )!,
    );
  }

  @override
  SrsCards createAlias(String alias) {
    return SrsCards(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
    'PRIMARY KEY(item_type, item_id)',
  ];
  @override
  bool get dontWriteConstraints => true;
}

class SrsCard extends DataClass implements Insertable<SrsCard> {
  final String itemType;
  final int itemId;
  final DateTime due;
  final DateTime? firstSeenAt;
  final String cardJson;
  const SrsCard({
    required this.itemType,
    required this.itemId,
    required this.due,
    this.firstSeenAt,
    required this.cardJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['item_type'] = Variable<String>(itemType);
    map['item_id'] = Variable<int>(itemId);
    map['due'] = Variable<DateTime>(due);
    if (!nullToAbsent || firstSeenAt != null) {
      map['first_seen_at'] = Variable<DateTime>(firstSeenAt);
    }
    map['card_json'] = Variable<String>(cardJson);
    return map;
  }

  SrsCardsCompanion toCompanion(bool nullToAbsent) {
    return SrsCardsCompanion(
      itemType: Value(itemType),
      itemId: Value(itemId),
      due: Value(due),
      firstSeenAt: firstSeenAt == null && nullToAbsent
          ? const Value.absent()
          : Value(firstSeenAt),
      cardJson: Value(cardJson),
    );
  }

  factory SrsCard.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SrsCard(
      itemType: serializer.fromJson<String>(json['item_type']),
      itemId: serializer.fromJson<int>(json['item_id']),
      due: serializer.fromJson<DateTime>(json['due']),
      firstSeenAt: serializer.fromJson<DateTime?>(json['first_seen_at']),
      cardJson: serializer.fromJson<String>(json['card_json']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'item_type': serializer.toJson<String>(itemType),
      'item_id': serializer.toJson<int>(itemId),
      'due': serializer.toJson<DateTime>(due),
      'first_seen_at': serializer.toJson<DateTime?>(firstSeenAt),
      'card_json': serializer.toJson<String>(cardJson),
    };
  }

  SrsCard copyWith({
    String? itemType,
    int? itemId,
    DateTime? due,
    Value<DateTime?> firstSeenAt = const Value.absent(),
    String? cardJson,
  }) => SrsCard(
    itemType: itemType ?? this.itemType,
    itemId: itemId ?? this.itemId,
    due: due ?? this.due,
    firstSeenAt: firstSeenAt.present ? firstSeenAt.value : this.firstSeenAt,
    cardJson: cardJson ?? this.cardJson,
  );
  SrsCard copyWithCompanion(SrsCardsCompanion data) {
    return SrsCard(
      itemType: data.itemType.present ? data.itemType.value : this.itemType,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      due: data.due.present ? data.due.value : this.due,
      firstSeenAt: data.firstSeenAt.present
          ? data.firstSeenAt.value
          : this.firstSeenAt,
      cardJson: data.cardJson.present ? data.cardJson.value : this.cardJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SrsCard(')
          ..write('itemType: $itemType, ')
          ..write('itemId: $itemId, ')
          ..write('due: $due, ')
          ..write('firstSeenAt: $firstSeenAt, ')
          ..write('cardJson: $cardJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(itemType, itemId, due, firstSeenAt, cardJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SrsCard &&
          other.itemType == this.itemType &&
          other.itemId == this.itemId &&
          other.due == this.due &&
          other.firstSeenAt == this.firstSeenAt &&
          other.cardJson == this.cardJson);
}

class SrsCardsCompanion extends UpdateCompanion<SrsCard> {
  final Value<String> itemType;
  final Value<int> itemId;
  final Value<DateTime> due;
  final Value<DateTime?> firstSeenAt;
  final Value<String> cardJson;
  final Value<int> rowid;
  const SrsCardsCompanion({
    this.itemType = const Value.absent(),
    this.itemId = const Value.absent(),
    this.due = const Value.absent(),
    this.firstSeenAt = const Value.absent(),
    this.cardJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SrsCardsCompanion.insert({
    required String itemType,
    required int itemId,
    required DateTime due,
    this.firstSeenAt = const Value.absent(),
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
    Expression<DateTime>? firstSeenAt,
    Expression<String>? cardJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (itemType != null) 'item_type': itemType,
      if (itemId != null) 'item_id': itemId,
      if (due != null) 'due': due,
      if (firstSeenAt != null) 'first_seen_at': firstSeenAt,
      if (cardJson != null) 'card_json': cardJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SrsCardsCompanion copyWith({
    Value<String>? itemType,
    Value<int>? itemId,
    Value<DateTime>? due,
    Value<DateTime?>? firstSeenAt,
    Value<String>? cardJson,
    Value<int>? rowid,
  }) {
    return SrsCardsCompanion(
      itemType: itemType ?? this.itemType,
      itemId: itemId ?? this.itemId,
      due: due ?? this.due,
      firstSeenAt: firstSeenAt ?? this.firstSeenAt,
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
    if (firstSeenAt.present) {
      map['first_seen_at'] = Variable<DateTime>(firstSeenAt.value);
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
          ..write('firstSeenAt: $firstSeenAt, ')
          ..write('cardJson: $cardJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final Kanjis kanjis = Kanjis(this);
  late final Kanas kanas = Kanas(this);
  late final VocabularyEntries vocabularyEntries = VocabularyEntries(this);
  late final KanjiTranslations kanjiTranslations = KanjiTranslations(this);
  late final VocabularyTranslations vocabularyTranslations =
      VocabularyTranslations(this);
  late final Sentences sentences = Sentences(this);
  late final SentenceTranslations sentenceTranslations = SentenceTranslations(
    this,
  );
  late final Exercises exercises = Exercises(this);
  late final GrammarLessons grammarLessons = GrammarLessons(this);
  late final GrammarExercises grammarExercises = GrammarExercises(this);
  late final GrammarLessonProgress grammarLessonProgress =
      GrammarLessonProgress(this);
  late final GrammarLessonStarts grammarLessonStarts = GrammarLessonStarts(
    this,
  );
  late final GrammarChapterUnlocks grammarChapterUnlocks =
      GrammarChapterUnlocks(this);
  late final ProgressEntries progressEntries = ProgressEntries(this);
  late final SrsCards srsCards = SrsCards(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    kanjis,
    kanas,
    vocabularyEntries,
    kanjiTranslations,
    vocabularyTranslations,
    sentences,
    sentenceTranslations,
    exercises,
    grammarLessons,
    grammarExercises,
    grammarLessonProgress,
    grammarLessonStarts,
    grammarChapterUnlocks,
    progressEntries,
    srsCards,
  ];
}

typedef $KanjisCreateCompanionBuilder =
    KanjisCompanion Function({
      Value<int> id,
      required String character,
      required String meaning,
      required String onReading,
      required String kunReading,
      required String jlptLevel,
      Value<String?> svg,
    });
typedef $KanjisUpdateCompanionBuilder =
    KanjisCompanion Function({
      Value<int> id,
      Value<String> character,
      Value<String> meaning,
      Value<String> onReading,
      Value<String> kunReading,
      Value<String> jlptLevel,
      Value<String?> svg,
    });

final class $KanjisReferences
    extends BaseReferences<_$AppDatabase, Kanjis, Kanji> {
  $KanjisReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<VocabularyEntries, List<VocabularyEntry>>
  _vocabularyEntriesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.vocabularyEntries,
        aliasName: 'kanjis__id__vocabulary_entries__kanji_id',
      );

  $VocabularyEntriesProcessedTableManager get vocabularyEntriesRefs {
    final manager = $VocabularyEntriesTableManager(
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

  static MultiTypedResultKey<KanjiTranslations, List<KanjiTranslation>>
  _kanjiTranslationsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.kanjiTranslations,
        aliasName: 'kanjis__id__kanji_translations__kanji_id',
      );

  $KanjiTranslationsProcessedTableManager get kanjiTranslationsRefs {
    final manager = $KanjiTranslationsTableManager(
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

class $KanjisFilterComposer extends Composer<_$AppDatabase, Kanjis> {
  $KanjisFilterComposer({
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

  ColumnFilters<String> get svg => $composableBuilder(
    column: $table.svg,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> vocabularyEntriesRefs(
    Expression<bool> Function($VocabularyEntriesFilterComposer f) f,
  ) {
    final $VocabularyEntriesFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.vocabularyEntries,
      getReferencedColumn: (t) => t.kanjiId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $VocabularyEntriesFilterComposer(
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
    Expression<bool> Function($KanjiTranslationsFilterComposer f) f,
  ) {
    final $KanjiTranslationsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.kanjiTranslations,
      getReferencedColumn: (t) => t.kanjiId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $KanjiTranslationsFilterComposer(
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

class $KanjisOrderingComposer extends Composer<_$AppDatabase, Kanjis> {
  $KanjisOrderingComposer({
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

  ColumnOrderings<String> get svg => $composableBuilder(
    column: $table.svg,
    builder: (column) => ColumnOrderings(column),
  );
}

class $KanjisAnnotationComposer extends Composer<_$AppDatabase, Kanjis> {
  $KanjisAnnotationComposer({
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

  GeneratedColumn<String> get svg =>
      $composableBuilder(column: $table.svg, builder: (column) => column);

  Expression<T> vocabularyEntriesRefs<T extends Object>(
    Expression<T> Function($VocabularyEntriesAnnotationComposer a) f,
  ) {
    final $VocabularyEntriesAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.vocabularyEntries,
      getReferencedColumn: (t) => t.kanjiId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $VocabularyEntriesAnnotationComposer(
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
    Expression<T> Function($KanjiTranslationsAnnotationComposer a) f,
  ) {
    final $KanjiTranslationsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.kanjiTranslations,
      getReferencedColumn: (t) => t.kanjiId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $KanjiTranslationsAnnotationComposer(
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

class $KanjisTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          Kanjis,
          Kanji,
          $KanjisFilterComposer,
          $KanjisOrderingComposer,
          $KanjisAnnotationComposer,
          $KanjisCreateCompanionBuilder,
          $KanjisUpdateCompanionBuilder,
          (Kanji, $KanjisReferences),
          Kanji,
          PrefetchHooks Function({
            bool vocabularyEntriesRefs,
            bool kanjiTranslationsRefs,
          })
        > {
  $KanjisTableManager(_$AppDatabase db, Kanjis table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $KanjisFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $KanjisOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $KanjisAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> character = const Value.absent(),
                Value<String> meaning = const Value.absent(),
                Value<String> onReading = const Value.absent(),
                Value<String> kunReading = const Value.absent(),
                Value<String> jlptLevel = const Value.absent(),
                Value<String?> svg = const Value.absent(),
              }) => KanjisCompanion(
                id: id,
                character: character,
                meaning: meaning,
                onReading: onReading,
                kunReading: kunReading,
                jlptLevel: jlptLevel,
                svg: svg,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String character,
                required String meaning,
                required String onReading,
                required String kunReading,
                required String jlptLevel,
                Value<String?> svg = const Value.absent(),
              }) => KanjisCompanion.insert(
                id: id,
                character: character,
                meaning: meaning,
                onReading: onReading,
                kunReading: kunReading,
                jlptLevel: jlptLevel,
                svg: svg,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), $KanjisReferences(db, table, e)))
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
                          Kanjis,
                          VocabularyEntry
                        >(
                          currentTable: table,
                          referencedTable: $KanjisReferences
                              ._vocabularyEntriesRefsTable(db),
                          managerFromTypedResult: (p0) => $KanjisReferences(
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
                          Kanjis,
                          KanjiTranslation
                        >(
                          currentTable: table,
                          referencedTable: $KanjisReferences
                              ._kanjiTranslationsRefsTable(db),
                          managerFromTypedResult: (p0) => $KanjisReferences(
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

typedef $KanjisProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      Kanjis,
      Kanji,
      $KanjisFilterComposer,
      $KanjisOrderingComposer,
      $KanjisAnnotationComposer,
      $KanjisCreateCompanionBuilder,
      $KanjisUpdateCompanionBuilder,
      (Kanji, $KanjisReferences),
      Kanji,
      PrefetchHooks Function({
        bool vocabularyEntriesRefs,
        bool kanjiTranslationsRefs,
      })
    >;
typedef $KanasCreateCompanionBuilder =
    KanasCompanion Function({
      Value<int> id,
      required String character,
      required String romaji,
      required String type,
      required String row,
      required String kanaGroup,
      required int slot,
    });
typedef $KanasUpdateCompanionBuilder =
    KanasCompanion Function({
      Value<int> id,
      Value<String> character,
      Value<String> romaji,
      Value<String> type,
      Value<String> row,
      Value<String> kanaGroup,
      Value<int> slot,
    });

class $KanasFilterComposer extends Composer<_$AppDatabase, Kanas> {
  $KanasFilterComposer({
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

class $KanasOrderingComposer extends Composer<_$AppDatabase, Kanas> {
  $KanasOrderingComposer({
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

class $KanasAnnotationComposer extends Composer<_$AppDatabase, Kanas> {
  $KanasAnnotationComposer({
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

class $KanasTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          Kanas,
          Kana,
          $KanasFilterComposer,
          $KanasOrderingComposer,
          $KanasAnnotationComposer,
          $KanasCreateCompanionBuilder,
          $KanasUpdateCompanionBuilder,
          (Kana, BaseReferences<_$AppDatabase, Kanas, Kana>),
          Kana,
          PrefetchHooks Function()
        > {
  $KanasTableManager(_$AppDatabase db, Kanas table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $KanasFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $KanasOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $KanasAnnotationComposer($db: db, $table: table),
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

typedef $KanasProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      Kanas,
      Kana,
      $KanasFilterComposer,
      $KanasOrderingComposer,
      $KanasAnnotationComposer,
      $KanasCreateCompanionBuilder,
      $KanasUpdateCompanionBuilder,
      (Kana, BaseReferences<_$AppDatabase, Kanas, Kana>),
      Kana,
      PrefetchHooks Function()
    >;
typedef $VocabularyEntriesCreateCompanionBuilder =
    VocabularyEntriesCompanion Function({
      Value<int> id,
      required String word,
      required String reading,
      required String meaning,
      required String jlptLevel,
      required String partOfSpeech,
      Value<int?> kanjiId,
    });
typedef $VocabularyEntriesUpdateCompanionBuilder =
    VocabularyEntriesCompanion Function({
      Value<int> id,
      Value<String> word,
      Value<String> reading,
      Value<String> meaning,
      Value<String> jlptLevel,
      Value<String> partOfSpeech,
      Value<int?> kanjiId,
    });

final class $VocabularyEntriesReferences
    extends BaseReferences<_$AppDatabase, VocabularyEntries, VocabularyEntry> {
  $VocabularyEntriesReferences(super.$_db, super.$_table, super.$_typedResult);

  static Kanjis _kanjiIdTable(_$AppDatabase db) =>
      db.kanjis.createAlias('vocabulary_entries__kanji_id__kanjis__id');

  $KanjisProcessedTableManager? get kanjiId {
    final $_column = $_itemColumn<int>('kanji_id');
    if ($_column == null) return null;
    final manager = $KanjisTableManager(
      $_db,
      $_db.kanjis,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_kanjiIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    VocabularyTranslations,
    List<VocabularyTranslation>
  >
  _vocabularyTranslationsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.vocabularyTranslations,
        aliasName:
            'vocabulary_entries__id__vocabulary_translations__vocabulary_id',
      );

  $VocabularyTranslationsProcessedTableManager get vocabularyTranslationsRefs {
    final manager = $VocabularyTranslationsTableManager(
      $_db,
      $_db.vocabularyTranslations,
    ).filter((f) => f.vocabularyId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _vocabularyTranslationsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<Sentences, List<Sentence>> _sentencesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.sentences,
    aliasName: 'vocabulary_entries__id__sentences__vocabulary_id',
  );

  $SentencesProcessedTableManager get sentencesRefs {
    final manager = $SentencesTableManager(
      $_db,
      $_db.sentences,
    ).filter((f) => f.vocabularyId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_sentencesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $VocabularyEntriesFilterComposer
    extends Composer<_$AppDatabase, VocabularyEntries> {
  $VocabularyEntriesFilterComposer({
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

  $KanjisFilterComposer get kanjiId {
    final $KanjisFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kanjiId,
      referencedTable: $db.kanjis,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $KanjisFilterComposer(
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

  Expression<bool> vocabularyTranslationsRefs(
    Expression<bool> Function($VocabularyTranslationsFilterComposer f) f,
  ) {
    final $VocabularyTranslationsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.vocabularyTranslations,
      getReferencedColumn: (t) => t.vocabularyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $VocabularyTranslationsFilterComposer(
            $db: $db,
            $table: $db.vocabularyTranslations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> sentencesRefs(
    Expression<bool> Function($SentencesFilterComposer f) f,
  ) {
    final $SentencesFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sentences,
      getReferencedColumn: (t) => t.vocabularyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $SentencesFilterComposer(
            $db: $db,
            $table: $db.sentences,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $VocabularyEntriesOrderingComposer
    extends Composer<_$AppDatabase, VocabularyEntries> {
  $VocabularyEntriesOrderingComposer({
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

  $KanjisOrderingComposer get kanjiId {
    final $KanjisOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kanjiId,
      referencedTable: $db.kanjis,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $KanjisOrderingComposer(
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

class $VocabularyEntriesAnnotationComposer
    extends Composer<_$AppDatabase, VocabularyEntries> {
  $VocabularyEntriesAnnotationComposer({
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

  $KanjisAnnotationComposer get kanjiId {
    final $KanjisAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kanjiId,
      referencedTable: $db.kanjis,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $KanjisAnnotationComposer(
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

  Expression<T> vocabularyTranslationsRefs<T extends Object>(
    Expression<T> Function($VocabularyTranslationsAnnotationComposer a) f,
  ) {
    final $VocabularyTranslationsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.vocabularyTranslations,
      getReferencedColumn: (t) => t.vocabularyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $VocabularyTranslationsAnnotationComposer(
            $db: $db,
            $table: $db.vocabularyTranslations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> sentencesRefs<T extends Object>(
    Expression<T> Function($SentencesAnnotationComposer a) f,
  ) {
    final $SentencesAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sentences,
      getReferencedColumn: (t) => t.vocabularyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $SentencesAnnotationComposer(
            $db: $db,
            $table: $db.sentences,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $VocabularyEntriesTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          VocabularyEntries,
          VocabularyEntry,
          $VocabularyEntriesFilterComposer,
          $VocabularyEntriesOrderingComposer,
          $VocabularyEntriesAnnotationComposer,
          $VocabularyEntriesCreateCompanionBuilder,
          $VocabularyEntriesUpdateCompanionBuilder,
          (VocabularyEntry, $VocabularyEntriesReferences),
          VocabularyEntry,
          PrefetchHooks Function({
            bool kanjiId,
            bool vocabularyTranslationsRefs,
            bool sentencesRefs,
          })
        > {
  $VocabularyEntriesTableManager(_$AppDatabase db, VocabularyEntries table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $VocabularyEntriesFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $VocabularyEntriesOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $VocabularyEntriesAnnotationComposer($db: db, $table: table),
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
                  $VocabularyEntriesReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                kanjiId = false,
                vocabularyTranslationsRefs = false,
                sentencesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (vocabularyTranslationsRefs) db.vocabularyTranslations,
                    if (sentencesRefs) db.sentences,
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
                                        $VocabularyEntriesReferences
                                            ._kanjiIdTable(db),
                                    referencedColumn:
                                        $VocabularyEntriesReferences
                                            ._kanjiIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (vocabularyTranslationsRefs)
                        await $_getPrefetchedData<
                          VocabularyEntry,
                          VocabularyEntries,
                          VocabularyTranslation
                        >(
                          currentTable: table,
                          referencedTable: $VocabularyEntriesReferences
                              ._vocabularyTranslationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $VocabularyEntriesReferences(
                                db,
                                table,
                                p0,
                              ).vocabularyTranslationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.vocabularyId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (sentencesRefs)
                        await $_getPrefetchedData<
                          VocabularyEntry,
                          VocabularyEntries,
                          Sentence
                        >(
                          currentTable: table,
                          referencedTable: $VocabularyEntriesReferences
                              ._sentencesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $VocabularyEntriesReferences(
                                db,
                                table,
                                p0,
                              ).sentencesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.vocabularyId == item.id,
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

typedef $VocabularyEntriesProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      VocabularyEntries,
      VocabularyEntry,
      $VocabularyEntriesFilterComposer,
      $VocabularyEntriesOrderingComposer,
      $VocabularyEntriesAnnotationComposer,
      $VocabularyEntriesCreateCompanionBuilder,
      $VocabularyEntriesUpdateCompanionBuilder,
      (VocabularyEntry, $VocabularyEntriesReferences),
      VocabularyEntry,
      PrefetchHooks Function({
        bool kanjiId,
        bool vocabularyTranslationsRefs,
        bool sentencesRefs,
      })
    >;
typedef $KanjiTranslationsCreateCompanionBuilder =
    KanjiTranslationsCompanion Function({
      required int kanjiId,
      required String locale,
      required String meaning,
      Value<int> rowid,
    });
typedef $KanjiTranslationsUpdateCompanionBuilder =
    KanjiTranslationsCompanion Function({
      Value<int> kanjiId,
      Value<String> locale,
      Value<String> meaning,
      Value<int> rowid,
    });

final class $KanjiTranslationsReferences
    extends BaseReferences<_$AppDatabase, KanjiTranslations, KanjiTranslation> {
  $KanjiTranslationsReferences(super.$_db, super.$_table, super.$_typedResult);

  static Kanjis _kanjiIdTable(_$AppDatabase db) =>
      db.kanjis.createAlias('kanji_translations__kanji_id__kanjis__id');

  $KanjisProcessedTableManager get kanjiId {
    final $_column = $_itemColumn<int>('kanji_id')!;

    final manager = $KanjisTableManager(
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

class $KanjiTranslationsFilterComposer
    extends Composer<_$AppDatabase, KanjiTranslations> {
  $KanjiTranslationsFilterComposer({
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

  $KanjisFilterComposer get kanjiId {
    final $KanjisFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kanjiId,
      referencedTable: $db.kanjis,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $KanjisFilterComposer(
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

class $KanjiTranslationsOrderingComposer
    extends Composer<_$AppDatabase, KanjiTranslations> {
  $KanjiTranslationsOrderingComposer({
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

  $KanjisOrderingComposer get kanjiId {
    final $KanjisOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kanjiId,
      referencedTable: $db.kanjis,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $KanjisOrderingComposer(
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

class $KanjiTranslationsAnnotationComposer
    extends Composer<_$AppDatabase, KanjiTranslations> {
  $KanjiTranslationsAnnotationComposer({
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

  $KanjisAnnotationComposer get kanjiId {
    final $KanjisAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kanjiId,
      referencedTable: $db.kanjis,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $KanjisAnnotationComposer(
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

class $KanjiTranslationsTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          KanjiTranslations,
          KanjiTranslation,
          $KanjiTranslationsFilterComposer,
          $KanjiTranslationsOrderingComposer,
          $KanjiTranslationsAnnotationComposer,
          $KanjiTranslationsCreateCompanionBuilder,
          $KanjiTranslationsUpdateCompanionBuilder,
          (KanjiTranslation, $KanjiTranslationsReferences),
          KanjiTranslation,
          PrefetchHooks Function({bool kanjiId})
        > {
  $KanjiTranslationsTableManager(_$AppDatabase db, KanjiTranslations table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $KanjiTranslationsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $KanjiTranslationsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $KanjiTranslationsAnnotationComposer($db: db, $table: table),
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
                  $KanjiTranslationsReferences(db, table, e),
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
                                referencedTable: $KanjiTranslationsReferences
                                    ._kanjiIdTable(db),
                                referencedColumn: $KanjiTranslationsReferences
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

typedef $KanjiTranslationsProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      KanjiTranslations,
      KanjiTranslation,
      $KanjiTranslationsFilterComposer,
      $KanjiTranslationsOrderingComposer,
      $KanjiTranslationsAnnotationComposer,
      $KanjiTranslationsCreateCompanionBuilder,
      $KanjiTranslationsUpdateCompanionBuilder,
      (KanjiTranslation, $KanjiTranslationsReferences),
      KanjiTranslation,
      PrefetchHooks Function({bool kanjiId})
    >;
typedef $VocabularyTranslationsCreateCompanionBuilder =
    VocabularyTranslationsCompanion Function({
      required int vocabularyId,
      required String locale,
      required String meaning,
      Value<int> rowid,
    });
typedef $VocabularyTranslationsUpdateCompanionBuilder =
    VocabularyTranslationsCompanion Function({
      Value<int> vocabularyId,
      Value<String> locale,
      Value<String> meaning,
      Value<int> rowid,
    });

final class $VocabularyTranslationsReferences
    extends
        BaseReferences<
          _$AppDatabase,
          VocabularyTranslations,
          VocabularyTranslation
        > {
  $VocabularyTranslationsReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static VocabularyEntries _vocabularyIdTable(_$AppDatabase db) =>
      db.vocabularyEntries.createAlias(
        'vocabulary_translations__vocabulary_id__vocabulary_entries__id',
      );

  $VocabularyEntriesProcessedTableManager get vocabularyId {
    final $_column = $_itemColumn<int>('vocabulary_id')!;

    final manager = $VocabularyEntriesTableManager(
      $_db,
      $_db.vocabularyEntries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_vocabularyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $VocabularyTranslationsFilterComposer
    extends Composer<_$AppDatabase, VocabularyTranslations> {
  $VocabularyTranslationsFilterComposer({
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

  $VocabularyEntriesFilterComposer get vocabularyId {
    final $VocabularyEntriesFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vocabularyId,
      referencedTable: $db.vocabularyEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $VocabularyEntriesFilterComposer(
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

class $VocabularyTranslationsOrderingComposer
    extends Composer<_$AppDatabase, VocabularyTranslations> {
  $VocabularyTranslationsOrderingComposer({
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

  $VocabularyEntriesOrderingComposer get vocabularyId {
    final $VocabularyEntriesOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vocabularyId,
      referencedTable: $db.vocabularyEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $VocabularyEntriesOrderingComposer(
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

class $VocabularyTranslationsAnnotationComposer
    extends Composer<_$AppDatabase, VocabularyTranslations> {
  $VocabularyTranslationsAnnotationComposer({
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

  $VocabularyEntriesAnnotationComposer get vocabularyId {
    final $VocabularyEntriesAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vocabularyId,
      referencedTable: $db.vocabularyEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $VocabularyEntriesAnnotationComposer(
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

class $VocabularyTranslationsTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          VocabularyTranslations,
          VocabularyTranslation,
          $VocabularyTranslationsFilterComposer,
          $VocabularyTranslationsOrderingComposer,
          $VocabularyTranslationsAnnotationComposer,
          $VocabularyTranslationsCreateCompanionBuilder,
          $VocabularyTranslationsUpdateCompanionBuilder,
          (VocabularyTranslation, $VocabularyTranslationsReferences),
          VocabularyTranslation,
          PrefetchHooks Function({bool vocabularyId})
        > {
  $VocabularyTranslationsTableManager(
    _$AppDatabase db,
    VocabularyTranslations table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $VocabularyTranslationsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $VocabularyTranslationsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $VocabularyTranslationsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> vocabularyId = const Value.absent(),
                Value<String> locale = const Value.absent(),
                Value<String> meaning = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VocabularyTranslationsCompanion(
                vocabularyId: vocabularyId,
                locale: locale,
                meaning: meaning,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int vocabularyId,
                required String locale,
                required String meaning,
                Value<int> rowid = const Value.absent(),
              }) => VocabularyTranslationsCompanion.insert(
                vocabularyId: vocabularyId,
                locale: locale,
                meaning: meaning,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $VocabularyTranslationsReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({vocabularyId = false}) {
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
                    if (vocabularyId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.vocabularyId,
                                referencedTable:
                                    $VocabularyTranslationsReferences
                                        ._vocabularyIdTable(db),
                                referencedColumn:
                                    $VocabularyTranslationsReferences
                                        ._vocabularyIdTable(db)
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

typedef $VocabularyTranslationsProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      VocabularyTranslations,
      VocabularyTranslation,
      $VocabularyTranslationsFilterComposer,
      $VocabularyTranslationsOrderingComposer,
      $VocabularyTranslationsAnnotationComposer,
      $VocabularyTranslationsCreateCompanionBuilder,
      $VocabularyTranslationsUpdateCompanionBuilder,
      (VocabularyTranslation, $VocabularyTranslationsReferences),
      VocabularyTranslation,
      PrefetchHooks Function({bool vocabularyId})
    >;
typedef $SentencesCreateCompanionBuilder =
    SentencesCompanion Function({
      Value<int> id,
      required String japanese,
      required String targetWord,
      required int vocabularyId,
      Value<String?> furiganaBefore,
      Value<String?> furiganaAfter,
      Value<String?> furigana,
    });
typedef $SentencesUpdateCompanionBuilder =
    SentencesCompanion Function({
      Value<int> id,
      Value<String> japanese,
      Value<String> targetWord,
      Value<int> vocabularyId,
      Value<String?> furiganaBefore,
      Value<String?> furiganaAfter,
      Value<String?> furigana,
    });

final class $SentencesReferences
    extends BaseReferences<_$AppDatabase, Sentences, Sentence> {
  $SentencesReferences(super.$_db, super.$_table, super.$_typedResult);

  static VocabularyEntries _vocabularyIdTable(_$AppDatabase db) => db
      .vocabularyEntries
      .createAlias('sentences__vocabulary_id__vocabulary_entries__id');

  $VocabularyEntriesProcessedTableManager get vocabularyId {
    final $_column = $_itemColumn<int>('vocabulary_id')!;

    final manager = $VocabularyEntriesTableManager(
      $_db,
      $_db.vocabularyEntries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_vocabularyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<SentenceTranslations, List<SentenceTranslation>>
  _sentenceTranslationsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.sentenceTranslations,
        aliasName: 'sentences__id__sentence_translations__sentence_id',
      );

  $SentenceTranslationsProcessedTableManager get sentenceTranslationsRefs {
    final manager = $SentenceTranslationsTableManager(
      $_db,
      $_db.sentenceTranslations,
    ).filter((f) => f.sentenceId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _sentenceTranslationsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $SentencesFilterComposer extends Composer<_$AppDatabase, Sentences> {
  $SentencesFilterComposer({
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

  ColumnFilters<String> get japanese => $composableBuilder(
    column: $table.japanese,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetWord => $composableBuilder(
    column: $table.targetWord,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get furiganaBefore => $composableBuilder(
    column: $table.furiganaBefore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get furiganaAfter => $composableBuilder(
    column: $table.furiganaAfter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get furigana => $composableBuilder(
    column: $table.furigana,
    builder: (column) => ColumnFilters(column),
  );

  $VocabularyEntriesFilterComposer get vocabularyId {
    final $VocabularyEntriesFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vocabularyId,
      referencedTable: $db.vocabularyEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $VocabularyEntriesFilterComposer(
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

  Expression<bool> sentenceTranslationsRefs(
    Expression<bool> Function($SentenceTranslationsFilterComposer f) f,
  ) {
    final $SentenceTranslationsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sentenceTranslations,
      getReferencedColumn: (t) => t.sentenceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $SentenceTranslationsFilterComposer(
            $db: $db,
            $table: $db.sentenceTranslations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $SentencesOrderingComposer extends Composer<_$AppDatabase, Sentences> {
  $SentencesOrderingComposer({
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

  ColumnOrderings<String> get japanese => $composableBuilder(
    column: $table.japanese,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetWord => $composableBuilder(
    column: $table.targetWord,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get furiganaBefore => $composableBuilder(
    column: $table.furiganaBefore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get furiganaAfter => $composableBuilder(
    column: $table.furiganaAfter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get furigana => $composableBuilder(
    column: $table.furigana,
    builder: (column) => ColumnOrderings(column),
  );

  $VocabularyEntriesOrderingComposer get vocabularyId {
    final $VocabularyEntriesOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vocabularyId,
      referencedTable: $db.vocabularyEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $VocabularyEntriesOrderingComposer(
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

class $SentencesAnnotationComposer extends Composer<_$AppDatabase, Sentences> {
  $SentencesAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get japanese =>
      $composableBuilder(column: $table.japanese, builder: (column) => column);

  GeneratedColumn<String> get targetWord => $composableBuilder(
    column: $table.targetWord,
    builder: (column) => column,
  );

  GeneratedColumn<String> get furiganaBefore => $composableBuilder(
    column: $table.furiganaBefore,
    builder: (column) => column,
  );

  GeneratedColumn<String> get furiganaAfter => $composableBuilder(
    column: $table.furiganaAfter,
    builder: (column) => column,
  );

  GeneratedColumn<String> get furigana =>
      $composableBuilder(column: $table.furigana, builder: (column) => column);

  $VocabularyEntriesAnnotationComposer get vocabularyId {
    final $VocabularyEntriesAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vocabularyId,
      referencedTable: $db.vocabularyEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $VocabularyEntriesAnnotationComposer(
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

  Expression<T> sentenceTranslationsRefs<T extends Object>(
    Expression<T> Function($SentenceTranslationsAnnotationComposer a) f,
  ) {
    final $SentenceTranslationsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sentenceTranslations,
      getReferencedColumn: (t) => t.sentenceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $SentenceTranslationsAnnotationComposer(
            $db: $db,
            $table: $db.sentenceTranslations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $SentencesTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          Sentences,
          Sentence,
          $SentencesFilterComposer,
          $SentencesOrderingComposer,
          $SentencesAnnotationComposer,
          $SentencesCreateCompanionBuilder,
          $SentencesUpdateCompanionBuilder,
          (Sentence, $SentencesReferences),
          Sentence,
          PrefetchHooks Function({
            bool vocabularyId,
            bool sentenceTranslationsRefs,
          })
        > {
  $SentencesTableManager(_$AppDatabase db, Sentences table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $SentencesFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $SentencesOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $SentencesAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> japanese = const Value.absent(),
                Value<String> targetWord = const Value.absent(),
                Value<int> vocabularyId = const Value.absent(),
                Value<String?> furiganaBefore = const Value.absent(),
                Value<String?> furiganaAfter = const Value.absent(),
                Value<String?> furigana = const Value.absent(),
              }) => SentencesCompanion(
                id: id,
                japanese: japanese,
                targetWord: targetWord,
                vocabularyId: vocabularyId,
                furiganaBefore: furiganaBefore,
                furiganaAfter: furiganaAfter,
                furigana: furigana,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String japanese,
                required String targetWord,
                required int vocabularyId,
                Value<String?> furiganaBefore = const Value.absent(),
                Value<String?> furiganaAfter = const Value.absent(),
                Value<String?> furigana = const Value.absent(),
              }) => SentencesCompanion.insert(
                id: id,
                japanese: japanese,
                targetWord: targetWord,
                vocabularyId: vocabularyId,
                furiganaBefore: furiganaBefore,
                furiganaAfter: furiganaAfter,
                furigana: furigana,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (e.readTable(table), $SentencesReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({vocabularyId = false, sentenceTranslationsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (sentenceTranslationsRefs) db.sentenceTranslations,
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
                        if (vocabularyId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.vocabularyId,
                                    referencedTable: $SentencesReferences
                                        ._vocabularyIdTable(db),
                                    referencedColumn: $SentencesReferences
                                        ._vocabularyIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (sentenceTranslationsRefs)
                        await $_getPrefetchedData<
                          Sentence,
                          Sentences,
                          SentenceTranslation
                        >(
                          currentTable: table,
                          referencedTable: $SentencesReferences
                              ._sentenceTranslationsRefsTable(db),
                          managerFromTypedResult: (p0) => $SentencesReferences(
                            db,
                            table,
                            p0,
                          ).sentenceTranslationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sentenceId == item.id,
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

typedef $SentencesProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      Sentences,
      Sentence,
      $SentencesFilterComposer,
      $SentencesOrderingComposer,
      $SentencesAnnotationComposer,
      $SentencesCreateCompanionBuilder,
      $SentencesUpdateCompanionBuilder,
      (Sentence, $SentencesReferences),
      Sentence,
      PrefetchHooks Function({bool vocabularyId, bool sentenceTranslationsRefs})
    >;
typedef $SentenceTranslationsCreateCompanionBuilder =
    SentenceTranslationsCompanion Function({
      required int sentenceId,
      required String locale,
      required String translation,
      Value<int> rowid,
    });
typedef $SentenceTranslationsUpdateCompanionBuilder =
    SentenceTranslationsCompanion Function({
      Value<int> sentenceId,
      Value<String> locale,
      Value<String> translation,
      Value<int> rowid,
    });

final class $SentenceTranslationsReferences
    extends
        BaseReferences<
          _$AppDatabase,
          SentenceTranslations,
          SentenceTranslation
        > {
  $SentenceTranslationsReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static Sentences _sentenceIdTable(_$AppDatabase db) => db.sentences
      .createAlias('sentence_translations__sentence_id__sentences__id');

  $SentencesProcessedTableManager get sentenceId {
    final $_column = $_itemColumn<int>('sentence_id')!;

    final manager = $SentencesTableManager(
      $_db,
      $_db.sentences,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sentenceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $SentenceTranslationsFilterComposer
    extends Composer<_$AppDatabase, SentenceTranslations> {
  $SentenceTranslationsFilterComposer({
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

  ColumnFilters<String> get translation => $composableBuilder(
    column: $table.translation,
    builder: (column) => ColumnFilters(column),
  );

  $SentencesFilterComposer get sentenceId {
    final $SentencesFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sentenceId,
      referencedTable: $db.sentences,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $SentencesFilterComposer(
            $db: $db,
            $table: $db.sentences,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $SentenceTranslationsOrderingComposer
    extends Composer<_$AppDatabase, SentenceTranslations> {
  $SentenceTranslationsOrderingComposer({
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

  ColumnOrderings<String> get translation => $composableBuilder(
    column: $table.translation,
    builder: (column) => ColumnOrderings(column),
  );

  $SentencesOrderingComposer get sentenceId {
    final $SentencesOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sentenceId,
      referencedTable: $db.sentences,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $SentencesOrderingComposer(
            $db: $db,
            $table: $db.sentences,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $SentenceTranslationsAnnotationComposer
    extends Composer<_$AppDatabase, SentenceTranslations> {
  $SentenceTranslationsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get locale =>
      $composableBuilder(column: $table.locale, builder: (column) => column);

  GeneratedColumn<String> get translation => $composableBuilder(
    column: $table.translation,
    builder: (column) => column,
  );

  $SentencesAnnotationComposer get sentenceId {
    final $SentencesAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sentenceId,
      referencedTable: $db.sentences,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $SentencesAnnotationComposer(
            $db: $db,
            $table: $db.sentences,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $SentenceTranslationsTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          SentenceTranslations,
          SentenceTranslation,
          $SentenceTranslationsFilterComposer,
          $SentenceTranslationsOrderingComposer,
          $SentenceTranslationsAnnotationComposer,
          $SentenceTranslationsCreateCompanionBuilder,
          $SentenceTranslationsUpdateCompanionBuilder,
          (SentenceTranslation, $SentenceTranslationsReferences),
          SentenceTranslation,
          PrefetchHooks Function({bool sentenceId})
        > {
  $SentenceTranslationsTableManager(
    _$AppDatabase db,
    SentenceTranslations table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $SentenceTranslationsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $SentenceTranslationsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $SentenceTranslationsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> sentenceId = const Value.absent(),
                Value<String> locale = const Value.absent(),
                Value<String> translation = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SentenceTranslationsCompanion(
                sentenceId: sentenceId,
                locale: locale,
                translation: translation,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int sentenceId,
                required String locale,
                required String translation,
                Value<int> rowid = const Value.absent(),
              }) => SentenceTranslationsCompanion.insert(
                sentenceId: sentenceId,
                locale: locale,
                translation: translation,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $SentenceTranslationsReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sentenceId = false}) {
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
                    if (sentenceId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.sentenceId,
                                referencedTable: $SentenceTranslationsReferences
                                    ._sentenceIdTable(db),
                                referencedColumn:
                                    $SentenceTranslationsReferences
                                        ._sentenceIdTable(db)
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

typedef $SentenceTranslationsProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      SentenceTranslations,
      SentenceTranslation,
      $SentenceTranslationsFilterComposer,
      $SentenceTranslationsOrderingComposer,
      $SentenceTranslationsAnnotationComposer,
      $SentenceTranslationsCreateCompanionBuilder,
      $SentenceTranslationsUpdateCompanionBuilder,
      (SentenceTranslation, $SentenceTranslationsReferences),
      SentenceTranslation,
      PrefetchHooks Function({bool sentenceId})
    >;
typedef $ExercisesCreateCompanionBuilder =
    ExercisesCompanion Function({
      Value<int> id,
      required String locale,
      required String type,
      required String source,
      required int sourceId,
      required String prompt,
      required String answer,
      Value<String> distractors,
    });
typedef $ExercisesUpdateCompanionBuilder =
    ExercisesCompanion Function({
      Value<int> id,
      Value<String> locale,
      Value<String> type,
      Value<String> source,
      Value<int> sourceId,
      Value<String> prompt,
      Value<String> answer,
      Value<String> distractors,
    });

class $ExercisesFilterComposer extends Composer<_$AppDatabase, Exercises> {
  $ExercisesFilterComposer({
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
}

class $ExercisesOrderingComposer extends Composer<_$AppDatabase, Exercises> {
  $ExercisesOrderingComposer({
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
}

class $ExercisesAnnotationComposer extends Composer<_$AppDatabase, Exercises> {
  $ExercisesAnnotationComposer({
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
}

class $ExercisesTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          Exercises,
          Exercise,
          $ExercisesFilterComposer,
          $ExercisesOrderingComposer,
          $ExercisesAnnotationComposer,
          $ExercisesCreateCompanionBuilder,
          $ExercisesUpdateCompanionBuilder,
          (Exercise, BaseReferences<_$AppDatabase, Exercises, Exercise>),
          Exercise,
          PrefetchHooks Function()
        > {
  $ExercisesTableManager(_$AppDatabase db, Exercises table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $ExercisesFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $ExercisesOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $ExercisesAnnotationComposer($db: db, $table: table),
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
              }) => ExercisesCompanion(
                id: id,
                locale: locale,
                type: type,
                source: source,
                sourceId: sourceId,
                prompt: prompt,
                answer: answer,
                distractors: distractors,
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
              }) => ExercisesCompanion.insert(
                id: id,
                locale: locale,
                type: type,
                source: source,
                sourceId: sourceId,
                prompt: prompt,
                answer: answer,
                distractors: distractors,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $ExercisesProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      Exercises,
      Exercise,
      $ExercisesFilterComposer,
      $ExercisesOrderingComposer,
      $ExercisesAnnotationComposer,
      $ExercisesCreateCompanionBuilder,
      $ExercisesUpdateCompanionBuilder,
      (Exercise, BaseReferences<_$AppDatabase, Exercises, Exercise>),
      Exercise,
      PrefetchHooks Function()
    >;
typedef $GrammarLessonsCreateCompanionBuilder =
    GrammarLessonsCompanion Function({
      Value<int> id,
      Value<String> locale,
      required String level,
      required String path,
      Value<String> themeName,
      Value<String> themeDescription,
      required String chapter,
      required String title,
      required String blocksJson,
      required int orderIndex,
      Value<int> difficulty,
    });
typedef $GrammarLessonsUpdateCompanionBuilder =
    GrammarLessonsCompanion Function({
      Value<int> id,
      Value<String> locale,
      Value<String> level,
      Value<String> path,
      Value<String> themeName,
      Value<String> themeDescription,
      Value<String> chapter,
      Value<String> title,
      Value<String> blocksJson,
      Value<int> orderIndex,
      Value<int> difficulty,
    });

class $GrammarLessonsFilterComposer
    extends Composer<_$AppDatabase, GrammarLessons> {
  $GrammarLessonsFilterComposer({
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

  ColumnFilters<String> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get themeName => $composableBuilder(
    column: $table.themeName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get themeDescription => $composableBuilder(
    column: $table.themeDescription,
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

  ColumnFilters<String> get blocksJson => $composableBuilder(
    column: $table.blocksJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnFilters(column),
  );
}

class $GrammarLessonsOrderingComposer
    extends Composer<_$AppDatabase, GrammarLessons> {
  $GrammarLessonsOrderingComposer({
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

  ColumnOrderings<String> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get themeName => $composableBuilder(
    column: $table.themeName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get themeDescription => $composableBuilder(
    column: $table.themeDescription,
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

  ColumnOrderings<String> get blocksJson => $composableBuilder(
    column: $table.blocksJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnOrderings(column),
  );
}

class $GrammarLessonsAnnotationComposer
    extends Composer<_$AppDatabase, GrammarLessons> {
  $GrammarLessonsAnnotationComposer({
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

  GeneratedColumn<String> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<String> get path =>
      $composableBuilder(column: $table.path, builder: (column) => column);

  GeneratedColumn<String> get themeName =>
      $composableBuilder(column: $table.themeName, builder: (column) => column);

  GeneratedColumn<String> get themeDescription => $composableBuilder(
    column: $table.themeDescription,
    builder: (column) => column,
  );

  GeneratedColumn<String> get chapter =>
      $composableBuilder(column: $table.chapter, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get blocksJson => $composableBuilder(
    column: $table.blocksJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );

  GeneratedColumn<int> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => column,
  );
}

class $GrammarLessonsTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          GrammarLessons,
          GrammarLessonRow,
          $GrammarLessonsFilterComposer,
          $GrammarLessonsOrderingComposer,
          $GrammarLessonsAnnotationComposer,
          $GrammarLessonsCreateCompanionBuilder,
          $GrammarLessonsUpdateCompanionBuilder,
          (
            GrammarLessonRow,
            BaseReferences<_$AppDatabase, GrammarLessons, GrammarLessonRow>,
          ),
          GrammarLessonRow,
          PrefetchHooks Function()
        > {
  $GrammarLessonsTableManager(_$AppDatabase db, GrammarLessons table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $GrammarLessonsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $GrammarLessonsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $GrammarLessonsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> locale = const Value.absent(),
                Value<String> level = const Value.absent(),
                Value<String> path = const Value.absent(),
                Value<String> themeName = const Value.absent(),
                Value<String> themeDescription = const Value.absent(),
                Value<String> chapter = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> blocksJson = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<int> difficulty = const Value.absent(),
              }) => GrammarLessonsCompanion(
                id: id,
                locale: locale,
                level: level,
                path: path,
                themeName: themeName,
                themeDescription: themeDescription,
                chapter: chapter,
                title: title,
                blocksJson: blocksJson,
                orderIndex: orderIndex,
                difficulty: difficulty,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> locale = const Value.absent(),
                required String level,
                required String path,
                Value<String> themeName = const Value.absent(),
                Value<String> themeDescription = const Value.absent(),
                required String chapter,
                required String title,
                required String blocksJson,
                required int orderIndex,
                Value<int> difficulty = const Value.absent(),
              }) => GrammarLessonsCompanion.insert(
                id: id,
                locale: locale,
                level: level,
                path: path,
                themeName: themeName,
                themeDescription: themeDescription,
                chapter: chapter,
                title: title,
                blocksJson: blocksJson,
                orderIndex: orderIndex,
                difficulty: difficulty,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $GrammarLessonsProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      GrammarLessons,
      GrammarLessonRow,
      $GrammarLessonsFilterComposer,
      $GrammarLessonsOrderingComposer,
      $GrammarLessonsAnnotationComposer,
      $GrammarLessonsCreateCompanionBuilder,
      $GrammarLessonsUpdateCompanionBuilder,
      (
        GrammarLessonRow,
        BaseReferences<_$AppDatabase, GrammarLessons, GrammarLessonRow>,
      ),
      GrammarLessonRow,
      PrefetchHooks Function()
    >;
typedef $GrammarExercisesCreateCompanionBuilder =
    GrammarExercisesCompanion Function({
      Value<int> id,
      required String lessonPath,
      required int orderIndex,
      required String type,
      required String dataJson,
    });
typedef $GrammarExercisesUpdateCompanionBuilder =
    GrammarExercisesCompanion Function({
      Value<int> id,
      Value<String> lessonPath,
      Value<int> orderIndex,
      Value<String> type,
      Value<String> dataJson,
    });

class $GrammarExercisesFilterComposer
    extends Composer<_$AppDatabase, GrammarExercises> {
  $GrammarExercisesFilterComposer({
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

  ColumnFilters<String> get lessonPath => $composableBuilder(
    column: $table.lessonPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dataJson => $composableBuilder(
    column: $table.dataJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $GrammarExercisesOrderingComposer
    extends Composer<_$AppDatabase, GrammarExercises> {
  $GrammarExercisesOrderingComposer({
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

  ColumnOrderings<String> get lessonPath => $composableBuilder(
    column: $table.lessonPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dataJson => $composableBuilder(
    column: $table.dataJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $GrammarExercisesAnnotationComposer
    extends Composer<_$AppDatabase, GrammarExercises> {
  $GrammarExercisesAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get lessonPath => $composableBuilder(
    column: $table.lessonPath,
    builder: (column) => column,
  );

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get dataJson =>
      $composableBuilder(column: $table.dataJson, builder: (column) => column);
}

class $GrammarExercisesTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          GrammarExercises,
          GrammarExerciseRow,
          $GrammarExercisesFilterComposer,
          $GrammarExercisesOrderingComposer,
          $GrammarExercisesAnnotationComposer,
          $GrammarExercisesCreateCompanionBuilder,
          $GrammarExercisesUpdateCompanionBuilder,
          (
            GrammarExerciseRow,
            BaseReferences<_$AppDatabase, GrammarExercises, GrammarExerciseRow>,
          ),
          GrammarExerciseRow,
          PrefetchHooks Function()
        > {
  $GrammarExercisesTableManager(_$AppDatabase db, GrammarExercises table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $GrammarExercisesFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $GrammarExercisesOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $GrammarExercisesAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> lessonPath = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> dataJson = const Value.absent(),
              }) => GrammarExercisesCompanion(
                id: id,
                lessonPath: lessonPath,
                orderIndex: orderIndex,
                type: type,
                dataJson: dataJson,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String lessonPath,
                required int orderIndex,
                required String type,
                required String dataJson,
              }) => GrammarExercisesCompanion.insert(
                id: id,
                lessonPath: lessonPath,
                orderIndex: orderIndex,
                type: type,
                dataJson: dataJson,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $GrammarExercisesProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      GrammarExercises,
      GrammarExerciseRow,
      $GrammarExercisesFilterComposer,
      $GrammarExercisesOrderingComposer,
      $GrammarExercisesAnnotationComposer,
      $GrammarExercisesCreateCompanionBuilder,
      $GrammarExercisesUpdateCompanionBuilder,
      (
        GrammarExerciseRow,
        BaseReferences<_$AppDatabase, GrammarExercises, GrammarExerciseRow>,
      ),
      GrammarExerciseRow,
      PrefetchHooks Function()
    >;
typedef $GrammarLessonProgressCreateCompanionBuilder =
    GrammarLessonProgressCompanion Function({
      required String lessonPath,
      required DateTime readAt,
      Value<int> rowid,
    });
typedef $GrammarLessonProgressUpdateCompanionBuilder =
    GrammarLessonProgressCompanion Function({
      Value<String> lessonPath,
      Value<DateTime> readAt,
      Value<int> rowid,
    });

class $GrammarLessonProgressFilterComposer
    extends Composer<_$AppDatabase, GrammarLessonProgress> {
  $GrammarLessonProgressFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get lessonPath => $composableBuilder(
    column: $table.lessonPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get readAt => $composableBuilder(
    column: $table.readAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $GrammarLessonProgressOrderingComposer
    extends Composer<_$AppDatabase, GrammarLessonProgress> {
  $GrammarLessonProgressOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get lessonPath => $composableBuilder(
    column: $table.lessonPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get readAt => $composableBuilder(
    column: $table.readAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $GrammarLessonProgressAnnotationComposer
    extends Composer<_$AppDatabase, GrammarLessonProgress> {
  $GrammarLessonProgressAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get lessonPath => $composableBuilder(
    column: $table.lessonPath,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get readAt =>
      $composableBuilder(column: $table.readAt, builder: (column) => column);
}

class $GrammarLessonProgressTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          GrammarLessonProgress,
          GrammarLessonProgressRow,
          $GrammarLessonProgressFilterComposer,
          $GrammarLessonProgressOrderingComposer,
          $GrammarLessonProgressAnnotationComposer,
          $GrammarLessonProgressCreateCompanionBuilder,
          $GrammarLessonProgressUpdateCompanionBuilder,
          (
            GrammarLessonProgressRow,
            BaseReferences<
              _$AppDatabase,
              GrammarLessonProgress,
              GrammarLessonProgressRow
            >,
          ),
          GrammarLessonProgressRow,
          PrefetchHooks Function()
        > {
  $GrammarLessonProgressTableManager(
    _$AppDatabase db,
    GrammarLessonProgress table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $GrammarLessonProgressFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $GrammarLessonProgressOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $GrammarLessonProgressAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> lessonPath = const Value.absent(),
                Value<DateTime> readAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GrammarLessonProgressCompanion(
                lessonPath: lessonPath,
                readAt: readAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String lessonPath,
                required DateTime readAt,
                Value<int> rowid = const Value.absent(),
              }) => GrammarLessonProgressCompanion.insert(
                lessonPath: lessonPath,
                readAt: readAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $GrammarLessonProgressProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      GrammarLessonProgress,
      GrammarLessonProgressRow,
      $GrammarLessonProgressFilterComposer,
      $GrammarLessonProgressOrderingComposer,
      $GrammarLessonProgressAnnotationComposer,
      $GrammarLessonProgressCreateCompanionBuilder,
      $GrammarLessonProgressUpdateCompanionBuilder,
      (
        GrammarLessonProgressRow,
        BaseReferences<
          _$AppDatabase,
          GrammarLessonProgress,
          GrammarLessonProgressRow
        >,
      ),
      GrammarLessonProgressRow,
      PrefetchHooks Function()
    >;
typedef $GrammarLessonStartsCreateCompanionBuilder =
    GrammarLessonStartsCompanion Function({
      required String lessonPath,
      Value<int> rowid,
    });
typedef $GrammarLessonStartsUpdateCompanionBuilder =
    GrammarLessonStartsCompanion Function({
      Value<String> lessonPath,
      Value<int> rowid,
    });

class $GrammarLessonStartsFilterComposer
    extends Composer<_$AppDatabase, GrammarLessonStarts> {
  $GrammarLessonStartsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get lessonPath => $composableBuilder(
    column: $table.lessonPath,
    builder: (column) => ColumnFilters(column),
  );
}

class $GrammarLessonStartsOrderingComposer
    extends Composer<_$AppDatabase, GrammarLessonStarts> {
  $GrammarLessonStartsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get lessonPath => $composableBuilder(
    column: $table.lessonPath,
    builder: (column) => ColumnOrderings(column),
  );
}

class $GrammarLessonStartsAnnotationComposer
    extends Composer<_$AppDatabase, GrammarLessonStarts> {
  $GrammarLessonStartsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get lessonPath => $composableBuilder(
    column: $table.lessonPath,
    builder: (column) => column,
  );
}

class $GrammarLessonStartsTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          GrammarLessonStarts,
          GrammarLessonStartRow,
          $GrammarLessonStartsFilterComposer,
          $GrammarLessonStartsOrderingComposer,
          $GrammarLessonStartsAnnotationComposer,
          $GrammarLessonStartsCreateCompanionBuilder,
          $GrammarLessonStartsUpdateCompanionBuilder,
          (
            GrammarLessonStartRow,
            BaseReferences<
              _$AppDatabase,
              GrammarLessonStarts,
              GrammarLessonStartRow
            >,
          ),
          GrammarLessonStartRow,
          PrefetchHooks Function()
        > {
  $GrammarLessonStartsTableManager(_$AppDatabase db, GrammarLessonStarts table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $GrammarLessonStartsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $GrammarLessonStartsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $GrammarLessonStartsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> lessonPath = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GrammarLessonStartsCompanion(
                lessonPath: lessonPath,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String lessonPath,
                Value<int> rowid = const Value.absent(),
              }) => GrammarLessonStartsCompanion.insert(
                lessonPath: lessonPath,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $GrammarLessonStartsProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      GrammarLessonStarts,
      GrammarLessonStartRow,
      $GrammarLessonStartsFilterComposer,
      $GrammarLessonStartsOrderingComposer,
      $GrammarLessonStartsAnnotationComposer,
      $GrammarLessonStartsCreateCompanionBuilder,
      $GrammarLessonStartsUpdateCompanionBuilder,
      (
        GrammarLessonStartRow,
        BaseReferences<
          _$AppDatabase,
          GrammarLessonStarts,
          GrammarLessonStartRow
        >,
      ),
      GrammarLessonStartRow,
      PrefetchHooks Function()
    >;
typedef $GrammarChapterUnlocksCreateCompanionBuilder =
    GrammarChapterUnlocksCompanion Function({
      required String chapterKey,
      Value<int> rowid,
    });
typedef $GrammarChapterUnlocksUpdateCompanionBuilder =
    GrammarChapterUnlocksCompanion Function({
      Value<String> chapterKey,
      Value<int> rowid,
    });

class $GrammarChapterUnlocksFilterComposer
    extends Composer<_$AppDatabase, GrammarChapterUnlocks> {
  $GrammarChapterUnlocksFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get chapterKey => $composableBuilder(
    column: $table.chapterKey,
    builder: (column) => ColumnFilters(column),
  );
}

class $GrammarChapterUnlocksOrderingComposer
    extends Composer<_$AppDatabase, GrammarChapterUnlocks> {
  $GrammarChapterUnlocksOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get chapterKey => $composableBuilder(
    column: $table.chapterKey,
    builder: (column) => ColumnOrderings(column),
  );
}

class $GrammarChapterUnlocksAnnotationComposer
    extends Composer<_$AppDatabase, GrammarChapterUnlocks> {
  $GrammarChapterUnlocksAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get chapterKey => $composableBuilder(
    column: $table.chapterKey,
    builder: (column) => column,
  );
}

class $GrammarChapterUnlocksTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          GrammarChapterUnlocks,
          GrammarChapterUnlockRow,
          $GrammarChapterUnlocksFilterComposer,
          $GrammarChapterUnlocksOrderingComposer,
          $GrammarChapterUnlocksAnnotationComposer,
          $GrammarChapterUnlocksCreateCompanionBuilder,
          $GrammarChapterUnlocksUpdateCompanionBuilder,
          (
            GrammarChapterUnlockRow,
            BaseReferences<
              _$AppDatabase,
              GrammarChapterUnlocks,
              GrammarChapterUnlockRow
            >,
          ),
          GrammarChapterUnlockRow,
          PrefetchHooks Function()
        > {
  $GrammarChapterUnlocksTableManager(
    _$AppDatabase db,
    GrammarChapterUnlocks table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $GrammarChapterUnlocksFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $GrammarChapterUnlocksOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $GrammarChapterUnlocksAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> chapterKey = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GrammarChapterUnlocksCompanion(
                chapterKey: chapterKey,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String chapterKey,
                Value<int> rowid = const Value.absent(),
              }) => GrammarChapterUnlocksCompanion.insert(
                chapterKey: chapterKey,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $GrammarChapterUnlocksProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      GrammarChapterUnlocks,
      GrammarChapterUnlockRow,
      $GrammarChapterUnlocksFilterComposer,
      $GrammarChapterUnlocksOrderingComposer,
      $GrammarChapterUnlocksAnnotationComposer,
      $GrammarChapterUnlocksCreateCompanionBuilder,
      $GrammarChapterUnlocksUpdateCompanionBuilder,
      (
        GrammarChapterUnlockRow,
        BaseReferences<
          _$AppDatabase,
          GrammarChapterUnlocks,
          GrammarChapterUnlockRow
        >,
      ),
      GrammarChapterUnlockRow,
      PrefetchHooks Function()
    >;
typedef $ProgressEntriesCreateCompanionBuilder =
    ProgressEntriesCompanion Function({
      Value<int> id,
      required String itemType,
      required int itemId,
      required bool isKnown,
      required DateTime toggledAt,
    });
typedef $ProgressEntriesUpdateCompanionBuilder =
    ProgressEntriesCompanion Function({
      Value<int> id,
      Value<String> itemType,
      Value<int> itemId,
      Value<bool> isKnown,
      Value<DateTime> toggledAt,
    });

class $ProgressEntriesFilterComposer
    extends Composer<_$AppDatabase, ProgressEntries> {
  $ProgressEntriesFilterComposer({
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

class $ProgressEntriesOrderingComposer
    extends Composer<_$AppDatabase, ProgressEntries> {
  $ProgressEntriesOrderingComposer({
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

class $ProgressEntriesAnnotationComposer
    extends Composer<_$AppDatabase, ProgressEntries> {
  $ProgressEntriesAnnotationComposer({
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

class $ProgressEntriesTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          ProgressEntries,
          ProgressEntry,
          $ProgressEntriesFilterComposer,
          $ProgressEntriesOrderingComposer,
          $ProgressEntriesAnnotationComposer,
          $ProgressEntriesCreateCompanionBuilder,
          $ProgressEntriesUpdateCompanionBuilder,
          (
            ProgressEntry,
            BaseReferences<_$AppDatabase, ProgressEntries, ProgressEntry>,
          ),
          ProgressEntry,
          PrefetchHooks Function()
        > {
  $ProgressEntriesTableManager(_$AppDatabase db, ProgressEntries table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $ProgressEntriesFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $ProgressEntriesOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $ProgressEntriesAnnotationComposer($db: db, $table: table),
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

typedef $ProgressEntriesProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      ProgressEntries,
      ProgressEntry,
      $ProgressEntriesFilterComposer,
      $ProgressEntriesOrderingComposer,
      $ProgressEntriesAnnotationComposer,
      $ProgressEntriesCreateCompanionBuilder,
      $ProgressEntriesUpdateCompanionBuilder,
      (
        ProgressEntry,
        BaseReferences<_$AppDatabase, ProgressEntries, ProgressEntry>,
      ),
      ProgressEntry,
      PrefetchHooks Function()
    >;
typedef $SrsCardsCreateCompanionBuilder =
    SrsCardsCompanion Function({
      required String itemType,
      required int itemId,
      required DateTime due,
      Value<DateTime?> firstSeenAt,
      required String cardJson,
      Value<int> rowid,
    });
typedef $SrsCardsUpdateCompanionBuilder =
    SrsCardsCompanion Function({
      Value<String> itemType,
      Value<int> itemId,
      Value<DateTime> due,
      Value<DateTime?> firstSeenAt,
      Value<String> cardJson,
      Value<int> rowid,
    });

class $SrsCardsFilterComposer extends Composer<_$AppDatabase, SrsCards> {
  $SrsCardsFilterComposer({
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

  ColumnFilters<DateTime> get firstSeenAt => $composableBuilder(
    column: $table.firstSeenAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cardJson => $composableBuilder(
    column: $table.cardJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $SrsCardsOrderingComposer extends Composer<_$AppDatabase, SrsCards> {
  $SrsCardsOrderingComposer({
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

  ColumnOrderings<DateTime> get firstSeenAt => $composableBuilder(
    column: $table.firstSeenAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cardJson => $composableBuilder(
    column: $table.cardJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $SrsCardsAnnotationComposer extends Composer<_$AppDatabase, SrsCards> {
  $SrsCardsAnnotationComposer({
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

  GeneratedColumn<DateTime> get firstSeenAt => $composableBuilder(
    column: $table.firstSeenAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cardJson =>
      $composableBuilder(column: $table.cardJson, builder: (column) => column);
}

class $SrsCardsTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          SrsCards,
          SrsCard,
          $SrsCardsFilterComposer,
          $SrsCardsOrderingComposer,
          $SrsCardsAnnotationComposer,
          $SrsCardsCreateCompanionBuilder,
          $SrsCardsUpdateCompanionBuilder,
          (SrsCard, BaseReferences<_$AppDatabase, SrsCards, SrsCard>),
          SrsCard,
          PrefetchHooks Function()
        > {
  $SrsCardsTableManager(_$AppDatabase db, SrsCards table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $SrsCardsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $SrsCardsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $SrsCardsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> itemType = const Value.absent(),
                Value<int> itemId = const Value.absent(),
                Value<DateTime> due = const Value.absent(),
                Value<DateTime?> firstSeenAt = const Value.absent(),
                Value<String> cardJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SrsCardsCompanion(
                itemType: itemType,
                itemId: itemId,
                due: due,
                firstSeenAt: firstSeenAt,
                cardJson: cardJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String itemType,
                required int itemId,
                required DateTime due,
                Value<DateTime?> firstSeenAt = const Value.absent(),
                required String cardJson,
                Value<int> rowid = const Value.absent(),
              }) => SrsCardsCompanion.insert(
                itemType: itemType,
                itemId: itemId,
                due: due,
                firstSeenAt: firstSeenAt,
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

typedef $SrsCardsProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      SrsCards,
      SrsCard,
      $SrsCardsFilterComposer,
      $SrsCardsOrderingComposer,
      $SrsCardsAnnotationComposer,
      $SrsCardsCreateCompanionBuilder,
      $SrsCardsUpdateCompanionBuilder,
      (SrsCard, BaseReferences<_$AppDatabase, SrsCards, SrsCard>),
      SrsCard,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $KanjisTableManager get kanjis => $KanjisTableManager(_db, _db.kanjis);
  $KanasTableManager get kanas => $KanasTableManager(_db, _db.kanas);
  $VocabularyEntriesTableManager get vocabularyEntries =>
      $VocabularyEntriesTableManager(_db, _db.vocabularyEntries);
  $KanjiTranslationsTableManager get kanjiTranslations =>
      $KanjiTranslationsTableManager(_db, _db.kanjiTranslations);
  $VocabularyTranslationsTableManager get vocabularyTranslations =>
      $VocabularyTranslationsTableManager(_db, _db.vocabularyTranslations);
  $SentencesTableManager get sentences =>
      $SentencesTableManager(_db, _db.sentences);
  $SentenceTranslationsTableManager get sentenceTranslations =>
      $SentenceTranslationsTableManager(_db, _db.sentenceTranslations);
  $ExercisesTableManager get exercises =>
      $ExercisesTableManager(_db, _db.exercises);
  $GrammarLessonsTableManager get grammarLessons =>
      $GrammarLessonsTableManager(_db, _db.grammarLessons);
  $GrammarExercisesTableManager get grammarExercises =>
      $GrammarExercisesTableManager(_db, _db.grammarExercises);
  $GrammarLessonProgressTableManager get grammarLessonProgress =>
      $GrammarLessonProgressTableManager(_db, _db.grammarLessonProgress);
  $GrammarLessonStartsTableManager get grammarLessonStarts =>
      $GrammarLessonStartsTableManager(_db, _db.grammarLessonStarts);
  $GrammarChapterUnlocksTableManager get grammarChapterUnlocks =>
      $GrammarChapterUnlocksTableManager(_db, _db.grammarChapterUnlocks);
  $ProgressEntriesTableManager get progressEntries =>
      $ProgressEntriesTableManager(_db, _db.progressEntries);
  $SrsCardsTableManager get srsCards =>
      $SrsCardsTableManager(_db, _db.srsCards);
}
