import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:phloem_admin/controller/email_controller.dart';
import 'package:phloem_admin/controller/mentor_controller.dart';
import 'package:phloem_admin/model/course_model.dart';
import 'package:phloem_admin/model/mentor_model.dart';

class EditFieldBuilder {
 
  static Widget buildNameField(
      BuildContext context, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(labelText: 'Name'),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a name';
        }
        if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
          return 'Only alphabets are allowed for name';
        }
        return null;
      },
    );
  }

  static Widget buildEmailField(
      BuildContext context, TextEditingController controller) {
    return ChangeNotifierProvider(
      create: (_) => EmailValidationProvider(),
      child: Consumer<EmailValidationProvider>(
        builder: (context, emailValidationProvider, _) {
          return TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: 'Email',
              errorText: emailValidationProvider.emailErrorText,
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter an email';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                  .hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: (value) {
              emailValidationProvider.validateEmail(value);
            },
          );
        },
      ),
    );
  }

  static Widget buildPasswordField(
      BuildContext context, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(labelText: 'Password'),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a password';
        }
        if (value.length != 6) {
          return 'Password must be exactly 6 digits';
        }
        return null;
      },
    );
  }

  static Widget buildCoursesField(
      String initialValue,
      BuildContext context,
      TextEditingController controller,
      MentorProvider mentorProvider,
      Mentor mentor) {
    return FutureBuilder<List<Course>>(
      future: FirebaseFirestore.instance.collection('courses').get().then(
          (querySnapshot) => querySnapshot.docs
              .map((doc) => Course.fromSnapshot(doc))
              .toList()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final courses = snapshot.data!;
          // if (mentor.courses.isNotEmpty) {
          //   initialValue = courses.any(
          //           (course) => course.name == mentor.courses)
          //       ? mentor.courses
          //       : null;
          // }
          return DropdownButtonFormField<String>(
            value: initialValue,
            items: courses.map((course) {
              return DropdownMenuItem<String>(
                value: course.name,
                child: Text(course.name),
              );
            }).toList(),
            onChanged: (value) {
              print('=-================================ $value');
              controller.text = value!;
              final selectedCourse = courses.firstWhere(
                (course) => course.name == value,
                orElse: () => Course.empty,
              );
              mentorProvider.isSameCourse=false;
              mentorProvider.setSelectedCourse(value, selectedCourse.modules);
            },
            decoration: const InputDecoration(
              labelText: 'Courses',
            ),
            validator: (value) {
              if (value == null) {
                return 'Please select a course';
              }
              return null;
            },
          );
        }
      },
    );
  }

  static Widget buildModulesField(
      BuildContext context, MentorProvider mentorProvider,String id) {
    return Consumer<MentorProvider>(
      builder: (context, mentorProvider, _) {
        print('module refresh');
        print(mentorProvider.selectedCourseModules.contains(mentorProvider.selectedCourseModules[0]));

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text('Modules:'),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: mentorProvider.selectedCourseModules.length,
              itemBuilder: (context, index) {
                 
                 final module = mentorProvider.selectedCourseModules[index];
        
                log("$module module ");
                log("${mentorProvider.selectedModules}");
                log("${mentorProvider.selectedModules.contains(module)}");
                return CheckboxListTile(
                  title: Text(module),
                  value: mentorProvider.selectedModules.contains(module),
                  onChanged: (value) {
                    log('on tap');
                    mentorProvider.toggleSelectedModule(module);
                  },
                );
               
              },
            ),
          ],
        );
      },
    );
  }
}