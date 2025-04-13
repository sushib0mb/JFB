import 'package:flutter/material.dart';
import 'package:jfbfestival/pages/food/components/payment_filter.dart';
import 'package:jfbfestival/pages/food/components/vegan_filter.dart';
import 'package:jfbfestival/pages/food/components/allergy_filter.dart';
import 'package:jfbfestival/pages/food/components/booth_details.dart';
import 'package:jfbfestival/data/food_booths.dart';
import 'package:jfbfestival/models/food_booth.dart';
import '/models/dish.dart';

class AnimatedBoothDetailWrapper extends StatefulWidget {
  final FoodBooth booth;
  final VoidCallback onClose;

  const AnimatedBoothDetailWrapper({
    Key? key,
    required this.booth,
    required this.onClose,
  }) : super(key: key);

  @override
  State<AnimatedBoothDetailWrapper> createState() =>
      _AnimatedBoothDetailWrapperState();
}

class _AnimatedBoothDetailWrapperState extends State<AnimatedBoothDetailWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: BoothDetails(booth: widget.booth, onClose: widget.onClose),
      ),
    );
  }
}

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
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    return Scaffold(
      body: Stack(
        children: [
          _buildBackgroundGradient(),
          _buildTopGradient(),
          _buildBottomGradient(),

          // Ensure this is behind the filter button
          Positioned.fill(child: _buildMainContent(screenWidth, screenHeight)),

          // This stays on top
          _buildFilterButton(),
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
        height:
            MediaQuery.of(context).size.height *
            0.25, // Adjust based on screen height
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
          height:
              MediaQuery.of(context).size.height *
              0.25, // Adjust based on screen height
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
      top: MediaQuery.of(context).size.height * 0.05,
      right: MediaQuery.of(context).size.width * 0.05,
      child: GestureDetector(
        onTap: _showFilterPopup,
        child: Material(
          // Wrap with Material for better tap detection
          color: Colors.transparent,
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
              child: Image.asset('assets/Filter.png', fit: BoxFit.contain),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent(double screenWidth, double screenHeight) {
    double maxWidth = screenWidth > 1200 ? 1300 : screenWidth * 0.95;
    double padding = screenWidth < 600 ? 16 : 24;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight * 0.1),
                Container(
  height: 1.5,
  color: Colors.grey.shade300,
  margin: const EdgeInsets.only(bottom: 12),
),

                _buildAllBoothsSection(screenWidth),
                Container(
  height: 1.5,
  color: Colors.grey.shade300,
  margin: const EdgeInsets.symmetric(vertical: 12),
),

                SizedBox(height: screenHeight * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAllBoothsSection(double screenWidth) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 60),
        Text(
  "All Food Booths",
  style: TextStyle(
    fontSize: screenWidth > 600 ? 26 : 22,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.2,
    color: const Color(0xFF2B2B2B), // rich neutral for contrast
    shadows: [
      Shadow(
        color: Colors.black.withOpacity(0.05),
        offset: Offset(0, 1.5),
        blurRadius: 2,
      ),
    ],
  ),
  textAlign: TextAlign.center,
),

        const SizedBox(height: .01), //
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: screenWidth > 600 ? 2 : 1,
            crossAxisSpacing: 2, // 👈 reduced from 30
            mainAxisSpacing: 2, // 👈 reduced from 30
            childAspectRatio: 1.34, // slight tweak for balance
          ),
          itemCount: filteredBooths.length,
          itemBuilder: (context, index) {
            final booth = filteredBooths[index];
            return GestureDetector(
              onTap: () => _showBoothDetails(context, booth),
              child: Center(
                child: Container(
                  width: 320,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ), // 👈 tighter padding
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          booth.logoPath,
                          width: 80,
                          height: 80,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 12), // 👈 reduced
                      Text(
                        booth.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6), // 👈 reduced
                      Text(
                        'Food Booth: ${booth.boothLocation}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10), // 👈 reduced
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          booth.genre,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  void _showBoothDetails(BuildContext context, FoodBooth booth) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      transitionAnimationController: AnimationController(
        duration: const Duration(milliseconds: 350),
        vsync: Navigator.of(context),
      ),
      builder: (context) {
        return AnimatedBoothDetailWrapper(
          booth: booth,
          onClose: () => Navigator.of(context).pop(),
        );
      },
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
          initialChildSize: 0.9,
          maxChildSize: 1,
          minChildSize: 0.4,
          builder: (_, controller) {
            return StatefulBuilder(
              builder: (context, setModalState) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 10),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ),
                          Expanded(
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
                                Center(child: _buildSectionTitle("Allergens")),
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
                                Center(
                                  child: _buildApplyButton(
                                    onApply: _applyFilters,
                                    closeModal:
                                        () => Navigator.of(context).pop(),
                                  ),
                                ),
                              ],
                            ),
                          ),
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
        ],
      ),
    );
  }

  Widget _buildApplyButton({
    required VoidCallback onApply,
    required VoidCallback closeModal,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red, // background color
        foregroundColor: Colors.white, // text color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // more rounded corners
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 40,
        ), // adjust padding for better proportions
        elevation: 10, // add shadow for depth
      ).copyWith(
        shadowColor: MaterialStateProperty.all(
          Colors.redAccent.withOpacity(0.5),
        ), // custom shadow color
      ),
      onPressed: () {
        onApply(); // Apply filters
        closeModal(); // Close modal
      },
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
      // Payments filter
      if (selectedPayments.isNotEmpty &&
          !booth.payments.any((p) => selectedPayments.contains(p))) {
        return false;
      }

      // Vegan filter
      if (veganOnly == true && !booth.isVegan) return false;

      // Allergen filter (dish-based)
      if (selectedAllergens.isNotEmpty) {
  
  bool hasSafeDish = booth.dishes.any((dish) =>
      !dish.allergens.any((a) => selectedAllergens.contains(a)));
  if (!hasSafeDish) return false;
}


      return true;
    }).toList();
  });
}

}