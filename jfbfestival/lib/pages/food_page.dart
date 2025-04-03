import 'package:flutter/material.dart';
import 'dart:ui';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Vendors',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const FoodPage(),
    );
  }
}

class FoodPage extends StatelessWidget {
  const FoodPage({super.key});

  final List<FoodBooth> booths = const [
    // FoodBooth(
    //   "Wakazo Gyoza",
    //   "D7",
    //   "Food Genre",
    //   "assets/miraku_boston.png",
    //   "assets/JFB-19.png",
    //   true,
    //   ["Cash", "Venmo", "Zelle", "PayPal"],
    //   ["Egg", "Wheat", "Peanut", "Milk", "Soy", "Tree Nut", "Fish", "Shellfish", "Sesame"],
    // ),
    // FoodBooth(
    //   "McDonald's",
    //   "M1",
    //   "Fast Food",
    //   "assets/mcdonald-s-golden-arches-svg-1.png",
    //   "assets/JFB-19.png",
    //   false,
    //   ["Cash", "Venmo"],
    //   ["Milk", "Wheat"],
    // ),
    // FoodBooth(
    //   "Sukiya",
    //   "C6",
    //   "Fast Food",
    //   "assets/sukiya-logo-svg-1.png",
    //   "assets/JFB-19.png",
    //   false,
    //   ["Cash"],
    //   ["Milk", "Wheat"],
    // ),
    // FoodBooth(
    //   "Doutor Coffee",
    //   "F4",
    //   "Coffee",
    //   "assets/61e7ace5a84bd79c5fc643799f045fd0-c1386ca9179105eae23bdd086d44de15-1.png",
    //   "assets/JFB-19.png",
    //   true,
    //   ["Cash", "PayPal"],
    //   ["Milk"],
    // ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF0B3775).withOpacity(0.15),
                  const Color(0xFFBF1D23).withOpacity(0.15),
                ],
              ),
            ),
          ),

          // Top gradient
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withOpacity(0.15),
                    Colors.white.withOpacity(0.08),
                    Colors.transparent,
                  ],
                  stops: [0.59, 0.62, 0.66],
                ),
              ),
            ),
          ),

          // Bottom gradient
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Transform.rotate(
              angle: 3.14159, // 180 degrees in radians
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withOpacity(0.15),
                      Colors.white.withOpacity(0.08),
                      Colors.transparent,
                    ],
                    stops: [0.57, 0.60, 0.64],
                  ),
                ),
              ),
            ),
          ),

          // Festival logo
          Positioned(
            top: 20,
            left: MediaQuery.of(context).size.width / 2 - 30,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Center(
                child: Image.asset(
                  "assets/JFBLogo.png",
                  width: 100,
                  height: 100,
                ),
              ),
            ),
          ),

          // Filter button
          Positioned(
            top: 60,
            right: 30,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: const Icon(Icons.filter_alt_outlined),
            ),
          ),

          // Scroll indicator
          Positioned(
            top: 55,
            right: 12,
            child: Container(
              width: 7,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),

          // Main content card
          Positioned(
            top: 149,
            left: MediaQuery.of(context).size.width / 2 - 169,
            child: Container(
              width: 338,
              height: 906,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: booths.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder:
                            (context) => FoodBoothDetails(booth: booths[index]),
                      );
                    },
                    child: Container(
                      width: 290,
                      height: 290,
                      margin: const EdgeInsets.only(
                        top: 28,
                        left: 24,
                        right: 24,
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 28,
                            left: 0,
                            child: Container(
                              width: 284,
                              height: 200,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.35),
                                    blurRadius: 10,
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 50),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: Text(
                                        booths[index].name,
                                        style: const TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: Text(
                                        "Food Booth: ${booths[index].boothLocation}",
                                        style: const TextStyle(
                                          fontSize: 23,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Center(
                                      child: Container(
                                        width: 182,
                                        height: 28,
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.05),
                                          borderRadius: BorderRadius.circular(
                                            25,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.45,
                                              ),
                                              blurRadius: 5,
                                              spreadRadius: 0,
                                              offset: Offset.zero,
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: Text(
                                            booths[index].genre,
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            left: 83,
                            child: Container(
                              width: 118,
                              height: 68,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
                                    blurRadius: 10,
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Image.asset(
                                  booths[index].logoPath,
                                  width: 60,
                                  height: 50,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Bottom navigation bar
        ],
      ),
    );
  }
}

class FoodBooth {
  final String name;
  final String boothLocation;
  final String genre;
  final String logoPath;
  final String dishImagePath;
  final bool isVegan;
  final List<String> payments;
  final List<String> allergens;

  const FoodBooth(
    this.name,
    this.boothLocation,
    this.genre,
    this.logoPath,
    this.dishImagePath,
    this.isVegan,
    this.payments,
    this.allergens,
  );
}

class FoodBoothDetails extends StatelessWidget {
  final FoodBooth booth;

  const FoodBoothDetails({required this.booth, super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Blurred Background
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(color: Colors.white.withOpacity(0.02)),
          ),
        ),

        // Main Content with Logo Overlay
        Stack(
          children: [
            // Draggable Content Sheet
            DraggableScrollableSheet(
              initialChildSize: 0.6,
              minChildSize: 0.5,
              maxChildSize: 0.9,
              builder: (context, controller) {
                return Container(
                  width: 284,
                  height: 505,
                  margin: const EdgeInsets.only(left: 57, right: 57),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 15,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Food stall image container
                      Container(
                        height: 186,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                          ),
                          image: DecorationImage(
                            image: AssetImage(booth.dishImagePath),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25),
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.6),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                booth.name,
                                style: const TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                  shadows: [
                                    Shadow(blurRadius: 5, color: Colors.black),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Food Booth: ${booth.boothLocation}",
                                style: const TextStyle(
                                  fontSize: 23,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                  shadows: [
                                    Shadow(blurRadius: 5, color: Colors.black),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),

                      // Rest of the content...
                      Padding(
                        padding: const EdgeInsets.only(top: 250),
                        child: SingleChildScrollView(
                          controller: controller,
                          child: Column(
                            children: [
                              _buildSection(
                                "Payment",
                                _buildPaymentOptions(booth.payments),
                              ),
                              const SizedBox(height: 20),
                              _buildSection(
                                "Veganism",
                                _buildVeganism(booth.isVegan),
                              ),
                              const SizedBox(height: 20),
                              _buildSection(
                                "Allergens",
                                _buildAllergens(booth.allergens),
                              ),
                              const SizedBox(height: 40),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            // Logo positioned independently in the Stack
            Positioned(
              top: 300, // Half of logo height above the container
              left: 220, // Center horizontally
              child: Container(
                width: 200,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 10,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Center(
                  child: Image.asset(
                    booth.logoPath,
                    width: 105,
                    height: 70,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 120,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.45),
                    blurRadius: 5,
                    spreadRadius: 0,
                    offset: Offset.zero,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          content,
        ],
      ),
    );
  }

  Widget _buildPaymentOptions(List<String> payments) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildPaymentItem(
              "Venmo",
              "assets/payments/Venmo.png",
              payments.contains("Venmo"),
            ),
            _buildPaymentItem(
              "Zelle",
              "assets/payments/Zelle.png",
              payments.contains("Zelle"),
            ),
            _buildPaymentItem(
              "PayPal",
              "assets/paypal-logo-icon-2014-svg-1.png",
              payments.contains("PayPal"),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildPaymentItem(
          "Cash",
          "assets/payments/Cash.png",
          payments.contains("Cash"),
        ),
      ],
    );
  }

  Widget _buildPaymentItem(String method, String iconPath, bool isActive) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 10,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Center(
            child: Image.asset(
              iconPath,
              width: 44,
              height: 44,
              color: isActive ? null : Colors.grey.withOpacity(0.5),
              colorBlendMode: BlendMode.modulate,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          method,
          style: TextStyle(
            fontSize: 18,
            color: isActive ? Colors.black : Colors.grey[400],
            fontWeight: isActive ? FontWeight.normal : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildVeganism(bool isVegan) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 10,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Center(
            child: Image.asset(
              "assets/vegan.png",
              width: 44,
              height: 44,
              color: isVegan ? null : Colors.grey.withOpacity(0.5),
              colorBlendMode: BlendMode.modulate,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          isVegan ? "Vegan" : "Not Vegan",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.normal,
            color: isVegan ? Colors.black : Colors.grey[400],
          ),
        ),
      ],
    );
  }

  Widget _buildAllergens(List<String> allergens) {
    const allAllergens = [
      {"name": "Egg", "icon": "assets/allergens/egg.png"},
      {"name": "Wheat", "icon": "assets/allergens/wheat.png"},
      {"name": "Peanut", "icon": "assets/allergens/peanut.png"},
      {"name": "Milk", "icon": "assets/allergens/milk.png"},
      {"name": "Soy", "icon": "assets/allergens/soy.png"},
      {"name": "Tree Nut", "icon": "assets/allergens/tree nut.png"},
      {"name": "Fish", "icon": "assets/allergens/fish.png"},
      {"name": "Shellfish", "icon": "assets/allergens/shellfish.png"},
      {"name": "Sesame", "icon": "assets/allergens/sesame.png"},
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      childAspectRatio: 1.5,
      children:
          allAllergens.map((allergen) {
            final hasAllergen = allergens.contains(allergen["name"]);
            return Column(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 10,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Image.asset(
                      allergen["icon"]!,
                      width: 42,
                      height: 42,
                      color: hasAllergen ? null : Colors.grey.withOpacity(0.5),
                      colorBlendMode: BlendMode.modulate,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  allergen["name"]!,
                  style: TextStyle(
                    fontSize: 14,
                    color: hasAllergen ? Colors.black : Colors.grey[400],
                    fontWeight:
                        hasAllergen ? FontWeight.normal : FontWeight.normal,
                  ),
                ),
              ],
            );
          }).toList(),
    );
  }
}
