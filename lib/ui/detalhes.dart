import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../models/momento.dart';
import '../style/colors.dart';

class Detalhes extends StatelessWidget {
  final Momento momento;

  const Detalhes({super.key, required this.momento});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              if (momento.caminhoFoto.isNotEmpty) {
                Share.shareXFiles([XFile(momento.caminhoFoto)], text: momento.anotacao);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.redAccent),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              height: 420,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.rosaQueimadoMedio),
                borderRadius: BorderRadius.circular(12),
              ),
              child: momento.caminhoFoto.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(11),
                      child: kIsWeb
                          ? Image.network(
                              momento.caminhoFoto,
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              File(momento.caminhoFoto),
                              fit: BoxFit.cover,
                            ),
                    )
                  : const Center(child: Text('Foto não encontrada')),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                momento.anotacao.isEmpty ? 'Sem anotação' : momento.anotacao,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              momento.dataHora,
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}