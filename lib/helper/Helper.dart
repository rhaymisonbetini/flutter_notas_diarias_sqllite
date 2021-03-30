import 'package:flutter_notas_diarias_sqlite/model/Anotacao.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Helper {
  String _sqlAnotacao =
      "CREATE TABLE anotation(id INTEGER PRIMARY KEY AUTOINCREMENT, title VARCHAR, description TEXT, data DATETIME)";

  static final String columnId = 'id';
  static final String columnTitle = 'title';
  static final String columnDescription = 'description';
  static final String columnData = 'data';

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

  getAnotations() async {
    var dataBase = await db;
    String sql = "SELECT * FROM anotation ORDER BY data DESC";
    List anotacoes = await dataBase.rawQuery(sql);
    return anotacoes;
  }

  Future<int> saveAnotations(Anotacao anotacao) async {
    var dataBase = await db;
    int resultado = await dataBase.insert('anotation', anotacao.toMap());
    return resultado;
  }

  Future<int> updateAnotations(Anotacao anotacao, int id) async {
    var dataBase = await db;
    String sql =
        "UPDATE anotation SET title = ?, description = ? , data = ? WHERE id = ?";

    int resultado = await dataBase.rawQuery(
        sql, [anotacao.title, anotacao.description, anotacao.data, id]);
    return resultado;
  }

  Future<int> deleteAnotation(int id) async {
    var dataBase = await db;
    String sql = "DELETE FROM anotation WHERE id = ?";
    int resultado = await dataBase.rawQuery(sql, id);
    return resultado;
  }
}
