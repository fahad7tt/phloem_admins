import 'package:flutter/material.dart';
import 'package:phloem_admin/model/course_model.dart';
import 'package:phloem_admin/view/screens/course/edit%20course/edit_form_utils.dart';
import 'package:phloem_admin/view/screens/course/edit%20course/edit_forms.dart';

class EditCourseForm extends StatefulWidget {
  final Course course;

  const EditCourseForm({super.key, required this.course});

  @override
  // ignore: library_private_types_in_public_api
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

  @override
  Widget build(BuildContext context) {
    // Create an instance of FormFieldBuilder
    EditFormBuilder formFieldBuilder = EditFormBuilder(
      _courseNameController,
      _moduleControllers,
      _descriptionControllers,
      _selectedPayment,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        formFieldBuilder.buildCourseNameField(),
        const SizedBox(height: 16),
        formFieldBuilder.buildPaymentDropdown(),
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
                          child: formFieldBuilder.buildModuleField(index),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    formFieldBuilder.buildDescriptionField(index),
                    const SizedBox(height: 16),
                    formFieldBuilder.buildRemoveModuleButton(
                        index,
                        () => showRemoveModuleDialog(
                            context,
                            _moduleControllers,
                            _descriptionControllers,
                            index)),
                    const SizedBox(height: 22),
                  ],
                ),
              );
            },
          ),
        ),
        formFieldBuilder.buildAddModuleButton(() {
          setState(() {
            _moduleControllers.add(TextEditingController());
            _descriptionControllers.add(TextEditingController());
          });
        }),
        const SizedBox(height: 22),
        formFieldBuilder.buildSaveChangesButton(() {
          // Validate the form
          if (validateForm(_courseNameController, _moduleControllers,
              _descriptionControllers, context)) {
            // Save changes and pop the page
            saveChanges(context, widget.course, _courseNameController,
                _moduleControllers, _selectedPayment, _descriptionControllers);
          }
        }),
      ],
    );
  }
}