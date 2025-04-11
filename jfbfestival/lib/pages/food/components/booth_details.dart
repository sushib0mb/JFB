import 'package:flutter/material.dart';
import '/models/food_booth.dart';
import '/models/dish.dart';
import 'dart:ui'; 

class BoothDetails extends StatelessWidget {
  final FoodBooth booth;
  final VoidCallback onClose;

  const BoothDetails({required this.booth, required this.onClose, super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Blurred Background with clickable area to close
        Positioned.fill(
          child: GestureDetector(
            onTap: onClose,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(color: Colors.white.withOpacity(0.02)),
            ),
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
                      // Close button
                      Positioned(
                        top: 10,
                        right: 10,
                        child: IconButton(
                          icon: const Icon(Icons.close, size: 30),
                          onPressed: onClose,
                        ),
                      ),
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
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: MediaQuery.of(context).size.height - 250,
                            ),
                            child: Column(
                              children: [
                                _buildSection(
                                  "Payment",
                                  _buildPaymentOptions(booth.payments),
                                ),
                                const SizedBox(height: 20),
                                _buildSection(
                                  "Vegan Options",
                                  _buildVeganism(booth.isVegan),
                                ),
                                const SizedBox(height: 40),
                                _buildSection(
                                  "Dishes",
                                  _buildDishesSection(booth.dishes),
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            // Positioned(
            //   top: MediaQuery.of(context).size.height / 20,
            //   left: MediaQuery.of(context).size.width / 2.8,
            //   child: Container(
            //     width: 150,
            //     height: 100,
            //     decoration: BoxDecoration(
            //       color: Colors.white,
            //       borderRadius: BorderRadius.circular(25),
            //       boxShadow: [
            //         BoxShadow(
            //           color: Colors.black.withOpacity(0.5),
            //           blurRadius: 10,
            //           spreadRadius: 0,
            //         ),
            //       ],
            //     ),
            //     child: Center(
            //       child: Image.asset(
            //         booth.logoPath,
            //         width: 80,
            //         height: 60,
            //         fit: BoxFit.contain,
            //       ),
            //     ),
            //   ),
            // ),
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
              width: 140,
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

  Widget _buildDishesSection(List<Dish> dishes) {
    return Column(
      children: dishes.map((dish) => DishCard(dish: dish)).toList(),
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
          ],
        ),
        const SizedBox(height: 16),
        _buildPaymentItem(
          "Cash",
          "assets/payments/cash.png",
          payments.contains("Cash"),
        ),
         _buildPaymentItem(
          "Credit",
          "assets/payments/credit_card.png",
          payments.contains("Credit Card"),
        ),
      ],
    );
  }
Widget _buildPaymentItem(String label, String assetPath, bool isAccepted) {
  return Column(
    children: [
      Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: isAccepted ? Colors.white : Colors.grey[200],
          shape: BoxShape.circle,
          boxShadow: isAccepted
              ? [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  )
                ]
              : [],
        ),
        child: ClipOval(
          child: FadeInImage(
            placeholder: AssetImage('assets/payments/loading.png'), // your own loading spinner or blank image
            image: AssetImage(assetPath),
            fit: BoxFit.contain,
            imageErrorBuilder: (context, error, stackTrace) => Icon(Icons.error, color: Colors.red),
          ),
        ),
      ),
      const SizedBox(height: 8),
      Text(label, style: TextStyle(fontSize: 12)),
    ],
  );
}

Widget _buildVeganism(bool isVegan) {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
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
              width: 30,
              height: 30,
              color: isVegan ? null : Colors.grey.withOpacity(0.5),
              colorBlendMode: BlendMode.modulate,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          isVegan ? "Yes" : "None",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.normal,
            color: isVegan ? Colors.black : Colors.grey[400],
          ),
        ),
      ],
    ),
  );
}
}

class DishCard extends StatefulWidget {
  final Dish dish;
  
  const DishCard({required this.dish, super.key});
  
  @override
  State<DishCard> createState() => _DishCardState();
}

class _DishCardState extends State<DishCard> {
  bool _showAllergenDetails = false;
  
  // Map allergen names to their corresponding icon paths
  final Map<String, String> _allergenIcons = {
    "Egg": "assets/allergens/egg.png",
    "Wheat": "assets/allergens/wheat.png",
    "Peanut": "assets/allergens/peanut.png",
    "Milk": "assets/allergens/milk.png",
    "Soy": "assets/allergens/soy.png",
    "Tree Nut": "assets/allergens/tree_nut.png",
    "Fish": "assets/allergens/fish.png",
    "Shellfish": "assets/allergens/shellfish.png",
    "Sesame": "assets/allergens/sesame.png",
  };
  
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: double.infinity,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dish image and basic info
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.asset(
                    widget.dish.imagePath,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            widget.dish.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          "\$${widget.dish.price.toStringAsFixed(2)}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (widget.dish.isVegan)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.eco,
                            color: Colors.white,
                            size: 14,
                          ),
                          SizedBox(width: 4),
                          Text(
                            "Vegan",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            // Dish description
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.dish.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Allergen information
                  if (widget.dish.allergens.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              _showAllergenDetails = !_showAllergenDetails;
                            });
                          },
                          child: Row(
                            children: [
                              const Text(
                                "Contains allergens",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF7A4E2C),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                _showAllergenDetails
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                size: 18, 
                                color: Color.fromARGB(255, 151, 73, 0),
                              ),
                            ],
                          ),
                        ),
                        if (_showAllergenDetails) ...[
                          const SizedBox(height: 8),
                          // Allergen icons
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: widget.dish.allergens.map((allergen) {
                              final iconPath = _allergenIcons[allergen] ?? "assets/allergens/default.png";
                              return SizedBox(
                                width: 70, // Fixed width for consistent spacing
                                child: Column(
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
                                          width: 30,
                                          height: 30,
                                          color: Color.fromARGB(255, 107, 53, 1),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      allergen,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color.fromARGB(255, 107, 53, 1),
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}