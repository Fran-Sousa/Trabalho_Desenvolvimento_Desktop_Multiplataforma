// livro_model.dart

class Livro {
  final int? id;
  final String titulo;
  final String autor;
  final String categoria;
  final String status;
  final String raridade;
  final double valorPago;
  final double valorEstimado;
  final String observacoes;
  final String imagemPath; // caminho da foto da capa do livro

  Livro({
    this.id,
    required this.titulo,
    required this.autor,
    required this.categoria,
    required this.status,
    required this.raridade,
    required this.valorPago,
    required this.valorEstimado,
    required this.observacoes,
    this.imagemPath = '',
  });

  // Converte o objeto Livro para um Map (para salvar)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'autor': autor,
      'categoria': categoria,
      'status': status,
      'raridade': raridade,
      'valorPago': valorPago,
      'valorEstimado': valorEstimado,
      'observacoes': observacoes,
      'imagemPath': imagemPath,
    };
  }

  // Cria um objeto Livro a partir de um Map (para carregar)
  factory Livro.fromMap(Map<String, dynamic> map) {
    return Livro(
      id: map['id'],
      titulo: map['titulo'],
      autor: map['autor'],
      categoria: map['categoria'],
      status: map['status'],
      raridade: map['raridade'],
      valorPago: (map['valorPago'] as num).toDouble(),
      valorEstimado: (map['valorEstimado'] as num).toDouble(),
      observacoes: map['observacoes'],
      imagemPath: map['imagemPath'] ?? '',
    );
  }
}
