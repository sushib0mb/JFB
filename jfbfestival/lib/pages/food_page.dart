import 'package:flutter/material.dart';
import 'package:jfbfestival/data/food_booths.dart';  // Import the foodBooths data

class FoodPage extends StatefulWidget {
  @override
  _FoodPageState createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  List<Map<String, dynamic>> filteredBooths = foodBooths;  // Use the imported foodBooths data
  final TextEditingController _searchController = TextEditingController();
  double _minPrice = 0;
  double _maxPrice = 20;
  bool _isAlphabetical = false;
  List<String> _selectedFoodTypes = [];
  bool _isVegan = false;
  bool _isAllergicFriendly = false;

  // Function to filter booths based on search query, letter, and additional filters
  void _filterSearch(String query) {
    setState(() {
      filteredBooths = foodBooths
          .where((booth) {
            bool matchesQuery = booth['name'].toLowerCase().contains(query.toLowerCase());
            bool matchesPrice = booth['menu'].any((item) {
              double itemPrice = double.tryParse(item['price'].toString()) ?? 0;  // Convert price to double
              return itemPrice >= _minPrice && itemPrice <= _maxPrice;
            });
            bool matchesFoodType = _selectedFoodTypes.isEmpty || _selectedFoodTypes.contains(booth['cuisine']);
            bool matchesVegan = !_isVegan || booth['tags'].contains('Vegan');
            bool matchesAllergicFriendly = !_isAllergicFriendly || booth['tags'].contains('Allergy-Friendly');

            return matchesQuery && matchesPrice && matchesFoodType && matchesVegan && matchesAllergicFriendly;
          })
          .toList();

      // Apply alphabetical sorting if enabled
      if (_isAlphabetical) {
        filteredBooths.sort((a, b) => a['name'].compareTo(b['name']));
      }
    });
  }

  // Toggles between alphabetical sorting
  void _toggleSorting() {
    setState(() {
      _isAlphabetical = !_isAlphabetical;
      _filterSearch(_searchController.text);  // Reapply filters after sorting change
    });
  }

  // Opens the filter menu to select food types, vegan, and allergy-friendly options
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
                  // Price Range Slider
                  Text("Price Range: \$${_minPrice.toStringAsFixed(0)} - \$${_maxPrice.toStringAsFixed(0)}"),
                  RangeSlider(
                    min: 0,
                    max: 50,
                    values: RangeValues(_minPrice, _maxPrice),
                    onChanged: (RangeValues values) {
                      setStateDialog(() {
                        _minPrice = values.start;
                        _maxPrice = values.end;
                      });
                      _filterSearch(_searchController.text);  // Apply filter on slider change
                    },
                  ),
                  // Food Type Checkboxes
                  ...['Japanese', 'Korean', 'Chinese', 'American'].map((foodType) {
                    return CheckboxListTile(
                      title: Text(foodType),
                      value: _selectedFoodTypes.contains(foodType),
                      onChanged: (bool? newValue) {
                        setStateDialog(() {
                          if (newValue == true) {
                            _selectedFoodTypes.add(foodType);
                          } else {
                            _selectedFoodTypes.remove(foodType);
                          }
                        });
                        _filterSearch(_searchController.text);  // Apply filter on food type change
                      },
                    );
                  }).toList(),
                  // Vegan and Allergy-Friendly Checkboxes
                  CheckboxListTile(
                    title: Text("Vegan"),
                    value: _isVegan,
                    onChanged: (bool? newValue) {
                      setStateDialog(() {
                        _isVegan = newValue!;
                      });
                      _filterSearch(_searchController.text);  // Apply filter on vegan change
                    },
                  ),
                  CheckboxListTile(
                    title: Text("Allergy-Friendly"),
                    value: _isAllergicFriendly,
                    onChanged: (bool? newValue) {
                      setStateDialog(() {
                        _isAllergicFriendly = newValue!;
                      });
                      _filterSearch(_searchController.text);  // Apply filter on allergy-friendly change
                    },
                  ),
                  // Clear all filters button
                  ListTile(
                    title: Text("Clear All Filters", style: TextStyle(color: Colors.red)),
                    onTap: () {
                      setStateDialog(() {
                        _minPrice = 0;
                        _maxPrice = 20;
                        _selectedFoodTypes.clear();
                        _isVegan = false;
                        _isAllergicFriendly = false;
                      });
                      _filterSearch(_searchController.text);  // Apply filters after reset
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Food Booths"),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Text(
              _isAlphabetical ? "A-Z" : "Sort",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: _toggleSorting,
          ),
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () => _openFilterMenu(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar for filtering booths
          Padding(
            padding: const EdgeInsets.all(10.0),
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
          // Displaying the filtered list of booths
          Expanded(
            child: ListView.builder(
              itemCount: filteredBooths.length,
              itemBuilder: (context, index) {
                final booth = filteredBooths[index];
                return Card(
                  color: Colors.amber.shade100,
                  margin: EdgeInsets.all(8),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        booth['image'],
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(booth['name'], style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("${booth['location']} - ${booth['info']}"),
                    trailing: Icon(Icons.arrow_forward_ios),
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
        ],
      ),
    );
  }
}

class BoothDetailsPage extends StatelessWidget {
  final Map<String, dynamic> booth;

  BoothDetailsPage(this.booth);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(booth['name']), backgroundColor: Colors.orangeAccent),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              booth['image'],
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(booth['name'], style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text("Location: ${booth['location']}", style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Text(booth['info'], style: TextStyle(fontSize: 16)),
                  SizedBox(height: 16),
                  Text("Menu", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  // Menu items grid view
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: booth['menu'].length,
                    itemBuilder: (context, index) {
                      final item = booth['menu'][index];
                      return Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                              child: Image.asset(
                                item['image'],
                                height: 100,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    item['item'],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    item['price'],
                                    style: TextStyle(fontSize: 14, color: Colors.teal),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
