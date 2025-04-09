import 'package:flutter/material.dart';
import 'package:jfbfestival/data/timetableData.dart';
import 'package:collection/collection.dart';

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
                    margin: const EdgeInsets.all(16),
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

  /// ステージヘッダー
  Widget _buildStageHeader() {
    double fontSize = 30;

    return Padding(
      padding: const EdgeInsets.only(top: 25, bottom: 10),
      child: Container(
        width: 290,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.5),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, // <- changed
          children: [
            Text(
              "Stage 1",
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 17.5), // <- you can tweak this width as needed
            SizedBox(
              width: 4,
              height: 30,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(width: 17.5), // <- space after the divider
            Text(
              "Stage 2",
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
                color: Colors.white,
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
    final pixelsPerMinute = 7.4; // Adjust this for density

    // Get all unique times and sort them
    final timelineSlots =
        scheduleItems.map((item) => item.time).toSet().toList()..sort();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Time Column
        Padding(
          padding: const EdgeInsets.only(top: 12, left: 13),
          child: SizedBox(
            width: 60,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  timelineSlots.map((timeString) {
                    final timeParts = timeString.split(" ");
                    final timeText =
                        timeParts.isNotEmpty ? timeParts[0] : timeString;
                    final ampm = timeParts.length > 1 ? timeParts[1] : "";

                    return SizedBox(
                      height: 30 * pixelsPerMinute, // Height for 30-minute slot
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.start, // Align items at the top
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

        SizedBox(width: screenWidth * 0.026),

        // Stage 1 Column
        Expanded(
          child: Column(children: _buildEventColumn(1, pixelsPerMinute)),
        ),

        // Stage 2 Column
        Expanded(
          child: Column(children: _buildEventColumn(2, pixelsPerMinute)),
        ),
      ],
    );
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
      const SizedBox(height: 12),
      for (var i = 0; i < events.length; i++)
        Column(
          children: [
            SizedBox(
              height: events[i].duration * pixelsPerMinute,
              child: PerformanceBox(eventItem: events[i], onTap: onEventTap),
            ),
          ],
        ),
    ];
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
    double responsiveFontSize = (screenWidth / 375);

    double timeSectionHeight = screenHeight * 0.253;
    double eventHeight = widget.eventItem.duration / 60 * timeSectionHeight;

    return GestureDetector(
      onTap: () {
        // タップ時のアニメーション
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
          width: 140,
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
          child: Row(
            children: [
              SizedBox(width: screenWidth * 0.01),
              // アイコン部分（Flutter では Image や Icon で実装）
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
                        : Icon(
                          Icons.event,
                          size: 20,
                        ), // Fallback icon if no image is provided
              ),
              SizedBox(width: screenWidth * 0.03),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.eventItem.title.length > 20
                          ? widget.eventItem.title.substring(0, 17) + "..."
                          : widget.eventItem.title,
                      style: TextStyle(
                        fontSize: responsiveFontSize * 10,
                        fontWeight: FontWeight.w500,
                        height: screenHeight * 0.0010,
                      ),
                      maxLines: 2,
                    ),
                    Text(
                      widget.eventItem.time,
                      style: TextStyle(
                        fontSize: responsiveFontSize * 8,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                        height: 1.15,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
            ],
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
