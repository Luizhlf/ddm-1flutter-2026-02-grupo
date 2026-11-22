enum StatusLeitura {
  queroLer('Quero ler'),
  lendo('Lendo'),
  concluido('Concluído');

  const StatusLeitura(this.rotulo);

  final String rotulo;
}

class Livro {
  const Livro({
    required this.titulo,
    required this.autor,
    required this.status,
  });

  final String titulo;
  final String autor;
  final StatusLeitura status;

  factory Livro.fromJson(Map<String, dynamic> json) {
    return Livro(
      titulo: json['titulo'] as String,
      autor: json['autor'] as String,
      status: StatusLeitura.values.byName(json['status'] as String),
    );
  }

  Map<String, String> toJson() => {
    'titulo': titulo,
    'autor': autor,
    'status': status.name,
  };
}