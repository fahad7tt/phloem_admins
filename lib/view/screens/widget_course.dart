import 'package:flutter/material.dart';
import 'package:phloem_admin/controller/course_controller.dart';
import 'package:provider/provider.dart';

import 'add_modules.dart';

class FormFieldsBuilder {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _courseController = TextEditingController();
  String _selectedPayment = '';
  final String _courseName = '';

  Widget buildCourseNameFormField() {
    return TextFormField(
      controller: _courseController,
      decoration: const InputDecoration(
        labelText: 'Course Name',
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a course name';
        }
        return null;
      },
      onSaved: (value) {
      },
    );
  }

  Widget buildPaymentDropdownFormField() {
    return DropdownButtonFormField<String>(
      value: _selectedPayment.isNotEmpty ? _selectedPayment : null,
      onChanged: (value) {
        _selectedPayment = value!;
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

  Widget buildNextButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AddModulesPage(
                courseName: _courseName,
                payment: _selectedPayment,
              ),
            ),
          ).then((value) {
            if (value != null && value is Map<String, List<String>>) {
              List<String> returnedModules = value['modules'] ?? [];
              List<String> returnedDescriptions = value['descriptions'] ?? [];

              Provider.of<CourseProvider>(context, listen: false)
                  .addCourse(_courseName, returnedModules, _selectedPayment, returnedDescriptions);
            }
          });
        }
      },
      child: const Text('Next'),
    );
  }
}