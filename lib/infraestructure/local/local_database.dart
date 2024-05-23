import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _databaseName = "MyDatabase.db";
  static final _databaseVersion = 1;

  static final table = 'task';

  static final columnUuid = 'uuid';
  static final columnTitle = 'title';
  static final columnDescription = 'description';
  static final columnState = 'state';
  static final columnPriority = 'priority';
  static final columnNotificationTime = 'notificationTime';
  static final columnUserUUID = 'userUUID';
  static final columnIsSynced = 'isSynced';

  // Singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Database reference
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Open the database
  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnUuid TEXT PRIMARY KEY,
            $columnTitle TEXT NOT NULL,
            $columnDescription TEXT NOT NULL,
            $columnState TEXT NOT NULL,
            $columnPriority TEXT NOT NULL,
            $columnNotificationTime TEXT NOT NULL,
            $columnUserUUID TEXT NOT NULL,
            $columnIsSynced INTEGER NOT NULL
          )
          ''');
  }

  // CRUD operations: Create, Read, Update, Delete

  // Insert
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  // Read all rows
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  // Update
  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    String uuid = row[columnUuid];
    return await db
        .update(table, row, where: '$columnUuid = ?', whereArgs: [uuid]);
  }

  // Delete
  Future<int> delete(String uuid) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnUuid = ?', whereArgs: [uuid]);
  }

  // Read Row
  Future<Map<String, dynamic>> getRow(String uuid) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db
        .query(table, where: '$columnUuid = ? LIMIT 1', whereArgs: [uuid]);
    return result.isNotEmpty ? result.first : {};
  }
}
