import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:phloem_admin/controller/course_controller.dart';

class DismissConfirmationDialog {
  static Future<bool> show(BuildContext context, String id) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Confirm Deletion"),
              content:
                  const Text("Are you sure you want to delete this course?"),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    context
                        .read<CourseProvider>()
                        .deleteCourseFromFirestore(id);
                    Navigator.of(context).pop(true);
                  },
                  child: const Text("Delete"),
                ),
              ],
            );
          },
        ) ??
        false; // Return false if dialog is dismissed
  }
}
