import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';

// Event item model
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

  factory EventItem.fromSupabase(Map<String, dynamic> data) {
    return EventItem(
      title: data['event_title'] ?? '',
      time: data['event_time_range'] ?? '',
      duration: data['event_duration_minutes'] ?? 0,
      iconImage: data['event_icon_path'] ?? '',
      stage: data['event_stage'] ?? '',
      description: data['event_description'] ?? '',
      eventDetailImage: data['event_detail_image_path'] ?? '',
    );
  }
}

// Schedule item model
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

// Service to manage schedule data
class ScheduleDataService extends ChangeNotifier {
  // Supabase client
  final SupabaseClient _supabase;

  // Data storage
  List<ScheduleItem> day1ScheduleData = [];
  List<ScheduleItem> day2ScheduleData = [];

  // State variables
  bool isLoadingDay1 = false;
  bool isLoadingDay2 = false;
  String? errorDay1;
  String? errorDay2;

  // Realtime channel
  RealtimeChannel? _realtimeChannel;

  // Constructor
  ScheduleDataService(this._supabase) {
    initScheduleDataListeners();
  }

  // Initialize data listeners
  void initScheduleDataListeners() {
    // Fetch initial data
    fetchDay1ScheduleData();
    fetchDay2ScheduleData();

    // Set up realtime listener
    _setupRealtimeListener();
  }

  // Set up realtime listener for both tables
  void _setupRealtimeListener() {
    final supabase = _supabase;

    final channel = supabase.channel('db-changes');

    // Listen for INSERT, UPDATE, DELETE on day1_events
    channel
      ..on(
        RealtimeListenTypes.postgresChanges,
        ChannelFilter(event: 'INSERT', schema: 'public', table: 'day1_events'),
        (payload, [ref]) {
          fetchDay1ScheduleData();
        },
      )
      ..on(
        RealtimeListenTypes.postgresChanges,
        ChannelFilter(event: 'UPDATE', schema: 'public', table: 'day1_events'),
        (payload, [ref]) {
          fetchDay1ScheduleData();
        },
      )
      ..on(
        RealtimeListenTypes.postgresChanges,
        ChannelFilter(event: 'DELETE', schema: 'public', table: 'day1_events'),
        (payload, [ref]) {
          fetchDay1ScheduleData();
        },
      )
      // Listen for INSERT, UPDATE, DELETE on day2_events
      ..on(
        RealtimeListenTypes.postgresChanges,
        ChannelFilter(event: 'INSERT', schema: 'public', table: 'day2_events'),
        (payload, [ref]) {
          fetchDay2ScheduleData();
        },
      )
      ..on(
        RealtimeListenTypes.postgresChanges,
        ChannelFilter(event: 'UPDATE', schema: 'public', table: 'day2_events'),
        (payload, [ref]) {
          fetchDay2ScheduleData();
        },
      )
      ..on(
        RealtimeListenTypes.postgresChanges,
        ChannelFilter(event: 'DELETE', schema: 'public', table: 'day2_events'),
        (payload, [ref]) {
          fetchDay2ScheduleData();
        },
      )
      ..subscribe();
  }

  // Fetch Day 1 schedule data
  Future<void> fetchDay1ScheduleData() async {
    try {
      print('Starting fetchDay1ScheduleData');
      isLoadingDay1 = true;
      notifyListeners();

      // Fetch all events data for day 1
      final response = await _supabase
          .from('day1_events')
          .select()
          .order('grouping_time');

      print('Raw Day 1 data received: ${response.length} items');

      // Convert the response to the correct type
      List<Map<String, dynamic>> typedResponse =
          (response as List)
              .map(
                (item) =>
                    Map<String, dynamic>.from(item as Map<dynamic, dynamic>),
              )
              .toList();

      // Process the data
      day1ScheduleData = _processEventData(typedResponse);

      // Debug print
      print('Day 1 processed data: ${day1ScheduleData.length} items');

      if (day1ScheduleData.isNotEmpty) {
        print('First event for Day 1: ${day1ScheduleData[0].time}');
        if (day1ScheduleData[0].stage2Events?.isNotEmpty ?? false) {
          print(
            '  - Stage 2: ${day1ScheduleData[0].stage2Events?.first.title}',
          );
        }
      } else {
        print('Day 1 schedule data is empty after processing');
      }

      isLoadingDay1 = false;
      errorDay1 = null;
      notifyListeners();
    } catch (e) {
      print('Error in fetchDay1ScheduleData: $e');
      errorDay1 = "Failed to load Day 1 schedule data: $e";
      isLoadingDay1 = false;
      notifyListeners();
    }
  }

