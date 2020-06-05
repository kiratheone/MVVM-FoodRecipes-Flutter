import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:submission/data/data_repository.dart';
import 'package:submission/data/result.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  final String _url = "https://www.themealdb.com/api/json/v1/1/";
  test("Testing repository api get dessert success", () async {
    final client = MockClient();
    final repository = DataRepository(client);
    final response =
        '{"meals":[{"strMeal":"Apple & Blackberry Crumble","strMealThumb":"https:\/\/www.themealdb.com\/images\/media\/meals\/xvsurr1511719182.jpg","idMeal":"52893"},{"strMeal":"Apple Frangipan Tart","strMealThumb":"https:\/\/www.themealdb.com\/images\/media\/meals\/wxywrq1468235067.jpg","idMeal":"52768"}]';
    when(client.get(_url + "filter.php?c=Dessert"))
        .thenAnswer((_) async => http.Response(response, 200));

    expect(await repository.fetchDesserts(), isInstanceOf<Ok>());

  });

  test("Testing repository api get dessert failed", () async {
    final client = MockClient();
    final repository = DataRepository(client);
    final response =
        '{"meals":[{"strMeal":"Apple & Blackberry Crumble","strMealThumb":"https:\/\/www.themealdb.com\/images\/media\/meals\/xvsurr1511719182.jpg","idMeal":"52893"},{"strMeal":"Apple Frangipan Tart","strMealThumb":"https:\/\/www.themealdb.com\/images\/media\/meals\/wxywrq1468235067.jpg","idMeal":"52768"}]';
    when(client.get(_url + "filter.php?c=Dessert"))
        .thenAnswer((_) async => http.Response(null, 404));

    expect(await repository.fetchDesserts(), isInstanceOf<Error>());

  });
}
