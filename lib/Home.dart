import 'package:flutter/material.dart';
import 'package:flutter_notas_diarias_sqlite/helper/Helper.dart';
import 'package:flutter_notas_diarias_sqlite/model/Anotacao.dart';

class Home extends StatefulWidget {
  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {
  @override
  void initState() {
    super.initState();
    _getAnotations();
  }

  var _db = Helper();
  List<Anotacao> myNotes = [];

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

  _getAnotations() async {
    myNotes.clear();
    List anotations = await _db.getAnotations();
    List<Anotacao> tempList = [];
    for (var item in anotations) {
      Anotacao note = Anotacao.fromMap(item);
      tempList.add(note);
    }
    myNotes = tempList;
    tempList.clear();
  }

  _registerAnotation() async {
    Anotacao anotacao =
        Anotacao(_title.text, _description.text, DateTime.now().toString());
    await _db.saveAnotations(anotacao);
    _title.clear();
    _description.clear();
    setState(() {
      myNotes.add(anotacao);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minhas notas diárias'),
        backgroundColor: Colors.lightGreen,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: myNotes.length,
              itemBuilder: (context, index) {
                final note = myNotes[index];
                return Card(
                  child: ListTile(
                    title: Text(note.title),
                    subtitle: Text("${note.data} - ${note.description}"),
                  ),
                );
              },
            ),
          ),
        ],
      ),
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
