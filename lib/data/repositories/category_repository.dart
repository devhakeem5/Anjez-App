import 'package:get/get.dart';

import '../../core/constants/db_constants.dart';
import '../../core/database/db_helper.dart';
import '../models/category_model.dart';

class CategoryRepository extends GetxService {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<String> create(Category category) async {
    final db = await _dbHelper.database;
    await db.insert(DbConstants.tableCategories, category.toMap());
    return category.id;
  }

  Future<Category?> read(String id) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      DbConstants.tableCategories,
      where: '${DbConstants.colId} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Category.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Category>> readAll() async {
    final db = await _dbHelper.database;
    final orderBy = '${DbConstants.colCreatedAt} DESC';
    final result = await db.query(DbConstants.tableCategories, orderBy: orderBy);

    return result.map((json) => Category.fromMap(json)).toList();
  }

  Future<int> update(Category category) async {
    final db = await _dbHelper.database;
    return await db.update(
      DbConstants.tableCategories,
      category.toMap(),
      where: '${DbConstants.colId} = ?',
      whereArgs: [category.id],
    );
  }

  Future<int> delete(String id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      DbConstants.tableCategories,
      where: '${DbConstants.colId} = ?',
      whereArgs: [id],
    );
  }
}
