import 'package:flutter/material.dart';
import '../modelo/planeta.dart';

class TelaDetalhes extends StatelessWidget {
  final Planeta planeta;

  const TelaDetalhes({super.key, required this.planeta});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(planeta.nome),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Nome: ${planeta.nome}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text("Apelido: ${planeta.apelido ?? "N/A"}"),
            Text("Distância do Sol: ${planeta.distancia} km"),
            Text("Tamanho: ${planeta.tamanho} km"),
          ],
        ),
      ),
    );
  }
}
