// lib/services/supabase_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:postgrest/postgrest.dart';
import '/models/food_booth.dart';
import '/models/dish.dart';

class SupabaseService {
  final _client = Supabase.instance.client;
Future<List<FoodBooth>> fetchFoodBooths() async {
  try {
    // First fetch all food booths
    final boothsData = await _client
      .from('food_booths')
      .select('*');
      
    
    // Create initial booths without dishes
    List<FoodBooth> booths = (boothsData as List)
      .map((booth) => FoodBooth.fromJson({...booth, 'dishes': []}))
      .toList();
    
    // Now fetch dishes for each booth separately
    for (int i = 0; i < booths.length; i++) {
      final dishesData = await _client
        .from('dishes')
        .select('*')
        .eq('booth_id', booths[i].id);
        
      
      if (dishesData.isNotEmpty) {
        // Update the booth with its dishes
        List<Dish> parsedDishes = (dishesData as List)
          .map((dishJson) => Dish.fromJson(dishJson))
          .toList();
          
        // Create a new booth with the dishes
        booths[i] = FoodBooth(
          id: booths[i].id,
          name: booths[i].name,
          boothLocation: booths[i].boothLocation,
          mapPageFoodLocation: booths[i].mapPageFoodLocation,
          dishImagePath: booths[i].dishImagePath,
          genre: booths[i].genre,
          payments: booths[i].payments,
          isVegan: booths[i].isVegan,
          dishes: parsedDishes,
        );
      }
    }
    // Debug output
    
    return booths;
  } catch (e) {
    print('❌ Error fetching booths: $e');
    throw Exception('Error fetching booths: $e');
  }
}
}