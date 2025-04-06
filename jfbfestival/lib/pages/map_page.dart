import 'package:flutter/material.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  MapPageState createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  bool _isMiniWindowVisible = false;
  String _selectedFilter = '';
  String _currentMap = 'assets/map.png';
  final TransformationController _transformationController = TransformationController();
  final Duration _animationDuration = Duration(milliseconds: 300);

  final Map<String, String> mapImages = {
    'Food Vendors': 'assets/map1.png',
    'Help Center': 'assets/map2.png',
    'Restrooms': 'assets/map3.png',
    'Others': 'assets/map4.png',
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
        _currentMap = 'assets/map.png';
      } else {
        _selectedFilter = filter;
        _currentMap = mapImages[filter] ?? 'assets/map.png';
      }
      _isMiniWindowVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Image.asset(
          'assets/JFBLogo.png',
          height: 80,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 30.0),
            child: GestureDetector(
              onTap: _toggleMiniWindow,
              child: AnimatedContainer(
                duration: _animationDuration,
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isMiniWindowVisible ? Colors.grey.shade300 : Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                  border: Border.all(
                    color: Colors.black26,
                  ),
                ),
                padding: EdgeInsets.all(10),
                child: ClipOval(
                  child: Image.asset(
                    'assets/Filter.png',
                    fit: BoxFit.contain,
                    color: _isMiniWindowVisible ? Colors.black : null,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.lightBlue.shade100,
                  Colors.red.shade100,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Map Viewer with pinch-to-zoom (InteractiveViewer)
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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: InteractiveViewer(
                  transformationController: _transformationController,
                  minScale: 1.0, // Minimum scale factor (no zoom out smaller than original size)
                  maxScale: 5.0, // Maximum zoom level (can be adjusted as needed)
                  child: Image.asset(
                    _currentMap,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),

          // Fullscreen expanding mini window
          Positioned(
            top: _isMiniWindowVisible ? 0 : 40,
            left: _isMiniWindowVisible ? 0 : screenSize.width * 0.75,
            right: _isMiniWindowVisible ? 0 : screenSize.width * 0.75,
            bottom: _isMiniWindowVisible ? 0 : 40,
            child: AnimatedOpacity(
              duration: _animationDuration,
              opacity: _isMiniWindowVisible ? 1 : 0,
              child: _isMiniWindowVisible
                  ? GestureDetector(
                      onTap: _toggleMiniWindow,
                      child: Container(
                        color: Colors.black.withOpacity(0.4),
                        child: Center(
                          child: Container(
                            width: screenSize.width * 0.9,
                            height: screenSize.height * 0.9,
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
                                _buildFilterButton('Food Vendors', screenSize),
                                _buildFilterButton('Help Center', screenSize),
                                _buildFilterButton('Restrooms', screenSize),
                                _buildFilterButton('Others', screenSize),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
            ),
          ),
        ],
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
