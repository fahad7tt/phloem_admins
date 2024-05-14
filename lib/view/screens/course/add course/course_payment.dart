import 'package:flutter/material.dart';

class PaymentDropdownFormField extends StatelessWidget {
  final void Function(String) onPaymentSelected;

  const PaymentDropdownFormField({
    super.key,
    required this.onPaymentSelected,
  });

  @override
  Widget build(BuildContext context) {
    String selectedPayment = '';

    return DropdownButtonFormField<String>(
      value: selectedPayment.isNotEmpty ? selectedPayment : null,
      onChanged: (value) {
        selectedPayment = value!;
        onPaymentSelected(value); // Notify parent
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a payment option';
        }
        return null;
      },
      items: ['free', 'paid']
          .map((payment) => DropdownMenuItem(
                value: payment,
                child: Text(payment),
              ))
          .toList(),
      decoration: const InputDecoration(
        labelText: 'Payment',
      ),
    );
  }
}