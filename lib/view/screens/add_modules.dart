import 'package:flutter/material.dart';
import 'package:phloem_admin/controller/course_controller.dart';
import 'package:provider/provider.dart';

import 'widget_module.dart';

// ignore: must_be_immutable
class AddModulesPage extends StatelessWidget {
  final String courseName;
  final String payment;

  AddModulesPage({super.key, required this.courseName, required this.payment});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _moduleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final List<String> modules = [];
  final List<String> descriptions = [];

  int moduleCount = 0;

  @override
  Widget build(BuildContext context) {
        final moduleFormFieldsBuilder = ModuleFormFieldsBuilder();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Modules'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Course Name: $courseName',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              moduleFormFieldsBuilder.buildModuleFormField(),
              const SizedBox(height: 10),
              moduleFormFieldsBuilder.buildDescriptionFormField(),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    modules.add(_moduleController.text);
                    descriptions.add(_descriptionController.text);
                    _moduleController.clear();
                    _descriptionController.clear();
                    moduleCount++;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Module $moduleCount added'),
                      ),
                    );
                  }
                },
                child: const Text('Add Module'),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Consumer<CourseProvider>(
                  builder: (context, courseProvider, child) {
                    return ListView.builder(
                      itemCount: modules.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text('Module ${index + 1}: ${modules[index]}'),
                          subtitle: Text(
                              'Description for Module ${index + 1}: ${descriptions[index]}'),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Provider.of<CourseProvider>(context, listen: false)
                      .addCourse(courseName, modules, payment, descriptions);
                  Navigator.pop(context);
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}