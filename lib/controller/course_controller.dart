 // ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:phloem_admin/model/course_model.dart';

class CourseProvider extends ChangeNotifier {
  final List<Course> _courses = [];
  List<Course> get courses => _courses;

  List<String> getCourseNames() {
    return _courses.map((course) => course.name).toList();
  }
    
  Future<void> addCourse(
      String name, List<String> modules, String payment, List<String> descriptions) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      DocumentReference docRef = await firestore.collection('courses').add({
        'name': name,
        'modules': modules,
        'payment': payment,
        'descriptions': descriptions
      });
      _courses.add(Course(
          id: docRef.id, name: name, modules: modules, payment: payment, descriptions: descriptions));
      notifyListeners();
    } catch (e) {
      print('Error adding course: $e');
    }
  }

  void addModule(String courseName, String moduleName) {
  final index = _courses.indexWhere((course) => course.name == courseName);
  if (index != -1) {
    _courses[index].modules.add(moduleName);
    notifyListeners();
  } else {
    print('Course not found');
  }
}

  void updateCourseModules(int courseIndex, List<String> modules) {
    if (courseIndex >= 0 && courseIndex < _courses.length) {
      _courses[courseIndex].modules = modules;
      notifyListeners();
    } else {
      print('Invalid course index');
    }
  }

  Future<void> updateCourse(Course course, String newName,
      List<String> newModules, String newPayment, List<String> newDescriptions) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore.collection('courses').doc(course.id).update({
        'name': newName,
        'modules': newModules,
        'payment': newPayment,
        'description': newDescriptions
      });
      final index = _courses.indexOf(course);
      if (index != -1) {
        _courses[index] = Course(
            id: course.id,
            name: newName,
            modules: newModules,
            payment: newPayment,
            descriptions: newDescriptions);
        notifyListeners();
      } else {
        print('Course not found');
      }
    } catch (e) {
      print('Error updating course: $e');
    }
  }

  void deleteCourse(Course course) {
    // Remove the course from the list
    _courses.remove(course);
    // Delete the course from Firestore
    deleteCourseFromFirestore(course.id);
    // Notify listeners to rebuild the UI
    notifyListeners();
  }

  Future<void> deleteCourseFromFirestore(String courseId) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore.collection('courses').doc(courseId).delete();
    } catch (e) {
      print('Error deleting course from Firestore: $e');
    }
  }
}