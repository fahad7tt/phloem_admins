// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';

class CourseNameFormField extends StatelessWidget {
  final TextEditingController controller;

  const CourseNameFormField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'Course Name',
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a course name';
        }
        return null;
      },
      onSaved: (value) {},
    );
  }
}