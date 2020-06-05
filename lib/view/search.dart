import 'package:flutter/material.dart';
import 'package:submission/data/data_model.dart';
import 'package:submission/viewmodel/search_viewmodel.dart';

import 'detail.dart';

class FoodSearchDelegate extends SearchDelegate {
  final _viewModel = SearchViewModel();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.length < 3) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "Search term must be longer than two letters.",
            ),
          )
        ],
      );
    }

    return SafeArea(
      child: StreamBuilder<SearchState>(
        stream: _viewModel.state,
        initialData: SearchInitialState(),
        builder: (context, snapshot) {
          if (snapshot.data is SearchInitialState) {
            _viewModel.searchFoods(query);
            return _buildLoading();
          }

          if (snapshot.data is SearchLoadingState) {
            return _buildLoading();
          }

          if (snapshot.data is SearchShowState) {
            SearchShowState data = snapshot.data;
            return _buildContent(context, data.listFoods);
          }

          if (snapshot.data is SearchErrorState) {
            SearchErrorState data = snapshot.data;
            return _buildErrorContent(data.message);
          }

          return _buildLoading();
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, List<FoodModel> data) {
    return Center(
        child: ListView.builder(
      padding: EdgeInsets.only(top: 8.0),
      itemCount: data.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildItemList(context, data[index]);
      },
    ));
  }

  Widget _buildItemList(BuildContext context, FoodModel food) {
    return GestureDetector(
      onTap: () {
        final snackBar = SnackBar(
          content: Text(food.name),
          action: SnackBarAction(
            label: 'Open Detail',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FoodDetail(
                          foods: food,
                        )),
              );
            },
          ),
        );

        Scaffold.of(context).showSnackBar(snackBar);
      },
      child: Padding(
        padding: EdgeInsets.all(8),
        child: ListTile(
          leading: Hero(
            tag: food.id,
            child: Image.network(
              food.image,
              fit: BoxFit.fitHeight,
            ),
          ),
          title: Text(food.name),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorContent(String msg) {
    return Center(
      child: Text(msg),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Column();
  }
}
