// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:phloem_admin/controller/mentor_controller.dart';
import 'package:phloem_admin/model/course_model.dart';
import 'package:phloem_admin/model/mentor_model.dart';
import 'package:phloem_admin/view/screens/mentor/add%20mentor/add_mentor_fields.dart';
import 'package:provider/provider.dart';

class CourseDropdown extends StatelessWidget {
  final MentorProvider mentorProvider;

  const CourseDropdown({super.key, required this.mentorProvider});

  @override
  Widget build(BuildContext context) {
    return Consumer<MentorProvider>(
      builder: (context, mentorProvider, _) {
        return FutureBuilder<List<Course>>(
          future: mentorProvider.fetchCourses(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final courses = snapshot.data!;
              return DropdownButtonFormField<String>(
                value: mentorProvider.selectedCourses.isNotEmpty
                    ? mentorProvider.selectedCourses.first
                    : null,
                items: courses
                    .map((course) => DropdownMenuItem<String>(
                          value: course.name,
                          child: Text(course.name),
                        ))
                    .toList(),
                onChanged: (value) {
                  mentorProvider.resetState();
                  mentorProvider.toggleSelectedCourse(value!);
                },
                decoration: const InputDecoration(labelText: 'Courses'),
                validator: (value) =>
                    value == null ? 'Please select a course' : null,
              );
            }
          },
        );
      },
    );
  }
}

class ModuleCheckboxListWidget extends StatelessWidget {
  final MentorProvider mentorProvider;

  const ModuleCheckboxListWidget({super.key, required this.mentorProvider});

  @override
  Widget build(BuildContext context) {
    return Consumer<MentorProvider>(
      builder: (context, mentorProvider, _) {
        return FutureBuilder<List<Course>>(
          future: mentorProvider.fetchCourses(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final courses = snapshot.data!;
              final selectedCourse = mentorProvider.selectedCourses.isNotEmpty
                  ? courses.firstWhere(
                      (course) =>
                          course.name == mentorProvider.selectedCourses.first,
                      orElse: () => Course.empty,
                    )
                  : Course.empty;

              return ModuleCheckboxList(
                modules: selectedCourse.modules,
                selectedModules: mentorProvider.selectedModules,
                onModuleSelected: (module) {
                  mentorProvider.toggleSelectedModule(module);
                },
              );
            }
          },
        );
      },
    );
  }
}

class ImagePickerWidget extends StatelessWidget {
  final File? imageFile;
  final Function() getImage;

  const ImagePickerWidget({super.key, required this.imageFile, required this.getImage});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: imageFile == null
          ? GestureDetector(
              child: ElevatedButton(
                onPressed: getImage,
                child: const Text('Add Image'),
              ),
            )
          : Image.file(
              imageFile!,
              height: 200,
              width: 200,
              fit: BoxFit.cover,
            ),
    );
  }
}

class AddMentorButton extends StatelessWidget {
  final MentorProvider mentorProvider;
  final GlobalKey<FormState> formKey;
  final File? imageFile;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const AddMentorButton({super.key, 
    required this.mentorProvider,
    required this.formKey,
    required this.imageFile,
    required this.passwordController,
    required this.nameController,
    required this.emailController,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          if (formKey.currentState!.validate()) {
            _showProgressIndicator(true);
            final isPasswordUnique =
                await mentorProvider.isPasswordUnique(passwordController.text);

            if (!isPasswordUnique) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Password already exists'),
                  duration: Duration(seconds: 3),
                ),
              );
            } else {
              bool isEmailUnique =
                  await mentorProvider.isEmailUnique(emailController.text);

              if (isEmailUnique) {
                String? imageUrl;
                if (imageFile != null) {
                  imageUrl = await mentorProvider.uploadImage(imageFile!);
                }

                mentorProvider.addMentorToFirestore(
                  Mentor(
                    name: nameController.text,
                    email: emailController.text,
                    password: passwordController.text,
                    courses: mentorProvider.selectedCourses.join(', '),
                    imageUrl: imageUrl ?? '',
                    id: '',
                    selectedModule: mentorProvider.selectedModules,
                  ),
                );

                mentorProvider.resetSelectedCourses();

                Navigator.pop(context);
                _showProgressIndicator(false);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Email already exists'),
                    duration: Duration(seconds: 3),
                  ),
                );
              }
            }
          }
        },
        child: const Text('Add Mentor'),
      ),
    );
  }

  void _showProgressIndicator(bool show) {
    mentorProvider.setLoading(show);
  }
}