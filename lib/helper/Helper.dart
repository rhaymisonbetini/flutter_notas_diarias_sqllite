import 'package:flutter_notas_diarias_sqlite/model/Anotacao.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Helper {
  String _sqlAnotacao =
      "CREATE TABLE anotation(id INTEGER PRIMARY KEY AUTOINCREMENT, title VARCHAR, description TEXT, data DATETIME)";

  static final Helper _helper = Helper._internal();
  Database _db;

  factory Helper() {
    return _helper;
  }

  // ignore: empty_constructor_bodies
  Helper._internal() {}

  get db async {
    if (_db != null) {
      return _db;
    } else {
      return await inititDB();
    }
  }

  inititDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "minha_anotacoes.db");

    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    String sql = _sqlAnotacao;
    await db.execute(sql);
  }

  Future<int> salvarAnotacao(Anotacao anotacao) async {
    var dataBase = await db;
    int resultado = await dataBase.insert('anotation', anotacao.toMap());
    return resultado;
  }
}
