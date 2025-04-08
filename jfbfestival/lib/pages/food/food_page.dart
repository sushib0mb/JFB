import 'package:flutter/material.dart';
import 'package:jfbfestival/pages/food/components/booth_card.dart';
import 'package:jfbfestival/pages/food/components/payment_filter.dart';
import 'package:jfbfestival/pages/food/components/vegan_filter.dart';
import 'package:jfbfestival/pages/food/components/allergy_filter.dart';
import 'package:jfbfestival/pages/food/components/booth_details.dart';
import 'package:jfbfestival/data/food_booths.dart';
import 'package:jfbfestival/models/food_booth.dart';

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
    final screenSize = MediaQuery.of(context).size; // Get screen size
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    return Scaffold(
      body: Stack(
        children: [
          _buildBackgroundGradient(),
          _buildTopGradient(),
          _buildBottomGradient(),
          _buildFilterButton(),
          _buildScrollIndicator(),
          _buildMainContent(screenWidth, screenHeight),
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
        height: MediaQuery.of(context).size.height * 0.25, // Adjust based on screen height
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
          height: MediaQuery.of(context).size.height * 0.25, // Adjust based on screen height
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
      top: MediaQuery.of(context).size.height * 0.05, // Adjust position relative to screen height
      right: MediaQuery.of(context).size.width * 0.05, // Adjust position relative to screen width
      child: GestureDetector(
        onTap: _showFilterPopup,
        child: Container(
          width: 70, // Adjust size relative to screen width
          height: 70, // Adjust size relative to screen width
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
      top: MediaQuery.of(context).size.height * 0.075, // Adjust position relative to screen height
      right: MediaQuery.of(context).size.width * 0.03, // Adjust position relative to screen width
      child: Container(
        width: 7,
        height: MediaQuery.of(context).size.height * 0.08, // Adjust height based on screen size
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.4),
          borderRadius: BorderRadius.circular(25),
        ),
      ),
    );
  }

  Widget _buildMainContent(double screenWidth, double screenHeight) {
    double maxWidth = screenWidth > 1200 ? 1200 : screenWidth;
    double padding = screenWidth < 600 ? 16 : 24;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight * 0.15), // Adjust height based on screen size
                _buildFeaturedBoothsSection(),
                _buildAllBoothsSection(screenWidth),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedBoothsSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Featured Booths",
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width > 600 ? 20 : 16, // Adjust font size based on screen width
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.3, // Adjust height based on screen height
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: filteredBooths.length,
            itemBuilder: (context, index) => BoothCard(
              booth: filteredBooths[index],
              onTap: () => _showBoothDetails(context, filteredBooths[index]),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAllBoothsSection(double screenWidth) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 24),
        Text(
          "All Food Booths",
          style: TextStyle(
            fontSize: screenWidth > 600 ? 20 : 16, // Adjust font size based on screen width
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: screenWidth > 600 ? 2 : 1, // Adjust number of columns based on screen width
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
          ),
          itemCount: filteredBooths.length,
          itemBuilder: (context, index) => BoothListItem(
            booth: filteredBooths[index],
            onTap: () => _showBoothDetails(context, filteredBooths[index]),
          ),
        ),
      ],
    );
  }

  void _showBoothDetails(BuildContext context, FoodBooth booth) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BoothDetails(booth: booth),
    );
  }

  Set<String> selectedAllergens = {};

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
          builder: (_, controller) {
            return StatefulBuilder(
              builder: (context, setModalState) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: ListView(
                        controller: controller,
                        children: [
                          Center(child: _buildSectionTitle("Payment")),
                          Center(
                            child: PaymentFilterRow(
                              selectedPayments: selectedPayments,
                              onPaymentSelected: (method, isSelected) {
                                setModalState(() {
                                  if (isSelected) {
                                    selectedPayments.add(method);
                                  } else {
                                    selectedPayments.remove(method);
                                  }
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 15),
                          Center(child: _buildSectionTitle("Veganism")),
                          Center(
                            child: VeganFilterOption(
                              isVegan: veganOnly ?? false,
                              onChanged: (value) {
                                setModalState(() => veganOnly = value);
                              },
                            ),
                          ),
                          const SizedBox(height: 15),
                          Center(child: _buildSectionTitle("Exclude Allergens")),
                          Center(
                            child: AllergyFilterGrid(
                              selectedAllergens: selectedAllergens,
                              onAllergenSelected: (allergen, isSelected) {
                                setModalState(() {
                                  if (isSelected) {
                                    selectedAllergens.add(allergen);
                                  } else {
                                    selectedAllergens.remove(allergen);
                                  }
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          Center(child: _buildApplyButton(onApply: _applyFilters)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    ).then((_) => _applyFilters());
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
Widget _buildApplyButton({required VoidCallback onApply}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.red, // background color
      foregroundColor: Colors.white, // text color
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30), // more rounded corners
      ),
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 40), // adjust padding for better proportions
      elevation: 10, // add shadow for depth
    ).copyWith(
      shadowColor: MaterialStateProperty.all(Colors.redAccent.withOpacity(0.5)), // custom shadow color
    ),
    onPressed: onApply,
    child: const Text(
      "Apply Filters",
      style: TextStyle(
        fontSize: 18, // slightly larger font
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2, // increased letter spacing for better readability
      ),
    ),
  );
}



  void _applyFilters() {
    setState(() {
      filteredBooths = foodBooths.where((booth) {
        if (selectedPayments.isNotEmpty && 
            !booth.payments.any((p) => selectedPayments.contains(p))) {
          return false;
        }
        if (veganOnly == true && !booth.isVegan) return false;
        if (selectedAllergens.isNotEmpty && 
            booth.allergens.any((a) => selectedAllergens.contains(a))) {
          return false;
        }
        return true;
      }).toList();
    });
  }
}
