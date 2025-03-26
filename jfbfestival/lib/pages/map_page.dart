import 'package:flutter/material.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  String _currentMap = 'assets/map.png'; 
  bool _isMiniWindowVisible = false; 
  void _changeMap(String newMap) {
    setState(() {
      _currentMap = newMap;
      _isMiniWindowVisible = false; 
    });
  }

  void _toggleMiniWindow() {
    setState(() {
      _isMiniWindowVisible = !_isMiniWindowVisible;
    });
  }

  void _hideMiniWindow() {
    setState(() {
      _isMiniWindowVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Image.asset('assets/Filter.png', width: 35, height: 35),
            onPressed: _toggleMiniWindow,
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: Image.asset(_currentMap),
          ),


          if (_isMiniWindowVisible)
            GestureDetector(
              onTap: _hideMiniWindow, 
              behavior: HitTestBehavior.opaque, 
              child: Container(
                color: Colors.black.withOpacity(0.3), 
                child: Center(
                  child: GestureDetector(
                    onTap: () {}, 
                    child: Container(
                      width: 300,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Services',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () => _changeMap(
                                _currentMap == 'assets/map1.png' ? 'assets/map.png' : 'assets/map1.png'),
                            child: Text(_currentMap == 'assets/map1.png'
                                ? 'Back to Original Map'
                                : 'Lost and Found'),
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () => _changeMap(
                                _currentMap == 'assets/map3.png' ? 'assets/map.png' : 'assets/map3.png'),
                            child: Text(_currentMap == 'assets/map3.png'
                                ? 'Back to Original Map'
                                : 'Help Center'),
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () => _changeMap(
                                _currentMap == 'assets/map2.png' ? 'assets/map.png' : 'assets/map2.png'),
                            child: Text(_currentMap == 'assets/map2.png'
                                ? 'Back to Original Map'
                                : 'Toilet'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
