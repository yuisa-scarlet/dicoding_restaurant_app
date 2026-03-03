import 'item.dart';

class Menu {
  final List<Item> foods;
  final List<Item> drinks;

  Menu({required this.foods, required this.drinks});

  factory Menu.fromJson(Map<String, dynamic> json) => Menu(
    foods: List<Item>.from(json['foods'].map((food) => Item.fromJson(food))),
    drinks: List<Item>.from(json['drinks'].map((drink) => Item.fromJson(drink))),
  );

  Map<String, dynamic> toJson() => {
    'foods': List<dynamic>.from(foods.map((food) => food.toJson())),
    'drinks': List<dynamic>.from(drinks.map((drink) => drink.toJson())),
  };
}
