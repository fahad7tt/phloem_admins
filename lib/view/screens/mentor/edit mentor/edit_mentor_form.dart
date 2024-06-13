// ignore_for_file: prefer_typing_uninitialized_variables
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phloem_admin/controller/mentor_controller.dart';
import 'package:phloem_admin/model/mentor_model.dart';
import 'package:phloem_admin/view/widgets/mentor/edit_image_mentor.dart';
import 'package:provider/provider.dart';
import 'edit_field.dart';

class EditMentorForm extends StatelessWidget {
  final snapshot;
  final String id;

  const EditMentorForm({super.key, required this.snapshot, required this.id});

  @override
  Widget build(BuildContext context) {
  
    final mentorProvider=Provider.of<MentorProvider>(context, listen: false);
    // Provider.setSelectedCourse(snapshot["name"], List<String>.from(snapshot["modules"]));
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
        mentorProvider.selectedModules.clear();
        mentorProvider.selectedModules.addAll(mentored.selectedModules);    

    return Consumer<MentorProvider>(
      builder: (context, mentorProvider, _) {
        return Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EditFieldBuilder.buildNameField(context, nameController),
              EditFieldBuilder.buildEmailField(context, emailController),
              EditFieldBuilder.buildPasswordField(context, passwordController),
              EditFieldBuilder.buildCoursesField(
                coursesController.text,
                context,
                coursesController,
                mentorProvider,
                mentored,
              ),
              EditFieldBuilder.buildModulesField(context, mentorProvider,id),
              EditImageWidget.buildImagePicker(
                  context, mentorProvider, picker, mentored),
                  const SizedBox(height: 12),
              buildSaveButton(
                  context,
                  formKey,
                  nameController,
                  emailController,
                  passwordController,
                  coursesController,
                  mentorProvider,
                  mentored),
            ],
          ),
        );
      },
    );
  }

  Widget buildSaveButton(
      BuildContext context,
      GlobalKey<FormState> formKey,
      TextEditingController nameController,
      TextEditingController emailController,
      TextEditingController passwordController,
      TextEditingController coursesController,
      MentorProvider mentorProvider,
      Mentor mentored) { 
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          if (formKey.currentState!.validate()) {
            String? imageUrl;
            log("0909090909009 ------ ${mentorProvider.selectedModules} ------");
            if (mentorProvider.selectedImage != null) {
              imageUrl = await mentorProvider
                  .uploadImage(mentorProvider.selectedImage!);
            } else {
              imageUrl = mentored.imageUrl;
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
                selectedModules: mentorProvider.selectedModules,
              ),
              // ignore: use_build_context_synchronously
              context,
            );
            final updatedMentor = Mentor(
              name: nameController.text,
              email: emailController.text,
              password: passwordController.text,
              courses: coursesController.text,
              imageUrl: imageUrl ?? '',
              id: id,
              selectedModules: mentorProvider.selectedModules,
            );
            mentorProvider.updateMentor(updatedMentor);
            mentorProvider.setSelectedImage(null);
            // ignore: use_build_context_synchronously
            Navigator.pop(context);
          }
        },
        child: const Text('Save'),
      ),
    );
  }
}