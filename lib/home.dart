
import 'package:flutter/material.dart';
import 'package:submission/config.dart';
import 'package:submission/main.dart';
import 'package:submission/util/key.dart';
import 'package:submission/view/favorite.dart';
import 'package:submission/view/page.dart';
import 'package:submission/view/search.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  PageController controller = PageController();

  void _onBottomItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      controller.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  void _onPageChange(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Center(
            child: Text(widget.title,key: SubsKeys.title),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: FoodSearchDelegate(),
                );
              },
            )
          ],
        ),
        body: PageView.builder(
            controller: controller,
            itemCount: 3,
            onPageChanged: _onPageChange,
            itemBuilder: (context, position) {
              if (position == 0) {
                return Page(
                  food: Food.meal,
                );
              } else if (position == 1) {
                return Page(
                  food: Food.dessert,
                );
              } else {
                return Favorite();
              }
            }),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.fastfood),
              title: Text('Seafood'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.free_breakfast),
              title: Text('Dessert'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              title: Text('Favorite'),
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Config.appColor,
          onTap: _onBottomItemTapped,
        ));
  }
}