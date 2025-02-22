import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food App',
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    HomePage(),
    FoodPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.teal,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.restaurant), label: 'Food'),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Welcome to the Home Page')),
    );
  }
}

class FoodPage extends StatefulWidget {
  @override
  _FoodPageState createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  List<Map<String, String>> foodBooths = [];
  List<Map<String, String>> filteredBooths = [];
  List<String> selectedFilters = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(parent: _animationController, curve: Curves.easeIn);

    loadBooths().then((data) {
      setState(() {
        foodBooths = data;
        filteredBooths = data;
      });
      _animationController.forward();
    });
  }

  Future<List<Map<String, String>>> loadBooths() async {
    String jsonString = await rootBundle.loadString('assets/food_booths.json');
    List<dynamic> jsonResponse = json.decode(jsonString);
    return jsonResponse.map((item) => Map<String, String>.from(item)).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _filterSearch(String query) {
    setState(() {
      filteredBooths = foodBooths
          .where((booth) => booth['name']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
      _animationController.forward(from: 0);
    });
  }

  void _openFilterMenu(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text("Select Filters"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...['Downtown', 'Midtown', 'Uptown'].map((location) => CheckboxListTile(
                        title: Text(location),
                        value: selectedFilters.contains(location),
                        activeColor: Colors.teal,
                        onChanged: (bool? newValue) {
                          setStateDialog(() {
                            if (newValue == true) {
                              selectedFilters.add(location);
                            } else {
                              selectedFilters.remove(location);
                            }
                          });
                          setState(() => _applyFilters());
                        },
                      )),
                  ListTile(
                    title: Text("Clear All Filters", style: TextStyle(color: Colors.red)),
                    onTap: () {
                      setStateDialog(() => selectedFilters.clear());
                      setState(() => _applyFilters());
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _applyFilters() {
    setState(() {
      if (selectedFilters.isEmpty) {
        filteredBooths = foodBooths;
      } else {
        filteredBooths = foodBooths
            .where((booth) => selectedFilters.contains(booth['location']))
            .toList();
      }
      _animationController.forward(from: 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text("Food Search"),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () => _openFilterMenu(context),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade100, Colors.teal.shade700],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                onChanged: _filterSearch,
                decoration: InputDecoration(
                  hintText: "Search for a food booth...",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ListView.builder(
                  itemCount: filteredBooths.length,
                  itemBuilder: (context, index) {
                    final booth = filteredBooths[index];
                    return Card(
                      color: Colors.amber.shade100,
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            booth['image']!,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image),
                          ),
                        ),
                        title: Text(booth['name']!, style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text("${booth['location']} - ${booth['info']}"),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => BoothDetailsPage(booth)),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BoothDetailsPage extends StatelessWidget {
  final Map<String, String> booth;

  BoothDetailsPage(this.booth);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(booth['name']!), backgroundColor: Colors.teal),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              booth['image']!,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image, size: 200),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(booth['name']!, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text("Location: ${booth['location']}", style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Text(booth['info']!, style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
