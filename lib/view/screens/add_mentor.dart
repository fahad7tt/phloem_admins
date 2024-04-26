// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phloem_admin/controller/course_controller.dart';
import 'package:phloem_admin/controller/email_controller.dart';
import 'package:phloem_admin/controller/mentor_controller.dart';
import 'package:phloem_admin/model/course_model.dart';
import 'package:phloem_admin/model/mentor_model.dart';
import 'package:provider/provider.dart';

class AddMentorPage extends StatefulWidget {
  const AddMentorPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddMentorPageState createState() => _AddMentorPageState();
}

class _AddMentorPageState extends State<AddMentorPage> {
  final _formKey = GlobalKey<FormState>();
  final picker = ImagePicker();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  File? _imageFile;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Mentor'),
      ),
      body: Stack(
        children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Consumer2<CourseProvider, MentorProvider>(
                builder: (context, courseProvider, mentorProvider, _) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _nameController,
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
                              controller: _emailController,
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
                      FutureBuilder<bool>(
                          future: mentorProvider
                              .isPasswordUnique(_passwordController.text),
                          builder: (context, snapshot) {
                            String? errorText;
        
                            return TextFormField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                errorText: errorText,
                              ),
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
                          }),
                      const SizedBox(height: 20),
                      FutureBuilder<List<Course>>(
                        future: context.read<MentorProvider>().fetchCourses(),
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
        
                            return DropdownButtonFormField<String>(
                              value: mentorProvider.selectedCourses.isNotEmpty
                                  ? mentorProvider.selectedCourses.first
                                  : null,
                              items: courses.map((course) {
                                return DropdownMenuItem<String>(
                                  value: course.name,
                                  child: Text(course.name),
                                );
                              }).toList(),
                              onChanged: (value) {
                                mentorProvider.resetState();
        
                                mentorProvider.toggleSelectedCourse(value!);
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
                      const SizedBox(height: 20),
                      if (mentorProvider.selectedCourses.isNotEmpty)
                        FutureBuilder<List<Course>>(
                          future: context.read<MentorProvider>().fetchCourses(),
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
        
                              final selectedCourse = courses.firstWhere(
                                (course) =>
                                    course.name ==
                                    mentorProvider.selectedCourses.first,
                                orElse: () => Course.empty,
                              );
        
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10),
                                  const Text('Modules:'),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: selectedCourse.modules.length,
                                    itemBuilder: (context, index) {
                                      final module =
                                          selectedCourse.modules[index];
        
                                      return CheckboxListTile(
                                        title: Text(module),
                                        value: mentorProvider.selectedModules
                                            .contains(module),
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
                          },
                        ),
                      const SizedBox(height: 25),
                      Center(
                        child: _imageFile == null
                            ? GestureDetector(
                                child: ElevatedButton(
                                  onPressed: () {
                                    _getImage();
                                  },
                                  child: const Text('Add Image'),
                                ),
                              )
                            : Image.file(
                                _imageFile!,
                                height: 200,
                                width: 200,
                                fit: BoxFit.cover,
                              ),
                      ),
                      const SizedBox(height: 25),
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              _showProgressIndicator(true);
                              // Validate password
        
                              final isPasswordUnique = await mentorProvider
                                  .isPasswordUnique(_passwordController.text);
        
                              if (!isPasswordUnique) {
                                // ignore: duplicate_ignore
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Password already exists'),
                                    duration: Duration(seconds: 3),
                                  ),
                                );
                              } else {
                                // Proceed with adding mentor if no password error
                                bool isEmailUnique = await mentorProvider
                                    .isEmailUnique(_emailController.text);
        
                                if (isEmailUnique) {
                                  String? imageUrl;
        
                                  if (_imageFile != null) {
                                    imageUrl = await mentorProvider
                                        .uploadImage(_imageFile!);
                                  }
        
                                  mentorProvider.addMentorToFirestore(
                                    Mentor(
                                      name: _nameController.text,
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                      courses: mentorProvider.selectedCourses
                                          .join(', '),
                                      imageUrl: imageUrl ?? '',
                                      id: '',
                                      selectedModules:
                                          mentorProvider.selectedModules,
                                    ),
                                  );
        
                                  // Reset the selected courses
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
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
        if (_isLoading) // Show circular progress if _isLoading is true
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  void _showProgressIndicator(bool show) {
    setState(() {
      _isLoading = show;
    });
  }

  Future<void> _getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      // Notify the MentorProvider that the image has been selected
      context.read<MentorProvider>().setSelectedImage(_imageFile);
    }
  }
}