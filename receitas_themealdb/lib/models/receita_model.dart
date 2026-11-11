class Receita {
  final String id;
  final String nome;
  final String? imagemUrl;

  Receita({
    required this.id,
    required this.nome,
    this.imagemUrl,
  });

  factory Receita.fromJson(Map<String, dynamic> json) {
    return Receita(
      id: json['idMeal'] ?? '',
      nome: json['strMeal'] ?? 'Receita sem nome',
      imagemUrl: json['strMealThumb'],
    );
  }
}