import 'package:flutter/material.dart';

class AllergyFilterGrid extends StatelessWidget {
  final Set<String> selectedAllergens;
  final Function(String, bool) onAllergenSelected;

  const AllergyFilterGrid({
    required this.selectedAllergens,
    required this.onAllergenSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const allergens = [
      "Egg",
      "Wheat",
      "Peanut",
      "Milk",
      "Soy",
      "Tree Nut",
      "Fish",
      "Shellfish",
      "Sesame",
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      childAspectRatio: 1.4,
      children:
          allergens.map((allergen) {
            final isSelected = selectedAllergens.contains(allergen);
            return GestureDetector(
              onTap: () => onAllergenSelected(allergen, !isSelected),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 10,
                          spreadRadius: 0,
                        ),
                      ],
                      border: Border.all(
                        color: isSelected ? Colors.red : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/allergens/${allergen.toLowerCase().replaceAll(' ', '_')}.png',
                        width: 28,
                        height: 28,
                        color: isSelected ? null : Colors.grey.withOpacity(0.5),
                        colorBlendMode: BlendMode.modulate,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    allergen,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: isSelected ? Colors.black : Colors.grey[400],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }
}
