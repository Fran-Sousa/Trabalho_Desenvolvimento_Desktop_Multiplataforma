// detalhe_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import '../models/livro_model.dart';
import 'cadastro_screen.dart';

class DetalheScreen extends StatelessWidget {
  final Livro livro;

  const DetalheScreen({super.key, required this.livro});

  // Widget que monta cada linha de detalhe com ícone
  Widget itemDetalhe({
    required IconData icon,
    required String titulo,
    required String valor,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Colors.cyan.shade700),
        title: Text(titulo),
        subtitle: Text(valor),
      ),
    );
  }

  // Abre a tela de edição e volta para home ao finalizar
  Future<void> editarLivro(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CadastroScreen(livro: livro)),
    );
    if (!context.mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.cyan.shade700,
        title: const Text(
          'Detalhes do Livro',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () => editarLivro(context),
            icon: const Icon(Icons.edit, color: Colors.white),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Mostra a capa do livro se tiver imagem cadastrada
          if (livro.imagemPath.isNotEmpty &&
              File(livro.imagemPath).existsSync())
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(livro.imagemPath),
                  height: 200,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          if (livro.imagemPath.isNotEmpty &&
              File(livro.imagemPath).existsSync())
            const SizedBox(height: 12),

          itemDetalhe(icon: Icons.book, titulo: 'Título', valor: livro.titulo),
          itemDetalhe(icon: Icons.person, titulo: 'Autor', valor: livro.autor),
          itemDetalhe(
            icon: Icons.category,
            titulo: 'Gênero',
            valor: livro.categoria,
          ),
          itemDetalhe(
            icon: Icons.info_outline,
            titulo: 'Status',
            valor: livro.status,
          ),
          itemDetalhe(
            icon: Icons.star_outline,
            titulo: 'Raridade',
            valor: livro.raridade,
          ),
          itemDetalhe(
            icon: Icons.money_off,
            titulo: 'Valor pago',
            valor: 'R\$ ${livro.valorPago.toStringAsFixed(2)}',
          ),
          itemDetalhe(
            icon: Icons.attach_money,
            titulo: 'Valor estimado',
            valor: 'R\$ ${livro.valorEstimado.toStringAsFixed(2)}',
          ),
          itemDetalhe(
            icon: Icons.notes,
            titulo: 'Observações',
            valor: livro.observacoes.isEmpty
                ? 'Sem observações'
                : livro.observacoes,
          ),
        ],
      ),
    );
  }
}
