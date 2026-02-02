import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../core/constants/db_constants.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB(DbConstants.databaseName);
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: DbConstants.databaseVersion,
      onCreate: _createDB,
      onConfigure: _onConfigure,
    );
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _createDB(Database db, int version) async {
    // Create Categories Table
    await db.execute('''
      CREATE TABLE ${DbConstants.tableCategories} (
        ${DbConstants.colId} TEXT PRIMARY KEY,
        ${DbConstants.colName} TEXT NOT NULL,
        ${DbConstants.colColor} INTEGER NOT NULL,
        ${DbConstants.colIsActive} INTEGER NOT NULL,
        ${DbConstants.colCreatedAt} TEXT NOT NULL
      )
    ''');

    // Create Tasks Table
    await db.execute('''
      CREATE TABLE ${DbConstants.tableTasks} (
        ${DbConstants.colId} TEXT PRIMARY KEY,
        ${DbConstants.colTitle} TEXT NOT NULL,
        ${DbConstants.colDescription} TEXT,
        ${DbConstants.colCategoryId} TEXT,
        ${DbConstants.colPriority} TEXT NOT NULL,
        ${DbConstants.colStatus} TEXT NOT NULL,
        ${DbConstants.colIsDateBased} INTEGER NOT NULL,
        ${DbConstants.colDueDate} TEXT,
        ${DbConstants.colStartDate} TEXT,
        ${DbConstants.colEndDate} TEXT,
        ${DbConstants.colIsRecurring} INTEGER NOT NULL,
        ${DbConstants.colRecurrenceRule} TEXT,
        ${DbConstants.colReminderDateTime} TEXT,
        ${DbConstants.colCreatedAt} TEXT NOT NULL,
        ${DbConstants.colUpdatedAt} TEXT NOT NULL,
        FOREIGN KEY (${DbConstants.colCategoryId}) REFERENCES ${DbConstants.tableCategories} (${DbConstants.colId}) ON DELETE SET NULL
      )
    ''');

    // Create Subtasks Table
    await db.execute('''
      CREATE TABLE ${DbConstants.tableSubtasks} (
        ${DbConstants.colId} TEXT PRIMARY KEY,
        ${DbConstants.colTaskId} TEXT NOT NULL,
        ${DbConstants.colTitle} TEXT NOT NULL,
        ${DbConstants.colIsCompleted} INTEGER NOT NULL,
        FOREIGN KEY (${DbConstants.colTaskId}) REFERENCES ${DbConstants.tableTasks} (${DbConstants.colId}) ON DELETE CASCADE
      )
    ''');
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
