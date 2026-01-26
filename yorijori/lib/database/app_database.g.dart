// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $RecipesTable extends Recipes
    with TableInfo<$RecipesTable, RecipeEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecipesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _youtubeIdMeta = const VerificationMeta(
    'youtubeId',
  );
  @override
  late final GeneratedColumn<String> youtubeId = GeneratedColumn<String>(
    'youtube_id',
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
  static const VerificationMeta _channelNameMeta = const VerificationMeta(
    'channelName',
  );
  @override
  late final GeneratedColumn<String> channelName = GeneratedColumn<String>(
    'channel_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _thumbnailUrlMeta = const VerificationMeta(
    'thumbnailUrl',
  );
  @override
  late final GeneratedColumn<String> thumbnailUrl = GeneratedColumn<String>(
    'thumbnail_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ingredientsMeta = const VerificationMeta(
    'ingredients',
  );
  @override
  late final GeneratedColumn<String> ingredients = GeneratedColumn<String>(
    'ingredients',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stepsMeta = const VerificationMeta('steps');
  @override
  late final GeneratedColumn<String> steps = GeneratedColumn<String>(
    'steps',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    youtubeId,
    title,
    channelName,
    thumbnailUrl,
    ingredients,
    steps,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recipes';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecipeEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('youtube_id')) {
      context.handle(
        _youtubeIdMeta,
        youtubeId.isAcceptableOrUnknown(data['youtube_id']!, _youtubeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_youtubeIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('channel_name')) {
      context.handle(
        _channelNameMeta,
        channelName.isAcceptableOrUnknown(
          data['channel_name']!,
          _channelNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_channelNameMeta);
    }
    if (data.containsKey('thumbnail_url')) {
      context.handle(
        _thumbnailUrlMeta,
        thumbnailUrl.isAcceptableOrUnknown(
          data['thumbnail_url']!,
          _thumbnailUrlMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_thumbnailUrlMeta);
    }
    if (data.containsKey('ingredients')) {
      context.handle(
        _ingredientsMeta,
        ingredients.isAcceptableOrUnknown(
          data['ingredients']!,
          _ingredientsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ingredientsMeta);
    }
    if (data.containsKey('steps')) {
      context.handle(
        _stepsMeta,
        steps.isAcceptableOrUnknown(data['steps']!, _stepsMeta),
      );
    } else if (isInserting) {
      context.missing(_stepsMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecipeEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecipeEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      youtubeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}youtube_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      channelName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}channel_name'],
      )!,
      thumbnailUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}thumbnail_url'],
      )!,
      ingredients: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ingredients'],
      )!,
      steps: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}steps'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $RecipesTable createAlias(String alias) {
    return $RecipesTable(attachedDatabase, alias);
  }
}

