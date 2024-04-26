// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:phloem_admin/controller/course_controller.dart';
import 'package:phloem_admin/model/course_model.dart';
import 'package:provider/provider.dart';

class EditCoursePage extends StatelessWidget {
  final Course course;

  // ignore: use_key_in_widget_constructors
  const EditCoursePage({required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Course'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: EditCourseForm(course: course),
      ),
    );
  }
}

class EditCourseForm extends StatefulWidget {
  final Course course;

  const EditCourseForm({super.key, required this.course});

  @override
  _EditCourseFormState createState() => _EditCourseFormState();
}

class _EditCourseFormState extends State<EditCourseForm> {
  late TextEditingController _courseNameController;
  late List<TextEditingController> _moduleControllers;
  late List<TextEditingController> _descriptionControllers;
  late TextEditingController _paymentController;
  String _selectedPayment = '';

  @override
  void initState() {
    super.initState();
    _courseNameController = TextEditingController(text: widget.course.name);
    _moduleControllers = List.generate(
      widget.course.modules.length,
      (index) => TextEditingController(text: widget.course.modules[index]),
    );
    _descriptionControllers = List.generate(
      widget.course.descriptions.length,
      (index) => TextEditingController(text: widget.course.descriptions[index]),
    );
    _selectedPayment = widget.course.payment;
    _paymentController = TextEditingController(text: _selectedPayment);
  }

  @override
  void dispose() {
    _courseNameController.dispose();
    for (var controller in _moduleControllers) {
      controller.dispose();
    }
    for (var controller in _descriptionControllers) {
      controller.dispose();
    }
    _paymentController.dispose();
    super.dispose();
  }

  // Function to show dialog before removing module
  Future<void> _showRemoveModuleDialog(int index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button to close dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Remove Module'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to remove this module?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Remove'),
              onPressed: () {
                setState(() {
                  _moduleControllers.removeAt(index);
                  _descriptionControllers.removeAt(index);
                });
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _courseNameController,
          decoration: const InputDecoration(labelText: 'Course Name'),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter a course name';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: _selectedPayment,
          onChanged: (value) {
            setState(() {
              _selectedPayment = value!;
            });
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
        ),
        const SizedBox(height: 16),
        const Text('Modules',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _moduleControllers.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _moduleControllers[index],
                            decoration: InputDecoration(
                              labelText: 'Module ${index + 1} Name',
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a module name';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _descriptionControllers[index],
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
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: 93,
                      height: 32,
                      child: ElevatedButton(
                        onPressed: () {
                          _showRemoveModuleDialog(index);
                        },
                        child: const Text('Remove',
                            style: TextStyle(fontSize: 12)),
                      ),
                    ),
                    const SizedBox(height: 22),
                  ],
                ),
              );
            },
          ),
        ),
        Center(
          child: SizedBox(
            width: 115,
            height: 35,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _moduleControllers.add(TextEditingController());
                  _descriptionControllers.add(TextEditingController());
                });
              },
              child: const Text('Add Module', style: TextStyle(fontSize: 12)),
            ),
          ),
        ),
        const SizedBox(height: 22),
        Center(
          child: ElevatedButton(
            onPressed: () {
              // Validate the form
              if (_validateForm()) {
                // Save changes and pop the page
                saveChanges(context);
              }
            },
            child: const Text('Save Changes'),
          ),
        ),
      ],
    );
  }

  bool _validateForm() {
    // Validate course name
    if (_courseNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a course name')));
      return false;
    }

    // Validate module names and descriptions
    for (int i = 0; i < _moduleControllers.length; i++) {
      if (_moduleControllers[i].text.isEmpty ||
          _descriptionControllers[i].text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Please enter all module names and descriptions')));
        return false;
      }
    }
    return true;
  }

  void saveChanges(BuildContext context) {
    final courseProvider = Provider.of<CourseProvider>(context, listen: false);
    final newCourseName = _courseNameController.text;
    final newModules =
        _moduleControllers.map((controller) => controller.text).toList();
    final newPayment = _selectedPayment;
    final newDescriptions =
        _descriptionControllers.map((controller) => controller.text).toList();

    // Update the course in the provider
    courseProvider.updateCourse(
        widget.course, newCourseName, newModules, newPayment, newDescriptions);

    // Navigate back to the previous screen
    Navigator.pop(context);
  }
}