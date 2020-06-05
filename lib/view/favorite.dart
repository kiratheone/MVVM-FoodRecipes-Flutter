import 'package:flutter/material.dart';
import 'package:submission/data/data_model.dart';
import 'package:submission/data/local_repository.dart';
import 'package:submission/viewmodel/favorite_viewmodel.dart';

import '../main.dart';
import 'detail.dart';

class Favorite extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: SafeArea(
            child: TabBar(
              tabs: [
                Tab(text: "Seafood", icon: Icon(null)),
                Tab(text: "Desserts", icon: Icon(null)),
                Tab(text: "Others", icon: Icon(null))
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            FavoritePage(food: Food.meal),
            FavoritePage(food: Food.dessert),
            FavoritePage(food: Food.others)
          ],
        ),
      ),
    );
  }
}

class FavoritePage extends StatefulWidget {
  final Food food;
  final LocalRepository _repository = LocalRepository();

  FavoritePage({Key key, @required this.food})
      : assert(food != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  FavoriteViewModel _viewModel;

  @override
  void initState() {
    _viewModel = FavoriteViewModel(widget._repository);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: StreamBuilder<FavoriteState>(
      stream: _viewModel.favoriteState.asBroadcastStream(),
      initialData: FavoriteInitialState(),
      builder: (context, snapshot) {
        if (snapshot.data is FavoriteInitialState) {
          _viewModel.loadFavoriteFood(widget.food);
          return _buildLoading();
        }

        if (snapshot.data is FavoriteLoadingState) {
          return _buildLoading();
        }

        if (snapshot.data is DataShowFavState) {
          DataShowFavState data = snapshot.data;
          print("size fav " + data.listFoods[0].name);
          return _buildContent(context, data.listFoods);
        }

        if (snapshot.data is FavoriteErrorState) {
          FavoriteErrorState data = snapshot.data;
          return _buildErrorContent(data.message);
        }

        return _buildLoading();
      },
    ));
  }

  Widget _buildContent(BuildContext context, List<FoodModel> data) {
    return Center(
      child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 1.0,
          padding: EdgeInsets.all(8.0),
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
          children: data.map((food) => _buildItemGrid(context, food)).toList()),
    );
  }

  Widget _buildErrorContent(String msg) {
    return Center(
      child: Text(msg),
    );
  }

  Widget _buildItemGrid(BuildContext context, FoodModel food) {
    return GestureDetector(
      onTap: () {
        final snackBar = SnackBar(
          content: Text(food.name),
          action: SnackBarAction(
            label: 'Open Detail',
            onPressed: () {
              goToDetail(food);
            },
          ),
        );

        Scaffold.of(context).showSnackBar(snackBar);
      },
      child: GridTile(
        child: Hero(
          tag: food.id + "fav",
          child: Image.network(
            food.image,
            fit: BoxFit.fitHeight,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black45,
          title: Text(food.name),
        ),
      ),
    );
  }

  void goToDetail(FoodModel food) {
    print(food.id);
    final newFood =
        FoodModel(food.name, food.image, food.desc, food.id + "fav", food.type);

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => FoodDetail(
                foods: newFood,
              )),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _viewModel.onDisposed();
  }

  @override
  bool get wantKeepAlive => true;
}
