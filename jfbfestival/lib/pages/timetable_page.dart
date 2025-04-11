import 'package:flutter/material.dart';
import 'package:jfbfestival/data/timetableData.dart';
import 'package:collection/collection.dart';
import 'dart:math';

class _EventData {
  final EventItem event;
  final int startMinutes;
  final int endMinutes;

  _EventData({
    required this.event,
    required this.startMinutes,
    required this.endMinutes,
  });
}

/// メインビュー：タイムテーブル
class TimetablePage extends StatefulWidget {
  const TimetablePage({super.key});

  @override
  _TimetablePageState createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  int selectedDay = 1;
  int selectedStage = 1;
  EventItem? selectedEvent;
  bool isShowingDetail = false;
  double animationAmount = 1.0;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  //   // サンプルのスケジュールデータ（実際にはもっと項目が必要）

  @override
  Widget build(BuildContext context) {
    final double dayButtonHeight = MediaQuery.of(context).size.height * 0.082;
    final double dayButtonWidth = MediaQuery.of(context).size.width * 0.52;
    final topPadding = dayButtonHeight;
    final currentSchedule =
        selectedDay == 1 ? day1ScheduleData : day2ScheduleData;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Stack(
          children: [
            Positioned(
              left: MediaQuery.of(context).size.width * 0.06, // Adjust position
              top: MediaQuery.of(context).size.height * 0.002,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedDay = 1;
                  });
                },
                child: Container(
                  width: dayButtonWidth,
                  height: dayButtonHeight,
                  decoration: ShapeDecoration(
                    gradient: LinearGradient(
                      colors:
                          selectedDay == 1
                              ? [
                                const Color.fromARGB(255, 255, 131, 135),
                                const Color.fromARGB(128, 176, 113, 116),
                                const Color.fromARGB(0, 96, 96, 96),
                              ]
                              : [
                                const Color.fromARGB(128, 131, 131, 131),
                                const Color.fromARGB(64, 114, 114, 114),
                                const Color.fromARGB(0, 96, 96, 96),
                              ],
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  alignment: Alignment(-0.4, 0),
                  child: const Text(
                    'Day 1',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 45,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),

            Positioned(
              right:
                  MediaQuery.of(context).size.width * 0.06, // Adjust position
              top: MediaQuery.of(context).size.height * 0.002,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedDay = 2;
                  });
                },

                child: Container(
                  width: dayButtonWidth,
                  height: dayButtonHeight,
                  decoration: ShapeDecoration(
                    gradient: LinearGradient(
                      colors:
                          selectedDay == 2
                              ? [
                                const Color.fromARGB(49, 96, 96, 96),
                                const Color.fromARGB(128, 107, 136, 175),
                                const Color.fromARGB(255, 118, 175, 255),
                              ]
                              : [
                                const Color.fromARGB(0, 96, 96, 96),
                                const Color.fromARGB(64, 114, 114, 114),
                                const Color.fromARGB(128, 131, 131, 131),
                              ],
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  alignment: Alignment(0.55, 0),
                  child: const Text(
                    'Day 2',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 45,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
            Column(
              children: [
                SizedBox(
                  height:
                      topPadding + MediaQuery.of(context).size.height * 0.015,
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      gradient: LinearGradient(
                        colors: [
                          const Color.fromRGBO(10, 56, 117, 0.15),
                          const Color.fromRGBO(191, 28, 36, 0.15),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.height * 0.0725,
                          ),
                          child: _buildStageHeader(),
                        ),

                        Expanded(
                          child: SingleChildScrollView(
                            child: ScheduleList(
                              scheduleItems: currentSchedule,
                              onEventTap: (event) {
                                setState(() {
                                  selectedEvent = event;
                                  isShowingDetail = true;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // イベント詳細ポップアップ
            if (isShowingDetail && selectedEvent != null)
              EventDetailView(
                event: selectedEvent!,
                onClose: () {
                  setState(() {
                    isShowingDetail = false;
                    selectedEvent = null;
                  });
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStageHeader() {
    const double fontSize = 17;

    return Padding(
      padding: const EdgeInsets.only(top: 25, bottom: 10),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.67,
        height: 50,
        decoration: BoxDecoration(
  color: Color(0xFF8D8D97),
  borderRadius: BorderRadius.circular(36),
),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 12, right: 8),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Boston Common",
                    style: TextStyle(
                      fontSize: fontSize - 1.5,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
            ),
           Container(
  width: 3,
  height: 30,
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
  ),
),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 12),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Downtown",
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ScheduleList extends StatelessWidget {
  final List<ScheduleItem> scheduleItems;
  final void Function(EventItem) onEventTap;

  const ScheduleList({
    required this.scheduleItems,
    required this.onEventTap,
    super.key,
  });
 @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final baseFontSize = 17.0;
    final responsiveFontSize = baseFontSize * (screenWidth / 375);
    final pixelsPerMinute = 10.0;

    final timelineSlots = scheduleItems.map((item) => item.time).toSet().toList();
    timelineSlots.sort();
    final baseTime = _parseTimeToMinutes(timelineSlots.first);
    final latestTime = _parseTimeToMinutes(timelineSlots.last) + 120;
    final timelineHeight = (latestTime - baseTime) * pixelsPerMinute;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Time Column (unchanged)
        Padding(
          padding: const EdgeInsets.only(top: 12, left: 13),
          child: SizedBox(
            width: 60,
            height: timelineHeight,
            child: Stack(
              children: timelineSlots.map((timeString) {
                final timeParts = timeString.split(" ");
                final timeText = timeParts.isNotEmpty ? timeParts[0] : timeString;
                final ampm = timeParts.length > 1 ? timeParts[1] : "";
                final timeInMinutes = _parseTimeToMinutes(timeString);
                final topPosition = (timeInMinutes - baseTime) * pixelsPerMinute;

                return Positioned(
                  top: topPosition,
                  left: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
  timeText,
  style: TextStyle(
    fontSize: responsiveFontSize * 1.1,
    fontWeight: FontWeight.w400,
    color: Color(0xFF303030),
  ),
),
Text(
  ampm,
  style: TextStyle(
    fontSize: responsiveFontSize * 0.9,
    fontWeight: FontWeight.w300,
    color: Color(0xFF505050),
  ),
),

                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),

        // Stage 1 Column with smart positioning
       Expanded(
  child: SizedBox(
    height: timelineHeight,
    child: Stack(
      children: [
        _buildTimelineLines(
          baseTime: baseTime,
          latestTime: latestTime,
          pixelsPerMinute: pixelsPerMinute,
          width: screenWidth / 2,
        ),
        ..._buildSmartEventPositioning(
          stage: 1,
          baseTime: baseTime,
          pixelsPerMinute: pixelsPerMinute,
          screenWidth: screenWidth,
        ),
      ],
    ),
  ),
),


        // Stage 2 Column with smart positioning
              Expanded(
  child: SizedBox(
    height: timelineHeight,
    child: Stack(
      children: [
        _buildTimelineLines(
          baseTime: baseTime,
          latestTime: latestTime,
          pixelsPerMinute: pixelsPerMinute,
          width: screenWidth / 2,
        ),
        ..._buildSmartEventPositioning(
          stage: 2,
          baseTime: baseTime,
          pixelsPerMinute: pixelsPerMinute,
          screenWidth: screenWidth,
        ),
      ],
    ),
  ),
),
      ],
    );
  }
  Widget _buildTimelineLines({
  required int baseTime,
  required int latestTime,
  required double pixelsPerMinute,
  required double width,
}) {
  final List<Widget> lines = [];

  for (int t = baseTime; t <= latestTime; t += 30) { // <-- now every 15 minutes
    final top = (t - baseTime) * pixelsPerMinute;
    lines.add(Positioned(
      top: top,
      left: 0,
      right: 0,
      child: Container(
        width: width,
        height: 1,
        color: Colors.grey.withOpacity(1),
      ),
    ));
  }

  return Stack(children: lines);
}
List<Widget> _buildSmartEventPositioning({
  required int stage,
  required int baseTime,
  required double pixelsPerMinute,
  required double screenWidth,
}) {
  // Get all events for this stage
  final events = scheduleItems
      .expand((item) => stage == 1 ? (item.stage1Events ?? []) : (item.stage2Events ?? []))
      .where((e) => e.title.isNotEmpty)
      .map((e) {
        final start = _parseEventStartTime(e.time).toInt();
        final duration = e.duration;
        return _EventData(
          event: e,
          startMinutes: start,
          endMinutes: (start + duration).toInt(),
        );
      }).toList();

  // Sort events by start time
  events.sort((a, b) => a.startMinutes.compareTo(b.startMinutes));
  
  final List<Widget> widgets = [];
  
  // Approach: Process the events and place them in non-overlapping columns
  if (events.isEmpty) return widgets;
  
  // Track which columns have events at what times
  final List<List<_EventData>> columns = [];
  
  for (var event in events) {
    // Find a column where this event doesn't overlap with existing events
    bool placed = false;
    
    for (int i = 0; i < columns.length; i++) {
      // Check if this event overlaps with any event in this column
      bool hasOverlap = columns[i].any((existingEvent) => 
        (event.startMinutes < existingEvent.endMinutes && 
         event.endMinutes > existingEvent.startMinutes));
      
      if (!hasOverlap) {
        // No overlap in this column, add the event here
        columns[i].add(event);
        placed = true;
        break;
      }
    }
    
    // If we couldn't place in existing columns, create a new column
    if (!placed) {
      columns.add([event]);
    }
  }
  
  // Calculate layout parameters
  final double totalAvailableWidth = (screenWidth - 100) / 2;
  final double columnCount = columns.length.toDouble();
  final double cardWidth = max(totalAvailableWidth / columnCount, 80.0); // Minimum width of 80
  
  // Render each event in its assigned column
  for (int columnIndex = 0; columnIndex < columns.length; columnIndex++) {
    for (var event in columns[columnIndex]) {
      final double leftOffset = 5 + columnIndex * (totalAvailableWidth / columnCount);
      final double topPosition = (event.startMinutes - baseTime) * pixelsPerMinute;
      final double height = (event.endMinutes - event.startMinutes) * pixelsPerMinute;
      
      widgets.add(Positioned(
        top: topPosition + 12, // Add padding at top
        left: leftOffset,
        width: cardWidth - 10,
        height: height,
        child: PerformanceBox(
          eventItem: event.event,
          onTap: onEventTap,
        ),
      ));
    }
  }
  
  return widgets;
}

  List<List<_EventData>> _groupOverlappingEvents(List<_EventData> events) {
  if (events.isEmpty) return [];

  final List<List<_EventData>> lanes = [];

  for (final event in events) {
    bool placed = false;

    for (final lane in lanes) {
      final lastEventInLane = lane.last;

      // Only add if it starts after or exactly when the last ends
      if (event.startMinutes >= lastEventInLane.endMinutes) {
        lane.add(event);
        placed = true;
        break;
      }
    }

    if (!placed) {
      lanes.add([event]);
    }
  }

  return lanes;
}

  // Parse time string (like "11:00 am") to minutes since midnight
  int _parseTimeToMinutes(String timeString) {
    try {
      // Parse time format (handle both "11:00 am" and "11:00" formats)
      final parts = timeString.split(' ');
      final timePart = parts[0];
      final isPM = parts.length > 1 && parts[1].toLowerCase() == 'pm';
      
      final hourAndMinute = timePart.split(':');
      int hour = int.parse(hourAndMinute[0]);
      final int minute = hourAndMinute.length > 1 ? int.parse(hourAndMinute[1]) : 0;
      
      // Convert to 24-hour format if PM
      if (isPM && hour < 12) {
        hour += 12;
      }
      // Handle 12 AM edge case
      if (!isPM && hour == 12) {
        hour = 0;
      }
      
      return hour * 60 + minute;
    } catch (e) {
      print('Error parsing time: $timeString - $e');
      return 0; // Default fallback
    }
  }

  // Parse event time from the format used in your app
  int _parseEventStartTime(String eventTime) {
    try {
      // Handle formats like "11:00-11:30" or "11:00 am - 11:30 am"
      final parts = eventTime.split('-');
      if (parts.isEmpty) return 0;
      
      final String startTimePart = parts[0].trim();
      return _parseTimeToMinutes(startTimePart);
    } catch (e) {
      print('Error parsing event time: $eventTime - $e');
      return 0; // Default fallback
    }
  }

  List<Widget> _buildEventPositioned(int stage, int baseTime, double pixelsPerMinute) {
    final List<Widget> eventWidgets = [];
    
    // Get all events for this stage
    final events = scheduleItems.expand((item) => 
      stage == 1 ? (item.stage1Events ?? []) : (item.stage2Events ?? [])
    ).toList();
    
    // Filter out empty events
    final nonEmptyEvents = events.where((event) => event.title.isNotEmpty).toList();
    
    // For each event, position it based on its time
    for (var event in nonEmptyEvents) {
      try {
        // Parse the event start time
        final startTimeInMinutes = _parseEventStartTime(event.time);
        final topPosition = (startTimeInMinutes - baseTime) * pixelsPerMinute;
        
        if (topPosition >= 0) { // Only add if it's visible in our timeline view
          eventWidgets.add(
            Positioned(
              top: topPosition + 12, // Add padding at top
              left: 10,
              right: 10,
              height: event.duration * pixelsPerMinute * 0.85, // Slightly reduce height to prevent overlap
              child: PerformanceBox(eventItem: event, onTap: onEventTap),
            ),
          );
        }
      } catch (e) {
        print('Error positioning event ${event.title}: $e');
      }
    }
    
    return eventWidgets;
  }
}

// / パフォーマンスボックス：タップ時に詳細を表示（タップ時のアニメーション付き）
class PerformanceBox extends StatefulWidget {
  final EventItem eventItem;
  final Function(EventItem) onTap;

  const PerformanceBox({Key? key, required this.eventItem, required this.onTap})
      : super(key: key);

  @override
  _PerformanceBoxState createState() => _PerformanceBoxState();
}

class _PerformanceBoxState extends State<PerformanceBox>
    with SingleTickerProviderStateMixin {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double responsiveFontSize = screenWidth / 375;

    double timeSectionHeight = screenHeight * 0.253;
    double eventHeight = widget.eventItem.duration / 60 * timeSectionHeight + 6.7;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0), // Adds spacing to avoid overlap
      child: GestureDetector(
        onTap: () {
          setState(() {
            isPressed = true;
          });
          Future.delayed(const Duration(milliseconds: 150), () {
            widget.onTap(widget.eventItem);
            setState(() {
              isPressed = false;
            });
          });
        },
        child: AnimatedScale(
          scale: isPressed ? 0.95 : 1.0,
          duration: const Duration(milliseconds: 150),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(36),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: widget.eventItem.iconImage.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(6),
                          child: Image.asset(widget.eventItem.iconImage, fit: BoxFit.contain),
                        )
                      : const Icon(Icons.event, size: 20),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.eventItem.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: responsiveFontSize * 12.5,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  widget.eventItem.time,
                  style: TextStyle(
                    fontSize: responsiveFontSize * 9.5,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// イベント詳細ポップアップ
class EventDetailView extends StatefulWidget {
  final EventItem event;
  final VoidCallback onClose;

  const EventDetailView({Key? key, required this.event, required this.onClose})
    : super(key: key);

  @override
  _EventDetailViewState createState() => _EventDetailViewState();
}

class _EventDetailViewState extends State<EventDetailView>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _cardOffsetAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _headerScaleAnimation;

  @override
  void initState() {
    super.initState();
    // Animation controller setup
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _cardOffsetAnimation = Tween<double>(
      begin: 1000,
      end: 0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.5, curve: Curves.easeIn),
      ),
    );
    _headerScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _close() {
    _controller.reverse().then((value) {
      widget.onClose();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          // Ensure stack fills the screen
          fit: StackFit.expand,
          children: [
            // Background overlay - using Positioned.fill to ensure complete coverage
            Positioned.fill(
              child: Opacity(
                opacity: _opacityAnimation.value * 0.5,
                child: GestureDetector(
                  onTap: _close,
                  child: Container(color: Colors.black),
                ),
              ),
            ),
            // Event detail card
            Transform.translate(
              offset: Offset(0, _cardOffsetAnimation.value),
              child: Center(
                child: Container(
                  width: 300,
                  height: 500,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Content
                      Column(
                        children: [
                          // Header (background, icon, title)
                          Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(
                                255,
                                208,
                                85,
                                85,
                              ).withOpacity(0.3),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Transform.scale(
                                  scale: _headerScaleAnimation.value,
                                  child: CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.white,
                                    child: const Icon(Icons.image),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Transform.scale(
                                  scale: _headerScaleAnimation.value,
                                  child: Text(
                                    widget.event.title,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black54,
                                          offset: Offset(0, 1),
                                          blurRadius: 2,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Stage and time information
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Chip(label: Text(widget.event.stage)),
                                Chip(label: Text(widget.event.time)),
                              ],
                            ),
                          ),
                          // Expanded content area with scrolling
                          Expanded(
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 242,
                                    height: 255,
                                    decoration: ShapeDecoration(
                                      color: const Color.fromARGB(13, 0, 0, 0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Close button - positioned properly at the top right
                      Positioned(
                        top: 10,
                        right: 10,
                        child: GestureDetector(
                          onTap: _close,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
