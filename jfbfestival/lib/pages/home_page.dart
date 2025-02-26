import 'package:flutter/material.dart';

class HomePage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // First section: Logo in SliverAppBar
          SliverAppBar(
            pinned: true, // Makes the logo stay at the top
            expandedHeight: 250.0, // Height when expanded
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: const EdgeInsets.all(20.0),
                child: CircleAvatar(
                  radius: 80.0,
                  backgroundImage: AssetImage('assets/JFBLogo.png'),
                ),
              ),
            ),
          ),
          
          // Divider between sections
          SliverToBoxAdapter(
            child: Divider(thickness: 5, color: Colors.black),
          ),

          // Second section: Information
          SliverToBoxAdapter(
            child: Container(
              color: Colors.red[100], // Light red background
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Text(
                  'Information',
                  style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          
          // Divider between sections
          SliverToBoxAdapter(
            child: Divider(thickness: 5, color: Colors.black),
          ),

          // Third section: SNS
          SliverToBoxAdapter(
            child: Container(
              color: Colors.green[100], // Light green background
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Text(
                  'SNS',
                  style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),

          // Divider between sections
          SliverToBoxAdapter(
            child: Divider(thickness: 5, color: Colors.black),
          ),

          // Fourth section: Sponsors
          SliverToBoxAdapter(
            child: Container(
              color: Colors.blue[100], // Light blue background
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Text(
                  'Sponsors',
                  style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
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
