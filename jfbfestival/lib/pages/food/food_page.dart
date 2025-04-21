// lib/pages/food/food_page.dart
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:jfbfestival/models/food_booth.dart';
import 'package:jfbfestival/pages/food/components/payment_filter.dart';
import 'package:jfbfestival/pages/food/components/vegan_filter.dart';
import 'package:jfbfestival/pages/food/components/allergy_filter.dart';
import 'package:jfbfestival/pages/food/components/booth_details.dart';
import 'package:jfbfestival/services/supabase_service.dart';

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
  Widget build(BuildContext context) => FadeTransition(
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

class FoodPage extends StatefulWidget {
  final String? selectedMapLetter;
  const FoodPage({this.selectedMapLetter, Key? key}) : super(key: key);

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  final SupabaseService _supabaseService = SupabaseService();
  final Logger _logger = Logger();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  List<FoodBooth> allBooths = [];
  List<FoodBooth> filteredBooths = [];
  Set<String> selectedPayments = {};
  bool veganOnly = false;
  Set<String> selectedAllergens = {};

  // for split sections
  List<FoodBooth> safeBooths = [];
  List<FoodBooth> unsafeBoothsWithAllergens = [];
  List<FoodBooth> safeVeganBooths = [];
  List<FoodBooth> nonVeganBooths = [];

  String? currentMapLetter;
  bool loading = true;
  bool _isSearching = false;
  bool _isFilterPopupOpen = false;

  @override
  void initState() {
    super.initState();
    currentMapLetter = widget.selectedMapLetter;
    _searchController.addListener(_onSearchChanged);
    _loadAndFilterBooths();
  }

  void _onSearchChanged() => _applyFilters();

  @override
  void didUpdateWidget(FoodPage old) {
    super.didUpdateWidget(old);
    if (widget.selectedMapLetter != old.selectedMapLetter) {
      setState(() => currentMapLetter = widget.selectedMapLetter);
      _applyFilters();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadAndFilterBooths() async {
    try {
      final booths = await _supabaseService.fetchFoodBooths();
      setState(() {
        allBooths = booths;
        loading = false;
      });
      _applyFilters();
    } catch (err, stack) {
      // log both error and stacktrace in one message
      _logger.e("Failed to load booths: $err\n$stack");
      setState(() => loading = false);
    }
  }

  void _applyFilters() {
    if (!mounted) return;
    setState(() {
      safeBooths.clear();
      unsafeBoothsWithAllergens.clear();
      safeVeganBooths.clear();
      nonVeganBooths.clear();
      filteredBooths.clear();

      final query = _searchController.text.toLowerCase();
      // 1) map + search
      var initial =
          allBooths.where((b) {
            if (currentMapLetter != null &&
                b.mapPageFoodLocation != currentMapLetter) {
              return false;
            }
            if (query.isNotEmpty) {
              final matchName = b.name.toLowerCase().contains(query);
              final matchLoc = b.boothLocation.toLowerCase().contains(query);
              final matchGenre = b.genre.toLowerCase().contains(query);
              final matchDish = b.dishes.any(
                (d) =>
                    d.name.toLowerCase().contains(query) ||
                    d.description.toLowerCase().contains(query),
              );
              return matchName || matchLoc || matchGenre || matchDish;
            }
            return true;
          }).toList();

      // 2) payment
      if (selectedPayments.isNotEmpty) {
        initial =
            initial
                .where(
                  (b) => b.payments.any((p) => selectedPayments.contains(p)),
                )
                .toList();
      }

      // 3) vegan & allergen split
      for (var b in initial) {
        final hasVegan = b.dishes.any((d) => d.isVegan);
        final hasSafe = b.dishes.any(
          (d) => !d.allergens.any((a) => selectedAllergens.contains(a)),
        );

        if (veganOnly && selectedAllergens.isNotEmpty) {
          // both filters
          final vegSafe = b.dishes.any(
            (d) =>
                d.isVegan &&
                !d.allergens.any((a) => selectedAllergens.contains(a)),
          );
          if (vegSafe)
            safeBooths.add(b);
          else
            unsafeBoothsWithAllergens.add(b);
        } else if (selectedAllergens.isNotEmpty) {
          if (hasSafe)
            safeBooths.add(b);
          else
            unsafeBoothsWithAllergens.add(b);
        } else if (veganOnly) {
          if (hasVegan)
            safeVeganBooths.add(b);
          else
            nonVeganBooths.add(b);
        } else {
          filteredBooths.add(b);
        }
      }

      // 4) choose final list
      if (veganOnly && selectedAllergens.isNotEmpty) {
        filteredBooths = [...safeBooths];
      } else if (selectedAllergens.isNotEmpty) {
        filteredBooths = [...safeBooths];
      } else if (veganOnly) {
        filteredBooths = [...safeVeganBooths];
      }
      // else leave filteredBooths as-is
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const Center(child: CircularProgressIndicator());

    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final topPad = h * 0.082 + MediaQuery.of(context).padding.top + h * 0.015;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          _buildBackgroundGradient(),
          Column(
            children: [
              SizedBox(height: topPad),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top: _isSearching ? 10 : 0),
                    child: _buildMainContent(w, h),
                  ),
                ),
              ),
            ],
          ),
          _buildTopActionButtons(),
          if (_isSearching) _buildSearchBar(),
        ],
      ),
    );
  }

  Widget _buildBackgroundGradient() => Container(
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
                    ? const SizedBox.shrink() // Empty when searching
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

    return Padding(
      padding: EdgeInsets.fromLTRB(30, topPadding, 30, 0),
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
                  onChanged: (_) => _applyFilters(),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.grey),
                onPressed: () {
                  setState(() {
                    _searchController.clear();
                    _isSearching = false;
                    _applyFilters();
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
    if (veganOnly && selectedAllergens.isNotEmpty) {
      return "✅ Vegan & Allergen-Safe Options";
    } else if (veganOnly) {
      return "✅ Vegan Options";
    } else if (selectedAllergens.isNotEmpty) {
      return "✅ Allergen-Safe Options";
    } else {
      return "✅ All Options";
    }
  }

  String getUnsafeSectionTitle() {
    if (veganOnly && selectedAllergens.isNotEmpty) {
      return "⚠️ Contains Allergens Or Not Vegan";
    } else if (veganOnly) {
      return "⚠️ Not Vegan";
    } else if (selectedAllergens.isNotEmpty) {
      return "⚠️ May Contain Allergens";
    } else {
      return "⚠️ Other Booths";
    }
  }

  Widget _buildAllBoothsSection(double screenWidth) {
    final bool showSplitSections =
        (selectedAllergens.isNotEmpty || veganOnly) &&
        (safeBooths.isNotEmpty ||
            safeVeganBooths.isNotEmpty ||
            unsafeBoothsWithAllergens.isNotEmpty ||
            nonVeganBooths.isNotEmpty);

    final List<FoodBooth> boothsToShow =
        showSplitSections
            ? [
              ...safeBooths,
              ...safeVeganBooths,
              ...unsafeBoothsWithAllergens,
              ...nonVeganBooths,
            ]
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
          if (_hasActiveFilters())
            ElevatedButton(
              onPressed: () {
                setState(() {
                  selectedPayments.clear();
                  veganOnly = false;
                  selectedAllergens.clear();
                  currentMapLetter = null;
                  _searchController.clear();
                  _isSearching = false;
                  _applyFilters();
                });
              },
              child: const Text("Clear All Filters"),
            ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),

        // Show map section indicator if filtering by map
        if (currentMapLetter != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Showing booths in section $currentMapLetter',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),

        const SizedBox(height: 20),

        // Show filtered sections based on active filters
        if (showSplitSections) ...[
          // Safe section (vegan and/or allergen-safe)
          if (veganOnly &&
              selectedAllergens.isNotEmpty &&
              safeBooths.isNotEmpty) ...[
            Text(
              getSafeSectionTitle(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 30),
            _buildBoothGrid(safeBooths, screenWidth),
          ] else if (veganOnly && safeVeganBooths.isNotEmpty) ...[
            Text(
              "✅ Vegan Options",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 30),
            _buildBoothGrid(safeVeganBooths, screenWidth),
          ] else if (selectedAllergens.isNotEmpty && safeBooths.isNotEmpty) ...[
            Text(
              "✅ Allergen-Safe Options",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 30),
            _buildBoothGrid(safeBooths, screenWidth),
          ],

          // Unsafe section
          if ((veganOnly && nonVeganBooths.isNotEmpty) ||
              (selectedAllergens.isNotEmpty &&
                  unsafeBoothsWithAllergens.isNotEmpty)) ...[
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
            _buildBoothGrid(
              veganOnly && selectedAllergens.isEmpty
                  ? nonVeganBooths
                  : unsafeBoothsWithAllergens,
              screenWidth,
              faded: true,
            ),
          ],
        ] else ...[
          // No special filters - show all booths
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
        runSpacing: MediaQuery.of(context).size.height * 0.035,
        alignment: WrapAlignment.center,
        children:
            booths.map((booth) {
              return GestureDetector(
                onTap: () => _showBoothDetails(booth),
                child: Opacity(
                  opacity: faded ? 0.5 : 1.0,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    padding: const EdgeInsets.only(bottom: 20),
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
                        Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.2,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25),
                            ),
                            image: DecorationImage(
                              image: AssetImage(booth.dishImagePath),
                              fit: BoxFit.cover,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
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
                        const SizedBox(height: 2),
                        Text(
                          'Food Booth: ${booth.boothLocation}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
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

  void _showBoothDetails(FoodBooth booth) {
    final height = MediaQuery.of(context).size.height;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
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

    // Show filter popup with slight delay
    Future.delayed(const Duration(milliseconds: 50), () {
      if (!mounted) return;

      showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: 'FilterPopup',
        transitionDuration: const Duration(milliseconds: 200),
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
                    opacity: curved.value * 0.5, // Semi-transparent backdrop
                    child: GestureDetector(
                      onTap: () {
                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        }
                      },
                      child: Container(color: Colors.black),
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
                            maxHeight: MediaQuery.of(context).size.height * 0.8,
                          ),
                          margin: const EdgeInsets.symmetric(horizontal: 24),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(color: Colors.black26, blurRadius: 10),
                            ],
                          ),
                          child: StatefulBuilder(
                            builder: (context, setModalState) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 16.0,
                                        ),
                                        child: Text(
                                          "Filters",
                                          style:
                                              Theme.of(
                                                context,
                                              ).textTheme.titleLarge,
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.close),
                                        onPressed: () {
                                          if (Navigator.of(context).canPop()) {
                                            Navigator.of(context).pop();
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                  const Divider(),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      padding: const EdgeInsets.only(
                                        bottom: 24,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          const SizedBox(height: 5),
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
                                            isVegan: veganOnly,
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
                                                setModalState(() {
                                                  isSelected
                                                      ? selectedAllergens.add(
                                                        allergen,
                                                      )
                                                      : selectedAllergens
                                                          .remove(allergen);
                                                });
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Divider(),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 16.0,
                                      right: 16.0,
                                      bottom: 16.0,
                                      top: 8.0,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            setModalState(() {
                                              selectedPayments.clear();
                                              veganOnly = false;
                                              selectedAllergens.clear();
                                            });
                                          },
                                          child: const Text("Reset"),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            _applyFilters();
                                          },
                                          child: const Text("Apply"),
                                        ),
                                      ],
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
      ).then((_) {
        // Reset the flag when dialog is closed
        _isFilterPopupOpen = false;
      });
    });
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  bool _hasActiveFilters() {
    return selectedPayments.isNotEmpty ||
        veganOnly ||
        selectedAllergens.isNotEmpty ||
        currentMapLetter != null ||
        _searchController.text.isNotEmpty;
  }
}
