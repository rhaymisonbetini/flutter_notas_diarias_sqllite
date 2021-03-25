class Anotacao {
  int id;
  String title;
  String description;
  String data;

  Anotacao(this.title, this.description, this.data);

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
