class Event {
  final String name;
  final String startTime;
  final String endTime;
  final int stage;
  final String icon;
  final String description;

  Event({
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.stage,
    required this.icon,
    required this.description,
  });
}

class EventItem {
  final String title;
  final String time;
  final String image; // Flutter ではアイコン名や画像パスに置き換え

  EventItem({required this.title, required this.time, required this.image});
}

class ScheduleItem {
  final String time;
  final EventItem? stage1Event;
  final EventItem? stage2Event;

  ScheduleItem({required this.time, this.stage1Event, this.stage2Event});
}

final List<ScheduleItem> day1ScheduleData = [
  ScheduleItem(
    time: "11:00 am",
    stage1Event: EventItem(
      title: "Opening Ceremony",
      time: "11:00-11:30",
      image: "icon_socialdance", // ※実際のアイコンまたは画像パスに変更
    ),
    stage2Event: null,
  ),
  ScheduleItem(
    time: "11:30 am",
    stage1Event: null,
    stage2Event: EventItem(
      title: "Welcome Performance",
      time: "11:30-11:45",
      image: "icon_music_note",
    ),
  ),
  ScheduleItem(
    time: "12:00 pm",
    stage1Event: EventItem(
      title: "Showa Boston Dance Performance",
      time: "12:00-12:15",
      image: "icon_dance",
    ),
    stage2Event: EventItem(
      title: "Live Music",
      time: "12:00-12:30",
      image: "icon_music_mic",
    ),
  ),
  // 他のスケジュール項目...
];

final List<ScheduleItem> day2ScheduleData = [
  ScheduleItem(
    time: "11:00 am",
    stage1Event: EventItem(
      title: "Opening Ceremony",
      time: "11:00-11:30",
      image: "icon_socialdance", // ※実際のアイコンまたは画像パスに変更
    ),
    stage2Event: null,
  ),
  ScheduleItem(
    time: "11:30 am",
    stage1Event: null,
    stage2Event: EventItem(
      title: "Welcome Performance",
      time: "11:30-11:45",
      image: "icon_music_note",
    ),
  ),
  ScheduleItem(
    time: "12:00 pm",
    stage1Event: EventItem(
      title: "Showa Boston Dance Performance",
      time: "12:00-12:15",
      image: "icon_dance",
    ),
    stage2Event: EventItem(
      title: "Live Music",
      time: "12:00-12:30",
      image: "icon_music_mic",
    ),
  ),
  // 他のスケジュール項目...
];
