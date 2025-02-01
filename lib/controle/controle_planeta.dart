import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../modelo/planeta.dart';

class ControlePlaneta {
  static Database? _bd;

  // Inicializa o banco de dados
  Future<Database> get bd async {
    if (_bd != null) return _bd!;
    _bd = await _initBD('planetas.db');
    return _bd!;
  }

  // Criação e atualização do banco de dados
  Future<Database> _initBD(String localArquivo) async {
    final caminhoBD = await getDatabasesPath();
    final caminho = join(caminhoBD, localArquivo);
    return await openDatabase(
      caminho,
      version: 2,
      onCreate: (db, version) async {
        await _criarBD(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE historico_planetas (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              nome TEXT NOT NULL,
              tamanho REAL,
              distancia REAL,
              apelido TEXT
            );
          ''');
        }
      },
    );
  }

  // Criação das tabelas
  Future<void> _criarBD(Database bd) async {
    await bd.execute('''
      CREATE TABLE planetas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        tamanho REAL NOT NULL CHECK(tamanho > 0),
        distancia REAL NOT NULL CHECK(distancia > 0),
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

  // Lê os planetas cadastrados
  Future<List<Planeta>> lerPlanetas() async {
    final db = await bd;
    final resultado = await db.query('planetas');
    return resultado.map((item) => Planeta.fromMap(item)).toList();
  }
  // Remove um planeta do histórico
  Future<int> removerDoHistorico(int id) async {
    final db = await bd;
    return await db.delete('historico_planetas', where: 'id = ?', whereArgs: [id]);
  }

  // Insere um novo planeta no banco de dados
  Future<int> inserirPlaneta(Planeta planeta) async {
    final db = await bd;
    if (planeta.tamanho <= 0 || planeta.distancia <= 0) {
      throw Exception("Tamanho e distância devem ser valores positivos.");
    }
    return await db.insert('planetas', planeta.toMap());
  }

  // Salva um planeta no histórico antes de excluir
  Future<int> salvarNoHistorico(Planeta planeta) async {
    final db = await bd;
    return await db.insert('historico_planetas', planeta.toMap());
  }

  // Atualiza um planeta existente
  Future<int> alterarPlaneta(Planeta planeta) async {
    final db = await bd;
    if (planeta.tamanho <= 0 || planeta.distancia <= 0) {
      throw Exception("Tamanho e distância devem ser valores positivos.");
    }
    return await db.update(
      'planetas',
      planeta.toMap(),
      where: 'id = ?',
      whereArgs: [planeta.id],
    );
  }

  // Lê o histórico de planetas excluídos
  Future<List<Planeta>> lerHistorico() async {
    final db = await bd;
    final resultado = await db.query('historico_planetas');
    return resultado.map((item) => Planeta.fromMap(item)).toList();
  }

  // Exclui um planeta e o salva no histórico
  Future<int> excluirPlaneta(int id) async {
    final db = await bd;
    final planeta = (await db.query('planetas', where: 'id = ?', whereArgs: [id]))
        .map((item) => Planeta.fromMap(item))
        .firstOrNull;

    if (planeta != null) {
      await salvarNoHistorico(planeta);
    }

    return await db.delete('planetas', where: 'id = ?', whereArgs: [id]);
  }

  // Restaura um planeta do histórico
  Future<int> restaurarPlaneta(int id) async {
    final db = await bd;
    final planeta = (await db.query('historico_planetas', where: 'id = ?', whereArgs: [id]))
        .map((item) => Planeta.fromMap(item))
        .firstOrNull;

    if (planeta != null) {
      await inserirPlaneta(planeta);
      return await db.delete('historico_planetas', where: 'id = ?', whereArgs: [id]);
    }
    return 0;
  }
}