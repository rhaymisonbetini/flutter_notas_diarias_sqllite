import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
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
  int anotationId;

  _registerScreen({Anotacao anotacao}) {
    bool isEdit = false;
    if (anotacao != null) {
      _title.text = anotacao.title;
      _description.text = anotacao.description;
      anotationId = anotacao.id;
      isEdit = true;
    }

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

            !isEdit
                ?
                // ignore: deprecated_member_use
                FlatButton(
                    onPressed: () {
                      _registerAnotation();
                      Navigator.pop(context);
                    },
                    child: Text('Adicionar'),
                  )
                :
                // ignore: deprecated_member_use
                FlatButton(
                    onPressed: () {
                      _updateAnotation();
                      Navigator.pop(context);
                    },
                    child: Text('Editar'),
                  ),
          ],
        );
      },
    );
  }

  _deleteScreen() {}

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
    Anotacao anotacao = Anotacao(_title.text, _description.text,
        _formatedDate(DateTime.now().toString()));
    await _db.saveAnotations(anotacao);
    _title.clear();
    _description.clear();
    _getAnotations();
  }

  _updateAnotation() async {
    Anotacao anotacao = Anotacao(_title.text, _description.text,
        _formatedDate(DateTime.now().toString()));
    await _db.updateAnotations(anotacao, anotationId);
    _title.clear();
    _description.clear();
    _getAnotations();
  }

  _formatedDate(date) {
    initializeDateFormatting("pt_BR");
    var formater = DateFormat("y/M/d H:m:s");
    DateTime converted = DateTime.parse(date);
    String formatedDate = formater.format(converted);
    return formatedDate;
  }

  _verifyDirection(DismissDirection direction, Anotacao anotacao) {
    if (direction == DismissDirection.endToStart) {
      _deleteScreen();
    } else {
      _registerScreen(anotacao: anotacao);
    }
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

                return Dismissible(
                  onDismissed: (direction) {
                    _verifyDirection(direction, note);
                  },
                  direction: DismissDirection.horizontal,
                  key: Key(DateTime.now().microsecondsSinceEpoch.toString()),
                  background: Container(
                    color: Colors.greenAccent,
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  secondaryBackground: Container(
                    color: Colors.red,
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  child: Card(
                    child: ListTile(
                      title: Text(note.title),
                      subtitle: Text("${note.data} - ${note.description}"),
                    ),
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
