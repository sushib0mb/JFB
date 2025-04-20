// lib/models/dish.dart

class Dish {
  final String name;
  final String description;
  final double price;
  final List<String> allergens;
  final String imagePath;
  final bool isVegan;

  const Dish({
    required this.name,
    required this.description,
    required this.price,
    required this.allergens,
    required this.imagePath,
    required this.isVegan,
  });

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "price": price,
        "allergens": allergens,
        "image_path": imagePath,
        "is_vegan": isVegan,
      };

  factory Dish.fromJson(Map<String, dynamic> json) {
    // sometimes PostgREST will return camelCase or snake_case,
    // so we do a little fallback for both:
    final rawImage = json['image_path'] ?? json['imagePath'] ?? '';
    final rawVegan = json['is_vegan'] ?? json['isVegan'] ?? false;

    return Dish(
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      allergens: List<String>.from(json['allergens'] ?? <dynamic>[]),
      imagePath: (rawImage as String).trim(),
      isVegan: rawVegan as bool,
    );
  }
}
