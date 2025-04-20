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
    final payments = ["Cash", "Venmo", "Zelle", "Credit Card", "PayPal"];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children:
          payments.map((method) {
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

class _PaymentFilterItem extends StatelessWidget {
  final String method;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentFilterItem({
    required this.method,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 10,
                  spreadRadius: 0,
                ),
              ],
              border: Border.all(
                color:
                    isSelected
                        ? const Color.fromARGB(255, 255, 217, 0)
                        : Colors.transparent,
                width: 2,
              ),
            ),
            child: Center(
              child: Image.asset(
                'assets/payments/${method.toLowerCase().replaceAll(' ', '_')}.png',
                width: 44,
                height: 44,
                color: isSelected ? null : Colors.grey.withOpacity(0.5),
                colorBlendMode: BlendMode.modulate,
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 40, // bump this up a bit more
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: 4.0,
              ), // 👈 add a bit of bottom padding
              child: Text(
                method == "Credit Card" ? "Credit\nCard" : method,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: isSelected ? Colors.black : Colors.grey[400],
                  fontWeight: FontWeight.normal,
                  height: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
