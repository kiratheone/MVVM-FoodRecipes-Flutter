import 'dart:convert';
import 'package:submission/data/data_model.dart';
import 'package:http/http.dart' as http;
import 'package:submission/data/result.dart';

class DataRepository {
  final String _url = "https://www.themealdb.com/api/json/v1/1/";
  final http.Client client;

  DataRepository(this.client);

  Future<Result> fetchFoods() async {
    try {
      final response = await client.get(_url + "filter.php?c=Seafood");

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        final listData = (data['meals'] as List)
            .map((model) => FoodModel.fromJson(model, 0))
            .toList();
        return Result.ok(listData, null);
      } else {
        return Result.error(response.statusCode, null);
      }
    } catch (e) {
      print(e.toString());
      return Result.error(500, "Failed to get Data");
    }
  }

  Future<Result> fetchDesserts() async {
    try {
      final response = await client.get(_url + "filter.php?c=Dessert");

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        final listData = (data['meals'] as List)
            .map((model) => FoodModel.fromJson(model, 1))
            .toList();
        return Result.ok(listData, null);
      } else {
        return Result.error(response.statusCode, null);
      }
    } catch (e) {
      print(e.toString());
      return Result.error(500, "Failed to get Data");
    }
  }

  Future<Result> fetchDetail(FoodModel food) async {
    try {
      final response = await client
          .get(_url + "lookup.php?i=" + food.id.replaceAll('fav', ''));
      print(response.body);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        final listData = (data['meals'] as List)
            .map((model) => FoodModel.fromJson(model, food.type))
            .toList();
        return Result.ok(listData[0], null);
      } else {
        return Result.error(response.statusCode, null);
      }
    } catch (e) {
      print(e.toString());
      return Result.error(500, "Failed to get Data");
    }
  }

  Future<Result> searchFoods(String query) async {
    try {
      final response = await client.get(_url + "search.php?s=" + query.trim());
      print(response.body);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        final listData = (data['meals'] as List)
            .map((model) => FoodModel.fromJson(model, 2))
            .toList();
        return Result.ok(listData, null);
      } else {
        return Result.error(response.statusCode, null);
      }
    } catch (e) {
      print(e.toString());
      return Result.error(500, "Failed to get Data");
    }
  }
}
