import 'dart:async';

import 'package:submission/data/data_model.dart';
import 'package:submission/data/local_repository.dart';
import 'package:submission/main.dart';

class FavoriteViewModel {
  final LocalRepository _repository;

  FavoriteViewModel(this._repository);

  final StreamController<FavoriteState> _localFoodStreamController =
      StreamController.broadcast();

  Stream<FavoriteState> get favoriteState => _localFoodStreamController.stream;

  void loadFavoriteFood(Food food) async {
    int type;
    if(food == Food.meal){
      type= 0;
    }else if(food == Food.dessert){
      type= 1;
    }else{
      type= 2;
    }
    _localFoodStreamController.add(FavoriteState.loading());
    final List<FoodModel> foods = await _repository.fetchFavoriteByType(type);
    if (foods.isNotEmpty) {
      print(foods);
      _localFoodStreamController.add(FavoriteState.showData(foods));
    } else {
      _localFoodStreamController.add(FavoriteState.error("Nda ada Favorite"));
    }
  }

  void addRemoveFav({FoodModel foodModel}) async {
    if (await _repository.checkAlreadyFavored(foodModel)) {
      var result = await _repository.deleteFavorite(foodModel.id);
      print("removed ? $result");
      _localFoodStreamController.add(FavoriteState.removed());
    } else {
      var result = await _repository.addFavorite(foodModel);
      print("added ? $result");
      _localFoodStreamController.add(FavoriteState.added());
    }
  }

  void checkFav(FoodModel food) async {
    if (await _repository.checkAlreadyFavored(food)) {
      print('favorited');
      _localFoodStreamController.add(FavoriteState.added());
    } else {
      print('no favorite');
      _localFoodStreamController.add(FavoriteState.removed());
    }
  }

  void onDisposed() {
    _localFoodStreamController.close();
  }
}

class FavoriteState {
  FavoriteState();

  factory FavoriteState.loading() = FavoriteLoadingState;

  factory FavoriteState.showData(List<FoodModel> foods) = DataShowFavState;

  factory FavoriteState.removed() = FavoriteRemoved;

  factory FavoriteState.added() = FavoriteAdded;

  factory FavoriteState.error(String message) = FavoriteErrorState;
}

class FavoriteLoadingState extends FavoriteState {}

class FavoriteInitialState extends FavoriteState {}

class FavoriteRemoved extends FavoriteState {}

class FavoriteAdded extends FavoriteState {}

class DataShowFavState extends FavoriteState {
  final List<FoodModel> listFoods;

  DataShowFavState(this.listFoods);
}

class FavoriteErrorState extends FavoriteState {
  final String message;

  FavoriteErrorState(this.message);
}
