import 'package:flutter/material.dart';
import 'package:phloem_admin/view/const/color/colors.dart';
import 'package:provider/provider.dart';
import 'package:phloem_admin/controller/course_controller.dart';
import 'package:phloem_admin/model/course_model.dart';

bool validateForm(
    TextEditingController courseNameController,
    List<TextEditingController> moduleControllers,
    List<TextEditingController> descriptionControllers,
    TextEditingController amountController,
    BuildContext context) {
  // Validate course name
  if (courseNameController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a course name')));
    return false;
  }

  // Validate module names and descriptions
  for (int i = 0; i < moduleControllers.length; i++) {
    if (moduleControllers[i].text.isEmpty ||
        descriptionControllers[i].text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please enter all module names and descriptions')));
      return false;
    }
  }

  // Validate amount if payment is 'paid'
  if (amountController.text.isNotEmpty) {
    if (double.tryParse(amountController.text) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid amount')));
    return false;
    }
  }
  return true;
}

Future<void> showRemoveModuleDialog(
    BuildContext context,
    List<TextEditingController> moduleControllers,
    List<TextEditingController> descriptionControllers,
    int index) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
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
              moduleControllers.removeAt(index);
              descriptionControllers.removeAt(index);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void saveChanges(
    BuildContext context,
    Course course,
    TextEditingController courseNameController,
    List<TextEditingController> moduleControllers,
    String selectedPayment,
    List<TextEditingController> descriptionControllers,
    TextEditingController amountController){
  final courseProvider = Provider.of<CourseProvider>(context, listen: false);
  final newCourseName = courseNameController.text;
  final newModules =
      moduleControllers.map((controller) => controller.text).toList();
  final newPayment = selectedPayment;
  final newDescriptions =
      descriptionControllers.map((controller) => controller.text).toList();
  final newAmount = selectedPayment == 'paid' ? amountController.text : '0';

  courseProvider.updateCourse(
      course, newCourseName, newModules, newPayment, newDescriptions, newAmount);

  Navigator.pop(context);

  ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Course details updated successfully'),
                  backgroundColor: FColors.themeColor,
                  duration: Duration(seconds: 2),
                ),
              );
}