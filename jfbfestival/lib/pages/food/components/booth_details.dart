import 'package:flutter/material.dart';
import '/models/food_booth.dart'; // Ensure FoodBooth has 'imagePath', 'id', 'name', 'boothLocation', 'payments', 'isVegan'
import '/models/dish.dart'; // Ensure Dish has 'id', 'boothId', 'name', 'price', 'description', 'imagePath', 'allergens', 'isVegan'
import 'package:supabase_flutter/supabase_flutter.dart';

// Assuming you have a Supabase client configured in your app
final supabase = Supabase.instance.client;

class BoothDetails extends StatefulWidget {
  final FoodBooth booth;
  final VoidCallback onClose;
  final List<String> selectedAllergens;

  const BoothDetails({
    Key? key,
    required this.booth,
    required this.onClose,
    required this.selectedAllergens,
  }) : super(key: key);

  @override
  State<BoothDetails> createState() => _BoothDetailsState();
}

class _BoothDetailsState extends State<BoothDetails> {
  bool _isLoading = true;
  List<Dish> _dishes = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchDishesData();
  }

  Future<void> _fetchDishesData() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _dishes = [];
    });

    final boothIdForQuery = widget.booth.id;

    try {
      // 1. Fetch dishes for this booth
      final response = await supabase
          .from('dishes')
          .select('*') // Select all columns
          .eq('booth_id', boothIdForQuery);

      if (!mounted) return;

      if (response == null || response.isEmpty) {
        // Added null check for safety
        setState(() {
          _dishes = [];
          _isLoading = false;
        });
        return;
      }

      // *** FIX: Explicitly cast the List<dynamic> to List<Map<String, dynamic>> ***
      final List<Map<String, dynamic>> dishDataList =
          List<Map<String, dynamic>>.from(response);

      // 2. NO NEED to fetch from 'dish_allergens' based on previous analysis

      // 3. Map Supabase data to Dish objects
      setState(() {
        _dishes =
            dishDataList.map<Dish>((data) {
              // Accessing 'data' elements should now be safe as 'data' is Map<String, dynamic>
              final dishId = data['id'];
              final boothId = data['booth_id'];
              final priceData = data['price'];

              final allergenString = data['allergens'] as String?;
              final List<String> allergensList =
                  allergenString
                      ?.split(',')
                      .map((a) => a.trim())
                      .where((a) => a.isNotEmpty)
                      .toList() ??
                  [];

              return Dish(
                id: dishId,
                boothId: boothId,
                name: data['name'] as String? ?? 'Unnamed Dish',
                price: (priceData as num?)?.toDouble() ?? 0.0,
                description: data['description'] as String? ?? '',
                imagePath:
                    data['imagePath'] as String? ?? 'assets/default_dish.png',
                allergens: allergensList,
                isVegan: data['is_vegan'] as bool? ?? false,
              );
            }).toList();
        _isLoading = false;
      });
    } catch (e, stackTrace) {
      print('Error fetching dishes: $e');
      print('Stack trace: $stackTrace');
      if (mounted) {
        setState(() {
          _errorMessage =
              'Failed to load menu. Please check connection and try again.';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // ... (rest of build method remains the same)
    return Stack(
      children: [
        // Blurred Background with clickable area to close
        Positioned.fill(
          child: GestureDetector(
            onTap: widget.onClose,
            child: Container(color: Colors.white.withOpacity(0.02)),
          ),
        ),
        Center(
          child: Container(
            width:
                MediaQuery.of(context).size.width *
                0.85, // Slightly wider for better content fit
            height:
                MediaQuery.of(context).size.height * 0.75, // Slightly taller
            constraints: BoxConstraints(
              maxHeight:
                  MediaQuery.of(context).size.height *
                  0.9, // Adjusted max height
              maxWidth: 600, // Added max width for larger screens/tablets
            ),
            margin: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 20,
            ), // Adjusted margin
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3), // Softer shadow
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ClipRRect(
              // Clip content to rounded corners
              borderRadius: BorderRadius.circular(25),
              child: Stack(
                children: [
                  // Main scrollable content
                  Column(
                    children: [
                      // Top image and Booth Info
                      _buildBoothHeader(), // Extracted header to a method
                      // Scrollable content area
                      Expanded(
                        child:
                            _isLoading
                                ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                                : _errorMessage != null
                                ? Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      _errorMessage!,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  ),
                                )
                                : _buildBoothContent(), // Extracted content list
                      ),
                    ],
                  ),

                  // Close button floating on top right
                  Positioned(
                    top: 8, // Adjusted position
                    right: 8, // Adjusted position
                    child: Material(
                      color: Colors.black.withOpacity(
                        0.4,
                      ), // Semi-transparent background
                      shape: const CircleBorder(),
                      child: IconButton(
                        icon: const Icon(
                          Icons.close,
                          size: 24, // Slightly larger icon
                          color: Colors.white,
                        ),
                        tooltip: "Close",
                        onPressed: widget.onClose,
                        splashRadius: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // --- Helper Widgets ---

  Widget _buildBoothHeader() {
    // *** ATTENTION: Verify 'imagePath' exists in your FoodBooth model ***
    // *** AND ensure the image files/paths are correct and declared in pubspec.yaml ***
    String? imagePath = widget.booth.dishImagePath; // Access the correct field

    return Container(
      height: 180, // Adjusted height
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          // *** FIX: Use widget.booth.imagePath (or your correct field name) ***
          // Provide a default booth image if path is null or empty
          image: _getBoothImage(imagePath),
          fit: BoxFit.cover,
          onError: (exception, stackTrace) {
            // This onError in DecorationImage might not catch all asset loading errors
            print("Error loading booth image for DecorationImage: $exception");
          },
        ),
      ),
      child: Container(
        // Gradient overlay for text readability
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.6),
              Colors.transparent,
              Colors.black.withOpacity(0.6), // Gradient at bottom too
            ],
            stops: const [0.0, 0.5, 1.0], // Adjust stops for gradient spread
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Padding for text
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end, // Align text to bottom
            crossAxisAlignment: CrossAxisAlignment.start, // Align text left
            children: [
              Text(
                widget.booth.name, // Assumes 'name' exists
                style: const TextStyle(
                  fontSize: 24, // Adjusted size
                  color: Colors.white,
                  fontWeight: FontWeight.bold, // Bolder name
                  shadows: [
                    Shadow(
                      blurRadius: 4,
                      color: Colors.black87,
                    ), // Enhanced shadow
                  ],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                "Location: ${widget.booth.boothLocation}", // Assumes 'boothLocation' exists
                style: const TextStyle(
                  fontSize: 16, // Adjusted size
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                  shadows: [
                    Shadow(
                      blurRadius: 3,
                      color: Colors.black54,
                    ), // Enhanced shadow
                  ],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBoothContent() {
    // ... (rest of _buildBoothContent remains the same)
    return SingleChildScrollView(
      padding: const EdgeInsets.only(
        top: 16,
        bottom: 16,
        left: 8,
        right: 8,
      ), // Adjust padding
      child: Column(
        children: [
          _buildSection(
            "Payment Options", // More descriptive title
            _buildPaymentOptions(
              widget.booth.payments,
            ), // Handle null payments list
          ),
          const SizedBox(height: 20), // Increased spacing
          _buildSection(
            "Vegan Friendly", // More descriptive title
            _buildVeganism(widget.booth.isVegan), // Handle null isVegan
          ),
          const SizedBox(height: 20), // Increased spacing
          if (_dishes.isNotEmpty ||
              _isLoading) // Only show dish section if loading or has dishes
            _buildSection(
              "Menu", // Simpler title
              _buildDishesSection(_dishes, widget.selectedAllergens),
            ),
          if (!_isLoading && _dishes.isEmpty && _errorMessage == null)
            const Padding(
              // Show message if no dishes and not loading/error
              padding: EdgeInsets.symmetric(vertical: 30.0),
              child: Text(
                "No menu items available for this booth yet.",
                textAlign: TextAlign.center,
              ),
            ),
          const SizedBox(height: 20), // Bottom padding
        ],
      ),
    );
  }

  // Helper to get the appropriate ImageProvider
  ImageProvider _getBoothImage(String imagePath) {
    // Basic check if it looks like a URL
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return NetworkImage(imagePath);
    } else {
      return AssetImage(imagePath);
    }
  }

  Widget _buildSection(String title, Widget content) {
    // ... (rest of _buildSection remains the same)
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch, // Make section stretch
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
          ), // Padding for title
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600, // Slightly bolder title
              color: Colors.black87,
            ),
            textAlign: TextAlign.center, // Center title
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
          ), // Padding for content
          child: content,
        ),
        const Divider(
          height: 30,
          thickness: 1,
          indent: 20,
          endIndent: 20,
        ), // Add divider between sections
      ],
    );
  }

  Widget _buildDishesSection(
    List<Dish> dishes,
    List<String> selectedAllergens,
  ) {
    // ... (rest of _buildDishesSection remains the same)
    final dishesToShow =
        selectedAllergens.isEmpty
            ? dishes
            : dishes.where((dish) {
              // Only show dishes that don't contain any of the selected allergens
              final dishAllergensLower =
                  dish.allergens.map((a) => a.toLowerCase()).toSet();
              final selectedAllergensLower =
                  selectedAllergens.map((a) => a.toLowerCase()).toSet();
              return dishAllergensLower
                  .intersection(selectedAllergensLower)
                  .isEmpty;
            }).toList();

    if (dishesToShow.isEmpty && dishes.isNotEmpty) {
      // Adjusted condition
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            "No dishes match your current allergen filters.",
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    if (dishesToShow.isEmpty && dishes.isEmpty) {
      // Should be covered by outer checks, but for safety
      return const SizedBox.shrink(); // Or a "No dishes" message if preferred here
    }

    // Use ListView.builder for potentially long menus (more efficient)
    // Wrap with Column if inside SingleChildScrollView, otherwise use directly
    return Column(
      children:
          dishesToShow.map((dish) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 4.0,
              ), // Spacing between cards
              child: DishCard(
                // Use unique key based on dish ID
                key: ValueKey(
                  'dish_${dish.id}',
                ), // Ensure dish.id is unique and suitable as a key
                dish: dish,
                selectedAllergens: selectedAllergens,
              ),
            );
          }).toList(),
    );
  }

  Widget _buildPaymentOptions(List<String> payments) {
    // ... (rest of _buildPaymentOptions remains the same)
    final acceptedPaymentsLower = payments.map((p) => p.toLowerCase()).toSet();

    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 20, // Adjusted spacing
        runSpacing: 16,
        children: [
          _buildPaymentItem(
            "Venmo",
            "assets/payments/venmo.png",
            acceptedPaymentsLower.contains("venmo"),
          ),
          _buildPaymentItem(
            "Zelle",
            "assets/payments/zelle.png",
            acceptedPaymentsLower.contains("zelle"),
          ),
          _buildPaymentItem(
            "Cash",
            "assets/payments/cash.png",
            acceptedPaymentsLower.contains("cash"),
          ),
          _buildPaymentItem(
            "Credit", // Label for UI
            "assets/payments/credit_card.png",
            // Check for common variations
            acceptedPaymentsLower.contains("credit card") ||
                acceptedPaymentsLower.contains("credit"),
          ),
          _buildPaymentItem(
            "PayPal", // Label for UI
            "assets/payments/paypal.png",
            acceptedPaymentsLower.contains("paypal"),
          ),
          // Add more payment types if needed
        ],
      ),
    );
  }

  Widget _buildPaymentItem(String label, String assetPath, bool isAccepted) {
    // ... (rest of _buildPaymentItem remains the same)
    return Opacity(
      // Fade out if not accepted
      opacity: isAccepted ? 1.0 : 0.5,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 45, // Slightly larger icon background
            height: 45,
            padding: const EdgeInsets.all(8), // Padding inside circle
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle, // Use circle shape
              boxShadow:
                  isAccepted
                      ? [
                        // Only shadow if accepted
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ]
                      : null,
              border: Border.all(
                // Add subtle border
                color: isAccepted ? Colors.grey.shade300 : Colors.grey.shade400,
                width: 1,
              ),
            ),
            child: Image.asset(
              assetPath,
              // Removed color tinting for better original icon display
              errorBuilder: (context, error, stackTrace) {
                // Fallback icon if asset fails
                return Icon(
                  isAccepted ? Icons.check_circle_outline : Icons.highlight_off,
                  color: isAccepted ? Colors.green : Colors.grey,
                  size: 24,
                );
              },
            ),
          ),
          const SizedBox(height: 6), // Adjusted spacing
          Text(
            label,
            style: TextStyle(
              fontSize: 13, // Slightly smaller text
              fontWeight: FontWeight.normal,
              color: isAccepted ? Colors.black87 : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVeganism(bool isVegan) {
    // ... (rest of _buildVeganism remains the same)
    return Column(
      // Removed Center as _buildSection handles alignment
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 45,
          height: 45,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(color: Colors.grey.shade300, width: 1),
          ),
          child: Image.asset(
            "assets/vegan.png", // Ensure this asset exists
            // Keep color tinting for vegan icon for clarity
            color:
                isVegan ? Colors.green.shade600 : Colors.grey.withOpacity(0.6),
            colorBlendMode: isVegan ? null : BlendMode.modulate,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                isVegan ? Icons.eco : Icons.not_interested,
                color: isVegan ? Colors.green.shade600 : Colors.grey,
                size: 24,
              );
            },
          ),
        ),
        const SizedBox(height: 6),
        Text(
          isVegan
              ? "Offers Vegan Options"
              : "No Specific Vegan Options", // More descriptive text
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.normal,
            color: isVegan ? Colors.green.shade700 : Colors.grey[600],
          ),
        ),
      ],
    );
  }
}

