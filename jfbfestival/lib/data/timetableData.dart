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
  final String image;
  final int duration;

  EventItem({
    required this.title,
    required this.time,
    required this.duration,
    required this.image,
  });
}

class ScheduleItem {
  final String time;
  final List<EventItem>? stage1Events;
  final List<EventItem>? stage2Events;

  ScheduleItem({required this.time, this.stage1Events, this.stage2Events});
}

final List<ScheduleItem> day1ScheduleData = [
  ScheduleItem(
    time: "11:00 am",
    stage1Events: [
      EventItem(
        title: "One Week Wonder",
        time: "11:00-11:15",
        duration: 15,
        image: "assets/timetableIcons/Singing performance.png",
      ),
      EventItem(
        title: "Showa Boston Dance Performance",
        time: "11:15-11:30",
        duration: 15,
        image: "assets/timetableIcons/Dancing performance.png",
      ),
    ],
    stage2Events: [EventItem(title: "", time: "", duration: 35, image: "")],
  ),
  ScheduleItem(
    time: "11:30 am",
    stage1Events: [
      EventItem(
        title: "NODO JIMAN",
        time: "11:30-12:00",
        duration: 30,
        image: "assets/timetableIcons/Singing performance.png",
      ),
    ],
    stage2Events: [
      EventItem(
        title: "Ukulele",
        time: "11:35-12:05",
        duration: 30,
        image: "assets/timetableIcons/Singing performance.png",
      ),
    ],
  ),
  ScheduleItem(
    time: "12:00 pm",
    stage1Events: [
      EventItem(
        title: "Hiroko Watanabe Calligraphy",
        time: "12:00-12:40",
        duration: 40,
        image: "",
      ),
    ],
    stage2Events: [EventItem(title: "", time: "", duration: 25, image: "")],
  ),
  ScheduleItem(
    time: "12:30 pm",
    stage1Events: [
      EventItem(
        title: "opening ceremony",
        time: "12:40-13:00",
        duration: 20,
        image: "",
      ),
    ],
    stage2Events: [
      EventItem(title: "", time: "", duration: 25, image: ""),
      EventItem(
        title: "Berklee Band",
        time: "12:55-13:05",
        duration: 10,
        image: "",
      ),
    ],
  ),
  ScheduleItem(
    time: "1:00 pm",
    stage1Events: [
      EventItem(
        title: "Kitanodai Gagaku Ensemble",
        time: "13:00-13:30",
        duration: 30,
        image: "",
      ),
    ],
    stage2Events: [
      EventItem(title: "", time: "", duration: 5, image: ""),
      EventItem(
        title: "Anime Band",
        time: "13:05-13:45",
        duration: 40,
        image: "",
      ),
    ],
  ),
  ScheduleItem(
    time: "1:30 pm",
    stage1Events: [
      EventItem(
        title: "OKINAWA Ryukyu Kokusai Taiko",
        time: "13:30-14:00",
        duration: 30,
        image: "",
      ),
    ],
    stage2Events: [
      EventItem(
        title: "Cosplay Fashion Show",
        time: "13:45-14:05",
        duration: 20,
        image: "",
      ),
    ],
  ),
  ScheduleItem(
    time: "2:00 pm",
    stage1Events: [
      EventItem(
        title: "Jeiko Taiko Ensemble",
        time: "14:00-14:30",
        duration: 30,
        image: "",
      ),
    ],
    stage2Events: [
      EventItem(
        title: "parade to Boston Common",
        time: "14:05-14:25",
        duration: 20,
        image: "",
      ),
    ],
  ),
  ScheduleItem(
    time: "2:30 pm",
    stage1Events: [
      EventItem(
        title: "Cosplay Fashion Show",
        time: "14:30-14:50",
        duration: 20,
        image: "",
      ),
      EventItem(
        title: "Parfait Soleil Dance Performance",
        time: "14:50-15:20",
        duration: 30,
        image: "",
      ),
    ],
    stage2Events: [],
  ),
  ScheduleItem(
    time: "3:00 pm",
    stage1Events: [
      EventItem(
        title: "YAMAZAKI VS SUGIMONO",
        time: "15:20-15:30",
        duration: 10,
        image: "",
      ),
    ],
  ),
  ScheduleItem(
    time: "3:30 pm",
    stage1Events: [
      EventItem(
        title: "Japan AirLine Advertising and raffle",
        time: "15:30-15:40",
        duration: 10,
        image: "",
      ),
      EventItem(
        title: "Move&Inspire Kids Dance",
        time: "15:40-16:10",
        duration: 30,
        image: "",
      ),
    ],
  ),
  ScheduleItem(
    time: "4:00 pm",
    stage1Events: [
      EventItem(
        title: "Showa Boston Dance Performance",
        time: "16:10-16:25",
        duration: 15,
        image: "",
      ),
      EventItem(
        title: "Bon Dance Event",
        time: "16:25-16:55",
        duration: 30,
        image: "",
      ),
    ],
  ),
];

