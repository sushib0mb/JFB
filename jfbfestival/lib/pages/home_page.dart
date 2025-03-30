import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // First section: Logo in SliverAppBar
          SliverAppBar(
            pinned: true, // Keeps the logo pinned at the top
            expandedHeight: 150, // Adjusted height for the expanded logo
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: CircleAvatar(
                    radius: 50.0, // Smaller logo size
                    backgroundImage: AssetImage('assets/JFBLogo.png'),
                  ),
                ),
              ),
            ),
          ),

          // Divider between sections
          SliverToBoxAdapter(child: Divider(thickness: 5, color: Colors.black)),

          // Second section: Information
          SliverToBoxAdapter(
            child: InkWell(
              onTap: () {
                // Action for when the Information section is tapped
                print("Information tapped");
              },
              child: Container(
                margin: EdgeInsets.all(
                  10.0,
                ), // Adding margin to space out sections
                padding: const EdgeInsets.symmetric(
                  vertical: 100.0,
                  horizontal: 20.0,
                ), // Increased vertical padding for larger sections
                decoration: BoxDecoration(
                  color: Colors.red[200], // Light red background
                  borderRadius: BorderRadius.circular(15.0), // Rounded corners
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: Offset(0, 4), // Shadow direction
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'Information',
                    style: TextStyle(
                      fontSize: 50.0, // Increased font size for emphasis
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Divider between sections
          SliverToBoxAdapter(child: Divider(thickness: 5, color: Colors.black)),

          // Third section: SNS
          SliverToBoxAdapter(
            child: InkWell(
              onTap: () {
                // Action for when the SNS section is tapped
                print("SNS tapped");
              },
              child: Container(
                margin: EdgeInsets.all(
                  10.0,
                ), // Adding margin to space out sections
                padding: const EdgeInsets.symmetric(
                  vertical: 100.0,
                  horizontal: 20.0,
                ), // Increased vertical padding for larger sections
                decoration: BoxDecoration(
                  color: Colors.green[200], // Light green background
                  borderRadius: BorderRadius.circular(15.0), // Rounded corners
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: Offset(0, 4), // Shadow direction
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'SNS',
                    style: TextStyle(
                      fontSize: 50.0, // Increased font size for emphasis
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Divider between sections
          SliverToBoxAdapter(child: Divider(thickness: 5, color: Colors.black)),

          // Fourth section: Sponsors
          SliverToBoxAdapter(
            child: InkWell(
              onTap: () {
                // Action for when the Sponsors section is tapped
                print("Sponsors tapped");
              },
              child: Container(
                margin: EdgeInsets.all(
                  10.0,
                ), // Adding margin to space out sections
                padding: const EdgeInsets.symmetric(
                  vertical: 100.0,
                  horizontal: 20.0,
                ), // Increased vertical padding for larger sections
                decoration: BoxDecoration(
                  color: Colors.blue[200], // Light blue background
                  borderRadius: BorderRadius.circular(15.0), // Rounded corners
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: Offset(0, 4), // Shadow direction
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'Sponsors',
                    style: TextStyle(
                      fontSize: 50.0, // Increased font size for emphasis
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
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
