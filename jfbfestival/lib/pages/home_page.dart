import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:jfbfestival/mainscreen.dart';
import '/data/timetableData.dart';

class CurrentAndUpcomingEvents {
  final List<EventItem> currentStage1Events;
  final List<EventItem> currentStage2Events;
  final List<EventItem> upcomingStage1Events;
  final List<EventItem> upcomingStage2Events;

  CurrentAndUpcomingEvents({
    required this.currentStage1Events,
    required this.currentStage2Events,
    required this.upcomingStage1Events,
    required this.upcomingStage2Events,
  });
}

class HomePage extends StatefulWidget {
  final DateTime? testTime;
  const HomePage({Key? key, this.testTime}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> backgroundImages = [
    "assets/JFB-27.jpg",
    "assets/JFB-4.jpg",
    "assets/JFB-3.jpg",
    "assets/JFB-8.jpg",
    "assets/JFB-15.jpg",
    "assets/JFB-10.jpg",
    "assets/JFB-22.jpg",
    "assets/JFB-6.jpg",
  ];

  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _autoScrollTimer;
  Timer? _timetableUpdateTimer;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
    _timetableUpdateTimer = Timer.periodic(Duration(minutes: 1), (timer) {
      if (mounted) setState(() {});
    });
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (_pageController.hasClients) {
        int nextPage = (_currentPage + 1) % backgroundImages.length;
        _pageController.animateToPage(
          nextPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _timetableUpdateTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 600;

        return Scaffold(
          backgroundColor: Color(0xFFFFF5F5),
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: screenHeight * 0.6,
                          child: Stack(
                            children: [
                              PageView.builder(
                                controller: _pageController,
                                itemCount: backgroundImages.length,
                                onPageChanged: (index) {
                                  setState(() {
                                    _currentPage = index;
                                  });
                                },
                                itemBuilder: (context, index) {
                                  return Image.asset(
                                    backgroundImages[index],
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: screenHeight * 0.6,
                                  );
                                },
                              ),
                              Positioned(
                                bottom: 10,
                                left: 0,
                                right: 0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    backgroundImages.length,
                                    (index) => AnimatedContainer(
                                      duration: Duration(milliseconds: 300),
                                      margin: EdgeInsets.symmetric(horizontal: 4),
                                      width: _currentPage == index ? 10 : 6,
                                      height: _currentPage == index ? 10 : 6,
                                      decoration: BoxDecoration(
                                        color: _currentPage == index
                                            ? Colors.white
                                            : Colors.white70,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: screenHeight * 0.05,
                          right: screenWidth * 0.05,
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 5,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              // child: Image.asset(
                              //   "assets/langChange.png",
                              //   height: isSmallScreen ? 40 : 50,
                              // ), #COMMENT OUT FOR NOW!!
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    _buildLiveTimetable(screenWidth),
                    _buildSocialMediaIcons(screenWidth),
                    _buildSponsorsSection(screenWidth),
                    SizedBox(height: screenHeight * 0.3),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Helper class to organize events

Widget _buildLiveTimetable(double screenWidth) {
  // Use test time if provided, otherwise use current Boston time (UTC-4)
  // final now = widget.testTime ?? DateTime.now().toUtc().subtract(Duration(hours: 4));
    final now = widget.testTime ?? DateTime.utc(2025, 4, 27, 16, 55);
  
  // Festival dates setup
  final festivalStart = DateTime(2025, 4, 27, 11); // April 27 at 11:00 AM
  final festivalEnd = DateTime(2025, 4, 28, 23, 59); // April 28 at 11:59 PM

  // Check if we're outside festival dates
  if (now.isBefore(festivalStart) || now.isAfter(festivalEnd)) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        "Live Timetable is only available during the festival days (Apr 27–28).",
        style: TextStyle(fontSize: 16),
        textAlign: TextAlign.center,
      ),
    );
  }

  // Determine which day's schedule to use (day 1 or day 2)
  final bool isDay1 = now.day == 27; // First day is April 27
  
  // Make sure schedule data exists before proceeding
  final List<ScheduleItem> scheduleList;
  try {
    scheduleList = isDay1 ? day1ScheduleData : day2ScheduleData;
    
    // Safety check - if schedule data is empty, show a message
    if (scheduleList.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          "No schedule data available for ${isDay1 ? 'Day 1' : 'Day 2'}.",
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
      );
    }
  } catch (e) {
    // Handle case where data is not available
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        "Error loading schedule data: $e",
        style: TextStyle(fontSize: 16, color: Colors.red),
        textAlign: TextAlign.center,
      ),
    );
  }

  // Find all current and upcoming events for both stages
  final currentAndUpcomingEvents = _getCurrentAndUpcomingEvents(scheduleList, now, isDay1);

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      children: [
        if (currentAndUpcomingEvents.currentStage1Events.isNotEmpty || 
            currentAndUpcomingEvents.currentStage2Events.isNotEmpty) ...[
          _buildEventSection(
            "🎤 Now Happening", 
            currentAndUpcomingEvents.currentStage1Events,
            currentAndUpcomingEvents.currentStage2Events,
            screenWidth,
            isCurrent: true,
          ),
          SizedBox(height: 16),
        ],
        if (currentAndUpcomingEvents.upcomingStage1Events.isNotEmpty || 
            currentAndUpcomingEvents.upcomingStage2Events.isNotEmpty)
          _buildEventSection(
            "⏭️ Up Next", 
            currentAndUpcomingEvents.upcomingStage1Events,
            currentAndUpcomingEvents.upcomingStage2Events,
            screenWidth,
            isCurrent: false,
          ),
        if (currentAndUpcomingEvents.currentStage1Events.isEmpty && 
            currentAndUpcomingEvents.currentStage2Events.isEmpty &&
            currentAndUpcomingEvents.upcomingStage1Events.isEmpty &&
            currentAndUpcomingEvents.upcomingStage2Events.isEmpty)
          Text(
            "No current or upcoming events at this time.",
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
      ],
    ),
  );
}

CurrentAndUpcomingEvents _getCurrentAndUpcomingEvents(
  List<ScheduleItem> scheduleList, 
  DateTime now,
  bool isDay1
) {
  // Initialize empty lists for all categories
  List<EventItem> currentStage1Events = [];
  List<EventItem> currentStage2Events = [];
  List<EventItem> upcomingStage1Events = [];
  List<EventItem> upcomingStage2Events = [];
  
  // Current year and month
  final year = now.year;
  final month = now.month;
  final day = isDay1 ? 27 : 28; // April 27 or 28, 2025
  
  // Process all events to find current and upcoming
  for (final item in scheduleList) {
    // Safety check - skip if stage events are null
    if (item.stage1Events == null && item.stage2Events == null) continue;
    
    // Process Stage 1 events
    if (item.stage1Events != null) {
      for (final event in item.stage1Events!) {
        // Skip if time format is invalid
        if (!event.time.contains('-')) continue;
        
        try {
          // Parse the event time range (e.g., "11:00-11:15")
          final timeParts = event.time.split('-');
          final eventStartStr = timeParts[0].trim();
          final eventEndStr = timeParts[1].trim();
          
          // Convert to full DateTime objects
          final eventStartParts = eventStartStr.split(':');
          final eventEndParts = eventEndStr.split(':');
          
          if (eventStartParts.length != 2 || eventEndParts.length != 2) continue;
          
          final eventStartHour = int.parse(eventStartParts[0]);
          final eventStartMinute = int.parse(eventStartParts[1]);
          final eventEndHour = int.parse(eventEndParts[0]);
          final eventEndMinute = int.parse(eventEndParts[1]);
          
          final eventStart = DateTime(year, month, day, eventStartHour, eventStartMinute);
          final eventEnd = DateTime(year, month, day, eventEndHour, eventEndMinute);
          
          // Current event: now is between event start and end times
          if (now.isAfter(eventStart) && now.isBefore(eventEnd)) {
            currentStage1Events.add(event);
          }
          // Upcoming event: event starts after now
          else if (eventStart.isAfter(now)) {
            // Only add if we don't have upcoming events yet or if this starts at the same time
            if (upcomingStage1Events.isEmpty || 
                eventStart.isAtSameMomentAs(_parseEventStartTime(upcomingStage1Events.first.time, year, month, day))) {
              upcomingStage1Events.add(event);
            }
          }
        } catch (e) {
          // Skip this event if there's a parsing error
          print('Error parsing Stage 1 event: $e');
          continue;
        }
      }
    }
    
    // Process Stage 2 events
    if (item.stage2Events != null) {
      for (final event in item.stage2Events!) {
        // Skip if time format is invalid
        if (!event.time.contains('-')) continue;
        
        try {
          // Parse the event time range (e.g., "11:00-11:15")
          final timeParts = event.time.split('-');
          final eventStartStr = timeParts[0].trim();
          final eventEndStr = timeParts[1].trim();
          
          // Convert to full DateTime objects
          final eventStartParts = eventStartStr.split(':');
          final eventEndParts = eventEndStr.split(':');
          
          if (eventStartParts.length != 2 || eventEndParts.length != 2) continue;
          
          final eventStartHour = int.parse(eventStartParts[0]);
          final eventStartMinute = int.parse(eventStartParts[1]);
          final eventEndHour = int.parse(eventEndParts[0]);
          final eventEndMinute = int.parse(eventEndParts[1]);
          
          final eventStart = DateTime(year, month, day, eventStartHour, eventStartMinute);
          final eventEnd = DateTime(year, month, day, eventEndHour, eventEndMinute);
          
          // Current event: now is between event start and end times
          if (now.isAfter(eventStart) && now.isBefore(eventEnd)) {
            currentStage2Events.add(event);
          }
          // Upcoming event: event starts after now
          else if (eventStart.isAfter(now)) {
            // Only add if we don't have upcoming events yet or if this starts at the same time
            if (upcomingStage2Events.isEmpty || 
                eventStart.isAtSameMomentAs(_parseEventStartTime(upcomingStage2Events.first.time, year, month, day))) {
              upcomingStage2Events.add(event);
            }
          }
        } catch (e) {
          // Skip this event if there's a parsing error
          print('Error parsing Stage 2 event: $e');
          continue;
        }
      }
    }
  }
  
  // Sort upcoming events by start time if we have multiple events
  if (upcomingStage1Events.length > 1) {
    upcomingStage1Events.sort((a, b) {
      final aTime = _parseEventStartTime(a.time, year, month, day);
      final bTime = _parseEventStartTime(b.time, year, month, day);
      return aTime.compareTo(bTime);
    });
  }
  
  if (upcomingStage2Events.length > 1) {
    upcomingStage2Events.sort((a, b) {
      final aTime = _parseEventStartTime(a.time, year, month, day);
      final bTime = _parseEventStartTime(b.time, year, month, day);
      return aTime.compareTo(bTime);
    });
  }
  
  // If we have multiple upcoming events with different start times, only keep the earliest ones
  if (upcomingStage1Events.isNotEmpty && upcomingStage2Events.isNotEmpty) {
    final stage1StartTime = _parseEventStartTime(upcomingStage1Events.first.time, year, month, day);
    final stage2StartTime = _parseEventStartTime(upcomingStage2Events.first.time, year, month, day);
    
    if (stage1StartTime.isBefore(stage2StartTime)) {
      // Keep only stage1 events that start at the earliest time
      upcomingStage2Events.clear();
    } else if (stage2StartTime.isBefore(stage1StartTime)) {
      // Keep only stage2 events that start at the earliest time
      upcomingStage1Events.clear();
    }
  }

  return CurrentAndUpcomingEvents(
    currentStage1Events: currentStage1Events,
    currentStage2Events: currentStage2Events,
    upcomingStage1Events: upcomingStage1Events,
    upcomingStage2Events: upcomingStage2Events,
  );
}

// Helper method to parse event start time from time range string with full date
DateTime _parseEventStartTime(String timeRange, int year, int month, int day) {
  try {
    final timePart = timeRange.split('-')[0].trim();
    final parts = timePart.split(':');
    if (parts.length != 2) {
      // Return a default time far in the future if parsing fails
      return DateTime(9999);
    }
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return DateTime(year, month, day, hour, minute);
  } catch (e) {
    // Return a default time far in the future if parsing fails
    print('Error parsing event start time: $e');
    return DateTime(9999);
  }
}

// Update this method to handle AM/PM format properly if needed
DateTime _parseTimeString(String timeStr, int day) {
  try {
    final parts = timeStr.split(' ');
    if (parts.length != 2) {
      // Return current time if parsing fails
      return DateTime.now();
    }
    
    final timeParts = parts[0].split(':');
    if (timeParts.length != 2) {
      // Return current time if parsing fails
      return DateTime.now();
    }
    
    var hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);
    
    if (parts[1].toLowerCase() == 'pm' && hour != 12) {
      hour += 12;
    } else if (parts[1].toLowerCase() == 'am' && hour == 12) {
      hour = 0;
    }
    
    return DateTime(2025, 4, day, hour, minute);
  } catch (e) {
    // Return current time if parsing fails
    print('Error parsing time string: $e');
    return DateTime.now();
  }
}

  Widget _buildEventSection(
    String title,
    List<EventItem> stage1Events,
    List<EventItem> stage2Events,
    double screenWidth, {
    required bool isCurrent,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.pinkAccent,
            ),
          ),
        ),
        SizedBox(height: 8),
        ...stage1Events.map((event) => _buildEventCard(event, isCurrent, screenWidth)),
        ...stage2Events.map((event) => _buildEventCard(event, isCurrent, screenWidth)),
      ],
    );
  }

  Widget _buildEventCard(EventItem event, bool isCurrent, double screenWidth) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
  context,
  PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (_, __, ___) => MainScreen(initialIndex: 2),
    transitionsBuilder: (_, animation, __, child) {
      const begin = Offset(1.0, 0.0); // slide from right
      const end = Offset.zero;
      final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.easeInOut));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  ),
);

      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.mic, color: Colors.black),
                      SizedBox(width: 10),
                      Text(
                        event.stage,
                        style: TextStyle(
                          color: Colors.pinkAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Text(
                    event.title,
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(event.time, style: TextStyle(color: Colors.grey)),
                  if (isCurrent)
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          "Going on now!",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (event.iconImage.isNotEmpty)
              Positioned(
                top: -18,
                left: 3,
                child: Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Image.asset(
                    event.iconImage,
                    height: screenWidth * 0.12,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialMediaIcons(double screenWidth) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 2),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildIcon("assets/instagram.png", "https://www.instagram.com/japanfestivalboston?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw=="),
          _buildIcon("assets/facebook.png", "https://www.facebook.com/JapanFestivalBoston"),
          _buildIcon("assets/youtube.png", "https://www.youtube.com/@japanfestivalboston"),
          _buildIcon("assets/website.png", "https://www.japanfestivalboston.org"),
        ],
      ),
    );
  }

  Widget _buildIcon(String imagePath, String url) {
    return GestureDetector(
      onTap: () async {
        final Uri uri = Uri.parse(url);
        if (await canLaunch(uri.toString())) {
          await launch(uri.toString());
        } else {
          throw 'Could not launch $url';
        }
      },
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 2),
          ],
        ),
        child: Image.asset(imagePath, height: 30),
      ),
    );
  }

  Widget _buildSponsorsSection(double screenWidth) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 2),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildSponsorCategory("Sustainability", "assets/Takeda.jpg"),
          _buildSponsorCategory("Airline", "assets/jal.jpg"),
          _buildCorporateSponsors(),
          _buildJfbOrganizers(),
        ],
      ),
    );
  }

  Widget _buildSponsorCategory(String title, String imagePath) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          margin: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            title,
            style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
          ),
        ),
        Image.asset(imagePath, height: 50),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildCorporateSponsors() {
    List<String> corporateLogos = [
      "assets/sanipak.png",
      "assets/chopvalue.png",
      "assets/openwater.png",
      "assets/mitsubishi.jpg",
      "assets/SDT.jpg",
      "assets/senko.png",
      "assets/yamamoto.jpg",
    ];

    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          margin: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            "Corporate",
            style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
          ),
        ),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 20,
          runSpacing: 10,
          children: corporateLogos
              .map((logo) => Image.asset(logo, height: 50))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildJfbOrganizers() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          margin: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            "JFB Organizers",
            style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
          ),
        ),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 20,
          runSpacing: 10,
          children: [
            Image.asset("assets/showa.jpg", height: 50),
            Column(
              children: [
                Image.asset("assets/bosJapan.png", height: 50),
                SizedBox(height: 4),
                Text("Boston Japan", style: TextStyle(fontSize: 12)),
                Text("Community Hub", style: TextStyle(fontSize: 12)),
              ],
            ),
            Image.asset("assets/JAGB.jpg", height: 50),
          ],
        ),
      ],
    );
  }
}
