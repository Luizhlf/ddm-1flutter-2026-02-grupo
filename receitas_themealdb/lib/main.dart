// ============================================================================
// TP2 - Aplicativo de Receitas
// Autores: Yohans Silva Bezerra & Luiz Henrique dos Passos Silva
// ============================================================================

import 'package:flutter/material.dart';
import 'screens/tela_receitas.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Receitas',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const TelaReceitas(),
    );
  }
}