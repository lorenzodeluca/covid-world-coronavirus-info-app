// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String name;

  final List<Migration> _migrations = [];

  Callback _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? join(await sqflite.getDatabasesPath(), name)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String> listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  HttpDataDao _httpDataDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback callback]) async {
    return sqflite.openDatabase(
      path,
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `HttpData` (`id` INTEGER, `apiName` TEXT, `data` TEXT, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
  }

  @override
  HttpDataDao get httpDataDao {
    return _httpDataDaoInstance ??= _$HttpDataDao(database, changeListener);
  }
}

class _$HttpDataDao extends HttpDataDao {
  _$HttpDataDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _httpDataInsertionAdapter = InsertionAdapter(
            database,
            'HttpData',
            (HttpData item) => <String, dynamic>{
                  'id': item.id,
                  'apiName': item.apiName,
                  'data': item.data
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  static final _httpDataMapper = (Map<String, dynamic> row) => HttpData(
      row['id'] as int, row['data'] as String, row['apiName'] as String);

  final InsertionAdapter<HttpData> _httpDataInsertionAdapter;

  @override
  Future<List<HttpData>> getAll() async {
    return _queryAdapter.queryList('SELECT * FROM HttpData',
        mapper: _httpDataMapper);
  }

  @override
  Future<HttpData> findDataByApi(String api) async {
    return _queryAdapter.query('SELECT * FROM HttpData WHERE apiName = ?',
        arguments: <dynamic>[api], mapper: _httpDataMapper);
  }

  @override
  Future<void> clean() async {
    await _queryAdapter.queryNoReturn('DELETE FROM HttpData');
  }

  @override
  Future<void> insertApi(HttpData data) async {
    await _httpDataInsertionAdapter.insert(
        data, sqflite.ConflictAlgorithm.abort);
  }
}
