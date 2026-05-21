// home_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/livro_model.dart';
import 'cadastro_screen.dart';
import 'detalhe_screen.dart';
import 'relatorio_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Livro> livros = [];

  @override
  void initState() {
    super.initState();
    carregarLivros();
  }

  // Busca todos os livros salvos e atualiza a tela
  Future<void> carregarLivros() async {
    final lista = await DatabaseHelper.instance.listarLivros();
    setState(() {
      livros = lista;
    });
  }

  // Exclui um livro e atualiza a lista
  Future<void> excluirLivro(int id) async {
    await DatabaseHelper.instance.excluirLivro(id);
    carregarLivros();
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Livro excluído com sucesso')));
  }

  // Mostra um diálogo pedindo confirmação antes de excluir
  void confirmarExclusao(Livro livro) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: Text('Deseja excluir o livro "${livro.titulo}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                excluirLivro(livro.id!);
              },
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );
  }

  // Abre a tela de cadastro ou edição
  Future<void> abrirCadastro({Livro? livro}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CadastroScreen(livro: livro)),
    );
    carregarLivros();
  }

  // Abre a tela de detalhes do livro
  Future<void> abrirDetalhes(Livro livro) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetalheScreen(livro: livro)),
    );
  }

  // Abre a tela de relatório
  Future<void> abrirRelatorio() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RelatorioScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // Cabeçalho com fundo azul ciano e título em branco
        backgroundColor: Colors.cyan.shade700,
        title: const Text(
          'Minha Coleção de Livros',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: abrirRelatorio,
            icon: const Icon(Icons.bar_chart, color: Colors.white),
            tooltip: 'Relatório',
          ),
        ],
      ),
      body: livros.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.book_outlined,
                    size: 72,
                    color: Colors.cyan.shade200,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Nenhum livro cadastrado ainda.',
                    style: TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: livros.length,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemBuilder: (context, index) {
                final livro = livros[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    // Mostra a capa do livro se tiver, senão mostra ícone
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: SizedBox(
                        width: 46,
                        height: 60,
                        child:
                            livro.imagemPath.isNotEmpty &&
                                File(livro.imagemPath).existsSync()
                            ? Image.file(
                                File(livro.imagemPath),
                                fit: BoxFit.cover,
                              )
                            : CircleAvatar(
                                backgroundColor: Colors.cyan.shade50,
                                child: Icon(
                                  Icons.book,
                                  color: Colors.cyan.shade700,
                                ),
                              ),
                      ),
                    ),
                    title: Text(
                      livro.titulo,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Autor: ${livro.autor}\nStatus: ${livro.status}',
                    ),
                    isThreeLine: true,
                    onTap: () => abrirDetalhes(livro),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'editar') {
                          abrirCadastro(livro: livro);
                        } else if (value == 'excluir') {
                          confirmarExclusao(livro);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'editar',
                          child: Text('Editar'),
                        ),
                        const PopupMenuItem(
                          value: 'excluir',
                          child: Text('Excluir'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => abrirCadastro(),
        backgroundColor: Colors.cyan.shade700,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Novo Livro',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
