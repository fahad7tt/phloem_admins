import 'package:flutter/material.dart';
import 'package:phloem_admin/view/screens/course/add%20course/course_name.dart';
import 'package:phloem_admin/view/screens/course/add%20course/course_payment.dart';

class AddCourseForm extends StatefulWidget {
  final void Function(String, String, String?) onNextPressed;

  const AddCourseForm({
    super.key,
    required this.onNextPressed,
  });

  @override
  // ignore: library_private_types_in_public_api
  _AddCourseFormState createState() => _AddCourseFormState();
}

class _AddCourseFormState extends State<AddCourseForm> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController courseController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  String selectedPayment = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CourseNameFormField(controller: courseController),
          PaymentDropdownFormField(
            onPaymentSelected: (payment) {
              setState(() {
                selectedPayment = payment;
              });
            },
          ),
          if (selectedPayment == 'paid')
            TextFormField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount (₹)',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter an amount';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
          const SizedBox(height: 12),
          Center(
            child: ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  widget.onNextPressed(
                    courseController.text,
                    selectedPayment,
                    selectedPayment == 'paid' ? amountController.text : null,
                  );
                }
              },
              child: const Text('Next'),
            ),
          ),
        ],
      ),
    );
  }
}