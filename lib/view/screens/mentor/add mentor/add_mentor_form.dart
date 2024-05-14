// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phloem_admin/controller/mentor_controller.dart';
import 'package:phloem_admin/view/screens/mentor/add%20mentor/addmentor_fields.dart';
import 'package:phloem_admin/view/widgets/mentor/add_widget_mentor.dart';
import 'package:provider/provider.dart';

class AddMentorForm extends StatefulWidget {
  const AddMentorForm({super.key});
  @override
  _AddMentorFormState createState() => _AddMentorFormState();
}

class _AddMentorFormState extends State<AddMentorForm> {
  final _formKey = GlobalKey<FormState>();
  final picker = ImagePicker();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  File? _imageFile;
  final bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Consumer<MentorProvider>(
              builder: (context, mentorProvider, _) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NameField(controller: _nameController),
                    EmailField(controller: _emailController),
                    PasswordField(controller: _passwordController),
                    const SizedBox(height: 20),
                    CourseDropdown(mentorProvider: mentorProvider),
                    const SizedBox(height: 25),
                    ModuleCheckboxListWidget(mentorProvider: mentorProvider),
                    const SizedBox(height: 25),
                    ImagePickerWidget(imageFile: _imageFile, getImage: _getImage),
                    const SizedBox(height: 25),
                    AddMentorButton(mentorProvider: mentorProvider, formKey: _formKey, imageFile: _imageFile, passwordController: _passwordController, nameController: _nameController, emailController: _emailController),
                  ],
                );
              },
            ),
          ),
        ),
        if (_isLoading)
          const Center(
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }

  Future<void> _getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      context.read<MentorProvider>().setSelectedImage(_imageFile);
    }
  }
}