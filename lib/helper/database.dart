import 'package:nid_notes/models/note.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _database;
  //singleton per controllare se la connessione esiste già, perchè creare piu connessioni occupa memoria
  Future<Database?> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), 'nid_notes.db');
    //creazione db viene creato una volta sola
    return await openDatabase(path,
        version: 6,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade
    );
  }


  //la creazione della tabella viene fatta una sola volta per versione
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE notes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            content TEXT NULL,
            image TEXT NULL,
          )
          ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      await db.execute("ALTER TABLE notes ADD COLUMN image TEXT;");
    }
  }

  Future<int> insert(Note note) async {
    //metodo toMap, trasforma un qualsiasi oggetto in una mappa chiave-valore, string dynamic. E' come un jSON
    return (await database)!.insert('notes', note.toMap());
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    //queryAllRows, restituiscie anche questo una mappa chiave valore
    return (await database)!.query('notes');
  }

  Future<int> delete(int id) async {
    return (await database)!.rawDelete('DELETE FROM notes WHERE id = ' + id.toString());
  }


}