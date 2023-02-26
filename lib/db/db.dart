import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../model/note.dart';

class DBProvider {
  static Database? _db;
  static final DBProvider _singleton = DBProvider._internal();

  factory DBProvider() {
    return _singleton;
  }

  DBProvider._internal();

  Future<Database> get database async => _db ??= await _initDB();

  Future<Database> _initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'dbName.db');
    return await openDatabase(path,
        version: 1, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  ///
  /// 创建Table
  ///
  Future _onCreate(Database db, int version) async {
    db.execute(
        "create table tb_note( id INTEGER PRIMARY KEY, title TEXT, content TEXT, create_time INTEGER,  update_time INTEGER)");
  }

  ///
  /// 更新Table
  ///
  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {}

  Future<int?> saveNote(Note note) async {
    Map<String, dynamic> map = {
      "title": note.title,
      "content": note.content,
      "create_time": note.createTime.millisecondsSinceEpoch,
      "update_time": note.updateTime.millisecondsSinceEpoch,
    };

    return await _db?.insert('tb_note', map);
  }

  Future<void> updateNoteById(Note note) async {
    Map<String, dynamic> map = {
      "title": note.title,
      "content": note.content,
      "update_time": note.updateTime.millisecondsSinceEpoch,
    };
    _db?.update("tb_note", map, where: "id=?", whereArgs: [note.id]);
  }

  Future<List<Note>> getNoteList() async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'tb_note',
      columns: ["id", "title", "content", "create_time", "update_time"],
      orderBy: "create_time desc",
    );
    return List.generate(result.length, (i) {
      return Note(
          id: result[i]["id"],
          title: result[i]["title"],
          content: result[i]["content"],
          createTime:
              DateTime.fromMillisecondsSinceEpoch(result[i]["create_time"]),
          updateTime:
              DateTime.fromMillisecondsSinceEpoch(result[i]["update_time"]));
    });
  }

  Future<List<Note>> getNoteListPage(int offset, int pageSize) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'tb_note',
      columns: ["id", "title", "content", "create_time", "update_time"],
      offset: offset,
      limit: pageSize,
      orderBy: "create_time desc",
    );
    return List.generate(result.length, (i) {
      return Note(
          id: result[i]["id"],
          title: result[i]["title"],
          content: result[i]["content"],
          createTime:
              DateTime.fromMillisecondsSinceEpoch(result[i]["create_time"]),
          updateTime:
              DateTime.fromMillisecondsSinceEpoch(result[i]["update_time"]));
    });
  }

  Future<Note?> getNote(int noteId) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query('tb_note',
        columns: ["id", "title", "content", "create_time", "update_time"],
        where: "id=?",
        whereArgs: [noteId]);
    if (result.isEmpty) {
      return null;
    } else {
      return Note.newNoteFromMap(result[0]);
    }
  }

  Future<void> deleteNote(int noteId) async {
    final db = await database;
    await db.delete(
      "tb_note",
      where: "id=?",
      whereArgs: [noteId],
    );
  }
}
