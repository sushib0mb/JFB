import 'package:flutter/material.dart';
import '/models/food_booth.dart';
import 'dart:ui'; 

class BoothDetails extends StatelessWidget {
  final FoodBooth booth;

  const BoothDetails({required this.booth, super.key});

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
            DraggableScrollableSheet(
              initialChildSize: 0.9,
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
            Positioned(
              top:  MediaQuery.of(context).size.height / 20,
              left: MediaQuery.of(context).size.width / 2.8,
              child: Container(
                width: 150,
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
                    width: 80,
                    height: 60,
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
              "assets/payments/venmo.png",
              payments.contains("Venmo"),
            ),
            _buildPaymentItem(
              "Zelle",
              "assets/payments/zelle.png",
              payments.contains("Zelle"),
            ),
            _buildPaymentItem(
              "PayPal",
              "assets/payments/paypal.png",
              payments.contains("PayPal"),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildPaymentItem(
          "Cash",
          "assets/payments/cash.png",
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
      {"name": "Tree Nut", "icon": "assets/allergens/tree_nut.png"},
      {"name": "Fish", "icon": "assets/allergens/fish.png"},
      {"name": "Shellfish", "icon": "assets/allergens/shellfish.png"},
      {"name": "Sesame", "icon": "assets/allergens/sesame.png"},
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      childAspectRatio: 1.5,
      children: allAllergens.map((allergen) {
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
                fontWeight: hasAllergen ? FontWeight.normal : FontWeight.normal,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}