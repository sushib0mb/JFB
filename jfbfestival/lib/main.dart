import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as developer;
import 'theme_notifier.dart';
import 'settings_page.dart';
import 'package:jfbfestival/pages/food/food_page.dart';
import 'package:jfbfestival/pages/home_page.dart';
import 'package:jfbfestival/pages/map_page.dart';
import 'package:jfbfestival/pages/timetable_page.dart';
import 'package:jfbfestival/data/timetableData.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/feedback_entry.dart';
import 'models/survey_entry.dart';
import 'pages/survey/survey_page.dart';
import 'pages/survey/survey_list_page.dart';
import 'admin_dashboard.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'providers/reminder_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
<<<<<<< Updated upstream
  await dotenv.load();
=======
  await dotenv.load();      
>>>>>>> Stashed changes
  await Hive.initFlutter();
  Hive.registerAdapter(FeedbackEntryAdapter());
  Hive.registerAdapter(SurveyEntryAdapter());
  await Hive.openBox<FeedbackEntry>('feedback');
  await Hive.openBox<SurveyEntry>('survey');
<<<<<<< Updated upstream
  await Supabase.initialize(
=======
  await Supabase.initialize(                            
>>>>>>> Stashed changes
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  developer.log(
    'Supabase client initialized: \${Supabase.instance.client}',
    name: '🔥 SupabaseInit',
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
<<<<<<< Updated upstream
        ChangeNotifierProvider(create: (_) => ReminderProvider()), // 👈
=======
        ChangeNotifierProvider(create: (_) => ReminderProvider()),
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
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
              if (kDebugMode) // only in debug builds
                SurveyListPage.routeName: (_) => const SurveyListPage(),
              //  if (kDebugMode)
              //   AdminDashboardPage.routeName: (_) => const AdminDashboardPage(),
            },
          ),
=======
      builder: (context, theme, _) => MaterialApp(
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
        },
      ),
>>>>>>> Stashed changes
    );
  }
}

class MainScreen extends StatefulWidget {
  final int initialIndex;
  final EventItem? selectedEvent;
  final String? selectedMapLetter;

  const MainScreen({
    super.key,
    this.initialIndex = 0,
    this.selectedEvent,
<<<<<<< Updated upstream
    this.selectedMapLetter, // <-- add this
=======
    this.selectedMapLetter,
>>>>>>> Stashed changes
  });

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  late int selectedIndex;
<<<<<<< Updated upstream
=======
  Key foodPageKey = UniqueKey();
  String? currentMapLetter;
>>>>>>> Stashed changes

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
    currentMapLetter = widget.selectedMapLetter;
  }

  void _onItemTapped(int index) {
    // If navigating away from Food page, reset the letter filter
    if (selectedIndex == 1 && index != 1) {
      foodPageKey = UniqueKey();
      currentMapLetter = null;
    }
    setState(() => selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
<<<<<<< Updated upstream
          // 1) Your main pages
=======
>>>>>>> Stashed changes
          IndexedStack(
            index: selectedIndex,
            children: [
              HomePage(),
<<<<<<< Updated upstream
              FoodPage(selectedMapLetter: widget.selectedMapLetter),
=======
              FoodPage(
                key: foodPageKey,
                selectedMapLetter: currentMapLetter,
              ),
>>>>>>> Stashed changes
              TimetablePage(selectedEvent: widget.selectedEvent),
              MapPage(),
            ],
          ),
<<<<<<< Updated upstream

          // 2) Logo at top‑center
          SafeArea(child: TopBar(selectedIndex: selectedIndex)),

          // 3) Your bottom navigation bar
=======
          SafeArea(
            child: TopBar(selectedIndex: selectedIndex),
          ),
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream

=======
>>>>>>> Stashed changes
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
                color: Colors.transparent,
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
    final screenWidth = MediaQuery.of(context).size.width;
    final sidePadding = screenWidth * 0.03;
    final bottomBarWidth = screenWidth - 2 * sidePadding;
    final iconSize = 74.0;
    final numberOfIcons = 4;
    final totalIconsWidth = iconSize * numberOfIcons;
    final remainingSpace = bottomBarWidth - totalIconsWidth;
    final dynamicSpacing = remainingSpace / (numberOfIcons + 1);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: sidePadding),
      child: Container(
        width: bottomBarWidth,
        height: 94.74,
        margin: const EdgeInsets.only(bottom: 20),
        child: Stack(
          children: [
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
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
          color: isSelected && !isPressed
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
