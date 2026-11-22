import 'package:flutter/material.dart';

import 'livro.dart';

class TelaCadastro extends StatefulWidget {
  const TelaCadastro({super.key});

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  final _titulo = TextEditingController();
  final _autor = TextEditingController();
  StatusLeitura _status = StatusLeitura.queroLer;

  void _cadastrar() {
    final titulo = _titulo.text.trim();
    final autor = _autor.text.trim();

    if (titulo.isEmpty || autor.isEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Preencha o título e o autor.')),
        );
      return;
    }

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    Navigator.pop(
      context,
      Livro(titulo: titulo, autor: autor, status: _status),
    );
  }

  @override
  void dispose() {
    _titulo.dispose();
    _autor.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar livro')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            TextField(
              controller: _titulo,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Título',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _autor,
              decoration: const InputDecoration(
                labelText: 'Autor',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Status da leitura'),
            DropdownButton<StatusLeitura>(
              value: _status,
              isExpanded: true,
              items: [
                for (final status in StatusLeitura.values)
                  DropdownMenuItem(
                    value: status,
                    child: Text(status.rotulo),
                  ),
              ],
              onChanged: (status) {
                if (status == null) return;
                setState(() => _status = status);
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _cadastrar,
              child: const Text('Salvar livro'),
            ),
          ],
        ),
      ),
    );
  }
}