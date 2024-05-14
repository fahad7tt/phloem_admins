import 'package:flutter/material.dart';
import 'package:phloem_admin/model/course_model.dart';
import 'package:phloem_admin/view/const/appbar/appbar_const.dart';
import 'package:phloem_admin/view/screens/course/edit%20course/edit_courses.dart';

class EditCoursePage extends StatelessWidget {
  final Course course;

  // ignore: use_key_in_widget_constructors
  const EditCoursePage({required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FAppBar.editCourseAppBar,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: EditCourseForm(course: course),
      ),
    );
  }
}