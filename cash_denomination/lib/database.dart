import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = '${await getDatabasesPath()}denomination.db';
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE denomination (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            denominationQuantity INTEGER,
            totalAmount REAL,
            dropdownValue TEXT,
            remark TEXT
          )
        ''');
      },
    );
  }

  Future<int> insertRecord(Map<String, dynamic> record) async {
    final db = await database;
    return db.insert('denomination', record);
  }

    // Read all records
  Future<List<Map<String, dynamic>>> getAllRecords() async {
    final db = await database;
    return db.query('denomination');
  }

  // Delete a record (Optional for future use)
  Future<int> deleteRecord(int id) async {
    final db = await database;
    return db.delete('denomination', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateRecord(Map<String, dynamic> record) async {
  final db = await database;
  return db.update(
    'denomination',
    record,
    where: 'id = ?',
    whereArgs: [record['id']],
  );
}
}
