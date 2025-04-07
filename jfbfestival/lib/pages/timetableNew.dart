// import 'package:flutter/material.dart';
// import 'package:jfbfestival/data/timetableData.dart';

// /// メインビュー：タイムテーブル
// class TimetablePage extends StatefulWidget {
//   const TimetablePage({super.key});

//   @override
//   _TimetablePageState createState() => _TimetablePageState();
// }

// class _TimetablePageState extends State<TimetablePage> {
//   int selectedDay = 1;
//   int selectedStage = 1;
//   EventItem? selectedEvent;
//   bool isShowingDetail = false;
//   double animationAmount = 1.0;

//   // サンプルのスケジュールデータ（実際にはもっと項目が必要）

//   @override
//   Widget build(BuildContext context) {
//     final topPadding =
//         MediaQuery.of(context).size.height * 0.082 +
//         MediaQuery.of(context).padding.top +
//         MediaQuery.of(context).size.height * 0.02;
//     final currentSchedule =
//         selectedDay == 1 ? day1ScheduleData : day2ScheduleData;
//     final double dayButtonHeight = MediaQuery.of(context).size.height * 0.082;
//     final double dayButtonWidth = MediaQuery.of(context).size.width * 0.52;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Padding(
//         padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
//         child: Stack(
//           children: [
//             Positioned(
//               left: MediaQuery.of(context).size.width * 0.06, // Adjust position
//               top: MediaQuery.of(context).size.height * 0.002,
//               child: GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     selectedDay = 1;
//                   });
//                 },
//                 child: Container(
//                   width: dayButtonWidth,
//                   height: dayButtonHeight,
//                   decoration: ShapeDecoration(
//                     gradient: LinearGradient(
//                       colors:
//                           selectedDay == 1
//                               ? [
//                                 const Color.fromARGB(255, 255, 131, 135),
//                                 // const Color.fromARGB(251, 234, 27, 27),
//                                 const Color.fromARGB(128, 176, 113, 116),
//                                 const Color.fromARGB(0, 96, 96, 96),
//                               ]
//                               : [
//                                 const Color.fromARGB(128, 131, 131, 131),
//                                 const Color.fromARGB(64, 114, 114, 114),
//                                 const Color.fromARGB(0, 96, 96, 96),
//                               ],
//                       // begin: Alignment(-0.50, 0.50),
//                       // end: Alignment(1.0, 0.50),
//                     ),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(100),
//                     ),
//                   ),
//                   alignment: Alignment(-0.3, 0),
//                   child: const Text(
//                     'Day 1',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 45,
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                 ),
//               ),
//             ),

//             Positioned(
//               right:
//                   MediaQuery.of(context).size.width * 0.06, // Adjust position
//               top: MediaQuery.of(context).size.height * 0.002,
//               child: GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     selectedDay = 2;
//                   });
//                 },

