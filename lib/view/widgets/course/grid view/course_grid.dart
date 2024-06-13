import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:phloem_admin/model/course_model.dart';
import 'package:phloem_admin/view/const/color/colors.dart';
import 'package:phloem_admin/view/const/icon/icon_const.dart';
import 'package:phloem_admin/view/screens/course/edit%20course/edit_screen.dart';
import 'package:phloem_admin/view/widgets/course/dismiss/course_dismiss.dart';

class CourseGridView extends StatelessWidget {
  final List<DocumentSnapshot> courseDocuments;

  const CourseGridView({super.key, required this.courseDocuments});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Number of columns in the grid
        crossAxisSpacing: 2, // Spacing between columns
        mainAxisSpacing: 2, // Spacing between rows
      ),
      itemCount: courseDocuments.length,
      itemBuilder: (context, index) {
        final Course course = Course.fromSnapshot(courseDocuments[index]);
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 3,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditCoursePage(course: course),
                  ),
                );
              },
              child: Dismissible(
                key: Key(course.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: FColors.errorColor,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20.0),
                  child: FIcons.removeIcon
                ),
                confirmDismiss: (direction) async {
                  return await DismissConfirmationDialog.show(context, course.id);
                },
                onDismissed: (direction) {},
                child: ListTile(
                  title: Padding(
                    padding: const EdgeInsets.only(left: 26),
                    child: Text(
                      course.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 6),
                      const Text('Modules: ',
                      style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black)),
                      for (int i = 0; i < course.modules.length; i++)
                        Text(course.modules[i],
                        style: const TextStyle(fontSize: 14)),
                        const SizedBox(height: 6),
                      RichText(
                      text: TextSpan(
                      text: 'Payment: ',
                      style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                        text: course.payment,
                        style: const TextStyle(fontWeight: FontWeight.w400)),
                      ]),
                      ),
                      const SizedBox(height: 6),
                      if(course.payment == 'paid')
                      RichText(
                      text: TextSpan(
                      text: 'Amount: ',
                      style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                        text: course.amount,
                        style: const TextStyle(fontWeight: FontWeight.w400)),
                      ]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}