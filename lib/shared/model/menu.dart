import 'item.dart';

class Menu {
  final List<Item> foods;
  final List<Item> drinks;

  Menu({required this.foods, required this.drinks});

  factory Menu.fromJson(Map<String, dynamic> json) => Menu(
    foods: List<Item>.from(json['foods'].map((x) => Item.fromJson(x))),
    drinks: List<Item>.from(json['drinks'].map((x) => Item.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    'foods': List<dynamic>.from(foods.map((x) => x.toJson())),
    'drinks': List<dynamic>.from(drinks.map((x) => x.toJson())),
  };
}
