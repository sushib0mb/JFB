import 'package:flutter/material.dart';
import 'package:jfbfestival/main.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  MapPageState createState() => MapPageState();
}

class MapPageState extends State<MapPage> with SingleTickerProviderStateMixin {
  bool _isMiniWindowVisible = false;
  String _selectedFilter = 'All';
  final Duration _animationDuration = const Duration(milliseconds: 300);
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  String _currentMapImage = 'assets/MapNew.png';

  final Map<String, String> mapImages = {
    'All': 'assets/MapNew.png',
    'Food Vendors': 'assets/MapNew4.png',
    'Information Center': 'assets/MapNew3.png',
    'Toilets': 'assets/MapNew1.png',
    'Trash Station': 'assets/MapNew2.png',
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: _animationDuration,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleMiniWindow() {
    setState(() {
      _isMiniWindowVisible = !_isMiniWindowVisible;
      if (_isMiniWindowVisible) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _selectFilter(String filter) {
    setState(() {
      if (_selectedFilter == filter) {
        _selectedFilter = 'All';
      } else {
        _selectedFilter = filter;
      }
      _isMiniWindowVisible = false;
      _animationController.reverse();
      _currentMapImage = mapImages[_selectedFilter] ?? mapImages['All']!;
    });
  }

  void _onLetterTap(String letter) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            MainScreen(initialIndex: 1, selectedMapLetter: letter),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var fadeTween = Tween(begin: 0.0, end: 1.0)
              .chain(CurveTween(curve: Curves.easeInOut));
          return FadeTransition(
            opacity: animation.drive(fadeTween),
            child: child,
          );
        },
        transitionDuration: _animationDuration,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isTablet = screenSize.width >= 600;
    final bool isFilterActive = _selectedFilter != 'All';
    final String targetMapImage = mapImages[_selectedFilter] ?? mapImages['All']!;

    // Adaptive dimensions
    final double mapWidth = isTablet ? screenSize.width * 0.6 : screenSize.width * 0.85;
    final double mapHeight = isTablet ? screenSize.height * 0.7 : screenSize.height * 0.65;
    final double miniWidth = isTablet ? screenSize.width * 0.5 : screenSize.width * 0.75;
    final double miniHeight = isTablet ? screenSize.height * 0.6 : screenSize.height * 0.65;
    final double filterBtnFont = isTablet ? 24 : 22;
    final double letterBtnWidth = isTablet ? 100 : 80;
    final double letterBtnHeight = isTablet ? 45 : 35;
    final double letterFont = isTablet ? 20 : 18;

    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
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

          // Map with cross-fade
          Center(
            child: AnimatedCrossFade(
              firstChild: _buildMapContainer(
                screenSize, mapWidth, mapHeight,
                _currentMapImage, isTablet,
                letterBtnWidth, letterBtnHeight, letterFont
              ),
              secondChild: _buildMapContainer(
                screenSize, mapWidth, mapHeight,
                targetMapImage, isTablet,
                letterBtnWidth, letterBtnHeight, letterFont
              ),
              crossFadeState: _currentMapImage == targetMapImage
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: _animationDuration,
            ),
          ),

          // Mini window overlay
          if (_isMiniWindowVisible)
            Positioned.fill(
              child: GestureDetector(
                onTap: _toggleMiniWindow,
                child: AnimatedContainer(
                  duration: _animationDuration,
                  color: Colors.black.withOpacity(0.4),
                ),
              ),
            ),

          // Sliding filter menu
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: IgnorePointer(
              ignoring: !_isMiniWindowVisible,
              child: Align(
                alignment: Alignment.topCenter,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Container(
                    width: miniWidth,
                    height: miniHeight,
                    margin: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + screenSize.height * 0.1,
                    ),
                    padding: const EdgeInsets.all(24),
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
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: _toggleMiniWindow,
                            ),
                          ),
                          _buildFilterButton('All', miniWidth, filterBtnFont, isTablet),
                          _buildFilterButton('Food Vendors', miniWidth, filterBtnFont, isTablet),
                          _buildFilterButton('Information Center', miniWidth, filterBtnFont, isTablet),
                          _buildFilterButton('Toilets', miniWidth, filterBtnFont, isTablet),
                          _buildFilterButton('Trash Station', miniWidth, filterBtnFont, isTablet),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Filter icon
          Positioned(
            top: MediaQuery.of(context).padding.top + screenSize.height * 0.015,
            right: screenSize.width * 0.05,
            child: GestureDetector(
              onTap: _toggleMiniWindow,
              child: AnimatedContainer(
                duration: _animationDuration,
                width: isTablet ? 65 : 55,
                height: isTablet ? 65 : 55,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                  color: _isMiniWindowVisible || isFilterActive
                      ? Colors.grey.shade300
                      : Colors.white,
                ),
                padding: const EdgeInsets.all(10),
                child: ClipOval(
                  child: Image.asset(
                    'assets/Filter.png',
                    fit: BoxFit.contain,
                    color: _isMiniWindowVisible || isFilterActive ? Colors.black : null,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapContainer(
    Size screenSize,
    double width,
    double height,
    String imagePath,
    bool isTablet,
    double letterBtnWidth,
    double letterBtnHeight,
    double letterFont,
  ) {
    return Container(
      width: width,
      height: height,
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
      padding: const EdgeInsets.all(10),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              imagePath,
              fit: BoxFit.contain,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          if (_selectedFilter != 'Information Center' &&
              _selectedFilter != 'Toilets' &&
              _selectedFilter != 'Trash Station')
            Positioned(
              bottom: _selectedFilter == 'Food Vendors' ? 5 : 3,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildLetterButton('A', Colors.red, letterBtnWidth, letterBtnHeight, letterFont),
                  _buildLetterButton('B', Colors.blue, letterBtnWidth, letterBtnHeight, letterFont),
                  _buildLetterButton('C', Colors.green, letterBtnWidth, letterBtnHeight, letterFont),
                ],
              ),
          ),
        ],
      ),
    );
  }

  Widget _buildLetterButton(
    String letter,
    Color color,
    double width,
    double height,
    double fontSize,
  ) {
    return GestureDetector(
      onTap: () => _onLetterTap(letter),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            letter,
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButton(
    String label,
    double width,
    double fontSize,
    bool isTablet,
  ) {
    bool isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () => _selectFilter(label),
      child: Container(
        width: width,
        padding: EdgeInsets.symmetric(vertical: isTablet ? 24 : 20),
        margin: EdgeInsets.symmetric(vertical: isTablet ? 14 : 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.grey.shade400 : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.black : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}
