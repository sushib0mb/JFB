import 'package:flutter/material.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  MapPageState createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  bool _isMiniWindowVisible = false;
  String _selectedFilter = '';
  String _currentMap = 'assets/MapNew.png';
  final TransformationController _transformationController =
      TransformationController();
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
        _currentMap = 'assets/MapNew.png';
      } else {
        _selectedFilter = filter;
        _currentMap = mapImages[filter] ?? 'assets/MapNew.png';
      }
      _isMiniWindowVisible = false;
    });
  }

  void _onLetterTap(String letter) {
    print('Letter $letter tapped');
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    // Filter button should be highlighted if a filter is selected, but not "All"
    final bool isFilterActive =
        _selectedFilter.isNotEmpty && _selectedFilter != 'All';

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0, top: 12.0),
            child: GestureDetector(
              onTap: _toggleMiniWindow,
              child: AnimatedContainer(
                duration: _animationDuration,
                width: 75,
                height: 75,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      _isMiniWindowVisible || isFilterActive
                          ? Colors.grey.shade300
                          : Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                  border: Border.all(color: Colors.black26),
                ),
                padding: EdgeInsets.all(8),
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
      body: Stack(
        children: [
          // Background Gradient with lighter colors
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromRGBO(10, 56, 117, 0.15),
                  const Color.fromRGBO(191, 28, 36, 0.15),
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
              child: Stack(
                children: [
                  // Map base
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: InteractiveViewer(
                      transformationController: _transformationController,
                      minScale: 1.0,
                      maxScale: 5.0,
                      child: Image.asset(_currentMap, fit: BoxFit.contain),
                    ),
                  ),

                  // Only show food vendor markers when 'Food Vendors' filter is selected
                  if (_selectedFilter == 'Food Vendors') ...[
                    Positioned(
                      top: 30,
                      right: 145,
                      child: _buildImageMarker(
                        'MapButtonA.png',
                        'A',
                        width: 68,
                        height: 68,
                      ),
                    ),
                    Positioned(
                      bottom: 382,
                      left: 26,
                      child: _buildImageMarker(
                        'MapButtonB.png',
                        'B',
                        width: 50,
                        height: 50,
                      ),
                    ),
                    Positioned(
                      bottom: 266,
                      left: 25,
                      child: _buildImageMarker(
                        'MapButtonC.png',
                        'C',
                        width: 50,
                        height: 50,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Fullscreen expanding mini window
          Positioned(
            top: _isMiniWindowVisible ? -20 : 10, // Lifted up more by -20
            left: _isMiniWindowVisible ? 0 : screenSize.width * 0.75,
            right: _isMiniWindowVisible ? 0 : screenSize.width * 0.75,
            bottom: 40, // Keep the bottom unchanged
            child: AnimatedOpacity(
              duration: _animationDuration,
              opacity: _isMiniWindowVisible ? 1 : 0,
              child:
                  _isMiniWindowVisible
                      ? GestureDetector(
                        onTap: _toggleMiniWindow,
                        child: Container(
                          color: Colors.black.withOpacity(0.4),
                          child: Center(
                            child: Container(
                              width: screenSize.width * 0.9,
                              height:
                                  screenSize.height *
                                  0.8, // Adjust the height as needed
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
                                  _buildFilterButton(
                                    'All',
                                    screenSize,
                                  ), // Added "All" button
                                  _buildFilterButton(
                                    'Food Vendors',
                                    screenSize,
                                  ),
                                  _buildFilterButton(
                                    'Information Center',
                                    screenSize,
                                  ),
                                  _buildFilterButton('Toilets', screenSize),
                                  _buildFilterButton(
                                    'Trash Station',
                                    screenSize,
                                  ),
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

  Widget _buildImageMarker(
    String imageName,
    String letter, {
    double width = 40,
    double height = 40,
  }) {
    return GestureDetector(
      onTap: () => _onLetterTap(letter),
      child: Container(
        width: width,
        height: height,
        child: Image.asset('assets/$imageName', fit: BoxFit.contain),
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
