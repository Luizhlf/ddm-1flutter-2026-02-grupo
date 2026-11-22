import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lista_livro/home.dart';

void main() {
  testWidgets('Exibe a lista vazia quando não há livros', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Home(
          carregarLivros: () async => [],
          salvarLivros: (_) async {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Lista de Leitura'), findsOneWidget);
    expect(find.text('Nenhum livro cadastrado.'), findsOneWidget);
    expect(find.text('Adicionar livro'), findsOneWidget);
  });
}
