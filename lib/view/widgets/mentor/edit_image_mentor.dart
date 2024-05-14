import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phloem_admin/controller/mentor_controller.dart';
import 'package:phloem_admin/model/mentor_model.dart';

class EditImageWidget{
  static Widget buildImagePicker(BuildContext context, MentorProvider mentorProvider, ImagePicker picker, Mentor mentored) {
    return Center(
      child: GestureDetector(
        onTap: () async {
          final pickedFile =
          await picker.pickImage(source: ImageSource.gallery);
          if (pickedFile != null) {
            mentorProvider.setSelectedImage(File(pickedFile.path));
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
            : const Text('Tap to select an image'),
      ),
    );
  }
}