
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main(){
  group("Test Food list - ", (){
    final titleBar = find.text('List Foods');
    final navBar1 = find.text('Seafood');
    final navBar2 = find.text('Dessert');
    final navBar3 = find.text('Favorite');

    FlutterDriver driver;
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) driver.close();
    });

    test('Display Foods', () async {

      expect(await driver.getText(titleBar), "List Foods");
      expect(await driver.getText(navBar1), "Seafood");
      expect(await driver.getText(navBar2), "Dessert");
      expect(await driver.getText(navBar3), "Favorite");
      await driver.tap(navBar1);
      await driver.tap(navBar2);
      await driver.tap(navBar3);
    });



  });
}