import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white.withOpacity(0.9),
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.restaurant), label: 'Food'),
          BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Events'),
          BottomNavigationBarItem(icon: Icon(Icons.location_on), label: 'Map'),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top Section with Background Image and Overlays
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.5,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/JFB-27.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 20,
                  left: 20,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 25,
                    child: Icon(Icons.language, color: Colors.black),
                  ),
                ),
                Positioned(
                  top: 20,
                  right: 20,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 25,
                    child: Icon(Icons.translate, color: Colors.black),
                  ),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Event Cards
                      _buildEventCard("Kitano Gagaku E...", "Stage 1", "11:30-12:00", true),
                      _buildEventCard("JAL Advertising", "Stage 2", "11:30-11:40", true),
                      
                      SizedBox(height: 20),

                      // Sponsors Section
                      _buildSponsorSection(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Event Card Widget
  Widget _buildEventCard(String title, String stage, String time, bool ongoing) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.mic, color: Colors.black),
                SizedBox(width: 10),
                Text(stage, style: TextStyle(color: Colors.pinkAccent, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 5),
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(time, style: TextStyle(color: Colors.grey)),
            if (ongoing)
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text("Going on now!", style: TextStyle(color: Colors.white)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Sponsor Section Widget
  Widget _buildSponsorSection() {
    List<String> sponsors = [
      "Takeda", "Japan Airlines", "Meet Boston", "Sanipak",
      "Chop Value", "Mitsubishi Corporation", "Senko", "Open Water"
    ];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Sponsors", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3.5,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: sponsors.length,
          itemBuilder: (context, index) {
            return Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 3)],
              ),
              child: Center(child: Text(sponsors[index], style: TextStyle(fontSize: 16))),
            );
          },
        ),
      ],
    );
  }
}
