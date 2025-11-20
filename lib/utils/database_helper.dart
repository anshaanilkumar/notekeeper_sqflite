import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import '../models/note.dart';


class DatabaseHelper {
  static DatabaseHelper? _databaseHelper; // Singleton instance
  static Database? _database; // Singleton Database

  String noteTable = 'note_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colPriority = 'priority';
  String colDate = 'date';

  DatabaseHelper._createInstance(); // Named constructor

  factory DatabaseHelper() {
    _databaseHelper ??= DatabaseHelper._createInstance();
    return _databaseHelper!;
  }

  Future<Database> get database async {
    _database ??= await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'notes.db');

    var notesDatabase =
    await openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
      'CREATE TABLE $noteTable('
          '$colId INTEGER PRIMARY KEY AUTOINCREMENT, '
          '$colTitle TEXT, '
          '$colDescription TEXT, '
          '$colPriority INTEGER, '
          '$colDate TEXT)',
    );
  }

  // ------------------------------
  // 🟩 CRUD OPERATIONS START HERE
  // ------------------------------

  // INSERT Operation: Insert a Note object to the database
  Future<int> insertNote(Note note) async {
    Database db = await database;
    var result = await db.insert(noteTable, note.toMap());
    return result;
  }

  // FETCH Operation: Get all Note objects from database
  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await database;

    // Sort by priority (ascending)
    var result = await db.query(noteTable, orderBy: '$colPriority ASC');
    return result;
  }

  // UPDATE Operation: Update a Note object and save it to the database
  Future<int> updateNote(Note note) async {
    var db = await database;
    var result = await db.update(
      noteTable,
      note.toMap(),
      where: '$colId = ?',
      whereArgs: [note.id],
    );
    return result;
  }

  // DELETE Operation: Delete a Note object from database
  Future<int> deleteNote(int id) async {
    var db = await database;
    int result =
    await db.delete(noteTable, where: '$colId = ?', whereArgs: [id]);
    return result;
  }

  // GET Operation: Get number of Note objects in database
  Future<int> getCount() async {
    Database db = await database;
    List<Map<String, dynamic>> x =
    await db.rawQuery('SELECT COUNT (*) from $noteTable');
    int? result = Sqflite.firstIntValue(x);
    return result ?? 0;
  }

  // Convert Map List to Note List
  Future<List<Note>> getNoteList() async {
    var noteMapList = await getNoteMapList(); // Get Map List from DB
    int count = noteMapList.length;

    List<Note> noteList = [];
    for (int i = 0; i < count; i++) {
      noteList.add(Note.fromMapObject(noteMapList[i]));
    }

    return noteList;
  }
}
