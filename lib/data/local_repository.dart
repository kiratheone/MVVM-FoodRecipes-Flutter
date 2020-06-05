import 'dart:async';
import 'package:submission/data/data_dao.dart';
import 'package:submission/data/data_model.dart';

class LocalRepository {
  final dataDao = DataDao();

  Future fetchAllFavorite() => dataDao.getFoods();

  Future addFavorite(FoodModel food) => dataDao.addFavorite(food);

  Future deleteFavorite(String idMeal) => dataDao.deleteFavorite(idMeal);

  Future<bool> checkAlreadyFavored(FoodModel food) async {
    final result = await dataDao.getFoods(
        food: food,
        where: 'idMeal=?',
        whereArgs: [food.id.replaceAll('fav', '')]);
    return result.isNotEmpty ? true : false;
  }

  Future<List<FoodModel>> fetchFavoriteByType(int type) async {
    return await dataDao.getFoods(where: 'type=?', whereArgs: [type]);
  }
}