  // Fetch Day 2 schedule data
  Future<void> fetchDay2ScheduleData() async {
    try {
      print('Starting fetchDay2ScheduleData');
      isLoadingDay2 = true;
      notifyListeners();

      // Fetch all events data for day 1
      final response = await _supabase
          .from('day2_events')
          .select()
          .order('grouping_time');

      print('Raw Day 2 data received: ${response.length} items');

      // Convert the response to the correct type
      List<Map<String, dynamic>> typedResponse =
          (response as List)
              .map(
                (item) =>
                    Map<String, dynamic>.from(item as Map<dynamic, dynamic>),
              )
              .toList();

      // Process the data
      day2ScheduleData = _processEventData(typedResponse);

      // Debug print
      print('Day 2 processed data: ${day2ScheduleData.length} items');

      if (day2ScheduleData.isNotEmpty) {
        print('First event for Day 2: ${day2ScheduleData[0].time}');
        if (day2ScheduleData[0].stage2Events?.isNotEmpty ?? false) {
          print(
            '  - Stage 2: ${day2ScheduleData[0].stage2Events?.first.title}',
          );
        }
      } else {
        print('Day 2 schedule data is empty after processing');
      }

      isLoadingDay2 = false;
      errorDay2 = null;
      notifyListeners();
    } catch (e) {
      print('Error in fetchDay2ScheduleData: $e');
      errorDay2 = "Failed to load Day 2 schedule data: $e";
      isLoadingDay2 = false;
      notifyListeners();
    }
  }

  // Process event data into schedule items
  List<ScheduleItem> _processEventData(List<Map<String, dynamic>> data) {
    try {
      print('Processing ${data.length} raw events');

      // Group the events by grouping_time
      Map<String, Map<String, List<EventItem>>> groupedEvents = {};

      for (var item in data) {
        String groupingTime = item['grouping_time'] ?? '';
        String stage = item['event_stage'] ?? '';

        print('Processing item: time=$groupingTime, stage=$stage');

        // Initialize the grouping time if not exists
        if (!groupedEvents.containsKey(groupingTime)) {
          groupedEvents[groupingTime] = {'stage1': [], 'stage2': []};
        }

        EventItem event = EventItem.fromSupabase(item);

        // Add event to the appropriate stage list
        if (stage == 'Stage 1') {
          print('Adding Stage 1 event: $event');
          groupedEvents[groupingTime]!['stage1']!.add(event);
        } else if (stage == 'Stage 2') {
          print('Adding Stage 2 event: $event');
          groupedEvents[groupingTime]!['stage2']!.add(event);
        } else {
          print('Unknown stage value: $stage');
        }
      }

      print('Grouped events: ${groupedEvents.keys.length} time slots');

      // Convert the grouped data to ScheduleItem list
      List<ScheduleItem> scheduleItems = [];

      groupedEvents.entries.forEach((entry) {
        print('Creating ScheduleItem for time ${entry.key}');
        print('  - Stage1 events: ${entry.value['stage1']?.length ?? 0}');
        print('  - Stage2 events: ${entry.value['stage2']?.length ?? 0}');

        scheduleItems.add(
          ScheduleItem(
            time: entry.key,
            stage1Events: entry.value['stage1'],
            stage2Events: entry.value['stage2'],
          ),
        );
      });

      // Sort by time
      scheduleItems.sort((a, b) => a.time.compareTo(b.time));

      print('Created ${scheduleItems.length} schedule items');
      return scheduleItems;
    } catch (e) {
      print('Error in _processEventData: $e');
      print('Stack trace: ${StackTrace.current}');
      throw "Error processing schedule data: $e";
    }
  }

