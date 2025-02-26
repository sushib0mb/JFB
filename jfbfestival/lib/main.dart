import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:jfbfestival/pages/food_page.dart';
import 'package:jfbfestival/pages/home_page.dart';  

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'JFB App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 116, 252, 43),
          ),
        ),
        home: HomePage(), // Set HomePage as the initial page
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {} // Create app state here

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var selectedIndex = 0;

  // Remove HomePage from here because it's already the home screen.
  static List<Widget> widgetOptions = <Widget>[
    HomePage2(),  // Use Placeholder for Home, since it's already the first screen
    FoodPage(),
    Placeholder(),
    Placeholder(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: widgetOptions.elementAt(selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Color.fromARGB(255, 212, 89, 81),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: 'Food',
            backgroundColor: Color.fromARGB(255, 64, 144, 181),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_list),
            label: 'Timetable',
            backgroundColor: Color.fromARGB(255, 185, 107, 198),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.place),
            label: 'Map',
            backgroundColor: Color.fromARGB(255, 232, 204, 63),
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 255, 255, 255),
        onTap: _onItemTapped,
      ),
    );
  }
}