// =============================================
// DishCard Widget
// =============================================
// No changes needed in DishCard based on the new errors,
// assuming the 'allergens' list in the Dish object is populated correctly
// by the fixed _fetchDishesData method.
class DishCard extends StatefulWidget {
  final Dish
  dish; // Expects dish.allergens to be List<String> correctly populated
  final List<String> selectedAllergens;

  const DishCard({
    required this.dish,
    required this.selectedAllergens,
    super.key,
  });

  @override
  State<DishCard> createState() => _DishCardState();
}

class _DishCardState extends State<DishCard> {
  // State only needed to control the dropdown visibility
  bool _showAllergenDetails = false;
  // Removed: _isLoadingAllergens, _allergenDetails

  // Cache for local icons (keep this)
  final Map<String, String> _localBackupIcons = {
    "Egg": "assets/allergens/egg.png",
    "Wheat": "assets/allergens/wheat.png",
    "Peanut": "assets/allergens/peanut.png",
    "Milk": "assets/allergens/milk.png",
    "Soy": "assets/allergens/soy.png",
    "Tree Nut": "assets/allergens/tree_nut.png",
    "Fish": "assets/allergens/fish.png",
    "Shellfish": "assets/allergens/shellfish.png",
    "Sesame": "assets/allergens/sesame.png",
    "Gluten": "assets/allergens/wheat.png", // Example mapping
    // Add other allergens from your data if needed
  };
  final String _defaultAllergenIcon =
      "assets/allergens/default.png"; // Default icon asset path

