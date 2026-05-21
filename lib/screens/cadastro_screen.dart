// cadastro_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/livro_model.dart';
import '../database/database_helper.dart';

class CadastroScreen extends StatefulWidget {
  final Livro? livro;

  const CadastroScreen({super.key, this.livro});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final formKey = GlobalKey<FormState>();

  final tituloController = TextEditingController();
  final autorController = TextEditingController();
  final valorPagoController = TextEditingController();
  final valorEstimadoController = TextEditingController();
  final observacoesController = TextEditingController();

  String categoriaSelecionada = 'Romance';
  String statusSelecionado = 'Pertence à coleção';
  String raridadeSelecionada = 'Comum';
  String imagemSelecionada = '';

  @override
  void initState() {
    super.initState();
    // Se vier um livro para editar, preenche os campos com os dados dele
    if (widget.livro != null) {
      tituloController.text = widget.livro!.titulo;
      autorController.text = widget.livro!.autor;
      valorPagoController.text = widget.livro!.valorPago.toString();
      valorEstimadoController.text = widget.livro!.valorEstimado.toString();
      observacoesController.text = widget.livro!.observacoes;
      categoriaSelecionada = widget.livro!.categoria;
      statusSelecionado = widget.livro!.status;
      raridadeSelecionada = widget.livro!.raridade;
      imagemSelecionada = widget.livro!.imagemPath;
    }
  }

  @override
  void dispose() {
    tituloController.dispose();
    autorController.dispose();
    valorPagoController.dispose();
    valorEstimadoController.dispose();
    observacoesController.dispose();
    super.dispose();
  }

  // Abre a galeria para o usuário escolher uma foto da capa
  Future<void> selecionarImagem() async {
    try {
      final picker = ImagePicker();
      final XFile? imagem = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (imagem != null) {
        setState(() {
          imagemSelecionada = imagem.path;
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao selecionar imagem: $e')));
    }
  }

  // Salva ou atualiza o livro no banco de dados
  Future<void> salvarLivro() async {
    if (formKey.currentState!.validate()) {
      final livro = Livro(
        id: widget.livro?.id,
        titulo: tituloController.text,
        autor: autorController.text,
        categoria: categoriaSelecionada,
        status: statusSelecionado,
        raridade: raridadeSelecionada,
        valorPago: double.tryParse(valorPagoController.text) ?? 0.0,
        valorEstimado: double.tryParse(valorEstimadoController.text) ?? 0.0,
        observacoes: observacoesController.text,
        imagemPath: imagemSelecionada,
      );

      if (widget.livro == null) {
        await DatabaseHelper.instance.inserirLivro(livro);
      } else {
        await DatabaseHelper.instance.atualizarLivro(livro);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.livro == null
                ? 'Livro cadastrado com sucesso'
                : 'Livro atualizado com sucesso',
          ),
        ),
      );
      Navigator.pop(context);
    }
  }

  // Widget auxiliar para criar campos de texto padronizados
  Widget campoTexto({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    TextInputType teclado = TextInputType.text,
    bool obrigatorio = true,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: teclado,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (obrigatorio && (value == null || value.trim().isEmpty)) {
          return 'Preencha o campo $label';
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final editando = widget.livro != null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.cyan.shade700,
        title: Text(
          editando ? 'Editar Livro' : 'Cadastrar Livro',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              // Área para adicionar foto da capa do livro
              GestureDetector(
                onTap: selecionarImagem,
                child: Container(
                  width: double.infinity,
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.cyan.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.cyan.shade200),
                  ),
                  child:
                      imagemSelecionada.isNotEmpty &&
                          File(imagemSelecionada).existsSync()
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            File(imagemSelecionada),
                            fit: BoxFit.contain,
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_photo_alternate_outlined,
                              size: 52,
                              color: Colors.cyan.shade400,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Toque para adicionar a capa do livro',
                              style: TextStyle(color: Colors.cyan.shade700),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 16),
              campoTexto(
                controller: tituloController,
                label: 'Título do livro',
                icon: Icons.book,
              ),
              const SizedBox(height: 12),
              campoTexto(
                controller: autorController,
                label: 'Autor',
                icon: Icons.person,
              ),
              const SizedBox(height: 12),

              // Dropdown para categoria/gênero
              DropdownButtonFormField<String>(
                value: categoriaSelecionada,
                decoration: const InputDecoration(
                  labelText: 'Gênero',
                  prefixIcon: Icon(Icons.category),
                  border: OutlineInputBorder(),
                ),
                items: ['Romance', 'Ficção', 'Conto', 'Terror']
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() => categoriaSelecionada = v!),
              ),
              const SizedBox(height: 12),

              // Dropdown para status do livro na coleção
              DropdownButtonFormField<String>(
                value: statusSelecionado,
                decoration: const InputDecoration(
                  labelText: 'Status',
                  prefixIcon: Icon(Icons.info_outline),
                  border: OutlineInputBorder(),
                ),
                items:
                    [
                          'Pertence à coleção',
                          'Lista de desejos',
                          'Vendido',
                          'Trocado',
                          'Emprestado',
                        ]
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                onChanged: (v) => setState(() => statusSelecionado = v!),
              ),
              const SizedBox(height: 12),

              // Dropdown para raridade
              DropdownButtonFormField<String>(
                value: raridadeSelecionada,
                decoration: const InputDecoration(
                  labelText: 'Raridade',
                  prefixIcon: Icon(Icons.star_outline),
                  border: OutlineInputBorder(),
                ),
                items: ['Comum', 'Raro']
                    .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                    .toList(),
                onChanged: (v) => setState(() => raridadeSelecionada = v!),
              ),
              const SizedBox(height: 12),
              campoTexto(
                controller: valorPagoController,
                label: 'Valor pago (R\$)',
                icon: Icons.money_off,
                teclado: TextInputType.number,
                obrigatorio: false,
              ),
              const SizedBox(height: 12),
              campoTexto(
                controller: valorEstimadoController,
                label: 'Valor estimado (R\$)',
                icon: Icons.attach_money,
                teclado: TextInputType.number,
                obrigatorio: false,
              ),
              const SizedBox(height: 12),
              campoTexto(
                controller: observacoesController,
                label: 'Observações',
                icon: Icons.note,
                maxLines: 4,
                obrigatorio: false,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: salvarLivro,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyan.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.save, color: Colors.white),
                  label: Text(
                    editando ? 'Salvar alterações' : 'Cadastrar',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
