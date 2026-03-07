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

  Restaurant copyWith({
    String? id,
    String? name,
    String? description,
    String? pictureId,
    String? city,
    double? rating,
    String? address,
    List<Item>? categories,
    Menu? menus,
    List<CustomerReview>? customerReviews,
  }) {
    return Restaurant(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      pictureId: pictureId ?? this.pictureId,
      city: city ?? this.city,
      rating: rating ?? this.rating,
      address: address ?? this.address,
      categories: categories ?? this.categories,
      menus: menus ?? this.menus,
      customerReviews: customerReviews ?? this.customerReviews,
    );
  }

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
        : List<Item>.from(
            json['categories'].map((category) => Item.fromJson(category)),
          ),
    menus: json['menus'] == null ? null : Menu.fromJson(json['menus']),
    customerReviews: json['customerReviews'] == null
        ? null
        : List<CustomerReview>.from(
            json['customerReviews'].map(
              (review) => CustomerReview.fromJson(review),
            ),
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
      'categories': List<dynamic>.from(
        categories!.map((category) => category.toJson()),
      ),
    if (menus != null) 'menus': menus!.toJson(),
    if (customerReviews != null)
      'customerReviews': List<dynamic>.from(
        customerReviews!.map((review) => review.toJson()),
      ),
  };

  factory Restaurant.fromMap(Map<String, dynamic> map) {
    return Restaurant(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      pictureId: map['pictureId'],
      city: map['city'],
      rating: map['rating'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'pictureId': pictureId,
      'city': city,
      'rating': rating,
    };
  }
}
