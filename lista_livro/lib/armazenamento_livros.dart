import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'livro.dart';

class ArmazenamentoLivros {
  static const _chave = 'livros';

  final _preferencias = SharedPreferencesAsync();

  Future<List<Livro>> carregar() async {
    final texto = await _preferencias.getString(_chave);
    if (texto == null) return [];

    final dados = jsonDecode(texto) as List<dynamic>;
    return [
      for (final item in dados)
        Livro.fromJson(item as Map<String, dynamic>),
    ];
  }

  Future<void> salvar(List<Livro> livros) {
    final texto = jsonEncode([
      for (final livro in livros) livro.toJson(),
    ]);

    return _preferencias.setString(_chave, texto);
  }
}