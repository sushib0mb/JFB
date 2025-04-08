import 'package:flutter/material.dart';

class PaymentFilterRow extends StatelessWidget {
  final Set<String> selectedPayments;
  final Function(String, bool) onPaymentSelected;

  const PaymentFilterRow({
    required this.selectedPayments,
    required this.onPaymentSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final payments = ['Cash', 'Venmo', 'Zelle', 'PayPal'];
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: payments.map((method) {
        final isSelected = selectedPayments.contains(method);
        return _PaymentFilterItem(
          method: method,
          isSelected: isSelected,
          onTap: () => onPaymentSelected(method, !isSelected),
        );
      }).toList(),
    );
  }
}

class _PaymentFilterItem extends StatefulWidget {
  final String method;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentFilterItem({
    required this.method,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_PaymentFilterItem> createState() => _PaymentFilterItemState();
}

class _PaymentFilterItemState extends State<_PaymentFilterItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? Colors.blue.withOpacity(0.2)
                : _isHovered
                    ? Colors.grey.withOpacity(0.1)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: widget.isSelected
                  ? Colors.blue
                  : _isHovered
                      ? Colors.grey[400]!
                      : Colors.grey[300]!,
              width: widget.isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: _isHovered || widget.isSelected ? 1 : 0.7,
                child: Image.asset(
                  'assets/payments/${widget.method.toLowerCase()}.png',
                  width: 40,
                  color: widget.isSelected
                      ? Colors.blue
                      : _isHovered
                          ? Colors.grey[800]
                          : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.method,
                style: TextStyle(
                  fontWeight: widget.isSelected ? FontWeight.bold : FontWeight.normal,
                  color: widget.isSelected
                      ? Colors.blue
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