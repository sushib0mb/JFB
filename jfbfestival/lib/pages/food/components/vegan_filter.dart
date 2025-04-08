import 'package:flutter/material.dart';

class VeganFilterOption extends StatefulWidget {
  final bool isVegan;
  final Function(bool) onChanged;

  const VeganFilterOption({
    required this.isVegan,
    required this.onChanged,
    super.key,
  });

  @override
  State<VeganFilterOption> createState() => _VeganFilterOptionState();
}

class _VeganFilterOptionState extends State<VeganFilterOption> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () => widget.onChanged(!widget.isVegan),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: widget.isVegan
                ? Colors.green.withOpacity(0.2)
                : _isHovered
                    ? Colors.grey.withOpacity(0.1)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: widget.isVegan
                  ? Colors.green
                  : _isHovered
                      ? Colors.grey[400]!
                      : Colors.grey[300]!,
              width: widget.isVegan ? 2 : 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: _isHovered || widget.isVegan ? 1 : 0.7,
                child: Image.asset(
                  'assets/vegan.png',
                  width: 24,
                  color: widget.isVegan
                      ? Colors.green
                      : _isHovered
                          ? Colors.grey[800]
                          : Colors.grey[600],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Vegan',
                style: TextStyle(
                  fontWeight: widget.isVegan ? FontWeight.bold : FontWeight.normal,
                  color: widget.isVegan
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
    );
  }
}