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
    super.key,
    required this.booth,
    required this.onClose,
    required this.selectedAllergens,
  });

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
      duration: const Duration(milliseconds: 300),
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
  final String? selectedMapLetter;

  const FoodPage({this.selectedMapLetter, Key? key}) : super(key: key);

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
  List<FoodBooth> safeVeganBooths = [], nonVeganBooths = [];
  bool _isFilterPopupOpen = false;
  String? currentMapLetter;

  // Search related variables
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    currentMapLetter = widget.selectedMapLetter;

    // Filter by map section if coming from map
    _applyInitialMapFilter();
  }

  void _applyInitialMapFilter() {
    if (currentMapLetter != null) {
      setState(() {
        filteredBooths =
            foodBooths
                .where((booth) => booth.mapPageFoodLocation == currentMapLetter)
                .toList();
      });
    } else {
      setState(() {
        filteredBooths = foodBooths;
      });
    }
  }

  @override
  void didUpdateWidget(FoodPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update if selectedMapLetter changes
    if (widget.selectedMapLetter != oldWidget.selectedMapLetter) {
      currentMapLetter = widget.selectedMapLetter;
      _applyInitialMapFilter();
    }
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
    final topPadding = MediaQuery.of(context).size.height * 0.082;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Background first
          _buildBackgroundGradient(),

          // Adding white background
          Column(
            children: [
              SizedBox(
                height:
                    MediaQuery.of(context).padding.top +
                    topPadding +
                    MediaQuery.of(context).size.height * 0.015,
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color:
                        Theme.of(
                          context,
                        ).colorScheme.surface, // ← themed card color
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top: _isSearching ? 10 : 0),
                    child: _buildMainContent(screenWidth, screenHeight),
                  ),
                ),
              ),
            ],
          ),

          // Main content with top padding when search is active
          // Padding(
          //   padding: EdgeInsets.only(top: _isSearching ? 70 : 0),
          //   child: _buildMainContent(screenWidth, screenHeight),
          // ),

          // Search bar (fixed position, won't scroll)

          // Filter button on top of everything
          _buildTopActionButtons(),
          if (_isSearching) _buildSearchBar(),
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
      top:
          MediaQuery.of(context).padding.top +
          MediaQuery.of(context).size.height * 0.015,
      right: MediaQuery.of(context).size.width * 0.05,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Search Button
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child:
                _isSearching
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
            onPressed: () {
              if (!_isFilterPopupOpen) {
                _showFilterPopup();
              }
            },
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
          width: 55,
          height: 55,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(40),
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
            child:
                iconAsset != null
                    ? Image.asset(iconAsset, fit: BoxFit.contain)
                    : Icon(icon, size: 30),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    final pad = MediaQuery.of(context).size.height * 0.082;
    var topPadding =
        MediaQuery.of(context).padding.top +
        pad +
        MediaQuery.of(context).size.height * 0.015 +
        32.5;
    if (!_isSearching) return SizedBox.shrink(); // Hide if not searching

    return Padding(
      padding: EdgeInsets.fromLTRB(
        30,
        topPadding,
        30,
        0,
      ), // Tighter top padding
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
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
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Search food booths...',
                    border: InputBorder.none,
                  ),
                  onChanged: (_) => setState(() {}),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.grey),
                onPressed: () {
                  setState(() {
                    _searchController.clear();
                    _isSearching = false;
                  });
                  _searchFocusNode.unfocus();
                },
              ),
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
                const SizedBox(height: 16),

                _buildAllBoothsSection(screenWidth),
                SizedBox(height: screenHeight * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String getSafeSectionTitle() {
    if (veganOnly! && selectedAllergens.isNotEmpty) {
      return "✅ Vegan & Allergen-Safe Options";
    } else if (veganOnly!) {
      return "✅ Vegan Options";
    } else if (selectedAllergens.isNotEmpty) {
      return "✅ Allergen-Safe Options";
    } else {
      return "✅ All Options";
    }
  }

  String getUnsafeSectionTitle() {
    if (veganOnly! && selectedAllergens.isNotEmpty) {
      return "⚠️ Contains Allergens Or Not Vegan";
    } else if (veganOnly!) {
      return "⚠️ Not Vegan";
    } else if (selectedAllergens.isNotEmpty) {
      return "⚠️ May Contain Allergens";
    } else {
      return "⚠️ Other Booths";
    }
  }

  Widget _buildAllBoothsSection(double screenWidth) {
    final bool showSplitSections =
        safeBooths.isNotEmpty || unsafeBoothsWithAllergens.isNotEmpty;
    final List<FoodBooth> boothsToShow =
        showSplitSections
            ? [...safeBooths, ...unsafeBoothsWithAllergens]
            : filteredBooths;

    // Show empty state if no results
    if (boothsToShow.isEmpty) {
      return Column(
        children: [
          const SizedBox(height: 60),
          Icon(
            Icons.search_off,
            size: 60,
            color: Theme.of(context).disabledColor,
          ),
          const SizedBox(height: 20),
          Text(
            "No food booths found",
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Theme.of(context).disabledColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Try different search terms or filters",
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Theme.of(context).disabledColor,
            ),
          ),
          const SizedBox(height: 40),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        if (widget.selectedMapLetter != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Showing booths in section ${widget.selectedMapLetter}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),

        const SizedBox(height: 20),

        if (showSplitSections && safeBooths.isNotEmpty) ...[
          Text(
            getSafeSectionTitle(),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(height: 30),
          _buildBoothGrid(safeBooths, screenWidth),
        ],
        if (showSplitSections && unsafeBoothsWithAllergens.isNotEmpty) ...[
          const SizedBox(height: 30),
          Text(
            getUnsafeSectionTitle(),
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 30),
          _buildBoothGrid(unsafeBoothsWithAllergens, screenWidth, faded: true),
        ] else if (!showSplitSections) ...[
          _buildBoothGrid(filteredBooths, screenWidth),
        ],
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildBoothGrid(
    List<FoodBooth> booths,
    double screenWidth, {
    bool faded = false,
  }) {
    return Center(
      child: Wrap(
        spacing: 12,
        runSpacing:
            MediaQuery.of(context).size.height *
            0.035, // Spacing between food booths
        alignment: WrapAlignment.center,
        children:
            booths.map((booth) {
              return GestureDetector(
                onTap: () => _showBoothDetails(context, booth),
                child: Opacity(
                  opacity: faded ? 0.5 : 1.0,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
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
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
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
              );
            }).toList(),
      ),
    );
  }

  void _showBoothDetails(BuildContext context, FoodBooth booth) {
    final height = MediaQuery.of(context).size.height;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          // start 25% down from the top
          margin: EdgeInsets.only(top: height * 0.02),
          child: AnimatedBoothDetailWrapper(
            booth: booth,
            onClose: () => Navigator.of(ctx).pop(),
            selectedAllergens: selectedAllergens.toList(),
          ),
        );
      },
    ).then((_) {
      _applyFilters();
      _searchFocusNode.unfocus();
    });
  }

  void _showFilterPopup() {
    if (_isFilterPopupOpen) return; // Prevent re-entry
    _isFilterPopupOpen = true;

    // Delay just slightly to allow UI to settle but still appear fast
    Future.delayed(const Duration(milliseconds: 50), () {
      if (!mounted)
        return; // Prevent showing dialog if widget is no longer in the tree

      showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: 'FilterPopup',
        transitionDuration: const Duration(
          milliseconds: 200,
        ), // Faster appearance
        pageBuilder: (context, anim1, anim2) => const SizedBox.shrink(),
        transitionBuilder: (context, anim1, _, __) {
          final curved = CurvedAnimation(parent: anim1, curve: Curves.easeOut);

          return AnimatedBuilder(
            animation: curved,
            builder: (context, child) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: curved.value,
                    child: GestureDetector(
                      onTap: () {
                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 150),
                    opacity: curved.value,
                    child: Center(
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.85,
                            maxHeight:
                                MediaQuery.of(context).size.height *
                                0.8, // Increased height
                          ),
                          margin: const EdgeInsets.symmetric(horizontal: 24),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(color: Colors.black26, blurRadius: 10),
                            ],
                          ),
                          child: StatefulBuilder(
                            builder: (context, setModalState) {
                              return Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: IconButton(
                                      icon: const Icon(Icons.close),
                                      onPressed: () {
                                        if (Navigator.of(context).canPop()) {
                                          Navigator.of(context).pop();
                                        }
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      padding: const EdgeInsets.only(
                                        bottom: 24,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          SizedBox(height: 5),
                                          Center(
                                            child: _buildSectionTitle(
                                              "Payment",
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          PaymentFilterRow(
                                            selectedPayments: selectedPayments,
                                            onPaymentSelected: (
                                              method,
                                              isSelected,
                                            ) {
                                              setModalState(() {
                                                isSelected
                                                    ? selectedPayments.add(
                                                      method,
                                                    )
                                                    : selectedPayments.remove(
                                                      method,
                                                    );
                                              });
                                            },
                                          ),
                                          const SizedBox(height: 5),
                                          Center(
                                            child: _buildSectionTitle("Vegan"),
                                          ),
                                          const SizedBox(height: 12),
                                          VeganFilterOption(
                                            isVegan: veganOnly ?? false,
                                            onChanged: (value) {
                                              setModalState(
                                                () => veganOnly = value,
                                              );
                                            },
                                          ),
                                          const SizedBox(height: 15),
                                          Center(
                                            child: _buildSectionTitle(
                                              "Allergens",
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          AllergyFilterGrid(
                                            selectedAllergens:
                                                selectedAllergens,
                                            onAllergenSelected: (
                                              allergen,
                                              isSelected,
                                            ) {
                                              setModalState(() {
                                                isSelected
                                                    ? selectedAllergens.add(
                                                      allergen,
                                                    )
                                                    : selectedAllergens.remove(
                                                      allergen,
                                                    );
                                              });
                                            },
                                          ),
                                          // SizedBox(
                                          //   height:
                                          //       MediaQuery.of(
                                          //         context,
                                          //       ).size.height *
                                          //       0.001,
                                          // ),
                                          _buildApplyButton(
                                            onApply: _applyFilters,
                                            closeModal: () {
                                              if (Navigator.of(
                                                context,
                                              ).canPop()) {
                                                Navigator.of(context).pop();
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ).then((_) async {
        if (mounted) {
          _applyFilters();
          await Future.delayed(const Duration(milliseconds: 150));
          if (mounted) {
            setState(() => _isFilterPopupOpen = false);
          }
        }
      });
    });
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
                color: Theme.of(context).colorScheme.surface,
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
          const SizedBox(height: 2),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 40),
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
      safeVeganBooths = [];
      nonVeganBooths = [];
      filteredBooths = [];

      final searchQuery = _searchController.text.toLowerCase();

      for (var booth in foodBooths) {
        // Search filter
        if (searchQuery.isNotEmpty) {
          final matchesName = booth.name.toLowerCase().contains(searchQuery);
          final matchesLocation = booth.boothLocation.toLowerCase().contains(
            searchQuery,
          );
          final matchesGenre = booth.genre.toLowerCase().contains(searchQuery);
          final matchesDish = booth.dishes.any(
            (dish) =>
                dish.name.toLowerCase().contains(searchQuery) ||
                dish.description.toLowerCase().contains(searchQuery),
          );

          if (!matchesName &&
              !matchesLocation &&
              !matchesGenre &&
              !matchesDish) {
            continue;
          }
        }

        // Payments filter
        if (selectedPayments.isNotEmpty &&
            !booth.payments.any((p) => selectedPayments.contains(p))) {
          continue;
        }

        final hasVeganDish = booth.dishes.any((dish) => dish.isVegan);

        bool allDishesContainAllergens = booth.dishes.every(
          (dish) => dish.allergens.any((a) => selectedAllergens.contains(a)),
        );

        bool hasSafeDish = booth.dishes.any(
          (dish) => !dish.allergens.any((a) => selectedAllergens.contains(a)),
        );

        // Combo logic: both vegan & allergen filters selected
        if (selectedAllergens.isNotEmpty && veganOnly == true) {
          if (hasVeganDish && hasSafeDish) {
            safeBooths.add(booth);
          } else {
            unsafeBoothsWithAllergens.add(booth);
          }
          continue;
        }

        // Allergen filter only
        if (selectedAllergens.isNotEmpty) {
          if (allDishesContainAllergens) {
            unsafeBoothsWithAllergens.add(booth);
          } else {
            safeBooths.add(booth);
          }
          continue;
        }

        // Vegan filter only
        if (veganOnly == true) {
          if (hasVeganDish) {
            safeVeganBooths.add(booth);
          } else {
            nonVeganBooths.add(booth);
          }
          continue;
        }

        // No allergen or vegan filters
        filteredBooths.add(booth);
      }

      // Final display list
      if (selectedAllergens.isNotEmpty && veganOnly == true) {
        filteredBooths = [...safeBooths];
      } else if (selectedAllergens.isNotEmpty) {
        filteredBooths = [...safeBooths];
      } else if (veganOnly == true) {
        filteredBooths = [...safeVeganBooths];
      }
    });
  }
}
