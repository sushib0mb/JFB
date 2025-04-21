// lib/services/supabase_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
// Removed Postgrest import as it's not directly needed here
import '/models/food_booth.dart'; // Ensure FoodBooth.fromJson is updated (See Step 2)
// Removed Dish import as parsing happens within FoodBooth.fromJson now

class SupabaseService {
  final _client = Supabase.instance.client;

  Future<List<FoodBooth>> fetchFoodBooths() async {
    print("🚀 Fetching food booths with embedded dishes..."); // Add log
    try {
      // --- OPTIMIZED QUERY ---
      // Fetch booths AND their related dishes in one go.
      // Assumes a foreign key relationship exists in Supabase:
      // dishes.booth_id -> food_booths.id
      final response = await _client
          .from('food_booths')
          .select('*, dishes(*)'); // <-- Embed related dishes

      // Handle potential errors or empty data
      if (response == null) {
         print('❌ Error fetching booths: Response is null.');
         throw Exception('Failed to fetch booths: Received null response.');
      }

      // The response is already List<dynamic> (each element is Map<String, dynamic>)
      // Cast it safely
      final List<dynamic> rawBoothsData = response as List<dynamic>;

      if (rawBoothsData.isEmpty) {
        print("ℹ️ No food booths found.");
        return []; // Return empty list if no booths
      }

      // --- PARSING WITH UPDATED fromJson ---
      // Now, each 'boothJson' map should contain a 'dishes' key
      // with a list of dish maps. FoodBooth.fromJson handles this.
      List<FoodBooth> booths = rawBoothsData
          .map((boothJson) {
            // Ensure the item is actually a Map before processing
            if (boothJson is Map<String, dynamic>) {
               try {
                 return FoodBooth.fromJson(boothJson);
               } catch (e, stackTrace) {
                  print('❌ Error parsing booth: $boothJson');
                  print('   Error: $e');
                  print('   StackTrace: $stackTrace');
                  return null; // Return null for booths that fail parsing
               }
            } else {
               print('⚠️ Unexpected item type in response: ${boothJson?.runtimeType}');
               return null; // Skip items that are not maps
            }
          })
          .whereType<FoodBooth>() // Filter out any nulls from parsing errors
          .toList();

      print("✅ Successfully fetched and parsed ${booths.length} booths.");
      // Optional: Log details of the first booth for verification
      if (booths.isNotEmpty) {
         print("   Example Booth: ${booths.first.name}, Dishes count: ${booths.first.dishes.length}");
         if (booths.first.dishes.isNotEmpty) {
            print("      Example Dish: ${booths.first.dishes.first.name}");
         }
      }

      return booths;

    } on PostgrestException catch (e) { // Catch specific Supabase errors
       print('❌ Supabase Error fetching booths: ${e.message}');
       print('   Code: ${e.code}, Details: ${e.details}, Hint: ${e.hint}');
       throw Exception('Supabase error: ${e.message}');
    } catch (e, stackTrace) { // Catch general errors
       print('❌ Unexpected Error fetching booths: $e');
       print('   StackTrace: $stackTrace');
       throw Exception('Unexpected error fetching booths: $e');
    }
  }
}