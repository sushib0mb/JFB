import 'package:flutter/material.dart';

class TimetablePage extends StatelessWidget {
  const TimetablePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Create local scroll controllers
    final ScrollController scrollControllerLeft = ScrollController();
    final ScrollController scrollControllerRight = ScrollController();

    // Synchronize scrolling
    scrollControllerLeft.addListener(() {
      if (scrollControllerRight.hasClients) {
        scrollControllerRight.jumpTo(scrollControllerLeft.offset);
      }
    });

    scrollControllerRight.addListener(() {
      if (scrollControllerLeft.hasClients) {
        scrollControllerLeft.jumpTo(scrollControllerRight.offset);
      }
    });

    return Scaffold(
      body: Column(
        children: [
          // Custom AppBar
          const SizedBox(height: 90, child: TopBarWidget()),

          // Buttons spanning both panels
          Container(
            color: Colors.white, // Match background
            child: Row(
              children: [
                // Left-side padding (1/3 of the screen width)
                Container(
                  width: MediaQuery.of(context).size.width / 3,
                  height: 50, // Adjust height as needed
                  color: Colors.blueGrey[100], // Match left scroll panel color
                ),

                // Right-side text (occupy remaining space)
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue, // Background color
                          borderRadius: BorderRadius.circular(
                            30,
                          ), // Rounded corners
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                                right: 20,
                              ),
                              child: const Text(
                                "First Stage",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white, // Text color
                                ),
                              ),
                            ),
                            Container(
                              width: 1.5, // Divider thickness
                              height: 20, // Match text height
                              color: Colors.white.withOpacity(
                                0.5,
                              ), // Slightly transparent divider
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 20,
                                right: 5,
                              ),
                              child: const Text(
                                "Second Stage",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white, // Text color
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Main Content - Timestamps & Events
          Expanded(
            child: Row(
              children: [
                // Left panel - Timestamps
                Expanded(
                  flex: 1,
                  child: ScrollConfiguration(
                    behavior: ScrollBehavior().copyWith(
                      scrollbars: true,
                    ), // Hide scrollbar
                    child: ListView.builder(
                      controller: scrollControllerLeft,
                      physics: const ClampingScrollPhysics(),
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Container(
                          height: 100,
                          color: Colors.blueGrey[100],
                          child: Center(
                            child: Text(
                              "${index + 10}:00",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// CustomAppBar with buttons
class TopBarWidget extends StatelessWidget {
  const TopBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Background of AppBar
        Container(
          color: const Color.fromARGB(255, 51, 181, 147).withOpacity(0.7),
        ),

        // Left Oval Button
        Positioned(
          left: MediaQuery.of(context).size.width * 0.2, // Adjust position
          child: GestureDetector(
            onTap: () {
              print("Left button pressed");
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.4,
              height: 60,
              decoration: ShapeDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0.00, 0.50),
                  end: Alignment(1.00, 0.50),
                  colors: [
                    Color.fromARGB(255, 255, 131, 135),
                    Color.fromARGB(255, 176, 113, 116),
                    Color.fromARGB(255, 96, 96, 96),
                  ],
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              alignment: Alignment.center, // Center the text inside
              child: const Text(
                "Day 1",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white, // Ensure contrast with the background
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),

        // Right Oval Button
        Positioned(
          right: MediaQuery.of(context).size.width / 2 - 145, // Adjust position
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: ElevatedButton(
              onPressed: () {
                print("Left button pressed");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 30,
                ), // Only vertical padding
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 60, right: 30),
                child: const Text("二日目", style: TextStyle(fontSize: 20)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
