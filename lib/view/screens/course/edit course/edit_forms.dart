import 'package:flutter/material.dart';

class EditFormBuilder {
  late TextEditingController courseNameController;
  late List<TextEditingController> moduleControllers;
  late List<TextEditingController> descriptionControllers;
  late String selectedPayment;

  EditFormBuilder(
      this.courseNameController,
      this.moduleControllers,
      this.descriptionControllers,
      this.selectedPayment,
      );

  Widget buildCourseNameField() {
    return TextFormField(
      controller: courseNameController,
      decoration: const InputDecoration(labelText: 'Course Name'),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a course name';
        }
        return null;
      },
    );
  }

  Widget buildPaymentDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedPayment,
      onChanged: (value) {
        selectedPayment = value!;
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

  Widget buildModuleField(int index) {
    return TextFormField(
      controller: moduleControllers[index],
      decoration: InputDecoration(
        labelText: 'Module ${index + 1} Name',
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a module name';
        }
        return null;
      },
    );
  }

  Widget buildDescriptionField(int index) {
    return TextFormField(
      controller: descriptionControllers[index],
      maxLines: 3,
      decoration: InputDecoration(
        labelText: 'Description for Module ${index + 1}',
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a description';
        }
        return null;
      },
    );
  }

  Widget buildRemoveModuleButton(int index, VoidCallback onPressed) {
    return SizedBox(
      width: 93,
      height: 32,
      child: ElevatedButton(
        onPressed: onPressed,
        child: const Text('Remove', style: TextStyle(fontSize: 12)),
      ),
    );
  }

  Widget buildAddModuleButton(VoidCallback onPressed) {
    return Center(
      child: SizedBox(
        width: 115,
        height: 35,
        child: ElevatedButton(
          onPressed: onPressed,
          child: const Text('Add Module', style: TextStyle(fontSize: 12)),
        ),
      ),
    );
  }

  Widget buildSaveChangesButton(VoidCallback onPressed) {
    return Center(
      child: ElevatedButton(
        onPressed: onPressed,
        child: const Text('Save Changes'),
      ),
    );
  }
}