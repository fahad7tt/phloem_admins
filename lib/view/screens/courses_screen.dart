import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:phloem_admin/controller/course_controller.dart';
import 'package:phloem_admin/model/course_model.dart';
import 'package:provider/provider.dart';
import 'add_course_page.dart';
import 'edit_courses.dart';

class CourseScreen extends StatelessWidget {
  const CourseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Courses'),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('courses').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return GridView.builder(
             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2, // Number of columns in the grid
    crossAxisSpacing: 2, // Spacing between columns
    mainAxisSpacing: 2, // Spacing between rows
  ),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final Course course =
                  Course.fromSnapshot(snapshot.data!.docs[index]);
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Card(
                  elevation: 3,
                  child: GestureDetector(
                    onTap: () {
                      // Navigate to the EditCoursePage with the selected course
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
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20.0),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      confirmDismiss: (direction) async {
                        return await _confirmDismiss(context, course.id);
                      },
                      onDismissed: (direction) {
                        
                      },
                      child: ListTile(
                        title: Text(
                          course.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            for (int i = 0; i < course.modules.length; i++)
                              Text('Module ${i + 1} : ${course.modules[i]}'),
                            Text('Payment: ${course.payment}')
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddCoursePage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<bool> _confirmDismiss(BuildContext context, String id) async {
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