import 'package:flutter/material.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  bool Window = false; 

  void InfoWindow() {
    setState(() {
      Window = !Window;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map Page'),
        actions: [
          // Button to show/hide the info window
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: InfoWindow,
          ),
        ],
      ),
      body: Stack(
        children: [
          // Main map view (still centered)
          Center(
            child: Image.asset(
              'assets/map.png',
              width: 400,
              height: 400,
              fit: BoxFit.cover,
            ),
          ),
          
          
          if (Window)
            Positioned.fill(  // This makes the info window take up most of the screen
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: InfoWindow, // Close the info window when tapped
                child: Material(
                  color: Colors.white.withOpacity(0.8), // Slight transparency for overlay
                  elevation: 8,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Map Information',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.close),
                              onPressed: InfoWindow, 
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Text(
                              'Put Something here\n',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
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
