import 'item.dart';
import 'menu.dart';
import 'customer_review.dart';

class Restaurant {
  final String id;
  final String name;
  final String description;
  final String pictureId;
  final String city;
  final double rating;
  final String? address;
  final List<Item>? categories;
  final Menu? menus;
  final List<CustomerReview>? customerReviews;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
    this.address,
    this.categories,
    this.menus,
    this.customerReviews,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    pictureId: json['pictureId'],
    city: json['city'],
    rating: (json['rating'] as num).toDouble(),
    address: json['address'],
    categories: json['categories'] == null
        ? null
        : List<Item>.from(json['categories'].map((x) => Item.fromJson(x))),
    menus: json['menus'] == null ? null : Menu.fromJson(json['menus']),
    customerReviews: json['customerReviews'] == null
        ? null
        : List<CustomerReview>.from(
            json['customerReviews'].map((x) => CustomerReview.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'pictureId': pictureId,
    'city': city,
    'rating': rating,
    if (address != null) 'address': address,
    if (categories != null)
      'categories': List<dynamic>.from(categories!.map((x) => x.toJson())),
    if (menus != null) 'menus': menus!.toJson(),
    if (customerReviews != null)
      'customerReviews': List<dynamic>.from(
        customerReviews!.map((x) => x.toJson()),
      ),
  };
}
