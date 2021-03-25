import 'package:flutter/material.dart';
import 'package:flutter_notas_diarias_sqlite/Home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Minhas notas diárias',
      home: Home(),
    );
  }
}
