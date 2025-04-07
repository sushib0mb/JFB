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
          return _AllergyFilterItem(
            allergen: allergen,
            isSelected: selectedAllergens.contains(allergen),
            onChanged: (isSelected) => onAllergenSelected(allergen, isSelected),
          );
        }).toList(),
      ),
    );
  }
}

class _AllergyFilterItem extends StatefulWidget {
  final String allergen;
  final bool isSelected;
  final Function(bool) onChanged;

  const _AllergyFilterItem({
    required this.allergen,
    required this.isSelected,
    required this.onChanged,
  });

  @override
  State<_AllergyFilterItem> createState() => _AllergyFilterItemState();
}

class _AllergyFilterItemState extends State<_AllergyFilterItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => widget.onChanged(!widget.isSelected),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? Colors.red.withOpacity(0.2)
                : _isHovered
                    ? Colors.grey.withOpacity(0.1)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: widget.isSelected
                  ? Colors.red
                  : _isHovered
                      ? Colors.grey[400]!
                      : Colors.grey[300]!,
              width: widget.isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: _isHovered || widget.isSelected ? 1 : 0.7,
                child: Image.asset(
                  'assets/allergens/${widget.allergen.toLowerCase().replaceAll(' ', '_')}.png',
                  width: 24,
                  color: widget.isSelected
                      ? Colors.red
                      : _isHovered
                          ? Colors.grey[800]
                          : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.allergen,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: widget.isSelected ? FontWeight.bold : FontWeight.normal,
                  color: widget.isSelected
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
    );
  }
}