final List<ScheduleItem> day2ScheduleData = [
  ScheduleItem(
    time: "11:00 am",
    stage1Events: [
      EventItem(
        title: "Opening Ceremony",
        time: "11:00-11:05",
        duration: 5,
        image: "",
      ),
      EventItem(
        title: "Showa Boston Dance Performance",
        time: "11:05-11:20",
        duration: 15,
        image: "",
      ),
    ],
    stage2Events: [],
  ),
  ScheduleItem(
    time: "12:00 pm",
    stage1Events: [
      EventItem(
        title: "Kitanodai Gagaku Ensemble",
        time: "12:00-12:30",
        duration: 30,
        image: "",
      ),
      EventItem(
        title: "Jeiko Taiko Ensemble",
        time: "12:30-13:00",
        duration: 30,
        image: "",
      ),
      EventItem(
        title: "Minami Toyama Noh, Utai, Shinobue",
        time: "11:20-11:55",
        duration: 35,
        image: "",
      ),
    ],
    stage2Events: [],
  ),
  ScheduleItem(
    time: "11:30 pm",
    stage1Events: [
      EventItem(
        title: "IMPLEMENTATIOIN ENDS HERE",
        time: "12:00-12:30",
        duration: 30,
        image: "",
      ),
      EventItem(
        title: "Jeiko Taiko Ensemble",
        time: "12:30-13:00",
        duration: 30,
        image: "",
      ),
    ],
    stage2Events: [],
  ),
  ScheduleItem(
    time: "1:00 pm",
    stage1Events: [
      EventItem(
        title: "OKINAWA Ryukyu Kokusai Taiko",
        time: "13:00-13:30",
        duration: 30,
        image: "",
      ),
      EventItem(
        title: "Parfait Soleil Dance Performance",
        time: "13:30-14:00",
        duration: 30,
        image: "",
      ),
    ],
    stage2Events: [],
  ),
  ScheduleItem(
    time: "2:00 pm",
    stage1Events: [
      EventItem(
        title: "Cosplay Fashion Show",
        time: "14:00-14:30",
        duration: 30,
        image: "",
      ),
      EventItem(
        title: "NODO JIMAN",
        time: "14:30-15:00",
        duration: 30,
        image: "",
      ),
    ],
    stage2Events: [],
  ),
  ScheduleItem(
    time: "3:00 pm",
    stage1Events: [
      EventItem(
        title: "Move&Inspire Kids Dance",
        time: "15:00-15:20",
        duration: 20,
        image: "",
      ),
      EventItem(
        title: "Showa Boston Dance Performance",
        time: "15:20-15:40",
        duration: 20,
        image: "",
      ),
      EventItem(
        title: "Bon Dance Event",
        time: "15:40-16:10",
        duration: 30,
        image: "",
      ),
    ],
    stage2Events: [
      EventItem(
        title: "DELETE ME",
        time: "15:40-16:10",
        duration: 30,
        image: "",
      ),
    ],
  ),
];
