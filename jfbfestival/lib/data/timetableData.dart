class EventItem {
  final String title;
  final String time;
  final String iconImage;
  final int duration;
  final String stage;
  final String description;
  final String eventDetailImage;

  EventItem({
    required this.title,
    required this.time,
    required this.duration,
    required this.iconImage,
    required this.stage,
    required this.description,
    required this.eventDetailImage,
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
        iconImage: "assets/timetableIcons/Band performance.png",
        description: "Taka Ochi band will perform Japanese songs, I think",
        eventDetailImage: "",
      ),
      EventItem(
        title: "Showa Boston Dance Performance",
        time: "11:15-11:30",
        duration: 15,
        stage: "Stage 1",
        iconImage: "assets/timetableIcons/Dancing performance.png",
        description: "",
        eventDetailImage: "",
      ),
    ],
    stage2Events: [],
  ),
  ScheduleItem(
    time: "11:30 am",
    stage1Events: [
      EventItem(
        title: "Nodo Jiman",
        time: "11:30-12:00",
        duration: 30,
        stage: "Stage 1",
        iconImage: "assets/timetableIcons/Singing performance.png",
        description: "",
        eventDetailImage: "",
      ),
    ],
    stage2Events: [
      EventItem(
        title: "Ukulele",
        time: "11:35-12:05",
        duration: 30,
        stage: "Stage 2",
        iconImage: "assets/timetableIcons/Band performance.png",
        description: "",
        eventDetailImage: "",
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
        stage: "Stage 1",
        iconImage: "assets/timetableIcons/Band performance.png",
        description: "",
        eventDetailImage: "",
      ),
    ],
    stage2Events: [],
  ),
  ScheduleItem(
    time: "12:30 pm",
    stage1Events: [
      EventItem(
        title: "Opening Ceremony",
        time: "12:40-13:00",
        duration: 20,
        stage: "Stage 1",
        iconImage: "assets/timetableIcons/Opening ceremony.png",
        description: "",
        eventDetailImage: "",
      ),
    ],
    stage2Events: [],
  ),
  ScheduleItem(
    time: "1:00 pm",
    stage1Events: [
      EventItem(
        title: "Kitanodai Gagaku Ensemble",
        time: "13:00-13:30",
        duration: 30,
        stage: "Stage 1",
        iconImage: "assets/timetableIcons/Dancing performance.png",
        description: "",
        eventDetailImage: "",
      ),
    ],
    stage2Events: [
      EventItem(
        title: "Berklee Band",
        time: "12:55-13:05",
        duration: 10,
        stage: "Stage 2",
        iconImage: "assets/timetableIcons/Band performance.png",
        description: "",
        eventDetailImage: "",
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
        stage: "Stage 1",
        iconImage: "assets/timetableIcons/Dancing performance.png",
        description: "",
        eventDetailImage: "",
      ),
    ],
    stage2Events: [
      EventItem(
        title: "Anime Band",
        time: "13:05-13:45",
        duration: 40,
        stage: "Stage 2",
        iconImage: "assets/timetableIcons/Anime stage.png",
        description: "",
        eventDetailImage: "",
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
        stage: "Stage 1",
        iconImage: "assets/timetableIcons/Dancing performance.png",
        description: "",
        eventDetailImage: "",
      ),
    ],
    stage2Events: [
      EventItem(
        title: "Cosplay Fashion Show",
        time: "13:45-14:05",
        duration: 20,
        stage: "Stage 2",
        iconImage: "assets/timetableIcons/Anime stage.png",
        description: "",
        eventDetailImage: "",
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
        stage: "Stage 1",
        iconImage: "assets/timetableIcons/Anime stage.png",
        description: "",
        eventDetailImage: "",
      ),
    ],
    stage2Events: [
      EventItem(
        title: "Parade to Boston Common",
        time: "14:05-14:25",
        duration: 20,
        stage: "Stage 2",
        iconImage: "assets/timetableIcons/Dancing performance.png",
        description: "",
        eventDetailImage: "",
      ),
    ],
  ),
  ScheduleItem(
    time: "2:45 pm",
    stage1Events: [
      EventItem(
        title: "Parfait Soleil Dance Performance",
        time: "14:50-15:20",
        duration: 30,
        stage: "Stage 1",
        iconImage: "assets/timetableIcons/Dancing performance.png",
        description: "",
        eventDetailImage: "",
      ),
    ],
    stage2Events: [],
  ),
  ScheduleItem(
    time: "3:00 pm",
    stage1Events: [
      EventItem(
        title: "Yamazaki VS Sugimono",
        time: "15:20-15:30",
        duration: 10,
        stage: "Stage 1",
        iconImage: "assets/timetableIcons/Kendo.png",
        description: "",
        eventDetailImage: "",
      ),
    ],
    stage2Events: [],
  ),
  ScheduleItem(
    time: "3:30 pm",
    stage1Events: [
      EventItem(
        title: "Japan Airline Advertising and Raffle",
        time: "15:30-15:40",
        duration: 10,
        stage: "Stage 1",
        iconImage: "assets/timetableIcons/Advertising.png",
        description: "",
        eventDetailImage: "",
      ),
      EventItem(
        title: "Move & Inspire Kids Dance",
        time: "15:40-16:10",
        duration: 30,
        stage: "Stage 1",
        iconImage: "assets/timetableIcons/Dancing performance.png",
        description: "",
        eventDetailImage: "",
      ),
    ],
    stage2Events: [],
  ),
  ScheduleItem(
    time: "4:00 pm",
    stage1Events: [
      EventItem(
        title: "Showa Boston Dance Performance",
        time: "16:10-16:25",
        duration: 15,
        stage: "Stage 1",
        iconImage: "assets/timetableIcons/Dancing performance.png",
        description: "",
        eventDetailImage: "",
      ),
      EventItem(
        title: "Bon Dance Event",
        time: "16:25-16:55",
        duration: 30,
        stage: "Stage 1",
        iconImage: "assets/timetableIcons/Dancing performance.png",
        description: "",
        eventDetailImage: "",
      ),
    ],
    stage2Events: [],
  ),
  ScheduleItem(time: "4:30 pm", stage1Events: [], stage2Events: []),
];

