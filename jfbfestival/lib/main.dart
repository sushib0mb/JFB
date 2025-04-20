import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as developer;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';

import 'theme_notifier.dart';
import 'settings_page.dart';
import 'pages/food/food_page.dart';
import 'pages/home_page.dart';
import 'pages/map_page.dart';
import 'pages/timetable_page.dart';
import 'data/timetableData.dart';
import 'SplashScreen/video_splash_screen.dart';
import 'models/feedback_entry.dart';
import 'models/survey_entry.dart';
import 'pages/survey/survey_page.dart';
import 'pages/survey/survey_list_page.dart';
import 'providers/reminder_provider.dart';
import 'config/supabase_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(FeedbackEntryAdapter());
  Hive.registerAdapter(SurveyEntryAdapter());

  await Hive.openBox<FeedbackEntry>('feedback');
  await Hive.openBox<SurveyEntry>('survey');

  // Supabase is now initialized via supabase_config.dart
  developer.log(
    'Supabase client initialized: $supabase',
    name: '🔥 SupabaseInit',
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
        ChangeNotifierProvider(create: (_) => ReminderProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder:
          (context, theme, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'JFB Festival',
            theme: ThemeData(
              brightness: Brightness.light,
              fontFamily: 'Fredoka',
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              fontFamily: 'Fredoka',
            ),
            themeMode: theme.mode,
            home: const MainScreen(),

            routes: {
              SettingsPage.routeName: (_) => const SettingsPage(),
              SurveyPage.routeName: (_) => const SurveyPage(),
              if (kDebugMode)
                SurveyListPage.routeName: (_) => const SurveyListPage(),
              // if (kDebugMode)
              //   AdminDashboardPage.routeName: (_) => const AdminDashboardPage(),
            },
          ),
    );
  }
}

class MainScreen extends StatefulWidget {
  final int initialIndex;
  final EventItem? selectedEvent;
  final String? selectedMapLetter;
  final int? selectedDay; // ← new

  const MainScreen({
    Key? key,
    this.initialIndex = 0,
    this.selectedEvent,
    this.selectedMapLetter,
    this.selectedDay, // ← accept it here
  }) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _currentIndex;
  late int _dayForTimetable;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _dayForTimetable = widget.selectedDay ?? 1; // default to Day 1
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;

      // If you want to reset your food‑page filter when leaving FoodPage:
      if (index != 1 && widget.selectedMapLetter != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (_) => MainScreen(
                  initialIndex: index,
                  selectedEvent: widget.selectedEvent,
                  selectedMapLetter: null,
                  selectedDay: _dayForTimetable,
                ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      HomePage(testTime: DateTime(2025, 4, 27, 14, 00)),
      FoodPage(selectedMapLetter: widget.selectedMapLetter),
      // Pass both event *and* day into TimetablePage:
      TimetablePage(
        selectedEvent: widget.selectedEvent,
        selectedDay: _dayForTimetable,
      ),
      MapPage(),
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          IndexedStack(index: _currentIndex, children: pages),
          SafeArea(child: TopBar(selectedIndex: _currentIndex)),
          Align(
            alignment: Alignment.bottomCenter,
            child: BottomBar(
              selectedIndex: _currentIndex,
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
    final double logoSize = MediaQuery.of(context).size.height * 0.086;

    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
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
