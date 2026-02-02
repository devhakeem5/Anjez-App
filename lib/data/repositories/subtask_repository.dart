import 'package:get/get.dart';

import '../../core/constants/db_constants.dart';
import '../../core/database/db_helper.dart';
import '../models/subtask_model.dart';

class SubTaskRepository extends GetxService {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<String> create(Subtask subtask) async {
    final db = await _dbHelper.database;
    await db.insert(DbConstants.tableSubtasks, subtask.toMap());
    return subtask.id;
  }

  Future<List<Subtask>> readByTaskId(String taskId) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      DbConstants.tableSubtasks,
      where: '${DbConstants.colTaskId} = ?',
      whereArgs: [taskId],
    );

    return result.map((json) => Subtask.fromMap(json)).toList();
  }

  Future<int> update(Subtask subtask) async {
    final db = await _dbHelper.database;
    return await db.update(
      DbConstants.tableSubtasks,
      subtask.toMap(),
      where: '${DbConstants.colId} = ?',
      whereArgs: [subtask.id],
    );
  }

  Future<int> delete(String id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      DbConstants.tableSubtasks,
      where: '${DbConstants.colId} = ?',
      whereArgs: [id],
    );
  }
}
