import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/notification_service.dart';
import '/data/timetableData.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:timezone/timezone.dart'      as tz;

class ReminderProvider extends ChangeNotifier {
  bool _enabled = false;
  bool get enabled => _enabled;

  final _notifier = NotificationService();

  ReminderProvider() {
   Future<void> _init() async {
  final prefs = await SharedPreferences.getInstance();            // ← restore
  _enabled = prefs.getBool('reminders') ?? false;                 // default OFF
  notifyListeners();

  await _notifier.init();        // run plugin init *after* we load prefs
  if (_enabled) unawaited(_scheduleAll());
} 
  }

  /* public API */
  Future<void> toggle() async => _setEnabled(!_enabled);

  /* internal */

  Future<void> _setEnabled(bool v) async {
    _enabled = v;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('reminders', v);

    if (v) {
      unawaited(_scheduleAll());
    } else {
      unawaited(_notifier.cancelAll());
    }
  }

  Future<void> _scheduleAll() async {
  if (kDebugMode) {
  // clear old duplicates so id=9999 is always free
  await _notifier.cancelAll();

  final fire = tz.TZDateTime.now(tz.local).add(const Duration(seconds: 8));
  debugPrint('Scheduling debug ping at $fire  tz.local=${tz.local}');

  await _notifier.schedule(
    id:     9999,
    title:  '🔔 Test notification',
    when:   fire,              // already a TZDateTime in local zone
    leadTime: Duration.zero,
  );

  await _notifier.logPending('after debug schedule');   // << new
  return;
}
    /* ---------- REAL EVENTS ---------- */
    int id = 0;
    for (final item in [...day1ScheduleData, ...day2ScheduleData]) {
      for (final e in [...?item.stage1Events, ...?item.stage2Events]) {
        if (!e.time.contains('-')) continue;
        final parts = e.time.split('-')[0].trim().split(':');
        final day   = item.time.contains('pm') ? 28 : 27;
        final start = DateTime(2025, 4, day,
            int.parse(parts[0]), int.parse(parts[1]));
        await _notifier.schedule(id: id++, title: e.title, when: start);
      }
    }
  }
}
