import 'package:flutter/material.dart';
import 'package:jfbfestival/data/timetableData.dart';

/// メインビュー：タイムテーブル
class TimetablePage extends StatefulWidget {
  final EventItem? selectedEvent;

  const TimetablePage({super.key, this.selectedEvent});

  @override
  _TimetablePageState createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  int selectedDay = 1;
  int selectedStage = 1;
  EventItem? selectedEvent;
  bool isShowingDetail = false;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    if (widget.selectedEvent != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _highlightSelectedEvent(widget.selectedEvent!);
      });
    }
  }

  void _highlightSelectedEvent(EventItem selected) {
    final currentSchedule =
        selectedDay == 1 ? day1ScheduleData : day2ScheduleData;

    for (var item in currentSchedule) {
      final allEvents = [...?item.stage1Events, ...?item.stage2Events];

      for (var e in allEvents) {
        if (e.title == selected.title &&
            e.time == selected.time &&
            e.stage == selected.stage) {
          setState(() {
            selectedEvent = e;
            isShowingDetail = true;
          });

          _scrollToEventTime(e.time);
          return;
        }
      }
    }
  }

  int _parseTimeToMinutes(String timeString) {
    try {
      final parts = timeString.split(' ');
      final timePart = parts[0];
      final isPM = parts.length > 1 && parts[1].toLowerCase() == 'pm';

      final hourAndMinute = timePart.split(':');
      int hour = int.parse(hourAndMinute[0]);
      final int minute =
          hourAndMinute.length > 1 ? int.parse(hourAndMinute[1]) : 0;

      if (isPM && hour < 12) {
        hour += 12;
      }
      if (!isPM && hour == 12) {
        hour = 0;
      }

      return hour * 60 + minute;
    } catch (e) {
      print('Error parsing time: $timeString - $e');
      return 0;
    }
  }

  void _scrollToEventTime(String time) {
    final startMinutes = _parseTimeToMinutes(time);
    final offset = (startMinutes - _parseTimeToMinutes("11:00 am")) * 10.0;

    _scrollController.animateTo(
      offset,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double dayButtonHeight = MediaQuery.of(context).size.height * 0.082;
    final double dayButtonWidth = MediaQuery.of(context).size.width * 0.52;
    final topPadding = dayButtonHeight;
    final currentSchedule =
        selectedDay == 1 ? day1ScheduleData : day2ScheduleData;

    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar:
          widget.selectedEvent != null
              ? AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: Container(
                  margin: EdgeInsets.only(left: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              )
              : null,
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Stack(
          children: [
            Positioned(
              left: MediaQuery.of(context).size.width * 0.06,
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
                    color:
                        selectedDay == 1
                            ? const Color.fromARGB(38, 191, 29, 35)
                            : const Color.fromARGB(175, 224, 224, 224),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                      side:
                          selectedDay == 1
                              ? const BorderSide(
                                color: Color.fromARGB(255, 191, 29, 35),
                                width: 2.0,
                              )
                              : BorderSide.none,
                    ),
                  ),
                  alignment: Alignment(-0.3, 0),
                  child: const Text(
                    'Day 1',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 40,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: MediaQuery.of(context).size.width * 0.06,
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
                    color:
                        selectedDay == 1
                            ? const Color.fromARGB(175, 224, 224, 224)
                            : const Color.fromARGB(38, 11, 55, 117),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                      side:
                          selectedDay == 2
                              ? const BorderSide(
                                color: Color.fromARGB(255, 11, 55, 117),
                                width: 2.0,
                              )
                              : BorderSide.none,
                    ),
                  ),
                  alignment: Alignment(0.4, 0),
                  child: const Text(
                    'Day 2',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 40,
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
                            left: MediaQuery.of(context).size.width * 0.1,
                          ),
                          child: _buildStageHeader(),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            controller: _scrollController,
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
        width: MediaQuery.of(context).size.width * 0.64,
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
    final baseFontSize = 16.0;
    final responsiveFontSize = baseFontSize * (screenWidth / 375);
    final pixelsPerMinute = 10.0;

    // If scheduleItems is empty, return an empty container
    if (scheduleItems.isEmpty) {
      return Container();
    }

    final timelineSlots =
        scheduleItems.map((item) => item.time).toSet().toList();
    final baseTime = _parseTimeToMinutes(timelineSlots.first);

    // Get the last event's duration from both stages based on scheduleItems
    int latestEventEndTime = baseTime;

    for (var item in scheduleItems) {
      final itemStartTime = _parseTimeToMinutes(item.time);

      // Check stage 1 events
      if (item.stage1Events != null) {
        for (var event in item.stage1Events!) {
          final eventEndTime = itemStartTime + event.duration;
          if (eventEndTime > latestEventEndTime) {
            latestEventEndTime = eventEndTime;
          }
        }
      }

      // Check stage 2 events
      if (item.stage2Events != null) {
        for (var event in item.stage2Events!) {
          final eventEndTime = itemStartTime + event.duration;
          if (eventEndTime > latestEventEndTime) {
            latestEventEndTime = eventEndTime;
          }
        }
      }
    }

    // Add padding to latest time
    final latestTime = latestEventEndTime + 35;
    final timelineHeight = (latestTime - baseTime) * pixelsPerMinute;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Time Column
        Padding(
          padding: const EdgeInsets.only(left: 13),
          child: SizedBox(
            width: screenWidth * 0.14,
            height: timelineHeight, // Set explicit height for time column
            child: Stack(
              children:
                  timelineSlots.map((timeString) {
                    final timeParts = timeString.split(" ");
                    final timeText =
                        timeParts.isNotEmpty ? timeParts[0] : timeString;
                    final ampm = timeParts.length > 1 ? timeParts[1] : "";
                    final timeInMinutes = _parseTimeToMinutes(timeString);
                    final topPosition =
                        (timeInMinutes - baseTime) * pixelsPerMinute;

                    return Positioned(
                      top: topPosition,
                      left: 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            timeText,
                            style: TextStyle(
                              fontSize: responsiveFontSize,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Text(
                            ampm,
                            style: TextStyle(
                              fontSize: responsiveFontSize,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
            ),
          ),
        ),

        Expanded(
          child: SizedBox(
            height: timelineHeight,
            child: Stack(
              clipBehavior: Clip.none, // Prevent clipping of children
              children: [
                _buildTimelineLines(
                  baseTime: baseTime,
                  latestTime: latestTime,
                  pixelsPerMinute: pixelsPerMinute,
                  width: screenWidth * 0,
                ),
                SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: SizedBox(
                    height: timelineHeight,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: _buildEventColumn(1, pixelsPerMinute),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        Expanded(
          child: SizedBox(
            height: timelineHeight,
            child: Stack(
              clipBehavior: Clip.none, // Prevent clipping of children
              children: [
                _buildTimelineLines(
                  baseTime: baseTime,
                  latestTime: latestTime,
                  pixelsPerMinute: pixelsPerMinute,
                  width: screenWidth / 2,
                ),
                SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  child: SizedBox(
                    height: timelineHeight,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: _buildEventColumn(2, pixelsPerMinute),
                    ),
                  ),
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

    for (int t = baseTime; t <= latestTime; t += 30) {
      final top = (t - baseTime) * pixelsPerMinute;
      lines.add(
        Positioned(
          top: top,
          left: 0,
          right: 0,
          child: Container(
            height: 4,
            decoration: BoxDecoration(
              color: const Color.fromARGB(8, 0, 0, 0),
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(0, 0),
                  blurRadius: 1,
                  spreadRadius: 0,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Stack(children: lines);
  }

  List<Widget> _buildEventColumn(int stage, double pixelsPerMinute) {
    final events =
        scheduleItems
            .expand(
              (item) =>
                  stage == 1
                      ? item.stage1Events ?? []
                      : item.stage2Events ?? [],
            )
            .where((e) => e.title.isNotEmpty)
            .toList();

    // Sort events by time if needed
    events.sort((a, b) => a.time.compareTo(b.time));

    return [
      for (var i = 0; i < events.length; i++)
        Column(
          children: [
            SizedBox(height: 4), // Add small gap between events in timetable
            SizedBox(
              height: ((events[i].duration) * pixelsPerMinute) - 4,
              child: PerformanceBox(eventItem: events[i], onTap: onEventTap),
            ),
          ],
        ),
    ];
  }
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
    final int minute =
        hourAndMinute.length > 1 ? int.parse(hourAndMinute[1]) : 0;

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
    return 0; // Default fallback
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

    double timeSectionHeight = screenHeight * 0.253;
    double eventHeight =
        widget.eventItem.duration / 60 * timeSectionHeight + 6.7;
    double responsiveFontSize = screenWidth / 380;

    return GestureDetector(
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
          width: screenWidth * 0.3,
          height: eventHeight,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(45),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isPressed ? 0.05 : 0.1),
                blurRadius: isPressed ? 1 : 3,
                offset: Offset(0, isPressed ? 0 : 1),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: screenWidth * 0.3 * 0.05,
            ),
            child:
                widget.eventItem.duration < 10
                    ? Row(
                      // Layout for duration < 10
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                          child:
                              widget.eventItem.iconImage.isNotEmpty
                                  ? Image.asset(
                                    widget.eventItem.iconImage,
                                    fit: BoxFit.cover,
                                  )
                                  : Icon(Icons.event, size: 20),
                        ),
                        SizedBox(width: screenWidth * 0.3 * 0.075),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.eventItem.title.length > 17
                                    ? "${widget.eventItem.title.substring(0, 17)}..."
                                    : widget.eventItem.title,
                                style: TextStyle(
                                  fontSize: responsiveFontSize * 8,
                                  fontWeight: FontWeight.w500,
                                  height: 0.93,
                                ),
                                maxLines: 2,
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                widget.eventItem.time,
                                style: TextStyle(
                                  fontSize: responsiveFontSize * 6,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                  height: 0.9,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                    : widget.eventItem.duration == 10
                    ? Row(
                      // Layout for duration = 10
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 33,
                          height: 33,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                          child:
                              widget.eventItem.iconImage.isNotEmpty
                                  ? Image.asset(
                                    widget.eventItem.iconImage,
                                    fit: BoxFit.cover,
                                  )
                                  : Icon(Icons.event, size: 20),
                        ),
                        SizedBox(width: screenWidth * 0.3 * 0.054),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.eventItem.title.length > 17
                                    ? "${widget.eventItem.title.substring(0, 17)}..."
                                    : widget.eventItem.title,
                                style: TextStyle(
                                  fontSize: responsiveFontSize * 9.5,
                                  fontWeight: FontWeight.w500,
                                  height: 1.7,
                                ),
                                maxLines: 2,
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                widget.eventItem.time,
                                style: TextStyle(
                                  fontSize: responsiveFontSize * 8,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                  height: 0.9,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                    : Column(
                      // Layout for duration > 10
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                          child: Image.asset(
                            widget.eventItem.iconImage,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: eventHeight * 0.05),
                        Text(
                          // widget.eventItem.title.length > 20
                          //     ? "${widget.eventItem.title.substring(0, 20)}..."
                          widget.eventItem.title,
                          style: TextStyle(
                            fontSize: responsiveFontSize * 12,
                            fontWeight: FontWeight.w500,
                            height: 0.8,
                          ),
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: screenHeight * 0.003),
                        Text(
                          widget.eventItem.time,
                          style: TextStyle(
                            fontSize: responsiveFontSize * 10,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                            height: 1.1,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
          ),
        ),
      ),
    );
  }
}

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
      duration: const Duration(milliseconds: 300),
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
            // Background overlay with full screen coverage
            Positioned.fill(
              child: Opacity(
                opacity: _opacityAnimation.value * 0.6, // Set the opacity here
                child: GestureDetector(
                  onTap: _close,
                  child: Container(color: const Color.fromARGB(255, 0, 0, 0)),
                ),
              ),
            ),
            // Event detail card animation
            Transform.translate(
              offset: Offset(0, _cardOffsetAnimation.value),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Event Detail Card
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: MediaQuery.of(context).size.height * 0.6,
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
                          Column(
                            children: [
                              // Header image
                              Container(
                                height: 200,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                      widget.event.eventDetailImage,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.3),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        height: 50,
                                      ), // space for floating icon
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
                              ),

                              // Stage and time info
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
                                            0.25,
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color:
                                              widget.event.stage == "Stage 1"
                                                  ? const Color.fromARGB(
                                                    120,
                                                    191,
                                                    29,
                                                    25,
                                                  )
                                                  : const Color.fromARGB(
                                                    76,
                                                    11,
                                                    55,
                                                    117,
                                                  ),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.3,
                                              ),
                                              blurRadius: 20,
                                            ),
                                          ],
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10,
                                        ),
                                        child: Center(
                                          child: Text(
                                            widget.event.stage,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black87,
                                              fontSize: 17,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                    ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
                                            0.25,
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.2,
                                              ),
                                              blurRadius: 10,
                                            ),
                                          ],
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10,
                                        ),
                                        child: Center(
                                          child: Text(
                                            widget.event.time,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black87,
                                              fontSize: 17,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Description section
                              Expanded(
                                child: SingleChildScrollView(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 242,
                                        height: 200,
                                        decoration: ShapeDecoration(
                                          color: const Color.fromARGB(
                                            13,
                                            0,
                                            0,
                                            0,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              25,
                                            ),
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            widget.event.description,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Close Button
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

                  // Floating Icon
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.15,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            widget.event.iconImage,
                            fit: BoxFit.contain,
                            width: 100,
                            height: 100,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
