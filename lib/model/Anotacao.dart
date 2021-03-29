import 'package:flutter_notas_diarias_sqlite/helper/Helper.dart';

class Anotacao {
  int id;
  String title;
  String description;
  String data;

  Anotacao(this.title, this.description, this.data);

  Anotacao.fromMap(Map map) {
    this.id = map[Helper.columnId];
    this.title = map[Helper.columnTitle];
    this.description = map[Helper.columnDescription];
    this.data = map[Helper.columnData];
  }

  Map toMap() {
    Map<String, dynamic> newAnotation = {
      "title": this.title,
      "description": this.description,
      "data": this.data
    };
    if (this.id != null) {
      newAnotation["id"] = this.id;
    }
    return newAnotation;
  }
}
