import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

import '../models/momento.dart';
import '../root/file.dart';
import '../style/colors.dart';
import 'splash.dart';
import 'detalhes.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ArquivoService arquivoService = ArquivoService();
  final ImagePicker _picker = ImagePicker();
  List<Momento> momentos = [];

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  Future<void> carregarDados() async {
    final dados = await arquivoService.carregarMomentos();
    if (!mounted) return;
    setState(() {
      momentos = dados;
    });
  }

  Future<void> tirarFotoEAdicionar() async {
    try {
      final XFile? pickedImage = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (pickedImage == null) return;

      String caminhoFinal = pickedImage.path;

      if (!kIsWeb) {
        final appDir = await getApplicationDocumentsDirectory();
        final fileName = 'foto_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final savedImage = await File(pickedImage.path).copy('${appDir.path}/$fileName');
        caminhoFinal = savedImage.path;
      }

      if (!mounted) return;

      final TextEditingController anotacaoController = TextEditingController();

      final anotacao = await showDialog<String>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text('Nova Anotação'),
            content: TextField(
              controller: anotacaoController,
              decoration: const InputDecoration(
                hintText: 'Digite uma anotação...',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, ''),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(dialogContext, anotacaoController.text),
                child: const Text('Salvar'),
              ),
            ],
          );
        },
      );

      final novoMomento = Momento(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        caminhoFoto: caminhoFinal,
        anotacao: anotacao ?? '',
        dataHora: DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now()),
      );

      setState(() {
        momentos.add(novoMomento);
      });

      await arquivoService.salvarMomentos(momentos);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao tirar ou salvar foto: $e')),
      );
    }
  }

  Future<void> excluirMomento(int index) async {
    final m = momentos[index];
    if (!kIsWeb) {
      final file = File(m.caminhoFoto);
      if (await file.exists()) {
        await file.delete();
      }
    }

    setState(() {
      momentos.removeAt(index);
    });
    await arquivoService.salvarMomentos(momentos);
  }

  Future<void> sairEApagarDados() async {
    await arquivoService.limparDados();
    setState(() {
      momentos.clear();
    });
    if (!mounted) return;
    Navigator.pop(context);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Splash()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus momentos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, size: 30),
            onPressed: tirarFotoEAdicionar,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: AppColors.rosaQueimado,
              ),
              accountName: const Text(
                'Meus Momentos',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              accountEmail: null,
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    'assets/icone.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.splitscreen),
              title: const Text('Splash'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Splash()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: Colors.black),
              title: const Text('Sair'),
              onTap: sairEApagarDados,
            ),
          ],
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.8,
        ),
        itemCount: momentos.length,
        itemBuilder: (context, index) {
          final m = momentos[index];
          return Stack(
            children: [
              GestureDetector(
                onTap: () async {
                  final deletar = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Detalhes(momento: m),
                    ),
                  );

                  if (deletar == true) {
                    excluirMomento(index);
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.rosaQueimadoMedio),
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(context).cardColor,
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: m.caminhoFoto.isNotEmpty
                            ? ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(7)),
                                child: kIsWeb
                                    ? Image.network(
                                        m.caminhoFoto,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        errorBuilder: (context, error, stackTrace) =>
                                            const Center(child: Text('Sem foto')),
                                      )
                                    : Image.file(
                                        File(m.caminhoFoto),
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        errorBuilder: (context, error, stackTrace) =>
                                            const Center(child: Text('Sem foto')),
                                      ),
                              )
                            : const Center(child: Text('Foto')),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          m.anotacao.isEmpty ? 'Anotação' : m.anotacao,
                          style: const TextStyle(fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        m.dataHora,
                        style: const TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 4,
                right: 4,
                child: GestureDetector(
                  onTap: () => excluirMomento(index),
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.white70,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, size: 20, color: Colors.black54),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}