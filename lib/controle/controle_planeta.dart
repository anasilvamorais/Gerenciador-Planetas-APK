import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../modelo/planeta.dart';

class ControlePlaneta {
  static Database? _bd;

  Future<Database> get bd async {
    if (_bd != null) return _bd!;
    _bd = await _initBD('planetas.db');
    return _bd!;
  }

  Future<Database> _initBD(String localArquivo) async {
    final caminhoBD = await getDatabasesPath();
    final caminho = join(caminhoBD, localArquivo);
    return await openDatabase(
      caminho,
      version: 2,
      onCreate: (db, version) async {
        await _criarBD(db);
      },
    );
  }

  Future<void> _criarBD(Database bd) async {
    await bd.execute('''
      CREATE TABLE planetas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        tamanho REAL NOT NULL,
        distancia REAL NOT NULL,
        apelido TEXT
      );
    ''');

    await bd.execute('''
      CREATE TABLE historico_planetas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        tamanho REAL,
        distancia REAL,
        apelido TEXT
      );
    ''');
  }

  Future<List<Planeta>> lerPlanetas() async {
    final db = await bd;
    final resultado = await db.query('planetas');
    return resultado.map((item) => Planeta.fromMap(item)).toList();
  }

  Future<int> inserirPlaneta(Planeta planeta) async {
    final db = await bd;
    return await db.insert('planetas', planeta.toMap());
  }

  Future<int> salvarNoHistorico(Planeta planeta) async {
    final db = await bd;
    return await db.insert('historico_planetas', planeta.toMap());
  }

  Future<int> alterarPlaneta(Planeta planeta) async {
    final db = await bd;
    return await db.update(
      'planetas',
      planeta.toMap(),
      where: 'id = ?',
      whereArgs: [planeta.id],
    );
  }

  Future<List<Planeta>> lerHistorico() async {
    final db = await bd;
    final resultado = await db.query('historico_planetas');
    return resultado.map((item) => Planeta.fromMap(item)).toList();
  }

  Future<int> excluirPlaneta(int id) async {
    final db = await bd;

    // Buscar o planeta antes de excluir
    final List<Map<String, dynamic>> resultado = await db.query(
      'planetas',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (resultado.isNotEmpty) {
      // Converter para objeto Planeta e salvar no histórico
      final planeta = Planeta.fromMap(resultado.first);
      await salvarNoHistorico(planeta);
    }

    // Agora, excluir o planeta da lista principal
    return await db.delete(
      'planetas',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Método para remover um planeta do histórico
  Future<int> removerDoHistorico(int id) async {
    final db = await bd;
    return await db.delete('historico_planetas', where: 'id = ?', whereArgs: [id]);
  }

  // Método para restaurar um planeta do histórico para a lista principal
  Future<void> restaurarPlaneta(Planeta planeta) async {
    final _ = await bd;
    await inserirPlaneta(planeta);
    await removerDoHistorico(planeta.id!);
  }
}