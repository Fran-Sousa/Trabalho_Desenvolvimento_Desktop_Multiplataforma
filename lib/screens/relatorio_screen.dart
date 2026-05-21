// relatorio_screen.dart

import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/livro_model.dart';

class RelatorioScreen extends StatefulWidget {
  const RelatorioScreen({super.key});

  @override
  State<RelatorioScreen> createState() => _RelatorioScreenState();
}

class _RelatorioScreenState extends State<RelatorioScreen> {
  List<Livro> livros = [];
  int totalLivros = 0;

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  // Carrega os dados do banco para montar o relatório
  Future<void> carregarDados() async {
    final lista = await DatabaseHelper.instance.listarLivros();
    final total = await DatabaseHelper.instance.contarLivros();
    setState(() {
      livros = lista;
      totalLivros = total;
    });
  }

  // Calcula o total investido apenas nos livros que pertencem à coleção
  double calcularInvestimentoTotal() {
    double total = 0;
    for (final livro in livros) {
      if (livro.status == 'Pertence à coleção') {
        total += livro.valorPago;
      }
    }
    return total;
  }

  // Conta quantos livros existem por status
  Map<String, int> calcularQuantidadePorStatus() {
    final Map<String, int> resumo = {};
    for (final livro in livros) {
      resumo[livro.status] = (resumo[livro.status] ?? 0) + 1;
    }
    return resumo;
  }

  // Conta quantos livros existem por gênero
  Map<String, int> calcularQuantidadePorGenero() {
    final Map<String, int> resumo = {};
    for (final livro in livros) {
      resumo[livro.categoria] = (resumo[livro.categoria] ?? 0) + 1;
    }
    return resumo;
  }

  @override
  Widget build(BuildContext context) {
    final resumoPorStatus = calcularQuantidadePorStatus();
    final resumoPorGenero = calcularQuantidadePorGenero();
    final investimento = calcularInvestimentoTotal();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.cyan.shade700,
        title: const Text(
          'Relatório da Coleção',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: RefreshIndicator(
        onRefresh: carregarDados,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Card com o total geral
            Card(
              child: ListTile(
                leading: Icon(Icons.book, color: Colors.cyan.shade700),
                title: const Text('Total de livros cadastrados'),
                subtitle: Text('$totalLivros livro(s)'),
              ),
            ),
            const SizedBox(height: 8),

            // Card com o valor investido
            Card(
              child: ListTile(
                leading: Icon(Icons.attach_money, color: Colors.cyan.shade700),
                title: const Text('Investimento na coleção'),
                subtitle: Text('R\$ ${investimento.toStringAsFixed(2)}'),
              ),
            ),
            const SizedBox(height: 16),

            // Resumo por status
            const Text(
              'Resumo por status',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (resumoPorStatus.isEmpty)
              const Card(
                child: ListTile(title: Text('Nenhum dado disponível.')),
              )
            else
              ...resumoPorStatus.entries.map((item) {
                return Card(
                  child: ListTile(
                    leading: Icon(Icons.bar_chart, color: Colors.cyan.shade700),
                    title: Text(item.key),
                    trailing: Text(
                      item.value.toString(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }),
            const SizedBox(height: 16),

            // Resumo por gênero
            const Text(
              'Resumo por gênero',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (resumoPorGenero.isEmpty)
              const Card(
                child: ListTile(title: Text('Nenhum dado disponível.')),
              )
            else
              ...resumoPorGenero.entries.map((item) {
                return Card(
                  child: ListTile(
                    leading: Icon(Icons.menu_book, color: Colors.cyan.shade700),
                    title: Text(item.key),
                    trailing: Text(
                      item.value.toString(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}
