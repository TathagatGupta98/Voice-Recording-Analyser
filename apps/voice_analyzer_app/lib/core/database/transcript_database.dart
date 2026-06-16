import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class TranscriptDatabase {
  static final TranscriptDatabase instance = TranscriptDatabase._init();
  static Database? _database;

  TranscriptDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('transcripts.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE transcripts (
        id TEXT PRIMARY KEY,
        text TEXT NOT NULL,
        timestamp TEXT NOT NULL
      )
    ''');
  }

  Future<void> insertTranscript(String id, String text) async {
    final db = await instance.database;
    await db.insert(
      'transcripts',
      {
        'id': id,
        'text': text,
        'timestamp': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> fetchAllTranscripts() async {
    final db = await instance.database;
    return await db.query('transcripts', orderBy: 'timestamp DESC');
  }
}