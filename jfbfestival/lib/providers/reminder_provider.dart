import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/notification_service.dart';
import '/data/timetableData.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
class ReminderProvider extends ChangeNotifier {
  bool _enabled = false;
  bool _loaded = false;         // 🚨 Add this
  bool get enabled => _enabled;
  bool get isLoaded => _loaded; // 🚨 Expose load status

  final _notifier = NotificationService();

  ReminderProvider() {
    _init(); // initialize upon creation
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    _enabled = prefs.getBool('reminders') ?? false;
    _loaded = true;               // ✅ Mark finished loading
    notifyListeners();

    await _notifier.init(); // init plugin
    if (_enabled) unawaited(_scheduleAll());
  }

  Future<void> toggle() async {
  if (!_enabled && Platform.isIOS) {
    await _notifier.requestPermissions(); // ❗ Prompt on enable
  }
  await _setEnabled(!_enabled);
}
Future<void> _setEnabled(bool v) async {
  _enabled = v;
  notifyListeners();

  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('reminders', v);

  if (v) {
    if (Platform.isIOS) {
      await _notifier.requestPermissions(); // ✅ Prompt user here
    }
    unawaited(_scheduleAll());
  } else {
    unawaited(_notifier.cancelAll());
  }
}

Future<void> _scheduleAll() async {
  await _notifier.cancelAll(); // clean slate
  int id = 0;

//   // For debugging purposes
// if (kDebugMode) {
//   await _notifier.cancelAll();

//   // Simulated current time: April 26, 2025 at 1:15 PM (UTC-4)
//   final simulatedNow = tz.TZDateTime(tz.local, 2025, 4, 26, 13, 15);
//   debugPrint('⏱ Simulated current time: $simulatedNow');

//   final matchingItem = day1ScheduleData.firstWhere(
//     (item) => item.time.trim() == "1:30 pm",
//     orElse: () => throw Exception("❌ No ScheduleItem found for 1:30 pm"),
//   );

//   final event = matchingItem.stage1Events!.firstWhere(
//     (e) => e.time.startsWith("13:30"),
//     orElse: () => throw Exception("❌ No EventItem starts at 13:30"),
//   );

//   // Fire 5 seconds from now for debug purposes
//   final fireTime = tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5));
//   final formatted = "${fireTime.hour.toString().padLeft(2, '0')}:${fireTime.minute.toString().padLeft(2, '0')}";

//   debugPrint("🔔 Scheduling debug notification for '${event.title}' at $formatted");

//   await _notifier.fln.zonedSchedule(
//     9999,
//     "🔔 Coming Up: ${event.title}",
//     "Starting at 1:30 PM on April 26",
//     fireTime,
//     NotificationDetails(
//       android: AndroidNotificationDetails(
//         'events',
//         'Event reminders',
//         importance: Importance.max,
//         priority: Priority.high,
//         color: Color(0xFFEF5350),
//         colorized: true,
//       ),
//       iOS: DarwinNotificationDetails(
//         presentAlert: true,
//         presentBadge: true,
//         presentSound: true,
//       ),
//     ),
//     uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
//     androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//     matchDateTimeComponents: DateTimeComponents.dateAndTime,
//   );

//   await _notifier.logPending("after debug schedule (simulated 1:15 PM)");
//   return;
// }


final now = tz.TZDateTime.now(tz.local);  // current local time
final List<List<ScheduleItem>> allDays = [day1ScheduleData, day2ScheduleData];
final List<int> dayDates = [26, 27]; // actual calendar dates

for (int i = 0; i < allDays.length; i++) {
  for (final item in allDays[i]) {
    final events = [...?item.stage1Events, ...?item.stage2Events];
    for (final e in events) {
      // Skip if time is invalid or title is blank
      if (!e.time.contains('-') || e.title.trim().isEmpty) continue;

      // Skip known filler or sponsor-related events
      final lowerTitle = e.title.toLowerCase();
      if (lowerTitle.contains('sponsor') ||
          lowerTitle.contains('raffle') ||
          lowerTitle.contains('advertising') ||
          lowerTitle.contains('individual') ||
          lowerTitle.contains('organizer') ||
          lowerTitle.contains('downtown') ||
          lowerTitle.contains('placeholder')) {
        continue;
      }

      final startStr = e.time.split('-')[0].trim();
      final parts = startStr.split(':');
      if (parts.length != 2) continue;

      final hour = int.tryParse(parts[0]);
      final minute = int.tryParse(parts[1]);
      if (hour == null || minute == null) continue;

      // Target time of the event
      final eventStart = tz.TZDateTime(tz.local, 2025, 4, dayDates[i], hour, minute);

      // Lead time is 15 minutes before the event
      final leadTime = const Duration(minutes: 15);
      final fireTime = eventStart.subtract(leadTime);

      // 🔔 Schedule only if current time is *exactly* 15 minutes before the event
      if (now.year == fireTime.year &&
          now.month == fireTime.month &&
          now.day == fireTime.day &&
          now.hour == fireTime.hour &&
          now.minute == fireTime.minute) {
        try {
          await _notifier.schedule(
            id: id++,
            title: '🔔 Coming up: ${e.title}',
            body: 'Starting at ${startStr}',
            when: eventStart,
            leadTime: leadTime,
          );
          debugPrint('✅ Scheduled notification for ${e.title} at $eventStart');
        } catch (e) {
          debugPrint('❌ Failed to schedule notification: $e');
        }
      }
    }
  }
}

// Verify scheduled notifications
await _notifier.logPending('after scheduling only matching events');
} 
}