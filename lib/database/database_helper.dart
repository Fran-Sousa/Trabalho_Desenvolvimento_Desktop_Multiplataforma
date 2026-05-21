// database_helper.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/livro_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  DatabaseHelper._init();

  // Chave usada para salvar os livros no SharedPreferences
  static const String _chaveLivros = 'livros';

  // Retorna todos os livros salvos
  Future<List<Livro>> listarLivros() async {
    final prefs = await SharedPreferences.getInstance();
    final String? dados = prefs.getString(_chaveLivros);

    if (dados == null) {
      return [];
    }

    final List listaJson = jsonDecode(dados);

    return listaJson.map((item) {
      return Livro.fromMap(Map<String, dynamic>.from(item));
    }).toList();
  }

  // Insere um novo livro na lista
  Future<int> inserirLivro(Livro livro) async {
    final prefs = await SharedPreferences.getInstance();

    // Carrega os livros já salvos
    final livros = await listarLivros();

    // Cria o livro com um ID único baseado na data/hora atual
    final novoLivro = Livro(
      id: DateTime.now().millisecondsSinceEpoch,
      titulo: livro.titulo,
      autor: livro.autor,
      categoria: livro.categoria,
      status: livro.status,
      raridade: livro.raridade,
      valorPago: livro.valorPago,
      valorEstimado: livro.valorEstimado,
      observacoes: livro.observacoes,
    );

    // Adiciona o novo livro à lista existente
    livros.add(novoLivro);

    // Converte a lista para Map e depois para JSON
    final listaMap = livros.map((l) => l.toMap()).toList();

    // Salva no SharedPreferences
    await prefs.setString(_chaveLivros, jsonEncode(listaMap));

    // Retorna o ID do livro inserido
    return novoLivro.id!;
  }

  // Atualiza os dados de um livro existente
  Future<int> atualizarLivro(Livro livroAtualizado) async {
    final prefs = await SharedPreferences.getInstance();

    // Carrega todos os livros cadastrados
    final livros = await listarLivros();

    // Encontra a posição do livro que queremos atualizar
    final index = livros.indexWhere((l) => l.id == livroAtualizado.id);

    if (index == -1) {
      return 0;
    }

    // Substitui o livro antigo pelo atualizado
    livros[index] = livroAtualizado;

    // Salva a lista atualizada
    final listaMap = livros.map((l) => l.toMap()).toList();
    await prefs.setString(_chaveLivros, jsonEncode(listaMap));

    return 1;
  }

  // Remove um livro pelo ID
  Future<int> excluirLivro(int id) async {
    final prefs = await SharedPreferences.getInstance();

    // Carrega a lista atual
    final livros = await listarLivros();
    final quantidadeAntes = livros.length;

    // Remove o livro com o ID informado
    livros.removeWhere((l) => l.id == id);

    final listaMap = livros.map((l) => l.toMap()).toList();
    await prefs.setString(_chaveLivros, jsonEncode(listaMap));

    // Retorna quantos livros foram removidos
    return quantidadeAntes - livros.length;
  }

  // Retorna a quantidade total de livros cadastrados
  Future<int> contarLivros() async {
    final livros = await listarLivros();
    return livros.length;
  }
}
