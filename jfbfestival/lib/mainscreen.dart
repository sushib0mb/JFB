import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jfbfestival/pages/food_page.dart';
import 'package:jfbfestival/pages/home_page.dart';
// import 'package:jfbfestival/pages/timetable_page.dart';
import 'package:jfbfestival/pages/map_page.dart';

import 'package:jfbfestival/pages/timetableNew.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          IndexedStack(
            index: selectedIndex,
            children: [HomePage(), FoodPage(), TimetablePage(), MapPage()],
          ),
          SafeArea(child: TopBar(selectedIndex: selectedIndex)),
          Align(
            alignment: Alignment.bottomCenter,
            child: BottomBar(
              selectedIndex: selectedIndex,
              onItemTapped: _onItemTapped,
            ),
          ),
        ],
      ),
    );
  }
}

class TopBar extends StatelessWidget {
  final int selectedIndex;
  const TopBar({super.key, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    final double logoSize = MediaQuery.of(context).size.height * 0.082;
    final double dayButtonHeight = MediaQuery.of(context).size.height * 0.082;
    final double dayButtonWidth = MediaQuery.of(context).size.width * 0.52;

    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 10),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          if (selectedIndex == 1) ...[
            Positioned(
              left: MediaQuery.of(context).size.width * 0.06, // Adjust position
              top: MediaQuery.of(context).size.height * 0.002,
              child: GestureDetector(
                onTap: () {
                  print("Right button pressed");
                },
                child: Container(
                  width: dayButtonWidth,
                  height: dayButtonHeight,
                  decoration: ShapeDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(-0.50, 0.50),
                      end: Alignment(1.0, 0.50),
                      colors: [
                        const Color.fromARGB(255, 255, 131, 135),
                        // const Color.fromARGB(251, 234, 27, 27),
                        const Color.fromARGB(128, 176, 113, 116),
                        const Color.fromARGB(0, 96, 96, 96),
                      ],
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  alignment: Alignment(-0.3, 0),
                  child: const Text(
                    'Day 1',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 45,
                      fontFamily: 'Fredoka',
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
                  print("Right button pressed");
                },
                child: Container(
                  width: dayButtonWidth,
                  height: dayButtonHeight,
                  decoration: ShapeDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(-0.50, 0.50),
                      end: Alignment(1.0, 0.50),
                      colors: [
                        const Color.fromARGB(0, 96, 96, 96),
                        // const Color.fromARGB(251, 234, 27, 27),
                        const Color.fromARGB(64, 114, 114, 114),
                        const Color.fromARGB(128, 131, 131, 131),
                      ],
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  alignment: Alignment(0.35, 0),
                  child: const Text(
                    'Day 2',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 45,
                      fontFamily: 'Fredoka',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          ],
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: logoSize,
              height: logoSize,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent, // Background color for the circle
              ),
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: ClipOval(
                  child: Image.asset('assets/JFBLogo.png', fit: BoxFit.cover),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomBar({
    required this.selectedIndex,
    required this.onItemTapped,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Get the screen width and calculate the width of the bottom bar
    final screenWidth = MediaQuery.of(context).size.width;

    // Define the padding for the left and right sides
    final sidePadding = screenWidth * 0.03; // Adjust the value as needed

    // Adjust the width of the bottom bar to account for side padding
    final bottomBarWidth =
        screenWidth - 2 * sidePadding; // Subtracting padding on both sides

    // Icon size
    final iconSize = 74.0; // Width and height of each icon
    final numberOfIcons = 4; // Number of icons in the bottom bar

    // Calculate total width of all icons (icons + space between them)
    final totalIconsWidth = iconSize * numberOfIcons;

    // Calculate the remaining space in the bottom bar
    final remainingSpace = bottomBarWidth - totalIconsWidth;

    // Calculate dynamic spacing based on the remaining space
    final dynamicSpacing =
        remainingSpace / (numberOfIcons + 1); // +1 for the edges

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: sidePadding),
      child: Container(
        width: bottomBarWidth,
        height: 94.74,
        margin: const EdgeInsets.only(bottom: 20),
        child: Stack(
          children: [
            // Semi-transparent background with blur
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
              ),
            ),
            // Navigation buttons
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Dynamic spacing for each icon
                  SizedBox(width: dynamicSpacing),
                  ImageButton(
                    index: 0,
                    defaultImage: "assets/bottomBar/Home.png",
                    pressedImage: "assets/bottomBar/Home(Frame).png",
                    selectedIndex: selectedIndex,
                    onSelect: onItemTapped,
                  ),
                  SizedBox(width: dynamicSpacing),
                  ImageButton(
                    index: 1,
                    defaultImage: "assets/bottomBar/Food.png",
                    pressedImage: "assets/bottomBar/Food(Frame).png",
                    selectedIndex: selectedIndex,
                    onSelect: onItemTapped,
                  ),
                  SizedBox(width: dynamicSpacing),
                  ImageButton(
                    index: 2,
                    defaultImage: "assets/bottomBar/Timetable.png",
                    pressedImage: "assets/bottomBar/Timetable(Frame).png",
                    selectedIndex: selectedIndex,
                    onSelect: onItemTapped,
                  ),
                  SizedBox(width: dynamicSpacing),
                  ImageButton(
                    index: 3,
                    defaultImage: "assets/bottomBar/Map.png",
                    pressedImage: "assets/bottomBar/Map(Frame).png",
                    selectedIndex: selectedIndex,
                    onSelect: onItemTapped,
                  ),
                  SizedBox(width: dynamicSpacing),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ImageButton extends StatefulWidget {
  final int index;
  final String defaultImage;
  final String pressedImage;
  final int selectedIndex;
  final Function(int) onSelect;

  const ImageButton({
    required this.index,
    required this.defaultImage,
    required this.pressedImage,
    required this.selectedIndex,
    required this.onSelect,
    super.key,
  });

  @override
  _ImageButtonState createState() => _ImageButtonState();
}

class _ImageButtonState extends State<ImageButton> {
  bool isPressed = false;

  // Handle tap events
  void _onTapDown(TapDownDetails details) {
    setState(() {
      isPressed = true;
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      isPressed = false;
    });
  }

  void _onTapCancel() {
    setState(() {
      isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isSelected = widget.selectedIndex == widget.index;
    final imageToShow = isPressed ? widget.pressedImage : widget.defaultImage;
    final iconSize = 67.0;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: () => widget.onSelect(widget.index),
      child: Container(
        width: 74,
        height: 74,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color:
              isSelected && !isPressed
                  ? Colors.white.withOpacity(0.7)
                  : Colors.transparent,
        ),
        child: Center(
          child: ClipOval(
            child: Image.asset(imageToShow, width: iconSize, height: iconSize),
          ),
        ),
      ),
    );
  }
}
