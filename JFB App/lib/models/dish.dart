class Dish {
  final String name;
  final String description;
  final String imagePath;
  final List<String> allergens;
  final bool isVegan;
  final double price;

  Dish({
    required this.name,
    required this.description,
    this.imagePath = '',
    required this.allergens,
    required this.isVegan,
    required this.price,
  });
}