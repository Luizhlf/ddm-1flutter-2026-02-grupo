import 'package:flutter/material.dart';

import 'livro.dart';
import 'tela_cadastro.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
    required this.carregarLivros,
    required this.salvarLivros,
  });

  final Future<List<Livro>> Function() carregarLivros;
  final Future<void> Function(List<Livro>) salvarLivros;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Livro> _livros = [];
  bool _carregando = true;
  bool _falhaAoCarregar = false;
  bool _salvando = false;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    try {
      final livros = await widget.carregarLivros();
      if (!mounted) return;

      setState(() {
        _livros = livros;
        _carregando = false;
        _falhaAoCarregar = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _carregando = false;
        _falhaAoCarregar = true;
      });
    }
  }

  Future<void> _adicionar() async {
    final livro = await Navigator.push<Livro>(
      context,
      MaterialPageRoute(builder: (_) => const TelaCadastro()),
    );

    if (!mounted || livro == null) return;
    await _salvar([..._livros, livro], 'Livro adicionado.');
  }

  Future<void> _remover(int index) async {
    final livros = [..._livros]..removeAt(index);
    await _salvar(livros, 'Livro removido.');
  }

  Future<void> _salvar(List<Livro> livros, String mensagem) async {
    if (_salvando) return;
    setState(() => _salvando = true);

    try {
      await widget.salvarLivros(livros);
      if (!mounted) return;

      setState(() => _livros = livros);
      _mostrarMensagem(mensagem);
    } catch (_) {
      if (mounted) {
        _mostrarMensagem('Não foi possível salvar a alteração.');
      }
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  void _mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(mensagem)));
  }

  Widget _corpo() {
    if (_carregando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_falhaAoCarregar) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Não foi possível carregar os livros.'),
            TextButton(
              onPressed: () {
                setState(() => _carregando = true);
                _carregar();
              },
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }

    if (_livros.isEmpty) {
      return const Center(child: Text('Nenhum livro cadastrado.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
      itemCount: _livros.length,
      itemBuilder: (context, index) {
        final livro = _livros[index];

        return Card(
          child: ListTile(
            leading: const Icon(Icons.menu_book_outlined),
            title: Text(livro.titulo),
            subtitle: Text('${livro.autor}\n${livro.status.rotulo}'),
            isThreeLine: true,
            trailing: IconButton(
              tooltip: 'Remover ${livro.titulo}',
              icon: const Icon(Icons.delete_outline),
              onPressed: _salvando ? null : () => _remover(index),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final podeAdicionar = !_carregando && !_falhaAoCarregar && !_salvando;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Lista de Leitura'),
            Text(
              'Luiz Henrique dos Passos Silva & Yohans Silva Bezerra',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
      body: SafeArea(child: _corpo()),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: podeAdicionar ? _adicionar : null,
        icon: const Icon(Icons.add),
        label: const Text('Adicionar livro'),
      ),
    );
  }
}