import 'package:flutter/material.dart';

/// データモデル
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

  // サンプルのスケジュールデータ（実際にはもっと項目が必要）
  final List<ScheduleItem> scheduleData = [
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

  @override
  Widget build(BuildContext context) {
    final topPadding =
        MediaQuery.of(context).size.height * 0.082 +
        MediaQuery.of(context).padding.top +
        MediaQuery.of(context).size.height * 0.02;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: topPadding),
              // _buildDaySelectionView(),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    // Gradient of timetable background
                    gradient: LinearGradient(
                      colors:
                          selectedDay == 1
                              ? [
                                const Color.fromRGBO(191, 28, 36, 0.15),
                                const Color.fromRGBO(10, 56, 117, 0.15),
                              ]
                              : [
                                const Color.fromRGBO(10, 56, 117, 0.15),
                                const Color.fromRGBO(191, 28, 36, 0.15),
                              ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  // Build contents of timetable
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.height * 0.0725,
                        ),
                        child: _buildStageHeader(),
                      ),
                      Divider(color: Colors.grey.shade300, height: 1),
                      Expanded(
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          itemCount: scheduleData.length,
                          separatorBuilder:
                              (context, index) => Divider(
                                color: Colors.grey.shade300,
                                height: 1,
                              ),
                          itemBuilder: (context, index) {
                            return ScheduleRow(
                              scheduleItem: scheduleData[index],
                              onEventTap: (event) {
                                setState(() {
                                  selectedEvent = event;
                                  isShowingDetail = true;
                                });
                              },
                            );
                          },
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
    );
  }

  /// 日付選択ビュー
  // Widget _buildDaySelectionView() {
  //   return Container(
  //     height: 60,
  //     margin: const EdgeInsets.symmetric(horizontal: 20),
  //     decoration: BoxDecoration(
  //       color: Colors.grey.withOpacity(0.1),
  //       borderRadius: BorderRadius.circular(25),
  //     ),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceAround,
  //       children: [
  //         // Day 1 ボタン
  //         ElevatedButton(
  //           style: ElevatedButton.styleFrom(
  //             backgroundColor: selectedDay == 1 ? Colors.red : Colors.white,
  //             shape: const StadiumBorder(),
  //             elevation: selectedDay == 1 ? 5 : 2,
  //           ),
  //           onPressed: () {
  //             setState(() {
  //               selectedDay = 1;
  //             });
  //           },
  //           child: Text(
  //             "Day 1",
  //             style: TextStyle(
  //               fontSize: 20,
  //               fontWeight: FontWeight.bold,
  //               color: selectedDay == 1 ? Colors.white : Colors.black,
  //             ),
  //           ),
  //         ),
  //         // 祭りロゴ
  //         Container(
  //           width: 50,
  //           height: 50,
  //           decoration: BoxDecoration(
  //             shape: BoxShape.circle,
  //             gradient: LinearGradient(
  //               colors: [Colors.white, Colors.grey.withOpacity(0.2)],
  //               begin: Alignment.topCenter,
  //               end: Alignment.bottomCenter,
  //             ),
  //             boxShadow: [
  //               BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 3),
  //             ],
  //           ),
  //           alignment: Alignment.center,
  //           child: const Text(
  //             "祭",
  //             style: TextStyle(
  //               fontSize: 28,
  //               fontWeight: FontWeight.bold,
  //               color: Colors.red,
  //             ),
  //           ),
  //         ),
  //         // Day 2 ボタン
  //         ElevatedButton(
  //           style: ElevatedButton.styleFrom(
  //             backgroundColor: selectedDay == 2 ? Colors.blue : Colors.white,
  //             shape: const StadiumBorder(),
  //             elevation: selectedDay == 2 ? 5 : 2,
  //           ),
  //           onPressed: () {
  //             setState(() {
  //               selectedDay = 2;
  //             });
  //           },
  //           child: Text(
  //             "Day 2",
  //             style: TextStyle(
  //               fontSize: 20,
  //               fontWeight: FontWeight.bold,
  //               color: selectedDay == 2 ? Colors.white : Colors.black,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  /// ステージヘッダー
  Widget _buildStageHeader() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.width;
    double baseFontSize = 25;
    double responsiveFontSize = baseFontSize * (screenWidth / 375);
    double stageHeaderWidth = screenWidth * 0.67;
    double stageHeaderHeight = screenHeight * 0.11;

    return Padding(
      padding: const EdgeInsets.only(top: 25, bottom: 10),
      child: Container(
        width: stageHeaderWidth,
        height: stageHeaderHeight,
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
                fontSize: responsiveFontSize,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 20), // <- you can tweak this width as needed
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
            SizedBox(width: 20), // <- space after the divider
            Text(
              "Stage 2",
              style: TextStyle(
                fontSize: responsiveFontSize,
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

/// スケジュール行（1 行分のタイムテーブル）
class ScheduleRow extends StatelessWidget {
  final ScheduleItem scheduleItem;
  final Function(EventItem) onEventTap;

  const ScheduleRow({
    Key? key,
    required this.scheduleItem,
    required this.onEventTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 時間テキストを分割
    List<String> timeParts = scheduleItem.time.split(" ");
    String timeText = timeParts.isNotEmpty ? timeParts[0] : scheduleItem.time;
    String ampm = timeParts.length > 1 ? timeParts[1] : "";

    double screenWidth = MediaQuery.of(context).size.width;
    double baseFontSize = 15;
    double responsiveFontSize = baseFontSize * (screenWidth / 375);

    return Padding(
      // Padding between events
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 時間列
          SizedBox(
            width: 60,
            child: Column(
              children: [
                Text(
                  timeText,
                  style: TextStyle(
                    fontSize: responsiveFontSize,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(ampm, style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // イベント列（Stage1 と Stage2）
          Expanded(
            child: Row(
              children: [
                scheduleItem.stage1Event != null
                    ? PerformanceBox(
                      eventItem: scheduleItem.stage1Event!,
                      onTap: onEventTap,
                    )
                    : SizedBox(width: 140, height: 60),
                const SizedBox(width: 10),
                scheduleItem.stage2Event != null
                    ? PerformanceBox(
                      eventItem: scheduleItem.stage2Event!,
                      onTap: onEventTap,
                    )
                    : SizedBox(width: 140, height: 60),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// パフォーマンスボックス：タップ時に詳細を表示（タップ時のアニメーション付き）
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
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
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
              const SizedBox(width: 8),
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
                child: const Icon(Icons.image),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.eventItem.title.length > 20
                          ? widget.eventItem.title.substring(0, 17) + "..."
                          : widget.eventItem.title,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                    ),
                    Text(
                      widget.eventItem.time,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                        color: Colors.grey,
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
    // アニメーションコントローラーの設定
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
          children: [
            // 背景オーバーレイ
            Opacity(
              opacity: _opacityAnimation.value * 0.5,
              child: GestureDetector(
                onTap: _close,
                child: Container(color: Colors.black),
              ),
            ),
            // イベント詳細カード
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
                  child: Column(
                    children: [
                      // ヘッダー（背景とアイコン＋タイトル）
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.3),
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
                      // ステージと時間情報
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Chip(label: const Text("Stage 1")),
                            Chip(label: Text(widget.event.time)),
                          ],
                        ),
                      ),
                      // イベント説明
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Event description",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "このイベントでは、伝統的な日本の音楽と現代的なパフォーマンスが融合した素晴らしいショーをお届けします。家族全員でお楽しみいただける内容となっています。",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      // 閉じるボタン（右上）
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: const Icon(
                            Icons.close,
                            size: 30,
                            color: Colors.white,
                          ),
                          onPressed: _close,
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
