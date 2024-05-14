import 'package:flutter/material.dart';
import 'package:phloem_admin/view/screens/course/add%20course/course_name.dart';
import 'package:phloem_admin/view/screens/course/add%20course/course_payment.dart';

class AddCourseForm extends StatelessWidget {
  final void Function(String, String) onNextPressed;

  const AddCourseForm({
    super.key,
    required this.onNextPressed,
  });

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController courseController = TextEditingController();
    String selectedPayment = '';

    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CourseNameFormField(controller: courseController),
          PaymentDropdownFormField(
            onPaymentSelected: (payment) {
              selectedPayment = payment;
            },
          ),
          const SizedBox(height: 6),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();
                onNextPressed(courseController.text, selectedPayment);
              }
            },
            child: const Text('Next'),
          ),
        ],
      ),
    );
  }
}