  // Clean up resources
  @override
  void dispose() {
    _realtimeChannel?.unsubscribe();
    super.dispose();
  }
}

// class EventItem {
//   final String title;
//   final String time;
//   final String iconImage;
//   final int duration;
//   final String stage;
//   final String description;
//   final String eventDetailImage;

//   EventItem({
//     required this.title,
//     required this.time,
//     required this.duration,
//     required this.iconImage,
//     required this.stage,
//     required this.description,
//     required this.eventDetailImage,
//   });
// }

// class ScheduleItem {
//   final String time;
//   final List<EventItem>? stage1Events;
//   final List<EventItem>? stage2Events;

//   ScheduleItem({
//     required this.time,
//     required this.stage1Events,
//     required this.stage2Events,
//   });
// }

// final List<ScheduleItem> day1ScheduleData = [
//   ScheduleItem(
//     time: "11:00 am",
//     stage1Events: [
//       EventItem(
//         title: "One Week Wonder",
//         time: "11:00-11:15",
//         duration: 15,
//         stage: "Stage 1",
//         iconImage: "assets/timetableIcons/Band performance.png",
//         description:
//             "We are One Week Wonder from Japan, a group of BU and Berklee students gathered to deliver some Japanese rock to Boston. Our band is inspired by the Japanese underground Rock culture, which is loved in Japan but rarely heard in the US, so I hope you guys will love them!",
//         eventDetailImage: "assets/timetableBackgrounds/oneweekwonder.JPG",
//       ),
//       EventItem(
//         title: "Showa Boston Dance Performance",
//         time: "11:15-11:30",
//         duration: 15,
//         stage: "Stage 1",
//         iconImage: "assets/timetableIcons/Dancing performance.png",
//         description:
//             "The Showa Boston Dance Performance brings the vibrant Soranbushi, a traditional Japanese folk dance, to life with lively movements and rhythmic chanting. This energetic performance celebrates the strength and spirit of Japanese culture.",
//         eventDetailImage: "assets/timetableBackgrounds/showaboston.jpg",
//       ),
//     ],
//     stage2Events: [
//       EventItem(
//         title: "",
//         time: "",
//         duration: 35,
//         stage: "",
//         iconImage: "",
//         description: "",
//         eventDetailImage: "",
//       ),
//     ],
//   ),
//   ScheduleItem(
//     time: "11:30 am",
//     stage1Events: [
//       EventItem(
//         title: "Nodo Jiman",
//         time: "11:30-12:00",
//         duration: 30,
//         stage: "Stage 1",
//         iconImage: "assets/timetableIcons/Singing performance.png",
//         description:
//             "Nodo Jiman is a Japanese vocal performance that highlights the raw emotion and power of traditional singing. Known for its competitive spirit, this performance features singers displaying their vocal prowess through heartfelt renditions of classic Japanese enka songs, celebrating both personal expression and cultural heritage.",
//         eventDetailImage: "assets/timetableBackgrounds/nodojiman.jpg",
//       ),
//     ],
//     stage2Events: [
//       EventItem(
//         title: "Ukulele",
//         time: "11:35-12:05",
//         duration: 30,
//         stage: "Stage 2",
//         iconImage: "assets/timetableIcons/Band performance.png",
//         description: "",
//         eventDetailImage: "assets/timetableBackgrounds/Ukulele.jpg",
//       ),
//     ],
//   ),
//   ScheduleItem(
//     time: "12:00 pm",
//     stage1Events: [
//       EventItem(
//         title: "Hiroko Watanabe Calligraphy",
//         time: "12:00-12:40",
//         duration: 40,
//         stage: "Stage 1",
//         iconImage: "assets/timetableIcons/Band performance.png",
//         description:
//             "Hiroko Watanabe’s calligraphy performance transforms brushstrokes into a captivating visual art. With each precise movement, they bring beauty and meaning to traditional Japanese writing.",
//         eventDetailImage: "assets/timetableBackgrounds/hiroko.jpg",
//       ),
//     ],
//     stage2Events: [],
//   ),
//   ScheduleItem(
//     time: "12:30 pm",
//     stage1Events: [
//       EventItem(
//         title: "Opening Ceremony",
//         time: "12:40-13:00",
//         duration: 20,
//         stage: "Stage 1",
//         iconImage: "assets/timetableIcons/Opening ceremony.png",
//         description:
//             "The Opening Ceremony for Japan Festival Boston 2025 will kick off vibrant performances, cultural displays, and speeches from distinguished guests. This exciting event sets the stage for a weekend celebrating Japanese arts, food, and traditions.",
//         eventDetailImage: "assets/timetableBackgrounds/OpeningCeremony.jpg",
//       ),
//     ],
//     stage2Events: [
//       EventItem(
//         title: "",
//         time: "",
//         duration: 55,
//         stage: "",
//         iconImage: "",
//         description: "",
//         eventDetailImage: "",
//       ),
//     ],
//   ),
//   ScheduleItem(
//     time: "1:00 pm",
//     stage1Events: [
//       EventItem(
//         title: "Kitanodai Gagaku Ensemble",
//         time: "13:00-13:30",
//         duration: 30,
//         stage: "Stage 1",
//         iconImage: "assets/timetableIcons/Dancing performance.png",
//         description:
//             "The Kitanodai Gagaku Ensemble performs gagaku, Japan’s ancient court music and dance, blending serene instrumental melodies with graceful movements. Their performance offers a rare and immersive experience of this UNESCO-recognized cultural heritage.",
//         eventDetailImage:
//             "assets/timetableBackgrounds/Kitanogai Gagaku Ensemble.jpg",
//       ),
//     ],
//     stage2Events: [
//       EventItem(
//         title: "Berklee Band",
//         time: "12:55-13:05",
//         duration: 10,
//         stage: "Stage 2",
//         iconImage: "assets/timetableIcons/Band performance.png",
//         description:
//             "The Berklee band will bring Japanese culture to the stage, performing Japanese hit songs. This ensemble offers a vibrant showcase of contemporary Japanese music, blending traditional sounds with modern flair.",
//         eventDetailImage: "assets/timetableBackgrounds/Berklee Band.jpg",
//       ),
//     ],
//   ),
//   ScheduleItem(
//     time: "1:30 pm",
//     stage1Events: [
//       EventItem(
//         title: "Okinawa Ryukyu Kokusai Taiko",
//         time: "13:30-14:00",
//         duration: 30,
//         stage: "Stage 1",
//         iconImage: "assets/timetableIcons/Dancing performance.png",
//         description:
//             "Ryukyu Kokusai Taiko is an Okinawan drumming ensemble known for its dynamic fusion of traditional Eisa rhythms, dance, and karate movements. Their powerful performances celebrate Okinawan culture, blending ancient sounds with modern energy.",
//         eventDetailImage: "assets/timetableBackgrounds/ryukyu.jpg",
//       ),
//     ],
//     stage2Events: [
//       EventItem(
//         title: "Anime Band",
//         time: "13:05-13:45",
//         duration: 40,
//         stage: "Stage 2",
//         iconImage: "assets/timetableIcons/Anime stage.png",
//         description:
//             "An Anime Band performs energetic renditions of popular songs from anime series, blending J-Rock, J-Pop, and orchestral music. Their performances bring iconic anime themes to life, offering fans a chance to experience their favorite tunes in a live, dynamic setting.",
//         eventDetailImage: "assets/timetableBackgrounds/animeband.jpg",
//       ),
//     ],
//   ),
//   ScheduleItem(
//     time: "2:00 pm",
//     stage1Events: [
//       EventItem(
//         title: "Jeiko Taiko Ensemble",
//         time: "14:00-14:30",
//         duration: 30,
//         stage: "Stage 1",
//         iconImage: "assets/timetableIcons/Dancing performance.png",
//         description:
//             "The Jeiko Taiko Ensemble is a vibrant Japanese drumming group based in New England, known for their high-energy performances that blend traditional taiko rhythms with modern influences. Their performances showcase the power and precision of Japanese drumming, engaging audiences with dynamic rhythms and movements.",
//         eventDetailImage:
//             "assets/timetableBackgrounds/Jeiko Taiko Ensemble.png",
//       ),
//     ],
//     stage2Events: [
//       EventItem(
//         title: "Cosplay Fashion Show",
//         time: "13:45-14:05",
//         duration: 20,
//         stage: "Stage 2",
//         iconImage: "assets/timetableIcons/Anime stage.png",
//         description:
//             "The Cosplay Fashion Show features participants showcasing their detailed costumes inspired by anime, manga, and pop culture. Models walk the runway, celebrating the creativity and craftsmanship behind each ensemble in a vibrant and exciting display.",
//         eventDetailImage:
//             "assets/timetableBackgrounds/Cosplay Fashion Show.png",
//       ),
//     ],
//   ),
//   ScheduleItem(
//     time: "2:30 pm",
//     stage1Events: [
//       EventItem(
//         title: "Cosplay Fashion Show",
//         time: "14:30-14:50",
//         duration: 20,
//         stage: "Stage 1",
//         iconImage: "assets/timetableIcons/Anime stage.png",
//         description:
//             "The Cosplay Fashion Show features participants showcasing their detailed costumes inspired by anime, manga, and pop culture. Models walk the runway, celebrating the creativity and craftsmanship behind each ensemble in a vibrant and exciting display.",
//         eventDetailImage:
//             "assets/timetableBackgrounds/Cosplay Fashion Show.png",
//       ),
//     ],
//     stage2Events: [
//       EventItem(
//         title: "Parade to Boston Common",
//         time: "14:05-14:25",
//         duration: 20,
//         stage: "Stage 2",
//         iconImage: "assets/timetableIcons/Dancing performance.png",
//         description:
//             "As the final performance at the Downtown Stage, participants will join together for a parade, walking to Boston Commons while enjoying the music along the way!",
//         eventDetailImage: "assets/timetableBackgrounds/Parade.jpg",
//       ),
//     ],
//   ),
//   ScheduleItem(
//     time: "2:45 pm",
//     stage1Events: [
//       EventItem(
//         title: "Parfait Soleil Dance Performance",
//         time: "14:50-15:20",
//         duration: 30,
//         stage: "Stage 1",
//         iconImage: "assets/timetableIcons/Dancing performance.png",
//         description:
//             "Parfait Soleil Dance Performance features a lively display of contemporary and traditional dance, blending fluid movements with vibrant energy. The performance captures the joy and beauty of dance through captivating choreography.",
//         eventDetailImage:
//             "assets/timetableBackgrounds/Parfait Soleil Dance Performance.png",
//       ),
//     ],
//     stage2Events: [],
//   ),
//   ScheduleItem(
//     time: "3:00 pm",
//     stage1Events: [
//       EventItem(
//         title: "Yamazaki VS Sugimono",
//         time: "15:20-15:30",
//         duration: 10,
//         stage: "Stage 1",
//         iconImage: "assets/timetableIcons/Kendo.png",
//         description:
//             "Yamazaki VS Sugimono is an intense Kendo showcase, where two skilled martial artists face off in a demonstration of precision, speed, and spirit. The clash highlights the discipline and tradition of Japanese swordsmanship.",
//         eventDetailImage: "assets/timetableBackgrounds/kendo.jpg",
//       ),
//     ],
//     stage2Events: [],
//   ),
//   ScheduleItem(
//     time: "3:30 pm",
//     stage1Events: [
//       EventItem(
//         title: "Japan Airline Advertising and Raffle",
//         time: "15:30-15:40",
//         duration: 10,
//         stage: "Stage 1",
//         iconImage: "assets/timetableIcons/Advertising.png",
//         description:
//             "Japan Airlines Advertising and Raffle offers an exciting opportunity to learn about the airline’s services while participants can enter to win exclusive prizes. It’s a fun and engaging way to promote travel with Japan Airlines.",
//         eventDetailImage:
//             "assets/timetableBackgrounds/Japan Airlines.png",
//       ),
//       EventItem(
//         title: "Move & Inspire Kids Dance",
//         time: "15:40-16:10",
//         duration: 30,
//         stage: "Stage 1",
//         iconImage: "assets/timetableIcons/Dancing performance.png",
//         description:
//             "Move & Inspire Kids Dance features young dancers showcasing their talent and energy through fun, upbeat performances. The event encourages creativity and movement while inspiring the next generation of performers.",
//         eventDetailImage:
//             "assets/timetableBackgrounds/Move & Inspire Kids Dance.png",
//       ),
//     ],
//     stage2Events: [],
//   ),
//   ScheduleItem(
//     time: "4:00 pm",
//     stage1Events: [
//       EventItem(
//         title: "Showa Boston Dance Performance",
//         time: "16:10-16:25",
//         duration: 15,
//         stage: "Stage 1",
//         iconImage: "assets/timetableIcons/Dancing performance.png",
//         description:
//             "The Showa Boston Dance Performance brings the vibrant Soranbushi, a traditional Japanese folk dance, to life with lively movements and rhythmic chanting. This energetic performance celebrates the strength and spirit of Japanese culture.",
//         eventDetailImage: "assets/timetableBackgrounds/showaboston.jpg",
//       ),
//       EventItem(
//         title: "Bon Dance Event",
//         time: "16:25-16:55",
//         duration: 30,
//         stage: "Stage 1",
//         iconImage: "assets/timetableIcons/Dancing performance.png",
//         description:
//             "The Bon Dance Event invites everyone to join in a traditional Japanese summer dance, celebrating community and honoring ancestors. It's a joyful, participatory experience filled with music, rhythm, and cultural connection.",
//         eventDetailImage: "assets/timetableBackgrounds/BonBon.png",
//       ),
//     ],
//     stage2Events: [],
//   ),
//   ScheduleItem(time: "4:30 pm", stage1Events: [], stage2Events: []),
// ];

