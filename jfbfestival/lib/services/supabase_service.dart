// lib/services/supabase_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:collection/collection.dart'; // Import for groupBy

// Import your models
import '/models/food_booth.dart';
import '/models/dish.dart'; // Ensure Dish model is imported if FoodBooth.fromJson needs it
import '/data/timetableData.dart';


class SupabaseService {
  final _client = Supabase.instance.client;

  // --- Food Booth Fetching ---
  Future<List<FoodBooth>> fetchFoodBooths() async {
    print("🚀 Fetching food booths with embedded dishes...");
    try {
      final response = await _client
          .from('food_booths')
          .select('*, dishes(*)'); // Assumes dishes(*) embedding works

      if (response == null) {
         print('❌ Error fetching booths: Response is null.');
         throw Exception('Failed to fetch booths: Received null response.');
      }

      // Safely cast List<dynamic> to List<Map<String, dynamic>>
      final List<Map<String, dynamic>> rawBoothsData = List<Map<String, dynamic>>.from(response);


      if (rawBoothsData.isEmpty) {
        print("ℹ️ No food booths found.");
        return [];
      }

      // Parse using FoodBooth.fromJson (ensure it handles nested dishes)
      List<FoodBooth> booths = rawBoothsData
          .map((boothJson) {
            try {
              return FoodBooth.fromJson(boothJson);
            } catch (e, stackTrace) {
              print('❌ Error parsing booth: $boothJson');
              print('   Error: $e');
              print('   StackTrace: $stackTrace');
              return null;
            }
          })
          .whereType<FoodBooth>()
          .toList();

      print("✅ Successfully fetched and parsed ${booths.length} booths.");
      if (booths.isNotEmpty) {
         print("   Example Booth: ${booths.first.name}, Dishes count: ${booths.first.dishes.length}");
         if (booths.first.dishes.isNotEmpty) {
            print("      Example Dish: ${booths.first.dishes.first.name}");
         }
      }

      return booths;

    } on PostgrestException catch (e) {
       print('❌ Supabase Error fetching booths: ${e.message}');
       print('   Code: ${e.code}, Details: ${e.details}, Hint: ${e.hint}');
       throw Exception('Supabase error: ${e.message}');
    } catch (e, stackTrace) {
       print('❌ Unexpected Error fetching booths: $e');
       print('   StackTrace: $stackTrace');
       throw Exception('Unexpected error fetching booths: $e');
    }
  }

  // --- Schedule Event Fetching ---
  // Assumes 'schedule_events' table has 'day_number' column (integer 1 or 2)
  Future<List<ScheduleItem>> fetchScheduleForDay(int dayNumber) async {
    print("🚀 Fetching schedule events for Day $dayNumber...");
    try {
      final response = await _client
          .from('schedule_events') // Use your actual table name
          .select('*')
          .eq('day_number', dayNumber) // Filter by day
          .order('grouping_time', ascending: true) // Primary sort for grouping
          .order('event_time_range', ascending: true); // Secondary sort within group

      if (response == null) {
        print('❌ Error fetching schedule for Day $dayNumber: Response is null.');
        throw Exception('Failed to fetch schedule: Received null response.');
      }

      // Safely cast List<dynamic> to List<Map<String, dynamic>>
      final List<Map<String, dynamic>> rawEventsData = List<Map<String, dynamic>>.from(response);

      if (rawEventsData.isEmpty) {
        print("ℹ️ No schedule events found for Day $dayNumber.");
        return [];
      }

      // Process Raw Data into EventItem List
      List<EventItem> allEvents = rawEventsData
          .map((eventJson) {
            try {
              // Assumes EventItem.fromJson exists and works correctly
              return EventItem.fromJson(eventJson);
            } catch (e, stackTrace) {
              print('❌ Error parsing event: $eventJson');
              print('   Error: $e\n   StackTrace: $stackTrace');
              return null;
            }
          })
          .whereType<EventItem>() // Filter out any nulls from parsing errors
          .toList();

      // Group EventItems into ScheduleItems
      final groupedByTime = groupBy(
          allEvents, (EventItem event) => event.groupingTime ?? 'Unknown Time');

      // Create ScheduleItem list from grouped data, ensuring chronological order
      List<ScheduleItem> scheduleItems = [];
      final sortedTimes = groupedByTime.keys.toList()
        ..sort((a, b) => parseTimeToMinutes(a).compareTo(parseTimeToMinutes(b))); // Sort keys

      for (var timeKey in sortedTimes) {
         final eventsForTime = groupedByTime[timeKey]!;
         scheduleItems.add(ScheduleItem(
           time: timeKey, // The grouping time ("11:00 am")
           stage1Events: eventsForTime
               .where((e) => e.stage == 'Stage 1') // Ensure case/name matches your DB
               .toList(),
           stage2Events: eventsForTime
               .where((e) => e.stage == 'Stage 2') // Ensure case/name matches your DB
               .toList(),
         ));
      }

      print("✅ Successfully fetched and processed ${allEvents.length} events into ${scheduleItems.length} time slots for Day $dayNumber.");
      return scheduleItems;

    } on PostgrestException catch (e) {
      print('❌ Supabase Error fetching schedule Day $dayNumber: ${e.message}');
      throw Exception('Supabase error: ${e.message}');
    } catch (e, stackTrace) {
      print('❌ Unexpected Error fetching schedule Day $dayNumber: $e');
      print('   StackTrace: $stackTrace');
      throw Exception('Unexpected error fetching schedule: $e');
    }
  }

  // --- Helper Functions ---

  // Static helper function to parse time for sorting within this service
  static int parseTimeToMinutes(String timeString) {
    try {
      timeString = timeString.toLowerCase().trim();
      bool isPM = timeString.contains('pm');
      // Remove am/pm and potentially surrounding spaces
      timeString = timeString.replaceAll(RegExp(r'\s*(am|pm)\s*$'), '');

      final parts = timeString.split(':');
      if (parts.length < 2) return 99999; // Invalid format, sort last

      int hour = int.tryParse(parts[0]) ?? 0;
      int minute = int.tryParse(parts[1]) ?? 0;

      if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return 99999; // Invalid values

      // Convert to 24-hour format
      if (isPM && hour < 12) {
        hour += 12;
      }
      if (!isPM && hour == 12) { // Handle 12 AM edge case -> 00:xx
        hour = 0;
      }
      // Note: 12 PM (12:xx) is already correct in 24-hour format

      return hour * 60 + minute;
    } catch (e) {
      print("Error parsing time '$timeString' for sorting: $e");
      return 99999; // Fallback for sorting, puts invalid times last
    }
  }
}