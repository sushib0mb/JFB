class Dish {
  final String id; // Or whatever type your ID is
  final String boothId;
  final String name;
  final String description;
  final double price;
  final String? imagePath; // <-- CHANGE: Make nullable
  final List<String> allergens;
  final bool isVegan;

  Dish({
    required this.id,
    required this.boothId,
    required this.name,
    required this.description,
    required this.price,
    required this.imagePath, // <-- Accepts String? now
    required this.allergens,
    required this.isVegan,
  });

  // Your fromJson factory (no changes needed here now)
  factory Dish.fromJson(Map<String, dynamic> json) {
  String? parseImagePath(dynamic pathValue) {
    if (pathValue is String) {
      final trimmedPath = pathValue.trim();
      return trimmedPath.isEmpty ? null : trimmedPath;
    }
    return null;
  }


  
  // ***************************
    return Dish(
      id: json['id'] ?? '',
      boothId: json['booth_id'] ?? '',
      name: json['name'] as String? ?? 'Unnamed Dish',
      description: json['description'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      imagePath: parseImagePath(json['imagePath']), // Passes String?
      allergens: (json['allergens'] is List)
          ? List<String>.from(json['allergens'])
          : (json['allergens'] is String
                  ? (json['allergens'] as String)
                      .split(',')
                      .map((a) => a.trim())
                      .where((a) => a.isNotEmpty)
                      .toList()
                  : []),
      isVegan: json['is_vegan'] as bool? ?? false,
    );
  }


}