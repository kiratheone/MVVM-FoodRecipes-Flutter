class FoodModel {
  final String name;
  final String image;
  final String desc;
  final String id;
  final int type; // 0 seafood; 1 dessert

  FoodModel(this.name, this.image, this.desc, this.id, this.type);

  factory FoodModel.fromJson(Map<String, dynamic> json, int type) {
    return FoodModel(json['strMeal'], json['strMealThumb'],
        json['strInstructions'], json['idMeal'], type);
  }

  Map<String, dynamic> toDatabaseJson() => {
        "strMeal": this.name,
        "strMealThumb": this.image,
        "type": this.type,
        "idMeal": this.id
      };
}
