 // ignore_for_file: avoid_print
import 'dart:developer';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:phloem_admin/model/course_model.dart';
import 'package:phloem_admin/model/mentor_model.dart';
import 'package:phloem_admin/view/const/color/colors.dart';

class MentorProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<Mentor> _mentors = [];
  final List<String> _selectedCourses = [];
  final List<String> _selectedModules = [];
  String? _selectedCourse;
  final List<String> _selectedCourseModules = [];
  File? _selectedImage;
  bool isEdit=false;
  bool isSameCourse=false;

  String? get selectedCourse => _selectedCourse;
  List<String> get selectedCourseModules => _selectedCourseModules;
  List<Mentor> get mentors => _mentors;
  List<String> get selectedCourses => _selectedCourses;
  List<String> get selectedModules => _selectedModules;
  File? get selectedImage => _selectedImage;

  bool _isLoading = false;
  List<Course> _courses = [];

  bool get isLoading => _isLoading;
  List<Course> get courses => _courses;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Method to toggle selected modules
  void toggleSelectedModule(String module) {
    log(module);
    log("===-=-=-=-=-=-=$_selectedModules");
if(!isSameCourse)
{
  _selectedModules.clear();
    isSameCourse = true;
}
    if (_selectedModules.contains(module)) {
      _selectedModules.remove(module);
    } else {
      _selectedModules.add(module);
    }
    log("----------- ----$_selectedModules");
    notifyListeners();
  }

  // Method to reset selected modules
  void resetSelectedModules() {
    _selectedModules.clear();
    notifyListeners();
  }

  void setSelectedImage(File? image) {
    _selectedImage = image;
    notifyListeners();
  }

  void resetSelectedCourses() {
    _selectedCourses.clear();
    notifyListeners();
  }

  void setMentors(List<Mentor> mentors) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mentors.clear();
      _mentors.addAll(mentors);
      notifyListeners();
    });
  }

  void addMentor(Mentor mentor) {
    _mentors.add(mentor);
    notifyListeners();
  }

  void setSelectedCourse(String courseName, List<dynamic> modules) {
    print('i am in set selected couuse ');
    print(courseName);
    print(modules);
    _selectedCourse = courseName;
    _selectedCourseModules.clear();
    for(int i=0;i<modules.length;i++)
    {
      _selectedCourseModules.add(modules[i].toString()); 
    }
  // _selectedCourseModules.addAll(modules as List<String>);
    notifyListeners();
  }

  void setSelectedModules(List<String> modules)  {
    // log("----${modules}");
  _selectedCourseModules.clear();
  _selectedCourseModules.addAll(modules);
  notifyListeners();
}

  void deleteMentor(String idDel) async {
    try {
      await FirebaseFirestore.instance
          .collection('mentors')
          .doc(idDel)
          .delete();
      notifyListeners();
    } catch (error) {
      print('Error deleting mentor from Firestore: $error');
    }
  }

  void resetState() {
    _selectedCourses.clear();
    _selectedModules.clear();
    _selectedImage = null;
    notifyListeners();
  }

  void toggleSelectedCourse(String course) {
    if (_selectedCourses.contains(course)) {
      _selectedCourses.remove(course);
      _selectedModules.clear(); // Clear modules when course is deselected
    } else {
      _selectedCourses.add(course);
    }
    notifyListeners();
  }

  Future<String?> uploadImage(File imageFile) async {
    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('mentor_images/${DateTime.now().millisecondsSinceEpoch}');
      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> addMentorToFirestore(Mentor mentor, BuildContext context) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    if (await isEmailUnique(mentor.email)) {
      try {
        await _firestore.collection('mentors').doc(mentor.id).set({
          'name': mentor.name,
          'email': mentor.email,
          'password': mentor.password,
          'courses': mentor.courses,
          'image': mentor.imageUrl,
          'modules': mentor.selectedModules,
        });
        print('Mentor added to Firestore with ID: ${mentor.id}');
        _mentors.add(mentor);
        notifyListeners();

        // Show a success Snackbar
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text('Mentor added successfully!'),
            backgroundColor: FColors.successColor,
            duration: Duration(seconds: 2),
          ),
        );
      } catch (error) {
        print('Error adding mentor to Firestore: $error');
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text('Error adding mentor!'),
            backgroundColor: FColors.errorColor,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Email already exists'),
          backgroundColor: FColors.existsColor,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> editMentorInFirestore(String index, Mentor updatedMentor, BuildContext context) async {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      try {
        await _firestore.collection('mentors').doc(index).update({
          'name': updatedMentor.name,
          'email': updatedMentor.email,
          'password': updatedMentor.password,
          'courses': updatedMentor.courses,
          'image': updatedMentor.imageUrl,
          'modules': updatedMentor.selectedModules,
        });

        print('Mentor updated in Firestore');
        log('!!!$updatedMentor');

        notifyListeners();

        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text('Mentor updated successfully!'),
            backgroundColor: FColors.themeColor,
            duration: Duration(seconds: 2),
          ),
        );
      } catch (error) {
        print('Error updating mentor in Firestore: $error');
      }
  }

  MentorProvider() {
    _fetchCourses();
  }

  Future<void> _fetchCourses() async {
    setLoading(true);
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('courses').get();
      _courses =
          querySnapshot.docs.map((doc) => Course.fromSnapshot(doc)).toList();
    } catch (e) {
      print('Error fetching courses: $e');
    }
    setLoading(false);
  }

  Future<bool> isEmailUnique(String email) async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('mentors').get();

    return !querySnapshot.docs.any((doc) => doc['email'] == email);
  }

  Future<bool> isPasswordUnique(String password) async {
  QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('mentors').get();

  return !querySnapshot.docs.any((doc) => doc['password'] == password);
}

Future<bool> isModuleAvailableForCourse(String courseName, List<String> selectedModules) async {
  try {
    // Fetch the course from Firestore
    DocumentSnapshot courseSnapshot = await FirebaseFirestore.instance.collection('courses').doc(courseName).get();
    Map<String, dynamic>? courseData = courseSnapshot.data() as Map<String, dynamic>?;
    if (courseData != null) {
      List<String> courseModules = List<String>.from(courseData['modules'] ?? []);

      // Check if any of the selected modules are already assigned to another mentor
      QuerySnapshot mentorSnapshot = await FirebaseFirestore.instance.collection('mentors').get();
      for (DocumentSnapshot doc in mentorSnapshot.docs) {
        Map<String, dynamic>? mentorData = doc.data() as Map<String, dynamic>?;
        if (mentorData != null) {
          List<String> mentorModules = List<String>.from(mentorData['modules'] ?? []);
          if (selectedModules.any((module) => mentorModules.contains(module))) {
            return false; // Return false if any of the selected modules are already assigned to another mentor
          }
        }
      }
      // Check if the selected modules are available for the course
      return selectedModules.every((module) => courseModules.contains(module));
    }
    return false;
  } catch (e) {
    print('Error checking module availability: $e');
    return false;
  }
}

void updateMentor(Mentor updatedMentor) {
  final index = _mentors.indexWhere((mentor) => mentor.id == updatedMentor.id);
  if (index != -1) {
    _mentors[index] = updatedMentor;
    notifyListeners();
  }
}
}