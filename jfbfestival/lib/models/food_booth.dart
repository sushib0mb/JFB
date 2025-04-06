// lib/models/food_booth.dart
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
  final List<String> payments;
  final List<String> allergens;

  const FoodBooth({
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
  });
}