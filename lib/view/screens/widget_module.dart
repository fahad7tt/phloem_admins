 import 'package:flutter/material.dart';

class ModuleFormFieldsBuilder{
  final TextEditingController _moduleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

Widget buildModuleFormField() {
    return TextFormField(
      controller: _moduleController,
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
      controller: _descriptionController,
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