  // Removed: _fetchAllergenDetails method

  @override
  Widget build(BuildContext context) {
    // Case-insensitive check for selected allergens
    final dishAllergensLower =
        widget.dish.allergens.map((a) => a.toLowerCase()).toSet();
    final selectedAllergensLower =
        widget.selectedAllergens.map((a) => a.toLowerCase()).toSet();
    final containsSelectedAllergens =
        dishAllergensLower.intersection(selectedAllergensLower).isNotEmpty;
    print(
      "--- DishCard build for '${widget.dish.name}': widget.dish.imagePath = '${widget.dish.imagePath}'",
    );
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            // Image, Badges, Name/Price Overlay
            children: [
              _buildDishImage(
                widget.dish.imagePath ?? 'assets/default_dish.png',
              ),
              Positioned(
                // Badges
                top: 8,
                left: 8,
                right: 8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (containsSelectedAllergens)
                      _buildBadge(
                        "⚠ Contains Selected Allergen",
                        Colors.red.withOpacity(0.9),
                        Icons.warning_amber_rounded,
                      ),
                    const Spacer(),
                    if (widget.dish.isVegan == true)
                      _buildBadge(
                        "Vegan",
                        Colors.green.withOpacity(0.85),
                        Icons.eco,
                      ),
                  ],
                ),
              ),
              Positioned(
                // Name/Price Overlay
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.75),
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          widget.dish.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.dish.price > 0
                            ? '\$${widget.dish.price.toStringAsFixed(2)}'
                            : 'TBD',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            // Description & Allergens
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.dish.description.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Text(
                      widget.dish.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        height: 1.4,
                      ),
                    ),
                  ),
                // Only build dropdown if allergens list is not empty
                if (widget.dish.allergens.isNotEmpty) _buildAllergenDropdown(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String text, Color color, IconData icon) {
    // ... (This helper remains the same) ...
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          // Add subtle shadow to badges
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 14),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11, // Slightly smaller badge text
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllergenDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Material(
          // Clickable header
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () {
              // *** FIX: Simply toggle the state, no fetch needed ***
              if (mounted) {
                setState(() {
                  _showAllergenDetails = !_showAllergenDetails;
                });
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Contains Allergens (${widget.dish.allergens.length})",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF7A4E2C),
                    ),
                  ),
                  Icon(
                    _showAllergenDetails
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 20,
                    color: const Color.fromARGB(255, 151, 73, 0),
                  ),
                ],
              ),
            ),
          ),
        ),
        AnimatedSize(
          // Animated dropdown content
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          child: Container(
            constraints: BoxConstraints(
              maxHeight: _showAllergenDetails ? 200 : 0,
            ), // Adjust max height if needed
            width: double.infinity,
            child:
                _showAllergenDetails
                    // *** FIX: Call the updated content builder ***
                    ? _buildAllergenDetailsContent()
                    : const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }

  // *** FIX: Rewritten content builder using only local assets ***
  Widget _buildAllergenDetailsContent() {
    // Check if there are allergens to display
    if (widget.dish.allergens.isEmpty) {
      return const SizedBox.shrink(); // Nothing to show
    }

    // Build the list of icons directly from widget.dish.allergens
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, left: 4, right: 4),
      child: Wrap(
        spacing: 8, // Horizontal space between items
        runSpacing: 10, // Vertical space between rows
        alignment: WrapAlignment.start,
        children:
            widget.dish.allergens.map((allergenName) {
              // Find the corresponding local icon path
              String localIconPath =
                  _localBackupIcons[allergenName] ??
                  _localBackupIcons[allergenName.split(' ').first] ??
                  _defaultAllergenIcon;

              // Check if this allergen is among the user's selected ones
              bool isSelected = widget.selectedAllergens.any(
                (sel) => sel.toLowerCase() == allergenName.toLowerCase(),
              );

              // Use the allergen name itself as the tooltip message
              String tooltipMessage = allergenName;

              return Tooltip(
                message: tooltipMessage,
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.symmetric(horizontal: 10),
                preferBelow: false,
                child: SizedBox(
                  width: 70, // Consistent width for each item
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        // Icon background
                        width: 40,
                        height: 40,
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color:
                                isSelected
                                    ? Colors.red.shade300
                                    : Colors.grey.shade300,
                            width: isSelected ? 1.5 : 1.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        // *** Use Image.asset directly ***
                        child: Center(
                          child: Image.asset(
                            localIconPath, // Use the determined local path
                            width: 28,
                            height: 28,
                            fit: BoxFit.contain,
                            color: const Color.fromARGB(
                              255,
                              107,
                              53,
                              1,
                            ), // Apply color tint
                            colorBlendMode: BlendMode.srcIn,
                            errorBuilder: (context, error, stackTrace) {
                              // Fallback if even the local asset fails
                              print(
                                "!!! Error loading local allergen asset: $localIconPath",
                              );
                              return Icon(
                                Icons.warning_amber_rounded,
                                color: const Color.fromARGB(255, 107, 53, 1),
                                size: 24,
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        // Allergen name text
                        allergenName,
                        style: TextStyle(
                          fontSize: 12,
                          color:
                              isSelected
                                  ? Colors.red.shade800
                                  : const Color.fromARGB(255, 107, 53, 1),
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }

  // Removed: _buildAllergenIconImage helper (logic moved into _buildAllergenDetailsContent)

  Widget _buildDishImage(String imagePath) {
    // ... (This helper remains the same) ...
    debugPrint(
      "--- [DishCard] Attempting to load image asset: '${widget.dish.imagePath}",
    );
    Widget placeholder = Container(
      height: 180,
      color: Colors.grey[300],
      child: const Center(
        child: Icon(
          Icons.restaurant_menu,
          size: 50,
          color: Colors.grey,
        ), // Different icon
      ),
    );

    if (imagePath.startsWith('http')) {
      return Image.network(
        imagePath,
        height: 180,
        width: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return placeholder; // Show placeholder while loading
        },
        errorBuilder:
            (context, error, stackTrace) =>
                placeholder, // Show placeholder on error
      );
    } else {
      // Assume asset path
      return Image.asset(
        imagePath,
        height: 180,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder:
            (context, error, stackTrace) =>
                placeholder, // Show placeholder on error
      );
    }
  }
}
