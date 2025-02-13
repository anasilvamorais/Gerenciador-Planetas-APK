import 'package:flutter/material.dart';
import '../controle/controle_planeta.dart';
import '../modelo/planeta.dart';

class TelaHistorico extends StatefulWidget {
  const TelaHistorico({super.key});

  @override
  State<TelaHistorico> createState() => _TelaHistoricoState();
}

class _TelaHistoricoState extends State<TelaHistorico> {
  final ControlePlaneta _controlePlaneta = ControlePlaneta();
  List<Planeta> _historicoPlanetas = [];

  @override
  void initState() {
    super.initState();
    _carregarHistorico();
  }

  // Carrega os planetas excluídos do histórico
  Future<void> _carregarHistorico() async {
  final planetas = await _controlePlaneta.lerHistorico();
  setState(() {
    _historicoPlanetas = planetas;
  });
}

  // Restaura um planeta do histórico para a lista principal
  void _restaurarPlaneta(Planeta planeta) async {
    await _controlePlaneta.inserirPlaneta(planeta);
    await _controlePlaneta.removerDoHistorico(planeta.id!);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Planeta restaurado com sucesso!'),
        backgroundColor: Colors.green,
      ),
    );
    _carregarHistorico();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Histórico de Planetas',
          style: TextStyle(fontFamily: 'Cinzel'),
        ),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: _historicoPlanetas.isEmpty
          ? const Center(
              child: Text(
                'Nenhum registro no histórico.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: _historicoPlanetas.length,
              itemBuilder: (context, index) {
                final planeta = _historicoPlanetas[index];
                return Card(
                  color: Colors.deepPurple[100],
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.public, color: Colors.purple),
                    title: Text(
                      planeta.nome,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cinzel',
                      ),
                    ),
                    subtitle: Text('Distância: ${planeta.distancia.toString()} km'),
                    trailing: IconButton(
                      icon: const Icon(Icons.restore, color: Colors.green),
                      onPressed: () => _restaurarPlaneta(planeta),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
