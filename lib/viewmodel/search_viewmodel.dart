

import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:submission/data/data_model.dart';
import 'package:submission/data/data_repository.dart';
import 'package:submission/data/result.dart';

class SearchViewModel{
  final DataRepository _repository = DataRepository(http.Client());
  final StreamController<SearchState> _searchStreamController = StreamController.broadcast();

  Stream<SearchState> get state => _searchStreamController.stream;

  void searchFoods(String query){
    _searchStreamController.sink.add(SearchState.loading());
    _repository.searchFoods(query).then((result){
      print(result);
      if (result is Ok) {
        _searchStreamController.sink.add(SearchState.showData(result.response));
      } else if (result is Error) {
        _searchStreamController.sink.add(SearchState.error(result.message));
      }
    });

  }

  void dispose() {
   _searchStreamController.close();
  }

}

class SearchState {
  SearchState();

  factory SearchState.loading() = SearchLoadingState;

  factory SearchState.showData(List<FoodModel> foods) = SearchShowState;

  factory SearchState.error(String message) = SearchErrorState;
}

class SearchLoadingState extends SearchState {}

class SearchInitialState extends SearchState {}

class SearchShowState extends SearchState {
  final List<FoodModel> listFoods;

  SearchShowState(this.listFoods);
}

class SearchErrorState extends SearchState {
  final String message;

  SearchErrorState(this.message);
}