// boas_vindas_screen.dart

import 'package:flutter/material.dart';
import 'home_screen.dart';

class BoasVindasScreen extends StatelessWidget {
  const BoasVindasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Ícone principal
              Icon(
                Icons.menu_book_rounded,
                size: 100,
                color: Colors.cyan.shade700,
              ),
              const SizedBox(height: 24),

              // Mensagem de boas-vindas
              Text(
                'Bem-vindo, Colecionador!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyan.shade900,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Organize sua coleção de livros em um só lugar.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 48),

              // Botão para entrar na coleção
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.collections_bookmark,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Clique aqui para cadastrar sua coleção',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyan.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
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
