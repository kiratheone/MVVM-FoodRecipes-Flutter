import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:submission/data/data_model.dart';
import 'package:submission/data/data_repository.dart';
import 'package:submission/data/local_repository.dart';
import 'package:submission/util/key.dart';
import 'package:submission/viewmodel/detail_viewmodel.dart';
import 'package:submission/viewmodel/favorite_viewmodel.dart';

class FoodDetail extends StatefulWidget {
  final FoodModel foods;
  final DataRepository _repository = DataRepository(http.Client());
  final LocalRepository _localRepository = LocalRepository();

  FoodDetail({
    Key key,
    @required this.foods,
  })  : assert(foods != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _DetailState();
}

class _DetailState extends State<FoodDetail> {
  DetailViewModel _viewModel;
  FavoriteViewModel _favViewModel;
  bool _isFavorite = false;

  @override
  void initState() {
    _viewModel = DetailViewModel(widget._repository);
    _favViewModel = FavoriteViewModel(widget._localRepository);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _viewModel.onDisposed();
    _favViewModel.onDisposed();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Food Detail"),
        actions: <Widget>[
          StreamBuilder<FavoriteState>(
            initialData: FavoriteInitialState(),
            stream: _favViewModel.favoriteState,
            builder: (context, snapshot) {
              if (snapshot.data is FavoriteInitialState) {
                _favViewModel.checkFav(widget.foods);
              }

              if (snapshot.data is FavoriteAdded) {
                _isFavorite = true;
              }

              if (snapshot.data is FavoriteRemoved) {
                _isFavorite = false;
              }

              return IconButton(
                icon:
                    Icon(_isFavorite ? Icons.favorite : Icons.favorite_border),
                onPressed: () {
                  setState(() {
                    _isFavorite = _isFavorite ? false : true;
                    _favViewModel.addRemoveFav(foodModel: widget.foods);
                  });
                },
              );
            },
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Hero(
                    tag: widget.foods.id,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(widget.foods.image),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 12),
                    child: Text(
                      widget.foods.name,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 8),
                  child: Text(
                    "How to : ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 4),
                  child: StreamBuilder<DataState>(
                    stream: _viewModel.state,
                    initialData: DataInitialState(),
                    builder: (context, snapshot) {
                      if (snapshot.data is DataInitialState) {
                        _viewModel.loadDetail(widget.foods);
                        return _buildLoading();
                      }

                      if (snapshot.data is DataLoadingState) {
                        return _buildLoading();
                      }

                      if (snapshot.data is DataShowState) {
                        DataShowState data = snapshot.data;
                        return Center(
                          child: Text(data.food.desc),
                        );
                      }

                      if (snapshot.data is DataErrorState) {
                        DataErrorState data = snapshot.data;
                        return _buildErrorContent(data.message);
                      }
                      return _buildLoading();
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorContent(String msg) {
    return Center(
      child: Text(msg),
    );
  }
}
