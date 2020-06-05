
import 'dart:async';
import 'package:submission/data/data_model.dart';
import 'package:submission/data/data_repository.dart';
import 'package:submission/data/result.dart';

class DetailViewModel {
  final DataRepository _repository;

  DetailViewModel(this._repository);

  final StreamController<DataState> _foodStreamController =
      StreamController.broadcast();

  Stream<DataState> get state => _foodStreamController.stream;

  void loadDetail(FoodModel foodModel) {
    _foodStreamController.add(DataState.loading());
    _repository.fetchDetail(foodModel).then((result){
      if (result is Ok) {
        _foodStreamController.sink.add(DataState.showDetail(result.response));
      } else if (result is Error) {
        _foodStreamController.sink.add(DataState.error(result.message));
      }
    });
  }

  void onDisposed() {
    _foodStreamController.close();
  }
}

class DataState {
  DataState();

  factory DataState.loading() = DataLoadingState;

  factory DataState.showDetail(FoodModel foods) = DataShowState;

  factory DataState.error(String message) = DataErrorState;
}

class DataLoadingState extends DataState {}

class DataInitialState extends DataState {}

class DataShowState extends DataState {
  final FoodModel food;

  DataShowState(this.food);
}

class DataErrorState extends DataState {
  final String message;

  DataErrorState(this.message);
}
