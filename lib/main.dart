// main.dart

import 'package:flutter/material.dart';
import 'screens/boas_vindas_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minha Coleção de Livros',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.cyan, useMaterial3: true),
      home: const BoasVindasScreen(),
    );
  }
}
