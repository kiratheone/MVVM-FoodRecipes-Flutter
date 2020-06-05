import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:submission/data/data_model.dart';
import 'package:submission/data/data_repository.dart';
import 'package:submission/main.dart';
import 'package:http/http.dart' as http;
import 'package:submission/util/key.dart';

import 'package:submission/viewmodel/data_viewmodel.dart';
import 'package:submission/view/detail.dart';

class Page extends StatefulWidget {
  final Food food;
  final DataRepository _repository = DataRepository(http.Client());

  Page({
    Key key,
    @required this.food
  })
      : assert(food != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _PageState();

}

class _PageState extends State<Page> with AutomaticKeepAliveClientMixin<Page> {
  DataViewModel _viewModel;

  @override
  void initState() {
    _viewModel = DataViewModel(widget._repository);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
        child: StreamBuilder<DataState>(
          stream: _viewModel.state.asBroadcastStream(),
          initialData: DataInitialState(),
          builder: (context, snapshot) {
            if (snapshot.data is DataInitialState) {
              _viewModel.loadData(widget.food);
              return _buildLoading();
            }

            if (snapshot.data is DataLoadingState) {
              return _buildLoading();
            }

            if (snapshot.data is DataShowState) {
              DataShowState data = snapshot.data;
              return _buildContent(context, data.listFoods);
            }

            if (snapshot.data is DataErrorState) {
              DataErrorState data = snapshot.data;
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
      key: SubsKeys.detail(food.id),
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
          tag: food.id,
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
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              FoodDetail(
                foods: food,
              )),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(
        key: SubsKeys.loading,
      ),
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