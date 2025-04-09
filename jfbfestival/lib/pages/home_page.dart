import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 600;

        return Scaffold(
          backgroundColor: Color(0xFFFFF5F5),
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: screenHeight * 0.6,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/JFB-27.jpg"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: screenHeight * 0.05,
                          right: screenWidth * 0.05,
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 5,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Image.asset(
                                "assets/langChange.png",
                                height: isSmallScreen ? 40 : 50,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    _buildEventSection(screenWidth, isSmallScreen),
                    _buildSocialMediaIcons(screenWidth),
                    _buildSponsorsSection(screenWidth),
                    SizedBox(height: screenHeight * 0.3),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSocialMediaIcons(double screenWidth) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 2),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildIcon("assets/instagram.png"),
          _buildIcon("assets/facebook.png"),
          _buildIcon("assets/youtube.png"),
          _buildIcon("assets/website.png"),
        ],
      ),
    );
  }

  Widget _buildEventSection(double screenWidth, bool isSmallScreen) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildEventCard(
            "Kitanodai Gagaku E...",
            "Stage 1",
            "11:30-12:00",
            true,
            true,
            false,
            screenWidth,
          ),
          _buildEventCard(
            "JAL Advertising",
            "Stage 2",
            "11:30-11:40",
            true,
            false,
            true,
            screenWidth,
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(
    String title,
    String stage,
    String time,
    bool ongoing,
    bool isSinging,
    bool isAdvertising,
    double screenWidth,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
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
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.mic, color: Colors.black),
                    SizedBox(width: 10),
                    Text(
                      stage,
                      style: TextStyle(
                        color: Colors.pinkAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
                      child: Text(
                        "Going on now!",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (isSinging)
            Positioned(
              top: -35,
              left: 10,
              child: Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Image.asset(
                  "assets/timetableIcons/Singing performance (Frame).png",
                  height: screenWidth * 0.18,
                ),
              ),
            ),
          if (isAdvertising)
            Positioned(
              top: -35,
              left: 10,
              child: Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Image.asset(
                  "assets/timetableIcons/Advertising (Frame).png",
                  height: screenWidth * 0.18,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSponsorsSection(double screenWidth) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 2),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildSponsorCategory("Sustainability", "assets/Takeda.jpg"),
          _buildSponsorCategory("Airline", "assets/jal.jpg"),
          _buildCorporateSponsors(),
          _buildJfbOrganizers(),
        ],
      ),
    );
  }

  Widget _buildSponsorCategory(String title, String imagePath) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          margin: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            title,
            style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
          ),
        ),
        Image.asset(imagePath, height: 50),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildCorporateSponsors() {
    List<String> corporateLogos = [
      "assets/sanipak.png",
      "assets/chopvalue.png",
      "assets/openwater.png",
      "assets/mitsubishi.jpg",
      "assets/SDT.jpg",
      "assets/senko.png",
      "assets/yamamoto.jpg",
    ];

    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          margin: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            "Corporate",
            style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
          ),
        ),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 20,
          runSpacing: 10,
          children:
              corporateLogos
                  .map((logo) => Image.asset(logo, height: 50))
                  .toList(),
        ),
      ],
    );
  }

  Widget _buildJfbOrganizers() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          margin: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            "JFB Organizers",
            style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
          ),
        ),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 20,
          runSpacing: 10,
          children: [
            Image.asset("assets/showa.jpg", height: 50),
            Column(
              children: [
                Image.asset("assets/bosJapan.png", height: 50),
                SizedBox(height: 4),
                Text("Boston Japan", style: TextStyle(fontSize: 12)),
                Text("Community Hub", style: TextStyle(fontSize: 12)),
              ],
            ),
            Image.asset("assets/JAGB.jpg", height: 50),
          ],
        ),
      ],
    );
  }

  Widget _buildIcon(String imagePath) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 2),
        ],
      ),
      child: Image.asset(imagePath, height: 30),
    );
  }
}
