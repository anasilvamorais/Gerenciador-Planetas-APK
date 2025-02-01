import 'package:flutter/material.dart';
import '../controle/controle_planeta.dart';
import '../modelo/planeta.dart';

class TelaPlaneta extends StatefulWidget {
  final bool isIncluir;
  final Planeta planeta;
  final Function() onFinalizado;

  const TelaPlaneta({
    super.key,
    required this.isIncluir,
    required this.planeta,
    required this.onFinalizado,
  });

  @override
  State<TelaPlaneta> createState() => _TelaPlanetaState();
}

class _TelaPlanetaState extends State<TelaPlaneta> {
  final _formKey = GlobalKey<FormState>();
  final ControlePlaneta _controlePlaneta = ControlePlaneta();

  late TextEditingController _nomeController;
  late TextEditingController _tamanhoController;
  late TextEditingController _distanciaController;
  late TextEditingController _apelidoController;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.planeta.nome);
    _tamanhoController = TextEditingController(text: widget.planeta.tamanho.toString());
    _distanciaController = TextEditingController(text: widget.planeta.distancia.toString());
    _apelidoController = TextEditingController(text: widget.planeta.apelido ?? '');
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _tamanhoController.dispose();
    _distanciaController.dispose();
    _apelidoController.dispose();
    super.dispose();
  }

  // Método para validar e salvar os dados do planeta
  void _salvarPlaneta() {
    if (_formKey.currentState!.validate()) {
      widget.planeta
        ..nome = _nomeController.text
        ..tamanho = double.parse(_tamanhoController.text)
        ..distancia = double.parse(_distanciaController.text)
        ..apelido = _apelidoController.text;

      if (widget.isIncluir) {
        _controlePlaneta.inserirPlaneta(widget.planeta);
      } else {
        _controlePlaneta.alterarPlaneta(widget.planeta);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Planeta ${widget.isIncluir ? 'adicionado' : 'atualizado'} com sucesso!'),
          backgroundColor: Colors.purple,
        ),
      );
      widget.onFinalizado();
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isIncluir ? 'Adicionar Planeta' : 'Editar Planeta',
          style: const TextStyle(fontFamily: 'Cinzel'),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nomeController,
                  decoration: const InputDecoration(
                    labelText: 'Nome',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 3) {
                      return 'Informe um nome válido (mínimo 3 caracteres)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _tamanhoController,
                  decoration: const InputDecoration(
                    labelText: 'Tamanho (km)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || double.tryParse(value) == null || double.parse(value) <= 0) {
                      return 'Informe um tamanho válido (maior que zero)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _distanciaController,
                  decoration: const InputDecoration(
                    labelText: 'Distância (km)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || double.tryParse(value) == null || double.parse(value) <= 0) {
                      return 'Informe uma distância válida (maior que zero)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _apelidoController,
                  decoration: const InputDecoration(
                    labelText: 'Apelido',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('Cancelar'),
                    ),
                    ElevatedButton(
                      onPressed: _salvarPlaneta,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purpleAccent,
                      ),
                      child: const Text('Salvar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
