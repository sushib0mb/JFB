import 'package:flutter/material.dart';
import 'package:jfbfestival/mainscreen.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  MapPageState createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  bool _isMiniWindowVisible = false;
  String _selectedFilter = '';

  final Duration _animationDuration = Duration(milliseconds: 300);

  final Map<String, String> mapImages = {
    'All': 'assets/MapNew.png',
    'Food Vendors': 'assets/MapNew4.png',
    'Information Center': 'assets/MapNew3.png',
    'Toilets': 'assets/MapNew1.png',
    'Trash Station': 'assets/MapNew2.png',
  };

  void _toggleMiniWindow() {
    setState(() {
      _isMiniWindowVisible = !_isMiniWindowVisible;
    });
  }

  void _selectFilter(String filter) {
    setState(() {
      if (_selectedFilter == filter) {
        _selectedFilter = '';
      } else {
        _selectedFilter = filter;
      }
      _isMiniWindowVisible = false;
    });
  }

  void _onLetterTap(String letter) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => MainScreen(
              initialIndex: 1, // Go to FoodPage
              selectedMapLetter: letter,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isFilterActive =
        _selectedFilter.isNotEmpty && _selectedFilter != 'All';

    final String mapImage =
        mapImages[_selectedFilter.isNotEmpty ? _selectedFilter : 'All'] ??
        mapImages['All']!;

    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(10, 56, 117, 0.15),
                  Color.fromRGBO(191, 28, 36, 0.15),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Centered map container
          Center(
            child: Container(
              width: screenSize.width * 0.85,
              height: screenSize.height * 0.65,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              padding: EdgeInsets.all(10),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      mapImage,
                      fit: BoxFit.contain,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),

                  // A, B, C buttons when filter is active
                  if (_selectedFilter == 'Food Vendors')
                    Positioned(
                      bottom: 7,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildLetterButton('A', Colors.red),
                          _buildLetterButton('B', Colors.blue),
                          _buildLetterButton('C', Colors.green),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Mini window overlay
          Positioned.fill(
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 300),
              opacity: _isMiniWindowVisible ? 1 : 0,
              child: IgnorePointer(
                ignoring: !_isMiniWindowVisible,
                child: GestureDetector(
                  onTap: _toggleMiniWindow,
                  child: Container(
                    color: Colors.black.withOpacity(0.4),
                    child: Center(
                      child: Container(
                        width: screenSize.width * 0.9,
                        height: screenSize.height * 0.65,
                        padding: EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 12,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildFilterButton('All', screenSize),
                            _buildFilterButton('Food Vendors', screenSize),
                            _buildFilterButton(
                              'Information Center',
                              screenSize,
                            ),
                            _buildFilterButton('Toilets', screenSize),
                            _buildFilterButton('Trash Station', screenSize),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            top:
                MediaQuery.of(context).padding.top +
                MediaQuery.of(context).size.height * 0.015,
            right: MediaQuery.of(context).size.width * 0.05,
            child: GestureDetector(
              onTap: _toggleMiniWindow,
              child: AnimatedContainer(
                duration: _animationDuration,
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                  color:
                      _isMiniWindowVisible || isFilterActive
                          ? Colors.grey.shade300
                          : Colors.white,
                ),
                padding: EdgeInsets.all(10),
                child: ClipOval(
                  child: Image.asset(
                    'assets/Filter.png',
                    fit: BoxFit.contain,
                    color:
                        _isMiniWindowVisible || isFilterActive
                            ? Colors.black
                            : null,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLetterButton(String letter, Color color) {
    return GestureDetector(
      onTap: () => _onLetterTap(letter),
      child: Container(
        width: 80,
        height: 50,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            letter,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButton(String label, Size screenSize) {
    bool isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () => _selectFilter(label),
      child: Container(
        width: screenSize.width * 0.75,
        padding: EdgeInsets.symmetric(vertical: 20),
        margin: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.grey.shade400 : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.black : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}
