// Autores: Luiz Henrique dos Passos Silva & Yohans Silva Bezerra

import 'package:flutter/material.dart';

import 'armazenamento_livros.dart';
import 'home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ListaLivroApp(armazenamento: ArmazenamentoLivros()));
}

class ListaLivroApp extends StatelessWidget {
  const ListaLivroApp({super.key, required this.armazenamento});

  final ArmazenamentoLivros armazenamento;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Leitura',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: Home(
        carregarLivros: armazenamento.carregar,
        salvarLivros: armazenamento.salvar,
      ),
    );
  }
}
