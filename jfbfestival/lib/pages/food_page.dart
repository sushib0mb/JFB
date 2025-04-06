// lib/pages/food_page.dart
import 'package:flutter/material.dart';
import 'dart:ui';
import '../data/food_booths.dart';
import '../models/food_booth.dart';
// First, add this extension for hover effects (place it at the top of your file)
extension HoverExtensions on Widget {
  Widget get showCursorOnHover {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: this,
    );
  }
  
  Widget scaleOnHover({double scale = 1.05}) {
    return StatefulBuilder(
      builder: (context, setState) {
        return MouseRegion(
          onEnter: (_) => setState(() {}),
          onExit: (_) => setState(() {}),
          child: AnimatedScale(
            scale: _isHovered ? scale : 1.0,
            duration: Duration(milliseconds: 200),
            child: this,
          ),
        );
      },
    );
  }
}

bool _isHovered = false; 
class FoodPage extends StatefulWidget {
  const FoodPage({super.key});

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  List<FoodBooth> filteredBooths = foodBooths;
  Set<String> selectedPayments = {};
  bool? veganOnly = false;
  Set<String> excludedAllergens = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackgroundGradient(),
          _buildTopGradient(),
          _buildBottomGradient(),
          _buildFilterButton(),
          _buildScrollIndicator(),
          _buildMainContent(),
        ],
      ),
    );
  }

  Widget _buildBackgroundGradient() {
    return Container(
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
    );
  }

  Widget _buildTopGradient() {
    return Positioned(
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
            stops: const [0.59, 0.62, 0.66],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomGradient() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Transform.rotate(
        angle: 3.14159,
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
              stops: const [0.57, 0.60, 0.64],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButton() {
    return Positioned(
      top: 60,
      right: 30,
      child: GestureDetector(
        onTap: _showFilterPopup,
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
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Image.asset(
              'assets/filter.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScrollIndicator() {
    return Positioned(
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
    );
  }

  Widget _buildMainContent() {
    return Positioned(
      top: 149,
      left: 0,
      right: 0,
      bottom: 0,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFeaturedBoothsSection(),
            _buildAllBoothsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedBoothsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 24, top: 16, bottom: 8),
          child: Text(
            "Featured Booths",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: filteredBooths.length,
            itemBuilder: (context, index) => _buildFeaturedBoothItem(filteredBooths[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedBoothItem(FoodBooth booth) {
    final hasAllergy = booth.allergy != null;
    
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: () => _showBoothDetails(context, booth),
        child: Container(
          width: 220,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: hasAllergy ? Colors.redAccent : Colors.transparent,
              width: 2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.asset(
                  booth.image,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booth.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      booth.description,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAllBoothsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 24, top: 24, bottom: 8),
          child: Text(
            "All Food Booths",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          itemCount: filteredBooths.length,
          itemBuilder: (context, index) => _buildBoothListItem(filteredBooths[index]),
        ),
      ],
    );
  }

  Widget _buildBoothListItem(FoodBooth booth) {
    return GestureDetector(
      onTap: () => _showBoothDetails(context, booth),
      child: Container(
        width: 290,
        height: 290,
        margin: const EdgeInsets.only(top: 28),
        child: Stack(
          children: [
            Positioned(
              top: 28,
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
                          booth.name,
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
                          "Food Booth: ${booth.boothLocation}",
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
                              booth.genre,
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
                    booth.logoPath,
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
  }

  void _showBoothDetails(BuildContext context, FoodBooth booth) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FoodBoothDetails(booth: booth),
    );
  }

  void _showFilterPopup() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5,
          maxChildSize: 0.75,
          minChildSize: 0.4,
          builder: (_, controller) => Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                )
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: ListView(
              controller: controller,
              children: [
                _buildSectionTitle("Payment"),
                _buildPaymentFilterRow(),
                SizedBox(height: 15),
                _buildSectionTitle("Veganism"),
                _buildVeganFilterOption(),
                SizedBox(height: 15),
                _buildSectionTitle("Exclude Allergens"),
                _buildAllergenFilterGrid(),
                SizedBox(height: 20),
                _buildApplyButton(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }


Widget _buildPaymentFilterRow() {
  final payments = ['Cash', 'Venmo', 'Zelle', 'PayPal'];
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: payments.map((method) {
      bool isSelected = selectedPayments.contains(method);
      return StatefulBuilder(
        builder: (context, setState) {
          return MouseRegion(
            onEnter: (_) => setState(() => _isHovered = true),
            onExit: (_) => setState(() => _isHovered = false),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    selectedPayments.remove(method);
                  } else {
                    selectedPayments.add(method);
                  }
                });
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.blue.withOpacity(0.2)
                      : _isHovered
                          ? Colors.grey.withOpacity(0.1)
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? Colors.blue
                        : _isHovered
                            ? Colors.grey[400]!
                            : Colors.grey[300]!,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Column(
                  children: [
                    AnimatedOpacity(
                      duration: Duration(milliseconds: 200),
                      opacity: _isHovered || isSelected ? 1 : 0.7,
                      child: Image.asset(
                        'assets/payments/${method.toLowerCase()}.png',
                        width: 40,
                        color: isSelected
                            ? Colors.blue
                            : _isHovered
                                ? Colors.grey[800]
                                : Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      method,
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected
                            ? Colors.blue
                            : _isHovered
                                ? Colors.grey[800]
                                : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ).showCursorOnHover.scaleOnHover();
        },
      );
    }).toList(),
  );
}

Widget _buildVeganFilterOption() {
  return StatefulBuilder(
    builder: (context, setState) {
      return MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: () {
            setState(() {
              veganOnly = !(veganOnly ?? false);
            });
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: (veganOnly ?? false)
                  ? Colors.green.withOpacity(0.2)
                  : _isHovered
                      ? Colors.grey.withOpacity(0.1)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: (veganOnly ?? false)
                    ? Colors.green
                    : _isHovered
                        ? Colors.grey[400]!
                        : Colors.grey[300]!,
                width: (veganOnly ?? false) ? 2 : 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedOpacity(
                  duration: Duration(milliseconds: 200),
                  opacity: _isHovered || (veganOnly ?? false) ? 1 : 0.7,
                  child: Image.asset(
                    'assets/vegan.png',
                    width: 24,
                    color: (veganOnly ?? false)
                        ? Colors.green
                        : _isHovered
                            ? Colors.grey[800]
                            : Colors.grey[600],
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  'Vegan Only',
                  style: TextStyle(
                    fontWeight: (veganOnly ?? false) ? FontWeight.bold : FontWeight.normal,
                    color: (veganOnly ?? false)
                        ? Colors.green
                        : _isHovered
                            ? Colors.grey[800]
                            : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
      ).showCursorOnHover.scaleOnHover(scale: 1.03);
    },
  );
}

Widget _buildAllergenFilterGrid() {
  final allergens = [
    "Egg", "Wheat", "Peanut", "Milk", "Soy",
    "Tree Nut", "Fish", "Shellfish", "Sesame",
  ];

  return Padding(
    padding: const EdgeInsets.only(top: 8.0),
    child: Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: allergens.map((allergen) {
        bool isExcluded = excludedAllergens.contains(allergen);
        return StatefulBuilder(
          builder: (context, setState) {
            return MouseRegion(
              onEnter: (_) => setState(() => _isHovered = true),
              onExit: (_) => setState(() => _isHovered = false),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (isExcluded) {
                      excludedAllergens.remove(allergen);
                    } else {
                      excludedAllergens.add(allergen);
                    }
                  });
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isExcluded
                        ? Colors.red.withOpacity(0.2)
                        : _isHovered
                            ? Colors.grey.withOpacity(0.1)
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isExcluded
                          ? Colors.red
                          : _isHovered
                              ? Colors.grey[400]!
                              : Colors.grey[300]!,
                      width: isExcluded ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedOpacity(
                        duration: Duration(milliseconds: 200),
                        opacity: _isHovered || isExcluded ? 1 : 0.7,
                        child: Image.asset(
                          'assets/allergens/${allergen.toLowerCase().replaceAll(' ', '_')}.png',
                          width: 30,
                          color: isExcluded
                              ? Colors.red
                              : _isHovered
                                  ? Colors.grey[800]
                                  : Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        allergen,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isExcluded ? FontWeight.bold : FontWeight.normal,
                          color: isExcluded
                              ? Colors.red
                              : _isHovered
                                  ? Colors.grey[800]
                                  : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ).showCursorOnHover.scaleOnHover();
          },
        );
      }).toList(),
    ),
  );
}

  Widget _buildApplyButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: () {
          _applyFilters();
          Navigator.pop(context);
        },
        child: Text(
          'Apply Filters',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  void _applyFilters() {
    setState(() {
      filteredBooths = foodBooths.where((booth) {
        // Payment filter
        if (selectedPayments.isNotEmpty) {
          final hasSelectedPayment = booth.payments.any((payment) => 
              selectedPayments.contains(payment));
          if (!hasSelectedPayment) return false;
        }

        // Vegan filter
        if (veganOnly == true && !booth.isVegan) return false;

        // Allergen filter
        if (excludedAllergens.isNotEmpty) {
          final hasExcludedAllergen = booth.allergens.any((allergen) => 
              excludedAllergens.contains(allergen));
          if (hasExcludedAllergen) return false;
        }

        return true;
      }).toList();
    });
  }
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
              top: 300,
              left: MediaQuery.of(context).size.width / 2 - 50,
              child: Container(
                width: 100,
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