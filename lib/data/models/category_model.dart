import '/core/constants/db_constants.dart';

class Category {
  final String id;
  final String name;
  final int color; // Store color as int (ARGB)
  final bool isActive;
  final DateTime createdAt;

  Category({
    required this.id,
    required this.name,
    required this.color,
    this.isActive = true,
    required this.createdAt,
  });

  Category copyWith({String? id, String? name, int? color, bool? isActive, DateTime? createdAt}) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      DbConstants.colId: id,
      DbConstants.colName: name,
      DbConstants.colColor: color,
      DbConstants.colIsActive: isActive ? 1 : 0,
      DbConstants.colCreatedAt: createdAt.toIso8601String(),
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map[DbConstants.colId],
      name: map[DbConstants.colName],
      color: map[DbConstants.colColor],
      isActive: map[DbConstants.colIsActive] == 1,
      createdAt: DateTime.parse(map[DbConstants.colCreatedAt]),
    );
  }
}
