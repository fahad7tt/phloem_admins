import 'package:flutter/material.dart';

class FAppBar{
  static final profileAppBar = AppBar(
        title: const Text('Profile'),
      );
  static final addCourseAppBar = AppBar(
        title: const Text('Add Course'),
      );
  static final allCourseAppBar = AppBar(
        title: const Text('All Courses'),
      );
  static final editCourseAppBar = AppBar(
        title: const Text('Edit Course'),
      );
  static final addMentorAppBar = AppBar(
        title: const Text('Add Mentor'),
      );
  static final editMentorAppBar = AppBar(
        title: const Text('Edit Mentor'),
      );
  static final mentorsAppBar = AppBar(
        title: const Text('Mentors'),
        centerTitle: true,
      ); 
  static final addModulesAppBar = AppBar(
        title: const Text('Add Modules'),
      );
}