final List<ScheduleItem> day2ScheduleData = [
  // ScheduleItem(
  //   time: "11:00 pm",
  //   stage1Events: [
  //     EventItem(
  //       title: "Showa Boston Dance Performance",
  //       time: "11:05-11:20",
  //       duration: 15,
  //       stage: "Stage 1", // Changed to string
  //       iconImage: "assets/timetableIcons/Dancing performance.png",
  //       description: "",
  //       eventDetailImage: "",
  //     ),
  //     EventItem(
  //       title: "Minami Toyama Noh, Utai, Shinobue",
  //       time: "11:20-11:55",
  //       duration: 35,
  //       stage: "Stage 1", // Changed to string
  //       iconImage: "assets/timetableIcons/Dancing performance.png",
  //       description: "",
  //       eventDetailImage: "",
  //     ),
  //   ],
  //   stage2Events: [],
  // ),
  // ScheduleItem(
  //   time: "11:30 am",
  //   stage1Events: [
  //     EventItem(
  //       title: "KENDO",
  //       time: "11:55-12:25",
  //       duration: 30,
  //       stage: "Stage 1", // Changed to string
  //       iconImage: "assets/timetableIcons/Kendo.png",
  //       description: "",
  //       eventDetailImage: "",
  //     ),
  //   ],
  //   stage2Events: [],
  // ),
  // ScheduleItem(
  //   time: "12:00 pm",
  //   stage1Events: [
  //     EventItem(
  //       title: "Cosplay Fashion Show",
  //       time: "12:25-12:45",
  //       duration: 20,
  //       stage: "Stage 1", // Changed to string
  //       iconImage: "assets/timetableIcons/Anime stage.png",
  //       description: "",
  //       eventDetailImage: "",
  //     ),
  //   ],
  //   stage2Events: [],
  // ),
  // ScheduleItem(
  //   time: "12:30 pm",
  //   stage1Events: [
  //     EventItem(
  //       title: "Parfait Soleil Dance Performance",
  //       time: "12:45-13:15",
  //       duration: 30,
  //       stage: "Stage 1", // Changed to string
  //       iconImage: "assets/timetableIcons/Dancing performance.png",
  //       description: "",
  //       eventDetailImage: "",
  //     ),
  //   ],
  //   stage2Events: [],
  // ),
  // ScheduleItem(
  //   time: "1:00 pm",
  //   stage1Events: [
  //     EventItem(
  //       title: "Kitanodai Gagaku Ensemble",
  //       time: "13:00-13:30",
  //       duration: 30,
  //       iconImage: "assets/timetableIcons/Dancing performance.png",
  //       stage: "1",
  //       description: "",
  //       eventDetailImage: "",
  //     ),
  //   ],
  //   stage2Events: [
  //     EventItem(
  //       title: "",
  //       time: "",
  //       duration: 5,
  //       iconImage: "",
  //       description: "",
  //       stage: "1",
  //       eventDetailImage: "assets/timetableIcons/Opening ceremony.png",
  //     ),
  //     EventItem(
  //       title: "Anime Band",
  //       time: "13:05-13:45",
  //       duration: 40,
  //       iconImage: "assets/timetableIcons/Band performance.png",
  //       stage: "2",
  //       description: "",
  //       eventDetailImage: "",
  //     ),
  //   ],
  // ),
  // ScheduleItem(
  //   time: "1:30 pm",
  //   stage1Events: [
  //     EventItem(
  //       title: "Okinawa Ryukyu Kokusai Taiko",
  //       time: "13:30-14:00",
  //       duration: 30,
  //       iconImage: "assets/timetableIcons/Band performance.png",
  //       stage: "1",
  //       description: "",
  //       eventDetailImage: "",
  //     ),
  //   ],
  //   stage2Events: [
  //     EventItem(
  //       title: "Cosplay Fashion Show",
  //       time: "13:45-14:05",
  //       duration: 20,
  //       iconImage: "assets/timetableIcons/Dancing performance.png",
  //       stage: "2",
  //       description: "",
  //       eventDetailImage: "",
  //     ),
  //   ],
  // ),
  // ScheduleItem(
  //   time: "2:00 pm",
  //   stage1Events: [
  //     EventItem(
  //       title: "Jeiko Taiko Ensemble",
  //       time: "14:00-14:30",
  //       duration: 30,
  //       iconImage: "assets/timetableIcons/Band performance.png",
  //       stage: "1",
  //       description: "",
  //       eventDetailImage: "",
  //     ),
  //   ],
  //   stage2Events: [
  //     EventItem(
  //       title: "Parade to Boston Common",
  //       time: "14:05-14:25",
  //       duration: 20,
  //       iconImage: "assets/timetableIcons/Dancing performance.png",
  //       stage: "2",
  //       description: "",
  //       eventDetailImage: "",
  //     ),
  //   ],
  // ),
  // ScheduleItem(
  //   time: "2:30 pm",
  //   stage1Events: [
  //     EventItem(
  //       title: "Cosplay Fashion Show",
  //       time: "14:30-14:50",
  //       duration: 20,
  //       iconImage: "assets/timetableIcons/Anime stage.png",
  //       stage: "1",
  //       description: "",
  //       eventDetailImage: "",
  //     ),
  //   ],
  //   stage2Events: [],
  // ),
  // ScheduleItem(time: "3:30 pm", stage1Events: [], stage2Events: []),
  // ScheduleItem(
  //   time: "1:00 pm",
  //   stage1Events: [
  //     EventItem(
  //       title: "Hiroko Watanabe Calligraphy",
  //       time: "13:15-13:55",
  //       duration: 30,
  //       stage: "Stage 1", // Changed to string
  //       iconImage: "assets/timetableIcons/Band performance.png",
  //       description: "",
  //       eventDetailImage: "",
  //     ),
  //     EventItem(
  //       title: "Cosplay Death Match",
  //       time: "13:55-14:25",
  //       duration: 30,
  //       stage: "Stage 1", // Changed to string
  //       iconImage: "assets/timetableIcons/Anime stage.png",
  //       description: "",
  //       eventDetailImage: "",
  //     ),
  //   ],
  //   stage2Events: [],
  // ),
  // ScheduleItem(
  //   time: "2:00 pm",
  //   stage1Events: [
  //     EventItem(
  //       title: "Jeiko Taiko Ensemble",
  //       time: "14:25-14:55",
  //       duration: 30,
  //       stage: "Stage 1", // Changed to string
  //       iconImage: "assets/timetableIcons/Band performance.png",
  //       description: "",
  //       eventDetailImage: "",
  //     ),
  //     EventItem(
  //       title: "Move & Inspire Kids dance",
  //       time: "14:55-15:25",
  //       duration: 30,
  //       stage: "Stage 1", // Changed to string
  //       iconImage: "assets/timetableIcons/Dancing performance.png",
  //       description: "",
  //       eventDetailImage: "",
  //     ),
  //   ],
  //   stage2Events: [],
  // ),
  // ScheduleItem(
  //   time: "3:00 pm",
  //   stage1Events: [
  //     EventItem(
  //       title: "OKINAWA Ryukyu Kokusai Taiko",
  //       time: "15:25-15:55",
  //       duration: 30,
  //       stage: "Stage 1", // Changed to string
  //       iconImage: "assets/timetableIcons/Band performance.png",
  //       description: "",
  //       eventDetailImage: "",
  //     ),
  //   ],
  //   stage2Events: [],
  // ),
  // ScheduleItem(
  //   time: "3:30 pm",
  //   stage1Events: [
  //     EventItem(
  //       title: "Japan Airline Advertising and Raffle",
  //       time: "15:55-16:05",
  //       duration: 10,
  //       stage: "Stage 1", // Changed to string
  //       iconImage: "assets/timetableIcons/Advertising.png",
  //       description: "",
  //       eventDetailImage: "",
  //     ),
  //   ],
  //   stage2Events: [],
  // ),
  // ScheduleItem(
  //   time: "4:00 pm",
  //   stage1Events: [
  //     EventItem(
  //       title: "Showa Boston Dance Performance",
  //       time: "16:05-16:20",
  //       duration: 15,
  //       stage: "Stage 1", // Changed to string
  //       iconImage: "assets/timetableIcons/Dancing performance.png",
  //       description: "",
  //       eventDetailImage: "",
  //     ),
  //     EventItem(
  //       title: "Bon Dance Event",
  //       time: "16:20-16:50",
  //       duration: 30,
  //       stage: "Stage 1", // Changed to string
  //       iconImage: "assets/timetableIcons/Dancing performance.png",
  //       description: "",
  //       eventDetailImage: "",
  //     ),
  //   ],
  //   stage2Events: [],
  // ),
  // ScheduleItem(
  //   time: "4:30 pm",
  //   stage1Events: [
  //     EventItem(
  //       title: "Closing Ceremony",
  //       time: "16:50-17:00",
  //       duration: 10,
  //       stage: "Stage 1", // Changed to string
  //       iconImage: "assets/timetableIcons/Closing ceremony.png",
  //       description: "",
  //       eventDetailImage: "",
  //     ),
  //   ],
  //   stage2Events: [],
  // ),
];
