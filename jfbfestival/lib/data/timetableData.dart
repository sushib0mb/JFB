class EventItem {
  final String title;
  final String time;
  final String iconImage;
  final int duration;
  final String stage;
  final String description;
  final String backgroundImage;

  EventItem({
    required this.title,
    required this.time,
    required this.duration,
    required this.iconImage,
    required this.stage,
    required this.description,
    required this.backgroundImage,
  });
}

class ScheduleItem {
  final String time;
  final List<EventItem>? stage1Events;
  final List<EventItem>? stage2Events;

  ScheduleItem({
    required this.time,
    required this.stage1Events,
    required this.stage2Events,
  });
}

final List<ScheduleItem> day1ScheduleData = [
  ScheduleItem(
    time: "11:00 am",
    stage1Events: [
      EventItem(
        title: "One Week Wonder",
        time: "11:00-11:15",
        duration: 15,
        stage: "Stage 1",
        iconImage: "assets/timetableIcons/Singing performance.png",
        description: "",
        backgroundImage: "",
      ),
      EventItem(
        title: "Showa Boston Dance Performance",
        time: "11:15-11:30",
        duration: 15,
        stage: "Stage 1", // Changed to string
        iconImage: "assets/timetableIcons/Dancing performance.png",
        description: "",
        backgroundImage: "",
      ),
    ],
    stage2Events: [
      EventItem(
        title: "",
        time: "",
        duration: 35,
        stage: "Stage 2", // Changed to string
        iconImage: "",
        description: "",
        backgroundImage: "",
      ),
    ],
  ),
  ScheduleItem(
    time: "11:30 am",
    stage1Events: [
      EventItem(
        title: "NODO JIMAN",
        time: "11:30-12:00",
        duration: 30,
        stage: "Stage 1", // Changed to string
        iconImage: "assets/timetableIcons/Singing performance.png",
        description: "",
        backgroundImage: "",
      ),
    ],
    stage2Events: [
      EventItem(
        title: "Ukulele",
        time: "11:35-12:05",
        stage: "Stage 2", // Changed to string
        duration: 30,
        iconImage: "assets/timetableIcons/Singing performance.png",
        description: "",
        backgroundImage: "",
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
        stage: "Stage 1", // Changed to string
        iconImage: "",
        description: "",
        backgroundImage: "",
      ),
    ],
    stage2Events: [
      EventItem(
        title: "",
        time: "",
        stage: "Stage 2", // Changed to string
        duration: 25,
        iconImage: "",
        description: "",
        backgroundImage: "",
      ),
    ],
  ),
  ScheduleItem(
    time: "12:30 pm",
    stage1Events: [
      EventItem(
        title: "opening ceremony",
        time: "12:40-13:00",
        duration: 20,
        stage: "Stage 1", // Changed to string
        iconImage: "",
        description: "",
        backgroundImage: "",
      ),
    ],
    stage2Events: [
      EventItem(
        title: "",
        time: "",
        duration: 25,
        stage: "Stage 2", // Changed to string
        iconImage: "",
        description: "",
        backgroundImage: "",
      ),
      EventItem(
        title: "Berklee Band",
        time: "12:55-13:05",
        stage: "Stage 2", // Changed to string
        duration: 10,
        iconImage: "",
        description: "",
        backgroundImage: "",
      ),
    ],
  ),
  // Repeat the pattern for other items...
];

final List<ScheduleItem> day2ScheduleData = [
  ScheduleItem(
    time: "11:00 am",
    stage1Events: [
      EventItem(
        title: "Opening Ceremony",
        time: "11:00-11:05",
        duration: 5,
        stage: "Stage 1", // Changed to string
        iconImage: "",
        description: "",
        backgroundImage: "",
      ),
      EventItem(
        title: "Showa Boston Dance Performance",
        time: "11:05-11:20",
        duration: 15,
        stage: "Stage 1", // Changed to string
        iconImage: "",
        description: "",
        backgroundImage: "",
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
        stage: "Stage 1", // Changed to string
        iconImage: "",
        description: "",
        backgroundImage: "",
      ),
      EventItem(
        title: "Jeiko Taiko Ensemble",
        time: "12:30-13:00",
        duration: 30,
        stage: "Stage 1", // Changed to string
        iconImage: "",
        description: "",
        backgroundImage: "",
      ),
      EventItem(
        title: "Minami Toyama Noh, Utai, Shinobue",
        time: "11:20-11:55",
        duration: 35,
        stage: "Stage 1", // Changed to string
        iconImage: "",
        description: "",
        backgroundImage: "",
      ),
    ],
    stage2Events: [],
  ),
  // Continue similarly for other entries...
];