//                 child: Container(
//                   width: dayButtonWidth,
//                   height: dayButtonHeight,
//                   decoration: ShapeDecoration(
//                     gradient: LinearGradient(
//                       colors:
//                           selectedDay == 2
//                               ? [
//                                 const Color.fromARGB(49, 96, 96, 96),
//                                 const Color.fromARGB(128, 107, 136, 175),
//                                 const Color.fromARGB(255, 118, 175, 255),
//                               ]
//                               : [
//                                 const Color.fromARGB(0, 96, 96, 96),
//                                 const Color.fromARGB(64, 114, 114, 114),
//                                 const Color.fromARGB(128, 131, 131, 131),
//                               ],
//                       // begin: Alignment(-0.50, 0.50),
//                       // end: Alignment(1.0, 0.50),
//                     ),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(100),
//                     ),
//                   ),
//                   alignment: Alignment(0.35, 0),
//                   child: const Text(
//                     'Day 2',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 45,
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             Column(
//               children: [
//                 SizedBox(height: topPadding),
//                 Expanded(
//                   child: Container(
//                     margin: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(25),
//                       // Gradient of timetable background
//                       gradient: LinearGradient(
//                         colors:
//                             selectedDay == 1
//                                 ? [
//                                   const Color.fromRGBO(191, 28, 36, 0.15),
//                                   const Color.fromRGBO(10, 56, 117, 0.15),
//                                 ]
//                                 : [
//                                   const Color.fromRGBO(10, 56, 117, 0.15),
//                                   const Color.fromRGBO(191, 28, 36, 0.15),
//                                 ],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                     ),
//                     // Build contents of timetable
//                     child: Column(
//                       children: [
//                         Padding(
//                           padding: EdgeInsets.only(
//                             left: MediaQuery.of(context).size.height * 0.0725,
//                           ),
//                           child: _buildStageHeader(),
//                         ),

//                         Expanded(
//                           child: ListView.separated(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 16,
//                               vertical: 10,
//                             ),
//                             itemCount: currentSchedule.length,
//                             separatorBuilder:
//                                 (context, index) => Divider(
//                                   color: Colors.grey.shade300,
//                                   height: 1,
//                                 ),
//                             itemBuilder: (context, index) {
//                               return ScheduleRow(
//                                 scheduleItem: currentSchedule[index],
//                                 onEventTap: (event) {
//                                   setState(() {
//                                     selectedEvent = event;
//                                     isShowingDetail = true;
//                                   });
//                                 },
//                                 isFirst: index == 0,
//                               );
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             // イベント詳細ポップアップ
//             if (isShowingDetail && selectedEvent != null)
//               EventDetailView(
//                 event: selectedEvent!,
//                 onClose: () {
//                   setState(() {
//                     isShowingDetail = false;
//                     selectedEvent = null;
//                   });
//                 },
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   /// ステージヘッダー
//   Widget _buildStageHeader() {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.width;
//     double baseFontSize = 25;
//     double responsiveFontSize = baseFontSize * (screenWidth / 375);
//     double stageHeaderWidth = screenWidth * 0.67;
//     double stageHeaderHeight = screenHeight * 0.11;

//     return Padding(
//       padding: const EdgeInsets.only(top: 25, bottom: 10),
//       child: Container(
//         width: stageHeaderWidth,
//         height: stageHeaderHeight,
//         decoration: BoxDecoration(
//           color: Colors.grey.withOpacity(0.5),
//           borderRadius: BorderRadius.circular(25),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center, // <- changed
//           children: [
//             Text(
//               "Stage 1",
//               style: TextStyle(
//                 fontSize: responsiveFontSize,
//                 fontWeight: FontWeight.w500,
//                 color: Colors.white,
//               ),
//             ),
//             SizedBox(width: 17.5), // <- you can tweak this width as needed
//             SizedBox(
//               width: 4,
//               height: 30,
//               child: DecoratedBox(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20),
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//             SizedBox(width: 17.5), // <- space after the divider
//             Text(
//               "Stage 2",
//               style: TextStyle(
//                 fontSize: responsiveFontSize,
//                 fontWeight: FontWeight.w500,
//                 color: Colors.white,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// /// スケジュール行（1 行分のタイムテーブル）
// class ScheduleRow extends StatelessWidget {
//   final ScheduleItem scheduleItem;
//   final void Function(EventItem) onEventTap;
//   final bool isFirst;

//   const ScheduleRow({
//     required this.scheduleItem,
//     required this.onEventTap,
//     this.isFirst = false,
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     // 時間テキストを分割
//     List<String> timeParts = scheduleItem.time.split(" ");
//     String timeText = timeParts.isNotEmpty ? timeParts[0] : scheduleItem.time;
//     String ampm = timeParts.length > 1 ? timeParts[1] : "";

//     double screenWidth = MediaQuery.of(context).size.width;
//     double baseFontSize = 17;
//     double responsiveFontSize = baseFontSize * (screenWidth / 375);

//     return Column(
//       children: [
//         // Top rounded divider (if first row)
//         if (isFirst)
//           Padding(
//             padding: EdgeInsets.only(
//               left: 60 + screenWidth * 0.026,
//               right: 0, // adjust if you want spacing on the right
//             ),
//             child: Container(
//               height: 3,
//               decoration: BoxDecoration(
//                 color: const Color.fromARGB(8, 0, 0, 0),
//                 borderRadius: BorderRadius.circular(4),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.1),
//                     offset: const Offset(0, 0),
//                     blurRadius: 1,
//                     spreadRadius: 0,
//                   ),
//                 ],
//               ),
//             ),
//           ),

//         // Main row content
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(
//               width: 60,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 // Displaying the time columns
//                 children: [
//                   Text(
//                     timeText,
//                     style: TextStyle(
//                       fontSize: responsiveFontSize,
//                       fontWeight: FontWeight.w300,
//                       height: 1.0,
//                     ),
//                   ),
//                   const SizedBox(height: 2),
//                   Text(
//                     ampm,
//                     style: TextStyle(
//                       fontSize: responsiveFontSize,
//                       height: 1.0,
//                       fontWeight: FontWeight.w300,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(width: screenWidth * 0.026),
//             // Displaying the events on the row
//             Expanded(
//               child: Row(
//                 children: [
//                   scheduleItem.stage1Event != null
//                       ? PerformanceBox(
//                         eventItem: scheduleItem.stage1Event!,
//                         onTap: onEventTap,
//                       )
//                       : const SizedBox(width: 140, height: 60),
//                   const SizedBox(width: 25),
//                   scheduleItem.stage2Event != null
//                       ? PerformanceBox(
//                         eventItem: scheduleItem.stage2Event!,
//                         onTap: onEventTap,
//                       )
//                       : const SizedBox(width: 140, height: 60),
//                 ],
//               ),
//             ),
//           ],
//         ),

//         // Bottom rounded divider (always)
//         Padding(
//           padding: EdgeInsets.only(left: 60 + screenWidth * 0.026, right: 0),
//           child: Container(
//             height: 3,
//             decoration: BoxDecoration(
//               color: const Color.fromARGB(8, 0, 0, 0),
//               borderRadius: BorderRadius.circular(4),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.1),
//                   offset: const Offset(0, 0),
//                   blurRadius: 1,
//                   spreadRadius: 0,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// /// パフォーマンスボックス：タップ時に詳細を表示（タップ時のアニメーション付き）
// class PerformanceBox extends StatefulWidget {
//   final EventItem eventItem;
//   final Function(EventItem) onTap;

//   const PerformanceBox({Key? key, required this.eventItem, required this.onTap})
//     : super(key: key);

//   @override
//   _PerformanceBoxState createState() => _PerformanceBoxState();
// }

// class _PerformanceBoxState extends State<PerformanceBox>
//     with SingleTickerProviderStateMixin {
//   bool isPressed = false;

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;
//     double responsiveFontSize = (screenWidth / 375);

//     return GestureDetector(
//       onTap: () {
//         // タップ時のアニメーション
//         setState(() {
//           isPressed = true;
//         });
//         Future.delayed(const Duration(milliseconds: 150), () {
//           widget.onTap(widget.eventItem);
//           setState(() {
//             isPressed = false;
//           });
//         });
//       },

//       // TODO: Add picture between pictuire and text
//       child: AnimatedScale(
//         scale: isPressed ? 0.95 : 1.0,
//         duration: const Duration(milliseconds: 150),
//         child: Container(
//           width: 140,
//           // TODO: Adjust height with length of event
//           height: screenHeight * 0.07,
//           // height: screenHeight * 0.07,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(40),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(isPressed ? 0.05 : 0.1),
//                 blurRadius: isPressed ? 1 : 3,
//                 offset: Offset(0, isPressed ? 0 : 1),
//               ),
//             ],
//           ),
//           child: Row(
//             children: [
//               SizedBox(width: screenWidth * 0.01),
//               // アイコン部分（Flutter では Image や Icon で実装）
//               Container(
//                 width: 30,
//                 height: 30,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: Colors.white,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.2),
//                       blurRadius: 2,
//                     ),
//                   ],
//                 ),
//                 child: const Icon(Icons.image),
//               ),
//               SizedBox(width: screenWidth * 0.03),
//               Expanded(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       widget.eventItem.title.length > 20
//                           ? widget.eventItem.title.substring(0, 17) + "..."
//                           : widget.eventItem.title,
//                       style: TextStyle(
//                         fontSize: responsiveFontSize * 10,
//                         fontWeight: FontWeight.w500,
//                         height: screenHeight * 0.0010,
//                       ),
//                       maxLines: 2,
//                     ),
//                     Text(
//                       widget.eventItem.time,
//                       style: TextStyle(
//                         fontSize: responsiveFontSize * 8,
//                         fontWeight: FontWeight.w500,
//                         color: Colors.grey,
//                         height: 1.15,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(width: 8),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// /// イベント詳細ポップアップ
// class EventDetailView extends StatefulWidget {
//   final EventItem event;
//   final VoidCallback onClose;

//   const EventDetailView({Key? key, required this.event, required this.onClose})
//     : super(key: key);

//   @override
//   _EventDetailViewState createState() => _EventDetailViewState();
// }

// class _EventDetailViewState extends State<EventDetailView>
//     with TickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _cardOffsetAnimation;
//   late Animation<double> _opacityAnimation;
//   late Animation<double> _headerScaleAnimation;

//   @override
//   void initState() {
//     super.initState();
//     // アニメーションコントローラーの設定
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 500),
//     );
//     _cardOffsetAnimation = Tween<double>(
//       begin: 1000,
//       end: 0,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
//     _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: const Interval(0.2, 0.5, curve: Curves.easeIn),
//       ),
//     );
//     _headerScaleAnimation = Tween<double>(
//       begin: 0.8,
//       end: 1.0,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
//     _controller.forward();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void _close() {
//     _controller.reverse().then((value) {
//       widget.onClose();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _controller,
//       builder: (context, child) {
//         return Stack(
//           children: [
//             // 背景オーバーレイ
//             Opacity(
//               opacity: _opacityAnimation.value * 0.5,
//               child: GestureDetector(
//                 onTap: _close,
//                 child: Container(color: Colors.black),
//               ),
//             ),
//             // イベント詳細カード
//             Transform.translate(
//               offset: Offset(0, _cardOffsetAnimation.value),
//               child: Center(
//                 child: Container(
//                   width: 300,
//                   height: 500,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(20),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.3),
//                         blurRadius: 10,
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     children: [
//                       // ヘッダー（背景とアイコン＋タイトル）
//                       Container(
//                         height: 200,
//                         decoration: BoxDecoration(
//                           color: Colors.grey.withOpacity(0.3),
//                           borderRadius: const BorderRadius.only(
//                             topLeft: Radius.circular(20),
//                             topRight: Radius.circular(20),
//                           ),
//                         ),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Transform.scale(
//                               scale: _headerScaleAnimation.value,
//                               child: CircleAvatar(
//                                 radius: 30,
//                                 backgroundColor: Colors.white,
//                                 child: const Icon(Icons.image),
//                               ),
//                             ),
//                             const SizedBox(height: 10),
//                             Transform.scale(
//                               scale: _headerScaleAnimation.value,
//                               child: Text(
//                                 widget.event.title,
//                                 textAlign: TextAlign.center,
//                                 style: const TextStyle(
//                                   fontSize: 24,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                   shadows: [
//                                     Shadow(
//                                       color: Colors.black54,
//                                       offset: Offset(0, 1),
//                                       blurRadius: 2,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       // ステージと時間情報
//                       Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 15),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             Chip(label: const Text("Stage 1")),
//                             Chip(label: Text(widget.event.time)),
//                           ],
//                         ),
//                       ),
//                       // イベント説明
//                       Padding(
//                         padding: const EdgeInsets.all(16),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: const [
//                             Text(
//                               "Event description",
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                             SizedBox(height: 10),
//                             Text(
//                               "このイベントでは、伝統的な日本の音楽と現代的なパフォーマンスが融合した素晴らしいショーをお届けします。家族全員でお楽しみいただける内容となっています。",
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 color: Colors.black87,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const Spacer(),
//                       // 閉じるボタン（右上）
//                       Align(
//                         alignment: Alignment.topRight,
//                         child: IconButton(
//                           icon: const Icon(
//                             Icons.close,
//                             size: 30,
//                             color: Colors.white,
//                           ),
//                           onPressed: _close,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
