import 'package:flutter/material.dart';

import 'controle/controle_planeta.dart';
import 'modelo/planeta.dart';
import 'telas/tela_planeta.dart';
import 'telas/tela_historico.dart';
import 'telas/tela_detalhes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gerenciador de Planetas',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.purple,
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: 'Cinzel', // Fonte mais elegante
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontSize: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.purpleAccent,
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ControlePlaneta _controlePlaneta = ControlePlaneta();
  List<Planeta> _planetas = [];

  @override
  void initState() {
    super.initState();
    _carregarPlanetas();
  }

  Future<void> _carregarPlanetas() async {
    final planetas = await _controlePlaneta.lerPlanetas();
    setState(() {
      _planetas = planetas;
    });
  }

  void _navegarParaTelaPlaneta({Planeta? planeta}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => TelaPlaneta(
              isIncluir: planeta == null,
              planeta: planeta ?? Planeta.vazio(),
              onFinalizado: _carregarPlanetas,
            ),
      ),
    );
  }

  void _navegarParaHistorico() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TelaHistorico()),
    );
  }

  void _confirmarExclusao(int id) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Confirmar Exclusão"),
            content: const Text(
              "Tem certeza de que deseja excluir este planeta?",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Cancelar"),
              ),
              TextButton(
                onPressed: () {
                  _excluirPlaneta(id);
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "Excluir",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  void _excluirPlaneta(int id) async {
    await _controlePlaneta.excluirPlaneta(id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Planeta removido e salvo no histórico!')),
    );
    _carregarPlanetas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciador de Planetas'),
        centerTitle: true,
      ),
      body:
          _planetas.isEmpty
              ? const Center(
                child: Text(
                  'Nenhum planeta cadastrado. Adicione um novo!',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
              : ListView.builder(
                itemCount: _planetas.length,
                itemBuilder: (context, index) {
                  final planeta = _planetas[index];
                  return Card(
                    color: Colors.deepPurple[100],
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => TelaDetalhes(planeta: planeta),
                          ),
                        );
                      },

                      leading: const Icon(
                        Icons.public,
                        color: Colors.deepPurple,
                      ),
                      title: Text(
                        planeta.nome,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cinzel',
                        ),
                      ),
                      subtitle: Text('Apelido: ${planeta.apelido ?? "N/A"}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.purple),
                            onPressed:
                                () => _navegarParaTelaPlaneta(planeta: planeta),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _confirmarExclusao(planeta.id!),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      floatingActionButton: Stack(
        clipBehavior: Clip.none, // permite que os botões se sobreponham
        children: [
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () => _navegarParaTelaPlaneta(),
              child: const Icon(Icons.add),
            ),
          ),
          Positioned(
            bottom: 16,
            right: 96, // Ajusta a posição do botão de histórico
            child: FloatingActionButton(
              onPressed: _navegarParaHistorico,
              child: const Icon(Icons.history),
            ),
          ),
        ],
      ),
    );
  }
}
