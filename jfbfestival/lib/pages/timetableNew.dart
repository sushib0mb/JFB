import 'package:flutter/material.dart';

class FestivalSchedule extends StatelessWidget {
  const FestivalSchedule({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenSize = MediaQuery.of(context).size;

    // Example schedule data
    final List<Map<String, dynamic>> scheduleData = [
      {
        "time": "11:00 am",
        "stage1": {
          "title": "Opening Ceremony",
          "time": "11:00-11:30",
          "image": "https://placehold.co/23x23",
        },
        "stage2": null,
      },
      {
        "time": "11:30 am",
        "stage1": null,
        "stage2": {
          "title": "Welcome Performance",
          "time": "11:30-11:45",
          "image": "https://placehold.co/23x23",
        },
      },
      {
        "time": "12:00 pm",
        "stage1": {
          "title": "Showa Boston Dance Performance",
          "time": "12:00-12:15",
          "image": "https://placehold.co/23x23",
        },
        "stage2": {
          "title": "Live Music",
          "time": "12:00-12:30",
          "image": "https://placehold.co/23x23",
        },
      },
      {
        "time": "12:30 pm",
        "stage1": {
          "title": "Cultural Presentation",
          "time": "12:30-1:00",
          "image": "https://placehold.co/23x23",
        },
        "stage2": null,
      },
      {
        "time": "1:00 pm",
        "stage1": null,
        "stage2": {
          "title": "Guest Speaker",
          "time": "1:00-1:45",
          "image": "https://placehold.co/23x23",
        },
      },
      {
        "time": "2:00 pm",
        "stage1": {
          "title": "Interactive Workshop",
          "time": "2:00-3:00",
          "image": "https://placehold.co/23x23",
        },
        "stage2": {
          "title": "Panel Discussion",
          "time": "2:00-3:00",
          "image": "https://placehold.co/23x23",
        },
      },
      {
        "time": "3:00 pm",
        "stage1": {
          "title": "Closing Performance",
          "time": "3:00-3:30",
          "image": "https://placehold.co/23x23",
        },
        "stage2": null,
      },
      {"time": "3:30 pm", "stage1": null, "stage2": null},
      {"time": "4:00 pm", "stage1": null, "stage2": null},
      // Adding more entries to ensure scrolling works
      {
        "time": "4:30 pm",
        "stage1": {
          "title": "Afterparty",
          "time": "4:30-5:30",
          "image": "https://placehold.co/23x23",
        },
        "stage2": null,
      },
      {
        "time": "5:00 pm",
        "stage1": null,
        "stage2": {
          "title": "Awards Ceremony",
          "time": "5:00-6:00",
          "image": "https://placehold.co/23x23",
        },
      },
      {
        "time": "6:00 pm",
        "stage1": {
          "title": "Final Goodbye",
          "time": "6:00-6:15",
          "image": "https://placehold.co/23x23",
        },
        "stage2": null,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: screenSize.width > 369 ? 332 : screenSize.width * 0.9,
          height: screenSize.height > 1110 ? 888 : screenSize.height * 0.8,
          // Apply shadow to the outer container
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
          child: Container(
            // Move gradient to inner container
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment(-1.0, 0.35),
                end: Alignment(1.00, 0.77),
                colors: [Color(0x260B3775), Color(0x26BF1D23)],
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              children: [
                // Stages header
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: Stages(),
                ),

                // Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children:
                            scheduleData
                                .map(
                                  (item) => ScheduleRow(
                                    time: item["time"],
                                    stage1Event: item["stage1"],
                                    stage2Event: item["stage2"],
                                  ),
                                )
                                .toList(),
                      ),
                    ),
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

class Stages extends StatelessWidget {
  const Stages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 259,
          height: 50,
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  width: 259,
                  height: 50,
                  decoration: ShapeDecoration(
                    color: Colors.black.withOpacity(0.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 127,
                top: 7,
                child: Container(
                  transform:
                      Matrix4.identity()
                        ..translate(0.0, 0.0)
                        ..rotateZ(1.57),
                  width: 36,
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 4,
                        strokeAlign: BorderSide.strokeAlignCenter,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const Positioned(
                left: 16,
                top: 7,
                child: SizedBox(
                  width: 98,
                  child: Text(
                    'Stage 1',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontFamily: 'Fredoka',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              const Positioned(
                left: 140,
                top: 7,
                child: SizedBox(
                  width: 104,
                  child: Text(
                    'Stage 2',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontFamily: 'Fredoka',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PerformanceBox extends StatelessWidget {
  final String title;
  final String time;
  final String imageUrl;

  const PerformanceBox({
    Key? key,
    required this.title,
    required this.time,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 115,
          height: 34,
          child: Material(
            // Use Material widget to get proper shadow effects
            color: Colors.transparent,
            // Make the Material transparent so it doesn't block our custom container
            elevation: 4,
            // Control shadow intensity
            shadowColor: const Color(0x33000000),
            // Shadow color with opacity
            borderRadius: BorderRadius.circular(25),
            // Apply the same border radius as the container
            child: Stack(
              children: [
                // Box background
                Positioned(
                  left: 0,
                  top: 0,
                  child: Container(
                    width: 115,
                    height: 34,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ),
                // Time text
                Positioned(
                  left: 32,
                  top: 24,
                  child: Text(
                    time,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 8,
                      fontFamily: 'Fredoka',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                // Title text
                Positioned(
                  left: 32,
                  top: 0,
                  child: SizedBox(
                    width: 74,
                    height: 24,
                    child: Text(
                      title.length > 25
                          ? title.substring(0, 22) + '...'
                          : title,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                        fontFamily: 'Fredoka',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                // Image shadow
                Positioned(
                  left: 4,
                  top: 6,
                  child: Container(
                    width: 21.79,
                    height: 21.79,
                    decoration: const ShapeDecoration(
                      color: Colors.white,
                      shape: OvalBorder(),
                      shadows: [
                        BoxShadow(
                          color: Color(0x66000000),
                          blurRadius: 3,
                          offset: Offset(0, 0),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                  ),
                ),
                // Image
                Positioned(
                  left: 3,
                  top: 6,
                  child: Container(
                    width: 23,
                    height: 23,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.cover,
                      ),
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
}

class ScheduleRow extends StatelessWidget {
  final String time;
  final Map<String, dynamic>? stage1Event;
  final Map<String, dynamic>? stage2Event;

  const ScheduleRow({
    Key? key,
    required this.time,
    this.stage1Event,
    this.stage2Event,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time column - reduced width slightly
          SizedBox(
            width: 50,
            child: Text(
              time,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                fontFamily: 'Fredoka',
              ),
            ),
          ),

          // Stage 1 column
          SizedBox(
            width: 115,
            child:
                stage1Event != null
                    ? PerformanceBox(
                      title: stage1Event!["title"],
                      time: stage1Event!["time"],
                      imageUrl: stage1Event!["image"],
                    )
                    : Container(),
          ),

          const SizedBox(width: 10), // Reduced spacing
          // Stage 2 column
          SizedBox(
            width: 115,
            child:
                stage2Event != null
                    ? PerformanceBox(
                      title: stage2Event!["title"],
                      time: stage2Event!["time"],
                      imageUrl: stage2Event!["image"],
                    )
                    : Container(),
          ),
        ],
      ),
    );
  }
}
