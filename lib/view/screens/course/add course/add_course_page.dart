import 'package:flutter/material.dart';
import 'package:phloem_admin/controller/course_controller.dart';
import 'package:phloem_admin/view/screens/course/add%20course/course_form.dart';
import 'package:phloem_admin/view/screens/modules/add_modules.dart';
import 'package:phloem_admin/view/widgets/appbar/appbar_const.dart';
import 'package:provider/provider.dart';

class AddCoursePage extends StatelessWidget {
  const AddCoursePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FAppBar.addCourseAppBar,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: AddCourseForm(
            onNextPressed: (String courseName, String selectedPayment, String? amount) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => AddModulesPage(
                    courseName: courseName,
                    payment: selectedPayment,
                    amount: amount ?? '',
                  ),
                ),
              ).then((value) {
                if (value != null && value is Map<String, List<String>>) {
                  // Handle returned modules and descriptions
                  List<String> returnedModules = value['modules'] ?? [];
                  List<String> returnedDescriptions =
                      value['descriptions'] ?? [];

                  // Add returned modules and descriptions to the course
                  Provider.of<CourseProvider>(context, listen: false).addCourse(
                    courseName,
                    returnedModules,
                    selectedPayment,
                    returnedDescriptions,
                    amount ?? ''
                  );
                }
              });
            },
          ),
        ),
      ),
    );
  }
}