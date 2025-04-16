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
  @override
  Widget build(BuildContext context) {
    final isVegan = widget.isVegan;

    return GestureDetector(
      onTap: () => widget.onChanged(!isVegan),
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
                color: isVegan ? Colors.green : Colors.transparent,
                width: 2,
              ),
            ),
            child: Center(
              child: Image.asset(
                'assets/vegan.png',
                width: 44,
                height: 44,
                color: isVegan ? null : Colors.grey.withOpacity(0.5),
                colorBlendMode: BlendMode.modulate,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isVegan ? 'Vegan' : 'Not Vegan',
            style: TextStyle(
              fontSize: 16,
              color: isVegan ? Colors.black : Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }
}
