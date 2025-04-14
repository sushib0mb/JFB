import 'package:flutter/material.dart';
import 'package:jfbfestival/pages/food/components/payment_filter.dart';
import 'package:jfbfestival/pages/food/components/vegan_filter.dart';
import 'package:jfbfestival/pages/food/components/allergy_filter.dart';
import 'package:jfbfestival/pages/food/components/booth_details.dart';
import 'package:jfbfestival/data/food_booths.dart';
import 'package:jfbfestival/models/food_booth.dart';

class AnimatedBoothDetailWrapper extends StatefulWidget {
  final FoodBooth booth;
  final VoidCallback onClose;
  final List<String> selectedAllergens;

  const AnimatedBoothDetailWrapper({
    Key? key,
    required this.booth,
    required this.onClose,
    required this.selectedAllergens,
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
        child: BoothDetails(
          booth: widget.booth,
          onClose: widget.onClose,
          selectedAllergens: widget.selectedAllergens,
        ),
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
  List<FoodBooth> safeBooths = [];
  List<FoodBooth> unsafeBoothsWithAllergens = [];
  Set<String> selectedAllergens = {};
  
  // Search related variables
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  FocusNode _searchFocusNode = FocusNode();
  
  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _applyFilters();
  }
@override
Widget build(BuildContext context) {
  final screenSize = MediaQuery.of(context).size;
  final screenWidth = screenSize.width;
  final screenHeight = screenSize.height;

  return Scaffold(
    body: Stack(
      children: [
        // Background first
        _buildBackgroundGradient(),
        
        // Main content with top padding when search is active
        Padding(
          padding: EdgeInsets.only(top: _isSearching ? 70 : 0),
          child: _buildMainContent(screenWidth, screenHeight),
        ),
        
        // Search bar (fixed position, won't scroll)
        if (_isSearching) _buildSearchBar(),
        
        // Filter button on top of everything
        _buildTopActionButtons(),
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

  Widget _buildTopActionButtons() {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.05,
      right: MediaQuery.of(context).size.width * 0.05,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Search Button
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _isSearching
                ? Container() // Empty container when searching
                : _buildIconButton(
                    icon: Icons.search,
                    onPressed: () {
                      setState(() {
                        _isSearching = true;
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _searchFocusNode.requestFocus();
                        });
                      });
                    },
                  ),
          ),
          const SizedBox(width: 10),
          // Filter Button
          _buildIconButton(
            iconAsset: 'assets/Filter.png',
            onPressed: _showFilterPopup,
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    IconData? icon,
    String? iconAsset,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Material(
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
            child: iconAsset != null
                ? Image.asset(iconAsset, fit: BoxFit.contain)
                : Icon(icon, size: 24),
          ),
        ),
      ),
    );
  }Widget _buildSearchBar() {
  return Positioned(
    top: MediaQuery.of(context).padding.top + 80, // Just below status bar
    left: 16,
    right: 16,
    child: Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                decoration: InputDecoration(
                  hintText: 'Search food booths...',
                  border: InputBorder.none,
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                            });
                          },
                        )
                      : null,
                ),
                style: TextStyle(fontSize: 16),
              ),
            ),
            // Removed the close (X) button completely
          ],
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
    final bool showSplitSections =
        safeBooths.isNotEmpty || unsafeBoothsWithAllergens.isNotEmpty;
    final List<FoodBooth> boothsToShow = showSplitSections
        ? [...safeBooths, ...unsafeBoothsWithAllergens]
        : filteredBooths;

    // Show empty state if no results
    if (boothsToShow.isEmpty) {
      return Column(
        children: [
          const SizedBox(height: 60),
          Icon(Icons.search_off, size: 60, color: Colors.grey[400]),
          const SizedBox(height: 20),
          Text(
            "No food booths found",
            style: TextStyle(
              fontSize: 22,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Try different search terms or filters",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 40),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 60),
        Text(
          "All Food Booths",
          style: TextStyle(
            fontSize: screenWidth > 600 ? 26 : 22,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
            color: const Color(0xFF2B2B2B),
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.05),
                offset: const Offset(0, 1.5),
                blurRadius: 2,
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        if (showSplitSections) ...[
          if (safeBooths.isNotEmpty) ...[
            Text(
              "✅ Safe Options",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildBoothGrid(safeBooths, screenWidth),
          ],
          if (unsafeBoothsWithAllergens.isNotEmpty) ...[
            const SizedBox(height: 30),
            Text(
              "⚠️ May Contain Allergens",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildBoothGrid(
              unsafeBoothsWithAllergens,
              screenWidth,
              faded: true,
            ),
          ],
        ] else ...[
          _buildBoothGrid(filteredBooths, screenWidth),
        ],
      ],
    );
  }

  Widget _buildBoothGrid(
    List<FoodBooth> booths,
    double screenWidth, {
    bool faded = false,
  }) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: screenWidth > 600 ? 2 : 1,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
        childAspectRatio: 1.34,
      ),
      itemCount: booths.length,
      itemBuilder: (context, index) {
        final booth = booths[index];
        return GestureDetector(
          onTap: () => _showBoothDetails(context, booth),
          child: Center(
            child: Opacity(
              opacity: faded ? 0.5 : 1.0,
              child: Container(
                width: 320,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
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
                    const SizedBox(height: 12),
                    Text(
                      booth.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Food Booth: ${booth.boothLocation}',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
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
          ),
        );
      },
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
          selectedAllergens: selectedAllergens.toList(),
        );
      },
    );
  }

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
                                const SizedBox(height: 35),
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
                                    closeModal: () => Navigator.of(context).pop(),
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
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 40,
        ),
        elevation: 10,
      ).copyWith(
        shadowColor: MaterialStateProperty.all(
          Colors.redAccent.withOpacity(0.5),
        ),
      ),
      onPressed: () {
        onApply();
        closeModal();
      },
      child: const Text(
        "Apply Filters",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  void _applyFilters() {
    setState(() {
      safeBooths = [];
      unsafeBoothsWithAllergens = [];
      filteredBooths = [];

      final searchQuery = _searchController.text.toLowerCase();

      for (var booth in foodBooths) {
        // Search filter
        if (searchQuery.isNotEmpty) {
          final matchesName = booth.name.toLowerCase().contains(searchQuery);
          final matchesLocation =
              booth.boothLocation.toLowerCase().contains(searchQuery);
          final matchesGenre = booth.genre.toLowerCase().contains(searchQuery);
          final matchesDish = booth.dishes.any((dish) =>
              dish.name.toLowerCase().contains(searchQuery) ||
              dish.description.toLowerCase().contains(searchQuery));

          if (!matchesName && !matchesLocation && !matchesGenre && !matchesDish) {
            continue;
          }
        }

        // Payments filter
        if (selectedPayments.isNotEmpty &&
            !booth.payments.any((p) => selectedPayments.contains(p))) {
          continue;
        }

        // Vegan filter
        if (veganOnly == true && !booth.isVegan) continue;

        // Allergen filtering
        if (selectedAllergens.isNotEmpty) {
          final hasAllergenDish = booth.dishes.any(
            (dish) => dish.allergens.any((a) => selectedAllergens.contains(a)),
          );

          if (hasAllergenDish) {
            unsafeBoothsWithAllergens.add(booth);
          } else {
            safeBooths.add(booth);
          }
        } else {
          // No allergen filter, so treat all booths as safe
          safeBooths.add(booth);
        }
      }

      // If no allergen filter applied, treat all as "safe"
      if (selectedAllergens.isEmpty) {
        unsafeBoothsWithAllergens.clear();
        filteredBooths = [...safeBooths];
      }
    });
  }
}