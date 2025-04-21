import 'dish.dart';
class FoodBooth {
  final String id;
  final String name;
  final String boothLocation;
  final String mapPageFoodLocation;
  final String dishImagePath;
  final String genre;
  final List<String> payments;
  final bool isVegan;
  final List<Dish> dishes;

  FoodBooth({
    required this.id,
    required this.name,
    required this.boothLocation,
    required this.mapPageFoodLocation,
    required this.dishImagePath,
    required this.genre,
    required this.payments,
    required this.isVegan,
    required this.dishes,
  });

  factory FoodBooth.fromJson(Map<String, dynamic> json) {
     List<Dish> parsedDishes = [];
       if (json['dishes'] != null) {
    parsedDishes = (json['dishes'] as List)
        .map((dishJson) => Dish.fromJson(dishJson))
        .toList();
  }
    return FoodBooth(
      
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      boothLocation: json['booth_location'] ?? '',
      mapPageFoodLocation: json['map_page_food_location'] ?? '',
      dishImagePath: json['dish_image_path'] ?? '',
      genre: json['genre'] ?? '',
      payments: (json['payments'] ?? '')
          .toString()
          .split('|')
          .map((e) => e.trim())
          .toList(),
      isVegan: json['is_vegan'] ?? false,
     
   dishes: parsedDishes,
    
    );
  }
}
