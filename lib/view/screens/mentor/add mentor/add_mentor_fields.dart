import 'package:flutter/material.dart';

class NameField extends StatelessWidget {
  final TextEditingController controller;
  
  const NameField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(labelText: 'Name'),
      validator: (value) => _validateName(value),
    );
  }

  String? _validateName(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Please enter a name';
    }
    if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value!)) {
      return 'Only alphabets are allowed for name';
    }
    return null;
  }
}

class EmailField extends StatelessWidget {
  final TextEditingController controller;

  const EmailField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(labelText: 'Email'),
      validator: (value) => _validateEmail(value),
    );
  }

  String? _validateEmail(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Please enter an email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
      return 'Please enter a valid email';
    }
    return null;
  }
}

class PasswordField extends StatelessWidget {
  final TextEditingController controller;

  const PasswordField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(labelText: 'Password'),
      keyboardType: TextInputType.number,
      validator: (value) => _validatePassword(value),
    );
  }

  String? _validatePassword(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Please enter a password';
    }
    if (value!.length != 6) {
      return 'Password must be exactly 6 digits';
    }
    return null;
  }
}

class ModuleCheckboxList extends StatelessWidget {
  final List<String> modules;
  final List<String> selectedModules;
  final Function(String) onModuleSelected;

  const ModuleCheckboxList({super.key, 
    required this.modules,
    required this.selectedModules,
    required this.onModuleSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        const Text('Modules:'),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: modules.length,
          itemBuilder: (context, index) {
            final module = modules[index];

            return CheckboxListTile(
              title: Text(module),
              value: selectedModules.contains(module),
              onChanged: (value) {
                onModuleSelected(module);
              },
            );
          },
        ),
      ],
    );
  }
}