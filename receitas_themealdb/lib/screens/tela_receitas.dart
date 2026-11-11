import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/receita_model.dart';

class TelaReceitas extends StatefulWidget {
  const TelaReceitas({super.key});

  @override
  State<TelaReceitas> createState() => _TelaReceitasState();
}

class _TelaReceitasState extends State<TelaReceitas> {
  final TextEditingController pesquisaController = TextEditingController();

  List<Receita> receitas = [];
  bool carregando = false;
  String mensagem = 'Digite o nome de uma receita para começar.';
  bool pesquisou = false;

  Future<void> buscarReceitas() async {
    final pesquisa = pesquisaController.text.trim();

    if (pesquisa.isEmpty) {
      setState(() {
        receitas = [];
        pesquisou = false;
        mensagem = 'Digite o nome de uma receita para pesquisar.';
      });
      return;
    }

    setState(() {
      carregando = true;
      pesquisou = true;
      receitas = [];
      mensagem = '';
    });

    try {
      final url = Uri.https(
        'www.themealdb.com',
        '/api/json/v1/1/search.php',
        {'s': pesquisa},
      );

      final resposta = await http.get(url);

      if (resposta.statusCode == 200) {
        final dados = jsonDecode(resposta.body);
        final List<dynamic>? listaMeals = dados['meals'];

        setState(() {
          carregando = false;
          if (listaMeals != null) {
            receitas = listaMeals.map((json) => Receita.fromJson(json)).toList();
          } else {
            receitas = [];
            mensagem = 'Nenhuma receita encontrada para "$pesquisa".';
          }
        });
      } else {
        setState(() {
          carregando = false;
          mensagem = 'Não foi possível consultar as receitas. '
              'Código: ${resposta.statusCode}.';
        });
      }
    } catch (erro) {
      setState(() {
        carregando = false;
        mensagem = 'Ocorreu um erro ao consultar a API. '
            'Verifique sua conexão e tente novamente.';
      });
    }
  }

  @override
  void dispose() {
    pesquisaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesquisa de Receitas'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: pesquisaController,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => buscarReceitas(),
              decoration: const InputDecoration(
                labelText: 'Nome da receita',
                hintText: 'Ex.: chicken, pizza, pasta',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: carregando ? null : buscarReceitas,
                child: const Text('Pesquisar'),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _construirResultados(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _construirResultados() {
    if (carregando) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 12),
            Text('Buscando receitas...'),
          ],
        ),
      );
    }

    if (receitas.isEmpty) {
      return Center(
        child: Text(
          mensagem,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      itemCount: receitas.length,
      itemBuilder: (context, index) {
        final receita = receitas[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          clipBehavior: Clip.antiAlias,
          child: ListTile(
            contentPadding: const EdgeInsets.all(10),
            leading: receita.imagemUrl != null
                ? Image.network(
                    receita.imagemUrl!,
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const SizedBox(
                        width: 90,
                        height: 90,
                        child: Icon(Icons.restaurant, size: 40),
                      );
                    },
                  )
                : const SizedBox(
                    width: 90,
                    height: 90,
                    child: Icon(Icons.restaurant, size: 40),
                  ),
            title: Text(
              receita.nome,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }
}