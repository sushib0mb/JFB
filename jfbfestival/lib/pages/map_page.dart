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
                      color: Colors.black.withOpacity(0.07),
                      blurRadius: 12,
                      offset: Offset(0, 6),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _transformationController.value = Matrix4.identity();
        },
        backgroundColor: Colors.white,
        child: Icon(Icons.center_focus_strong, color: Colors.black),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromARGB(255, 204, 233, 245),
                  const Color.fromARGB(255, 246, 221, 221),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 130),
                Center(
                  child: Text(
                    "Festival Grounds Map",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: InteractiveViewer(
                      transformationController: _transformationController,
                      minScale: 1.0,
                      maxScale: 5.0,
                      child: AspectRatio(
                        aspectRatio: 1.3,
                        child: Image.asset(
                          _currentMap,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: ExpansionTile(
                    title: Text("Legend", style: TextStyle(fontWeight: FontWeight.bold)),
                    children: const [
                      ListTile(title: Text("🟩 Portable Toilets")),
                      ListTile(title: Text("🟨 Light Poles")),
                      ListTile(title: Text("⬛ Entrances?")),
                    ],
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
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
                            height: screenSize.height * 0.6,
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