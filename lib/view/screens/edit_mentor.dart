import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phloem_admin/controller/email_controller.dart';
import 'package:phloem_admin/controller/mentor_controller.dart';
import 'package:phloem_admin/model/course_model.dart';
import 'package:phloem_admin/model/mentor_model.dart';
import 'package:provider/provider.dart';

class EditMentorPage extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final snapshot;
  final String id;

  const EditMentorPage({super.key, required this.snapshot, required this.id});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final mentorProvider = Provider.of<MentorProvider>(context, listen: false);
    final Mentor mentored = Mentor(
      name: snapshot["name"],
      email: snapshot["email"],
      password: snapshot["password"],
      courses: snapshot["courses"],
      imageUrl: snapshot["image"],
      id: id,
      selectedModules: snapshot["modules"] != null
          ? List<String>.from(snapshot["modules"])
          : [],
    );

    final formKey = GlobalKey<FormState>();
    final picker = ImagePicker();
    TextEditingController nameController =
        TextEditingController(text: mentored.name);
    TextEditingController emailController =
        TextEditingController(text: mentored.email);
    TextEditingController passwordController =
        TextEditingController(text: mentored.password);
    TextEditingController coursesController =
        TextEditingController(text: mentored.courses);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Mentor'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<MentorProvider>(
            builder: (context, mentorProvider, _) {
              final mentor = mentored;
              return Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: nameController,
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
                    ),
                    ChangeNotifierProvider(
                      create: (_) => EmailValidationProvider(),
                      child: Consumer<EmailValidationProvider>(
                        builder: (context, emailValidationProvider, _) {
                          return TextFormField(
                            controller: emailController,
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
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            onChanged: (value) {
                              emailValidationProvider.validateEmail(value);
                            },
                          );
                        },
                      ),
                    ),
                    TextFormField(
                      controller: passwordController,
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
                    ),
                    const SizedBox(height: 20),
                    FutureBuilder<List<Course>>(
                      future: FirebaseFirestore.instance
            .collection('courses')
            .get()
            .then((querySnapshot) => querySnapshot.docs
                .map((doc) => Course.fromSnapshot(doc))
                .toList()),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else {
                          final courses = snapshot.data!;
                          String? initialValue;
                          if (mentored.courses.isNotEmpty) {
                             initialValue = courses.any(
                                    (course) => course.name == mentored.courses)
                                ? mentored.courses
                                : null;
                          }

                          return DropdownButtonFormField<String>(
                            value: mentorProvider.selectedCourse ?? initialValue,
                            items: courses.map((course) {
                              return DropdownMenuItem<String>(
                                value: course.name,
                                child: Text(course.name),
                              );
                            }).toList(),
                            onChanged: (value) {
                              coursesController.text = value!;
                              // Update selected modules based on the selected course
                              final selectedCourse = courses.firstWhere(
                                (course) => course.name == value,
                                orElse: () => Course.empty,
                              );
                              mentorProvider.setSelectedCourse(value, selectedCourse.modules); // Update selected course and modules
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
                    ),
                    // Modules CheckboxListTile
                    const SizedBox(height: 20),
                          Consumer<MentorProvider>(
                            builder: (context, mentorProvider, _) {
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
                              
                                      return CheckboxListTile(
                                        title: Text(module),
                                        value: mentorProvider.selectedModules.contains(module),
                                        onChanged: (value) {
                                          mentorProvider
                                              .toggleSelectedModule(module);
                                        },
                                      );
                                    },
                                  ),
                                ],
                              );
                            }
                          ),
                    const SizedBox(height: 25),
                    Center(
                      child: GestureDetector(
                          onTap: () async {
                            final pickedFile = await picker.pickImage(
                                source: ImageSource.gallery);
                            if (pickedFile != null) {
                              mentorProvider
                                  .setSelectedImage(File(pickedFile.path));
                            }
                          },
                          child: mentorProvider.selectedImage != null
                              ? Image.file(
                                  mentorProvider.selectedImage!,
                                  height: 200,
                                  width: 200,
                                  fit: BoxFit.cover,
                                )
                              : mentored.imageUrl.isNotEmpty
                                  ? Image.network(
                                      mentored.imageUrl,
                                      height: 200,
                                      width: 200,
                                      fit: BoxFit.cover,
                                    )
                                  : const Text('Tap to select an image')),
                    ),

                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            String? imageUrl;
                            if (mentorProvider.selectedImage != null) {
                              // Upload the image and get the URL
                              imageUrl = await mentorProvider
                                  .uploadImage(mentorProvider.selectedImage!);
                            } else {
                              // If no new image is selected, use the existing image URL
                              imageUrl = mentor.imageUrl;
                            }
                            await mentorProvider.editMentorInFirestore(
                              id,
                              Mentor(
                                name: nameController.text,
                                email: emailController.text,
                                password: passwordController.text,
                                courses: coursesController.text,
                                imageUrl: imageUrl ?? '',
                                id: '',
                                selectedModules: mentor.selectedModules,
                              ),
                            );
                            // Update the local _mentors list
                            final updatedMentor = Mentor(
                              name: nameController.text,
                              email: emailController.text,
                              password: passwordController.text,
                              courses: coursesController.text,
                              imageUrl: imageUrl ?? '',
                              id: id,
                              selectedModules: mentor.selectedModules,
                            );
                            mentorProvider.updateMentor(updatedMentor);
                            // Reset the selected image after editing the mentor
                            mentorProvider.setSelectedImage(null);
                            // ignore: use_build_context_synchronously
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Save'),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
