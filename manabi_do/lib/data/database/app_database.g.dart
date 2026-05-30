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
  static const VerificationMeta _strokeSvgMeta = const VerificationMeta(
    'strokeSvg',
  );
  @override
  late final GeneratedColumn<String> strokeSvg = GeneratedColumn<String>(
    'stroke_svg',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    character,
    meaning,
    onReading,
    kunReading,
    jlptLevel,
    strokeSvg,
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
    if (data.containsKey('stroke_svg')) {
      context.handle(
        _strokeSvgMeta,
        strokeSvg.isAcceptableOrUnknown(data['stroke_svg']!, _strokeSvgMeta),
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
      strokeSvg: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}stroke_svg'],
      ),
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
  final String? strokeSvg;
  const Kanji({
    required this.id,
    required this.character,
    required this.meaning,
    required this.onReading,
    required this.kunReading,
    required this.jlptLevel,
    this.strokeSvg,
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
    if (!nullToAbsent || strokeSvg != null) {
      map['stroke_svg'] = Variable<String>(strokeSvg);
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
      strokeSvg: strokeSvg == null && nullToAbsent
          ? const Value.absent()
          : Value(strokeSvg),
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
      strokeSvg: serializer.fromJson<String?>(json['strokeSvg']),
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
      'strokeSvg': serializer.toJson<String?>(strokeSvg),
    };
  }

  Kanji copyWith({
    int? id,
    String? character,
    String? meaning,
    String? onReading,
    String? kunReading,
    String? jlptLevel,
    Value<String?> strokeSvg = const Value.absent(),
  }) => Kanji(
    id: id ?? this.id,
    character: character ?? this.character,
    meaning: meaning ?? this.meaning,
    onReading: onReading ?? this.onReading,
    kunReading: kunReading ?? this.kunReading,
    jlptLevel: jlptLevel ?? this.jlptLevel,
    strokeSvg: strokeSvg.present ? strokeSvg.value : this.strokeSvg,
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
      strokeSvg: data.strokeSvg.present ? data.strokeSvg.value : this.strokeSvg,
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
          ..write('strokeSvg: $strokeSvg')
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
    strokeSvg,
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
          other.strokeSvg == this.strokeSvg);
}

class KanjisCompanion extends UpdateCompanion<Kanji> {
  final Value<int> id;
  final Value<String> character;
  final Value<String> meaning;
  final Value<String> onReading;
  final Value<String> kunReading;
  final Value<String> jlptLevel;
  final Value<String?> strokeSvg;
  const KanjisCompanion({
    this.id = const Value.absent(),
    this.character = const Value.absent(),
    this.meaning = const Value.absent(),
    this.onReading = const Value.absent(),
    this.kunReading = const Value.absent(),
    this.jlptLevel = const Value.absent(),
    this.strokeSvg = const Value.absent(),
  });
  KanjisCompanion.insert({
    this.id = const Value.absent(),
    required String character,
    required String meaning,
    required String onReading,
    required String kunReading,
    required String jlptLevel,
    this.strokeSvg = const Value.absent(),
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
    Expression<String>? strokeSvg,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (character != null) 'character': character,
      if (meaning != null) 'meaning': meaning,
      if (onReading != null) 'on_reading': onReading,
      if (kunReading != null) 'kun_reading': kunReading,
      if (jlptLevel != null) 'jlpt_level': jlptLevel,
      if (strokeSvg != null) 'stroke_svg': strokeSvg,
    });
  }

  KanjisCompanion copyWith({
    Value<int>? id,
    Value<String>? character,
    Value<String>? meaning,
    Value<String>? onReading,
    Value<String>? kunReading,
    Value<String>? jlptLevel,
    Value<String?>? strokeSvg,
  }) {
    return KanjisCompanion(
      id: id ?? this.id,
      character: character ?? this.character,
      meaning: meaning ?? this.meaning,
      onReading: onReading ?? this.onReading,
      kunReading: kunReading ?? this.kunReading,
      jlptLevel: jlptLevel ?? this.jlptLevel,
      strokeSvg: strokeSvg ?? this.strokeSvg,
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
    if (strokeSvg.present) {
      map['stroke_svg'] = Variable<String>(strokeSvg.value);
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
          ..write('strokeSvg: $strokeSvg')
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
  @override
  List<GeneratedColumn> get $columns => [id, character, romaji, type, row];
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
  const Kana({
    required this.id,
    required this.character,
    required this.romaji,
    required this.type,
    required this.row,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['character'] = Variable<String>(character);
    map['romaji'] = Variable<String>(romaji);
    map['type'] = Variable<String>(type);
    map['row'] = Variable<String>(row);
    return map;
  }

  KanasCompanion toCompanion(bool nullToAbsent) {
    return KanasCompanion(
      id: Value(id),
      character: Value(character),
      romaji: Value(romaji),
      type: Value(type),
      row: Value(row),
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
    };
  }

  Kana copyWith({
    int? id,
    String? character,
    String? romaji,
    String? type,
    String? row,
  }) => Kana(
    id: id ?? this.id,
    character: character ?? this.character,
    romaji: romaji ?? this.romaji,
    type: type ?? this.type,
    row: row ?? this.row,
  );
  Kana copyWithCompanion(KanasCompanion data) {
    return Kana(
      id: data.id.present ? data.id.value : this.id,
      character: data.character.present ? data.character.value : this.character,
      romaji: data.romaji.present ? data.romaji.value : this.romaji,
      type: data.type.present ? data.type.value : this.type,
      row: data.row.present ? data.row.value : this.row,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Kana(')
          ..write('id: $id, ')
          ..write('character: $character, ')
          ..write('romaji: $romaji, ')
          ..write('type: $type, ')
          ..write('row: $row')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, character, romaji, type, row);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Kana &&
          other.id == this.id &&
          other.character == this.character &&
          other.romaji == this.romaji &&
          other.type == this.type &&
          other.row == this.row);
}

class KanasCompanion extends UpdateCompanion<Kana> {
  final Value<int> id;
  final Value<String> character;
  final Value<String> romaji;
  final Value<String> type;
  final Value<String> row;
  const KanasCompanion({
    this.id = const Value.absent(),
    this.character = const Value.absent(),
    this.romaji = const Value.absent(),
    this.type = const Value.absent(),
    this.row = const Value.absent(),
  });
  KanasCompanion.insert({
    this.id = const Value.absent(),
    required String character,
    required String romaji,
    required String type,
    required String row,
  }) : character = Value(character),
       romaji = Value(romaji),
       type = Value(type),
       row = Value(row);
  static Insertable<Kana> custom({
    Expression<int>? id,
    Expression<String>? character,
    Expression<String>? romaji,
    Expression<String>? type,
    Expression<String>? row,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (character != null) 'character': character,
      if (romaji != null) 'romaji': romaji,
      if (type != null) 'type': type,
      if (row != null) 'row': row,
    });
  }

  KanasCompanion copyWith({
    Value<int>? id,
    Value<String>? character,
    Value<String>? romaji,
    Value<String>? type,
    Value<String>? row,
  }) {
    return KanasCompanion(
      id: id ?? this.id,
      character: character ?? this.character,
      romaji: romaji ?? this.romaji,
      type: type ?? this.type,
      row: row ?? this.row,
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
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KanasCompanion(')
          ..write('id: $id, ')
          ..write('character: $character, ')
          ..write('romaji: $romaji, ')
          ..write('type: $type, ')
          ..write('row: $row')
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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $KanjisTable kanjis = $KanjisTable(this);
  late final $KanasTable kanas = $KanasTable(this);
  late final $GrammarLessonsTable grammarLessons = $GrammarLessonsTable(this);
  late final $ExercisesTable exercises = $ExercisesTable(this);
  late final $ProgressEntriesTable progressEntries = $ProgressEntriesTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    kanjis,
    kanas,
    grammarLessons,
    exercises,
    progressEntries,
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
      Value<String?> strokeSvg,
    });
typedef $$KanjisTableUpdateCompanionBuilder =
    KanjisCompanion Function({
      Value<int> id,
      Value<String> character,
      Value<String> meaning,
      Value<String> onReading,
      Value<String> kunReading,
      Value<String> jlptLevel,
      Value<String?> strokeSvg,
    });

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

  ColumnFilters<String> get strokeSvg => $composableBuilder(
    column: $table.strokeSvg,
    builder: (column) => ColumnFilters(column),
  );
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

  ColumnOrderings<String> get strokeSvg => $composableBuilder(
    column: $table.strokeSvg,
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

  GeneratedColumn<String> get strokeSvg =>
      $composableBuilder(column: $table.strokeSvg, builder: (column) => column);
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
          (Kanji, BaseReferences<_$AppDatabase, $KanjisTable, Kanji>),
          Kanji,
          PrefetchHooks Function()
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
                Value<String?> strokeSvg = const Value.absent(),
              }) => KanjisCompanion(
                id: id,
                character: character,
                meaning: meaning,
                onReading: onReading,
                kunReading: kunReading,
                jlptLevel: jlptLevel,
                strokeSvg: strokeSvg,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String character,
                required String meaning,
                required String onReading,
                required String kunReading,
                required String jlptLevel,
                Value<String?> strokeSvg = const Value.absent(),
              }) => KanjisCompanion.insert(
                id: id,
                character: character,
                meaning: meaning,
                onReading: onReading,
                kunReading: kunReading,
                jlptLevel: jlptLevel,
                strokeSvg: strokeSvg,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
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
      (Kanji, BaseReferences<_$AppDatabase, $KanjisTable, Kanji>),
      Kanji,
      PrefetchHooks Function()
    >;
typedef $$KanasTableCreateCompanionBuilder =
    KanasCompanion Function({
      Value<int> id,
      required String character,
      required String romaji,
      required String type,
      required String row,
    });
typedef $$KanasTableUpdateCompanionBuilder =
    KanasCompanion Function({
      Value<int> id,
      Value<String> character,
      Value<String> romaji,
      Value<String> type,
      Value<String> row,
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
              }) => KanasCompanion(
                id: id,
                character: character,
                romaji: romaji,
                type: type,
                row: row,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String character,
                required String romaji,
                required String type,
                required String row,
              }) => KanasCompanion.insert(
                id: id,
                character: character,
                romaji: romaji,
                type: type,
                row: row,
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

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$KanjisTableTableManager get kanjis =>
      $$KanjisTableTableManager(_db, _db.kanjis);
  $$KanasTableTableManager get kanas =>
      $$KanasTableTableManager(_db, _db.kanas);
  $$GrammarLessonsTableTableManager get grammarLessons =>
      $$GrammarLessonsTableTableManager(_db, _db.grammarLessons);
  $$ExercisesTableTableManager get exercises =>
      $$ExercisesTableTableManager(_db, _db.exercises);
  $$ProgressEntriesTableTableManager get progressEntries =>
      $$ProgressEntriesTableTableManager(_db, _db.progressEntries);
}