class RecipeEntity extends DataClass implements Insertable<RecipeEntity> {
  final int id;
  final String youtubeId;
  final String title;
  final String channelName;
  final String thumbnailUrl;
  final String ingredients;
  final String steps;
  final String createdAt;
  const RecipeEntity({
    required this.id,
    required this.youtubeId,
    required this.title,
    required this.channelName,
    required this.thumbnailUrl,
    required this.ingredients,
    required this.steps,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['youtube_id'] = Variable<String>(youtubeId);
    map['title'] = Variable<String>(title);
    map['channel_name'] = Variable<String>(channelName);
    map['thumbnail_url'] = Variable<String>(thumbnailUrl);
    map['ingredients'] = Variable<String>(ingredients);
    map['steps'] = Variable<String>(steps);
    map['created_at'] = Variable<String>(createdAt);
    return map;
  }

  RecipesCompanion toCompanion(bool nullToAbsent) {
    return RecipesCompanion(
      id: Value(id),
      youtubeId: Value(youtubeId),
      title: Value(title),
      channelName: Value(channelName),
      thumbnailUrl: Value(thumbnailUrl),
      ingredients: Value(ingredients),
      steps: Value(steps),
      createdAt: Value(createdAt),
    );
  }

  factory RecipeEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecipeEntity(
      id: serializer.fromJson<int>(json['id']),
      youtubeId: serializer.fromJson<String>(json['youtubeId']),
      title: serializer.fromJson<String>(json['title']),
      channelName: serializer.fromJson<String>(json['channelName']),
      thumbnailUrl: serializer.fromJson<String>(json['thumbnailUrl']),
      ingredients: serializer.fromJson<String>(json['ingredients']),
      steps: serializer.fromJson<String>(json['steps']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'youtubeId': serializer.toJson<String>(youtubeId),
      'title': serializer.toJson<String>(title),
      'channelName': serializer.toJson<String>(channelName),
      'thumbnailUrl': serializer.toJson<String>(thumbnailUrl),
      'ingredients': serializer.toJson<String>(ingredients),
      'steps': serializer.toJson<String>(steps),
      'createdAt': serializer.toJson<String>(createdAt),
    };
  }

  RecipeEntity copyWith({
    int? id,
    String? youtubeId,
    String? title,
    String? channelName,
    String? thumbnailUrl,
    String? ingredients,
    String? steps,
    String? createdAt,
  }) => RecipeEntity(
    id: id ?? this.id,
    youtubeId: youtubeId ?? this.youtubeId,
    title: title ?? this.title,
    channelName: channelName ?? this.channelName,
    thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
    ingredients: ingredients ?? this.ingredients,
    steps: steps ?? this.steps,
    createdAt: createdAt ?? this.createdAt,
  );
  RecipeEntity copyWithCompanion(RecipesCompanion data) {
    return RecipeEntity(
      id: data.id.present ? data.id.value : this.id,
      youtubeId: data.youtubeId.present ? data.youtubeId.value : this.youtubeId,
      title: data.title.present ? data.title.value : this.title,
      channelName: data.channelName.present
          ? data.channelName.value
          : this.channelName,
      thumbnailUrl: data.thumbnailUrl.present
          ? data.thumbnailUrl.value
          : this.thumbnailUrl,
      ingredients: data.ingredients.present
          ? data.ingredients.value
          : this.ingredients,
      steps: data.steps.present ? data.steps.value : this.steps,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecipeEntity(')
          ..write('id: $id, ')
          ..write('youtubeId: $youtubeId, ')
          ..write('title: $title, ')
          ..write('channelName: $channelName, ')
          ..write('thumbnailUrl: $thumbnailUrl, ')
          ..write('ingredients: $ingredients, ')
          ..write('steps: $steps, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    youtubeId,
    title,
    channelName,
    thumbnailUrl,
    ingredients,
    steps,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecipeEntity &&
          other.id == this.id &&
          other.youtubeId == this.youtubeId &&
          other.title == this.title &&
          other.channelName == this.channelName &&
          other.thumbnailUrl == this.thumbnailUrl &&
          other.ingredients == this.ingredients &&
          other.steps == this.steps &&
          other.createdAt == this.createdAt);
}

class RecipesCompanion extends UpdateCompanion<RecipeEntity> {
  final Value<int> id;
  final Value<String> youtubeId;
  final Value<String> title;
  final Value<String> channelName;
  final Value<String> thumbnailUrl;
  final Value<String> ingredients;
  final Value<String> steps;
  final Value<String> createdAt;
  const RecipesCompanion({
    this.id = const Value.absent(),
    this.youtubeId = const Value.absent(),
    this.title = const Value.absent(),
    this.channelName = const Value.absent(),
    this.thumbnailUrl = const Value.absent(),
    this.ingredients = const Value.absent(),
    this.steps = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  RecipesCompanion.insert({
    this.id = const Value.absent(),
    required String youtubeId,
    required String title,
    required String channelName,
    required String thumbnailUrl,
    required String ingredients,
    required String steps,
    required String createdAt,
  }) : youtubeId = Value(youtubeId),
       title = Value(title),
       channelName = Value(channelName),
       thumbnailUrl = Value(thumbnailUrl),
       ingredients = Value(ingredients),
       steps = Value(steps),
       createdAt = Value(createdAt);
  static Insertable<RecipeEntity> custom({
    Expression<int>? id,
    Expression<String>? youtubeId,
    Expression<String>? title,
    Expression<String>? channelName,
    Expression<String>? thumbnailUrl,
    Expression<String>? ingredients,
    Expression<String>? steps,
    Expression<String>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (youtubeId != null) 'youtube_id': youtubeId,
      if (title != null) 'title': title,
      if (channelName != null) 'channel_name': channelName,
      if (thumbnailUrl != null) 'thumbnail_url': thumbnailUrl,
      if (ingredients != null) 'ingredients': ingredients,
      if (steps != null) 'steps': steps,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  RecipesCompanion copyWith({
    Value<int>? id,
    Value<String>? youtubeId,
    Value<String>? title,
    Value<String>? channelName,
    Value<String>? thumbnailUrl,
    Value<String>? ingredients,
    Value<String>? steps,
    Value<String>? createdAt,
  }) {
    return RecipesCompanion(
      id: id ?? this.id,
      youtubeId: youtubeId ?? this.youtubeId,
      title: title ?? this.title,
      channelName: channelName ?? this.channelName,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (youtubeId.present) {
      map['youtube_id'] = Variable<String>(youtubeId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (channelName.present) {
      map['channel_name'] = Variable<String>(channelName.value);
    }
    if (thumbnailUrl.present) {
      map['thumbnail_url'] = Variable<String>(thumbnailUrl.value);
    }
    if (ingredients.present) {
      map['ingredients'] = Variable<String>(ingredients.value);
    }
    if (steps.present) {
      map['steps'] = Variable<String>(steps.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecipesCompanion(')
          ..write('id: $id, ')
          ..write('youtubeId: $youtubeId, ')
          ..write('title: $title, ')
          ..write('channelName: $channelName, ')
          ..write('thumbnailUrl: $thumbnailUrl, ')
          ..write('ingredients: $ingredients, ')
          ..write('steps: $steps, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $RecipesTable recipes = $RecipesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [recipes];
}

typedef $$RecipesTableCreateCompanionBuilder =
    RecipesCompanion Function({
      Value<int> id,
      required String youtubeId,
      required String title,
      required String channelName,
      required String thumbnailUrl,
      required String ingredients,
      required String steps,
      required String createdAt,
    });
typedef $$RecipesTableUpdateCompanionBuilder =
    RecipesCompanion Function({
      Value<int> id,
      Value<String> youtubeId,
      Value<String> title,
      Value<String> channelName,
      Value<String> thumbnailUrl,
      Value<String> ingredients,
      Value<String> steps,
      Value<String> createdAt,
    });

class $$RecipesTableFilterComposer
    extends Composer<_$AppDatabase, $RecipesTable> {
  $$RecipesTableFilterComposer({
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

  ColumnFilters<String> get youtubeId => $composableBuilder(
    column: $table.youtubeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get channelName => $composableBuilder(
    column: $table.channelName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get thumbnailUrl => $composableBuilder(
    column: $table.thumbnailUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ingredients => $composableBuilder(
    column: $table.ingredients,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get steps => $composableBuilder(
    column: $table.steps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RecipesTableOrderingComposer
    extends Composer<_$AppDatabase, $RecipesTable> {
  $$RecipesTableOrderingComposer({
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

  ColumnOrderings<String> get youtubeId => $composableBuilder(
    column: $table.youtubeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get channelName => $composableBuilder(
    column: $table.channelName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get thumbnailUrl => $composableBuilder(
    column: $table.thumbnailUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ingredients => $composableBuilder(
    column: $table.ingredients,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get steps => $composableBuilder(
    column: $table.steps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RecipesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecipesTable> {
  $$RecipesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get youtubeId =>
      $composableBuilder(column: $table.youtubeId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get channelName => $composableBuilder(
    column: $table.channelName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get thumbnailUrl => $composableBuilder(
    column: $table.thumbnailUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ingredients => $composableBuilder(
    column: $table.ingredients,
    builder: (column) => column,
  );

  GeneratedColumn<String> get steps =>
      $composableBuilder(column: $table.steps, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$RecipesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecipesTable,
          RecipeEntity,
          $$RecipesTableFilterComposer,
          $$RecipesTableOrderingComposer,
          $$RecipesTableAnnotationComposer,
          $$RecipesTableCreateCompanionBuilder,
          $$RecipesTableUpdateCompanionBuilder,
          (
            RecipeEntity,
            BaseReferences<_$AppDatabase, $RecipesTable, RecipeEntity>,
          ),
          RecipeEntity,
          PrefetchHooks Function()
        > {
  $$RecipesTableTableManager(_$AppDatabase db, $RecipesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecipesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecipesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecipesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> youtubeId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> channelName = const Value.absent(),
                Value<String> thumbnailUrl = const Value.absent(),
                Value<String> ingredients = const Value.absent(),
                Value<String> steps = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
              }) => RecipesCompanion(
                id: id,
                youtubeId: youtubeId,
                title: title,
                channelName: channelName,
                thumbnailUrl: thumbnailUrl,
                ingredients: ingredients,
                steps: steps,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String youtubeId,
                required String title,
                required String channelName,
                required String thumbnailUrl,
                required String ingredients,
                required String steps,
                required String createdAt,
              }) => RecipesCompanion.insert(
                id: id,
                youtubeId: youtubeId,
                title: title,
                channelName: channelName,
                thumbnailUrl: thumbnailUrl,
                ingredients: ingredients,
                steps: steps,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RecipesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecipesTable,
      RecipeEntity,
      $$RecipesTableFilterComposer,
      $$RecipesTableOrderingComposer,
      $$RecipesTableAnnotationComposer,
      $$RecipesTableCreateCompanionBuilder,
      $$RecipesTableUpdateCompanionBuilder,
      (
        RecipeEntity,
        BaseReferences<_$AppDatabase, $RecipesTable, RecipeEntity>,
      ),
      RecipeEntity,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$RecipesTableTableManager get recipes =>
      $$RecipesTableTableManager(_db, _db.recipes);
}
