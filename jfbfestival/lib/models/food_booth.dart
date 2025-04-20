// lib/models/food_booth.dart
import 'dart:convert';
import 'dish.dart';

class FoodBooth {
  final String name;
  final String image;
  final String description;
  final String? allergy;
  final String boothLocation;
  final String genre;
  final String logoPath;
  final String dishImagePath;
  final bool isVegan;
  final String mapPageFoodLocation;
  final List<String> payments;
  final List<String> allergens;
  final List<Dish> dishes;

  const FoodBooth({
    required this.mapPageFoodLocation,
    required this.name,
    required this.image,
    required this.description,
    this.allergy,
    required this.boothLocation,
    required this.genre,
    required this.logoPath,
    required this.dishImagePath,
    required this.isVegan,
    required this.payments,
    required this.allergens,
    this.dishes = const [],
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'image': image,
    'description': description,
    'allergy': allergy,
    'booth_location': boothLocation,
    'map_page_food_location': mapPageFoodLocation,
    'genre': genre,
    'logo_path': logoPath,
    'dish_image_path': dishImagePath,
    'is_vegan': isVegan,
    'payments': payments,
    'allergens': allergens,
    'dishes': dishes.map((d) => d.toJson()).toList(),
  };
factory FoodBooth.fromJson(Map<String, dynamic> json) {
  // 1) grab raw 'dishes' (could be JSON string or List)
  final raw = json['dishes'];

  // 2) normalize to List<dynamic>
  List<dynamic> list;
  if (raw is String) {
    try {
      list = jsonDecode(raw) as List<dynamic>;
    } catch (_) {
      list = <dynamic>[];
    }
  } else if (raw is List) {
    list = raw;
  } else {
    list = <dynamic>[];
  }

  // 3) map to Dish
  final dishList = list
    .map((e) => Dish.fromJson(e as Map<String, dynamic>))
    .toList();

  // Handle allergens which might be a string or a list
  var allergensData = json['allergens'] ?? <dynamic>[];
  List<String> allergensList;
  
  if (allergensData is String) {
    try {
      // Try to parse the string as JSON
      allergensList = List<String>.from(jsonDecode(allergensData));
    } catch (_) {
      // If parsing fails, treat as a single item
      allergensList = [allergensData];
    }
  } else if (allergensData is List) {
    allergensList = List<String>.from(allergensData);
  } else {
    allergensList = [];
  }

  // Same for payments
  var paymentsData = json['payments'] ?? <dynamic>[];
  List<String> paymentsList;
  
  if (paymentsData is String) {
    try {
      paymentsList = List<String>.from(jsonDecode(paymentsData));
    } catch (_) {
      paymentsList = [paymentsData];
    }
  } else if (paymentsData is List) {
    paymentsList = List<String>.from(paymentsData);
  } else {
    paymentsList = [];
  }

  return FoodBooth(
    mapPageFoodLocation: json['map_page_food_location'] as String,
    name: json['name'] as String,
    image: (json['image'] as String).trim(),
    description: json['description'] as String,
    allergy: json['allergy'] as String?,
    boothLocation: json['booth_location'] as String,
    genre: json['genre'] as String,
    logoPath: (json['logo_path'] as String).trim(),
    dishImagePath: (json['dish_image_path'] as String).trim(),
    isVegan: json['is_vegan'] as bool,
    payments: paymentsList,
    allergens: allergensList,
    dishes: dishList,
  );
}
}