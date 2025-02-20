import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:jfbfestival/pages/food_page.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
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
        home: HomePage(),
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

  // TODO(all): "link to your page here"
  static List<Widget> widgetOptions = <Widget>[
    Placeholder(),
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
        selectedItemColor: const Color.fromARGB(255, 67, 67, 225),
        onTap: _onItemTapped,
      ),
    );
  }
}