// final List<ScheduleItem> day2ScheduleData = [
//   ScheduleItem(
//     time: "11:00 am",
//     stage1Events: [
//       EventItem(
//         title: "Opening Ceremony",
//         time: "11:00-11:05",
//         duration: 5,
//         iconImage: "assets/timetableIcons/Opening ceremony.png",
//         stage: "Stage 1",
//         description:
//             "The Opening Ceremony for Japan Festival Boston 2025 will kick off vibrant performances, cultural displays, and speeches from distinguished guests. This exciting event sets the stage for a weekend celebrating Japanese arts, food, and traditions.",
//         eventDetailImage: "assets/timetableBackgrounds/OpeningCeremony.jpg",
//       ),
//       EventItem(
//         title: "Showa Boston Dance Performance",
//         time: "11:05-11:20",
//         duration: 15,
//         stage: "Stage 1",
//         iconImage: "assets/timetableIcons/Dancing performance.png",
//         description:
//             "The Showa Boston Dance Performance brings the vibrant Soranbushi, a traditional Japanese folk dance, to life with lively movements and rhythmic chanting. This energetic performance celebrates the strength and spirit of Japanese culture.",
//         eventDetailImage: "assets/timetableBackgrounds/showaboston.jpg",
//       ),
//       EventItem(
//         title: "Minami Toyama Noh, Utai, Shinobue",
//         time: "11:20-11:55",
//         duration: 35,
//         stage: "Stage 1",
//         iconImage: "assets/timetableIcons/Dancing performance.png",
//         description:
//             "Minami Toyama presents a captivating mix of Noh, Utai chanting, and Shinobue flute. This performance blends classical Japanese theater, vocal tradition, and melodic flute for a deeply cultural experience.",
//         eventDetailImage:
//             "assets/timetableBackgrounds/Minami Toyama Noh, Utai, Shinobue.png",
//       ),
//     ],
//     stage2Events: [
//       EventItem(
//         title: "",
//         time: "",
//         duration: 35,
//         stage: "",
//         iconImage: "",
//         description: "",
//         eventDetailImage: "",
//       ),
//     ],
//   ),
//   ScheduleItem(
//     time: "11:30 am",
//     stage1Events: [
//       EventItem(
//         title: "Kendo",
//         time: "11:55-12:25",
//         duration: 30,
//         stage: "Stage 1",
//         iconImage: "assets/timetableIcons/Kendo.png",
//         description:
//             "The Kendo performance showcases the art of Japanese swordsmanship through precise movements, discipline, and powerful strikes. It offers a glimpse into the spirit and technique of this traditional martial art.",
//         eventDetailImage: "assets/timetableBackgrounds/kendo.jpg",
//       ),
//     ],
//     stage2Events: [],
//   ),
//   ScheduleItem(
//     time: "12:00 pm",
//     stage1Events: [
//       EventItem(
//         title: "Cosplay Fashion Show",
//         time: "12:25-12:45",
//         duration: 20,
//         stage: "Stage 1",
//         iconImage: "assets/timetableIcons/Anime stage.png",
//         description:
//             "The Cosplay Fashion Show features participants showcasing their detailed costumes inspired by anime, manga, and pop culture. Models walk the runway, celebrating the creativity and craftsmanship behind each ensemble in a vibrant and exciting display.",
//         eventDetailImage:
//             "assets/timetableBackgrounds/Cosplay Fashion Show.png",
//       ),
//     ],
//     stage2Events: [],
//   ),
//   ScheduleItem(
//     time: "12:30 pm",
//     stage1Events: [
//       EventItem(
//         title: "Parfait Soleil Dance Performance",
//         time: "12:45-13:15",
//         duration: 30,
//         stage: "Stage 1",
//         iconImage: "assets/timetableIcons/Dancing performance.png",
//         description:
//             "Parfait Soleil Dance Performance features a lively display of contemporary and traditional dance, blending fluid movements with vibrant energy. The performance captures the joy and beauty of dance through captivating choreography.",
//         eventDetailImage:
//             "assets/timetableBackgrounds/Parfait Soleil Dance Performance.png",
//       ),
//     ],
//     stage2Events: [],
//   ),
//   ScheduleItem(
//     time: "1:00 pm",
//     stage1Events: [
//       EventItem(
//         title: "Hiroko Watanabe Calligraphy",
//         time: "13:15-13:55",
//         duration: 40,
//         stage: "Stage 1",
//         iconImage: "assets/timetableIcons/Band performance.png",
//         description:
//             "Hiroko Watanabe’s calligraphy performance transforms brushstrokes into a captivating visual art. With each precise movement, they bring beauty and meaning to traditional Japanese writing.",
//         eventDetailImage: "assets/timetableBackgrounds/hiroko.jpg",
//       ),
//     ],
//     stage2Events: [],
//   ),
//   ScheduleItem(
//     time: "1:30 pm",
//     stage1Events: [
//       EventItem(
//         title: "Cosplay Death Match",
//         time: "13:55-14:25",
//         duration: 30,
//         stage: "Stage 1",
//         iconImage: "assets/timetableIcons/Anime stage.png",
//         description:
//             "Cosplay Death Match is a lively competition where cosplayers battle it out with performances and style, all for the chance to be crowned the ultimate winner. Audience energy and creativity take center stage in this fan-favorite showdown.",
//         eventDetailImage: "assets/timetableBackgrounds/Cosplay Death Match.png",
//       ),
//     ],
//     stage2Events: [],
//   ),
//   ScheduleItem(
//     time: "2:00 pm",
//     stage1Events: [
//       EventItem(
//         title: "Jeiko Taiko Ensemble",
//         time: "14:25-14:55",
//         duration: 30,
//         iconImage: "assets/timetableIcons/Band performance.png",
//         stage: "Stage 1",
//         description:
//             "The Jeiko Taiko Ensemble is a vibrant Japanese drumming group based in New England, known for their high-energy performances that blend traditional taiko rhythms with modern influences. Their performances showcase the power and precision of Japanese drumming, engaging audiences with dynamic rhythms and movements.",
//         eventDetailImage:
//             "assets/timetableBackgrounds/Jeiko Taiko Ensemble.png",
//       ),
//     ],
//     stage2Events: [],
//   ),
//   ScheduleItem(
//     time: "2:30 pm",
//     stage1Events: [
//       EventItem(
//         title: "Move & Inspire Kids Dance",
//         time: "14:55-15:25",
//         duration: 30,
//         iconImage: "assets/timetableIcons/Dancing performance.png",
//         stage: "Stage 1",
//         description:
//             "Move & Inspire Kids Dance features young dancers showcasing their talent and energy through fun, upbeat performances. The event encourages creativity and movement while inspiring the next generation of performers.",
//         eventDetailImage:
//             "assets/timetableBackgrounds/Move & Inspire Kids Dance.png",
//       ),
//     ],
//     stage2Events: [],
//   ),
//   ScheduleItem(
//     time: "3:00 pm",
//     stage1Events: [
//       EventItem(
//         title: "Okinawa Ryukyu Kokusai Taiko",
//         time: "15:25-15:55",
//         duration: 30,
//         iconImage: "assets/timetableIcons/Band performance.png",
//         stage: "Stage 1",
//         description:
//             "Ryukyu Kokusai Taiko is an Okinawan drumming ensemble known for its dynamic fusion of traditional Eisa rhythms, dance, and karate movements. Their powerful performances celebrate Okinawan culture, blending ancient sounds with modern energy.",
//         eventDetailImage: "assets/timetableBackgrounds/ryukyu.jpg",
//       ),
//     ],
//     stage2Events: [],
//   ),
//   ScheduleItem(
//     time: "3:30 pm",
//     stage1Events: [
//       EventItem(
//         title: "Japan Airlines Advertising and Raffle",
//         time: "15:55-16:05",
//         duration: 10,
//         stage: "Stage 1",
//         iconImage: "assets/timetableIcons/Advertising.png",
//         description:
//             "Japan Airlines Advertising and Raffle offers an exciting opportunity to learn about the airline’s services while participants can enter to win exclusive prizes. It’s a fun and engaging way to promote travel with Japan Airlines.",
//         eventDetailImage:
//             "assets/timetableBackgrounds/Japan Airlines.png",
//       ),
//     ],
//     stage2Events: [],
//   ),
//   ScheduleItem(
//     time: "4:00 pm",
//     stage1Events: [
//       EventItem(
//         title: "Showa Boston Dance Performance",
//         time: "16:05-16:20",
//         duration: 15,
//         stage: "Stage 1",
//         iconImage: "assets/timetableIcons/Dancing performance.png",
//         description:
//             "The Showa Boston Dance Performance brings the vibrant Soranbushi, a traditional Japanese folk dance, to life with lively movements and rhythmic chanting. This energetic performance celebrates the strength and spirit of Japanese culture.",
//         eventDetailImage: "assets/timetableBackgrounds/showaboston.jpg",
//       ),
//       EventItem(
//         title: "Bon Dance Event",
//         time: "16:20-16:50",
//         duration: 30,
//         stage: "Stage 1",
//         iconImage: "assets/timetableIcons/Dancing performance.png",
//         description:
//             "The Bon Dance Event invites everyone to join in a traditional Japanese summer dance, celebrating community and honoring ancestors. It's a joyful, participatory experience filled with music, rhythm, and cultural connection.",
//         eventDetailImage: "assets/timetableBackgrounds/BonBon.png",
//       ),
//     ],
//     stage2Events: [],
//   ),
//   ScheduleItem(
//     time: "4:30 pm",
//     stage1Events: [
//       EventItem(
//         title: "Closing Ceremony",
//         time: "16:50-17:00",
//         duration: 10,
//         stage: "Stage 1",
//         iconImage: "assets/timetableIcons/Closing ceremony.png",
//         description:
//             "The Closing Ceremony marks the end of Japan Festival Boston 2025, wrapping up the weekend with final remarks, gratitude, and celebration. It’s a heartfelt farewell that honors the community, performers, and shared cultural experience.",
//         eventDetailImage: "assets/timetableBackgrounds/Closing Ceremony.jpg",
//       ),
//     ],
//     stage2Events: [],
//   ),
// ];
