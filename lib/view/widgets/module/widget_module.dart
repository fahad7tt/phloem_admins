 import 'package:flutter/material.dart';

class ModuleFormFieldsBuilder{
  final TextEditingController moduleController;
  final TextEditingController descriptionController;

  ModuleFormFieldsBuilder({
    required this.moduleController,
    required this.descriptionController,
  });

Widget buildModuleFormField() {
    return TextFormField(
      controller: moduleController,
      decoration: const InputDecoration(
        labelText: 'Module',
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a module name';
        }
        return null;
      },
    );
  }

  Widget buildDescriptionFormField() {
    return TextFormField(
      controller: descriptionController,
      maxLines: 3,
      decoration: const InputDecoration(
        labelText: 'Description',
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a description';
        }
        return null;
      },
    );
  }
}