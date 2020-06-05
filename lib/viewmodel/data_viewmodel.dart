import 'package:submission/data/data_model.dart';
import 'package:submission/data/data_repository.dart';
import 'dart:async';

import 'package:submission/data/result.dart';
import 'package:submission/main.dart';

class DataViewModel {
  DataViewModel(this._repository);

  final DataRepository _repository;

  final StreamController<DataState> _foodStreamController =
      StreamController.broadcast();

  Stream<DataState> get state => _foodStreamController.stream;

  void loadData(Food food) {
    switch (food) {
      case Food.meal:
        _loadMeal();
        break;
      case Food.dessert:
        _loadDessert();
        break;
      case Food.favorite:
        _loadFavorite();
        break;
      case Food.others:
        break;
    }
  }

  void _loadMeal() {
    _foodStreamController.sink.add(DataState.loading());
    _repository.fetchFoods().then((result) {
      print(result);
      if (result is Ok) {
        _foodStreamController.sink.add(DataState.showData(result.response));
      } else if (result is Error) {
        _foodStreamController.sink.add(DataState.error(result.message));
      }
    });
  }

  void _loadDessert() {
    _foodStreamController.sink.add(DataState.loading());
    _repository.fetchDesserts().then((result) {
      print(result);
      if (result is Ok) {
        _foodStreamController.sink.add(DataState.showData(result.response));
      } else if (result is Error) {
        _foodStreamController.sink.add(DataState.error(result.message));
      }
    });
  }

  void _loadFavorite(){
    _foodStreamController.sink.add(DataState.error("No Data"));
  }

  void onDisposed() {
    _foodStreamController.close();
  }
}

class DataState {
  DataState();

  factory DataState.loading() = DataLoadingState;

  factory DataState.showData(List<FoodModel> foods) = DataShowState;

  factory DataState.error(String message) = DataErrorState;
}

class DataLoadingState extends DataState {}

class DataInitialState extends DataState {}

class DataShowState extends DataState {
  final List<FoodModel> listFoods;

  DataShowState(this.listFoods);
}

class DataErrorState extends DataState {
  final String message;

  DataErrorState(this.message);
}
