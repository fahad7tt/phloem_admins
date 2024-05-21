 import 'dart:io';
import 'package:uuid/uuid.dart';

class Mentor {
 final String id;
 final String name;
 final String email;
 final String password;
 late final String courses;
 final String imageUrl;
 final List<String> selectedModule;
 File? selectedImage;
  
 Mentor({
    required this.name,
    required this.email,
    required this.password,
    required this.courses,
    required this.imageUrl,
    this.selectedImage,
    required String id,
    required this.selectedModule,
 }) : id = id.isNotEmpty ? id : const Uuid().v4();
}