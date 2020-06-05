import 'package:submission/data/data_model.dart';
import 'package:submission/data/database/database.dart';

class DataDao {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<int> addFavorite(FoodModel foodModel) async {
    final db = await dbProvider.database;
    return db.insert(dbProvider.tbFavorite, foodModel.toDatabaseJson());
  }

  Future<int> deleteFavorite(String idMeal) async {
    final db = await dbProvider.database;
    return db
        .delete(dbProvider.tbFavorite, where: 'idMeal=?', whereArgs: [idMeal]);
  }

  Future<List<FoodModel>> getFoods(
      {FoodModel food, String where, List<dynamic> whereArgs}) async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> result;

    if (food != null) {
      result = await db.query(dbProvider.tbFavorite,
          where: where, whereArgs: whereArgs);
      return result.isNotEmpty
          ? result.map((item) => FoodModel.fromJson(item, food.type)).toList()
          : [];
    } else if (where.isNotEmpty) {
      result = await db.query(dbProvider.tbFavorite,
          where: where, whereArgs: whereArgs);
      return result.isNotEmpty
          ? result
              .map((item) => FoodModel.fromJson(item, item['type']))
              .toList()
          : [];
    } else {
      result = await db.query(dbProvider.tbFavorite);
      return result.isNotEmpty
          ? result
              .map((item) => FoodModel.fromJson(item, item['type']))
              .toList()
          : [];
    }
  }
}
