import 'package:flutter/material.dart';
import 'package:flutter_notas_diarias_sqlite/helper/Helper.dart';
import 'package:flutter_notas_diarias_sqlite/model/Anotacao.dart';

class Home extends StatefulWidget {
  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {
  var _db = Helper();

  TextEditingController _title = TextEditingController();
  TextEditingController _description = TextEditingController();

  _registerScreen() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Adicionar nota"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _title,
                autofocus: true,
                decoration: InputDecoration(
                    labelText: "Titulo", hintText: "Digite o titulo..."),
              ),
              TextField(
                controller: _description,
                autofocus: true,
                decoration: InputDecoration(
                    labelText: "Descrição",
                    hintText: "Digite sua descrição..."),
              ),
            ],
          ),
          actions: [
            // ignore: deprecated_member_use
            FlatButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            // ignore: deprecated_member_use
            FlatButton(
              onPressed: () {
                _registerAnotation();
                Navigator.pop(context);
              },
              child: Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }

  _registerAnotation() async {
    Anotacao anotacao =
        Anotacao(_title.text, _description.text, DateTime.now().toString());
    int resultado = await _db.salvarAnotacao(anotacao);
    print(resultado);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minhas notas diárias'),
        backgroundColor: Colors.lightGreen,
      ),
      body: Container(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.greenAccent,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: () {
          _registerScreen();
        },
      ),
    );
  }
}
