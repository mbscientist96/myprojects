
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  static Database? _database;

  factory DBHelper() {
    return _instance;
  }

  DBHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'medication.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Criação da tabela medications
    await db.execute('''
      CREATE TABLE medications(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        time TEXT NOT NULL
      )
    ''');

    // Criação da tabela clinics
    await db.execute('''
      CREATE TABLE clinics(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        telefone TEXT NOT NULL,
        horario TEXT NOT NULL
      )
    ''');
  }

  // Métodos para a tabela medications (mantidos)

  Future<int> insertMedication(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert('medications', row);
  }

  Future<List<Map<String, dynamic>>> getAllMedications() async {
    Database db = await database;
    return await db.query('medications');
  }

  Future<int> deleteMedication(int id) async {
    Database db = await database;
    return await db.delete('medications', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateMedication(int id, Map<String, dynamic> row) async {
    Database db = await database;
    return await db.update('medications', row, where: 'id = ?', whereArgs: [id]);
  }

  // Métodos para a tabela clinics

  Future<int> insertClinica(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert('clinics', row);
  }

  Future<List<Map<String, dynamic>>> getAllClinics() async {
    Database db = await database;
    return await db.query('clinics');
  }

  Future<int> deleteClinica(int id) async {
    Database db = await database;
    return await db.delete('clinics', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateClinica(int id, Map<String, dynamic> row) async {
    Database db = await database;
    return await db.update('clinics', row, where: 'id = ?', whereArgs: [id]);
  }
}
