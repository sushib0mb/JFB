// lib/services/supabase_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:postgrest/postgrest.dart';

class SupabaseService {
  final _client = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> fetchFoodBooths() async {
    try {
      final data = await _client
        .from('food_booths')
        .select('*, dishes(*)');   // no `!…` needed
      print('🔍 raw supabase booths: $data');
      return List<Map<String, dynamic>>.from(data as List);
    } on PostgrestException catch (e) {
      throw Exception('Error fetching booths: ${e.message}');
    }
  }
}
