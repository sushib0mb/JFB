class Dish {
  final String name;
  final String description;
  final String imagePath;
  final List<String> allergens;
  final bool isVegan;

  Dish({
    required this.name,
    required this.description,
    this.imagePath = '',
    required this.allergens,
    required this.isVegan,
  });
}
