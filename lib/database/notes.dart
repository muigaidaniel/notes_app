import 'package:notes/database/note.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Notes {
  static final Notes instance = Notes._init();
  static Database? _database;
  Notes._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''CREATE TABLE $table(
    ${Fields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
    ${Fields.title} TEXT NOT NULL,
    ${Fields.content} TEXT NOT NULL,
    ${Fields.number} INTEGER NOT NULL,
    ${Fields.favourite} BOOLEAN NOT NULL,
    ${Fields.created} TEXT NOT NULL
    ) ''');
  }

  Future<Note> create(Note note) async {
    final db = await instance.database;
    final id = await db.insert(table, note.toJson());
    return note.copy(id: id);
  }

  Future<Note> update(Note note) async {
    final db = await instance.database;
    final id = await db.update(
      table,
      note.toJson(),
      where: '${Fields.id} = ?',
      whereArgs: [note.id],
    );
    return note.copy(id: id);
  }

  Future<Note> read(int id) async {
    final db = await instance.database;
    final maps = await db.query(table,
        columns: Fields.values, where: '${Fields.id}= ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Note.fromJson(maps.first);
    } else {
      throw Exception('Id $id not found');
    }
  }

  Future<List<Note>> readAll() async {
    final db = await instance.database;
    final orderBy = '${Fields.created} DESC';
    final result = await db.query(table, orderBy: orderBy);
    return result.map((json) => Note.fromJson(json)).toList();
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      table,
      where: '${Fields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
