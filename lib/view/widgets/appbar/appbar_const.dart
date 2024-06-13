import 'package:flutter/material.dart';
import 'package:phloem_admin/view/const/color/colors.dart';
import 'package:phloem_admin/view/const/icon/icon_const.dart';
import 'package:phloem_admin/view/screens/admin/dashboard/dashboard.dart';

class FAppBar {
  static final profileAppBar = AppBar(
    title: const Text('Admin Profile'),
    leading: Builder(
      builder: (BuildContext context) {
        return IconButton(
          icon: FIcons.backIcon,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>const AdminDashboard()));
          },
        );
      },
    ),
    centerTitle: true,
  );
  static final addCourseAppBar = AppBar(
    title: const Text('Add Course'),
  );
  static final allCourseAppBar = AppBar(
    title: const Text('Courses'),
    centerTitle: true,
    backgroundColor: FColors.appBarColor
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
    backgroundColor: FColors.appBarColor
  );
  static final addModulesAppBar = AppBar(
    title: const Text('Add Modules'),
  );
  static final appInfoAppBar = AppBar(
    title: const Text('App Info'),
    centerTitle: true,
  );
  static final guidelinesAppBar = AppBar(
    title: const Text('Admin Guidelines'),
  );
  static final privacyPolicyAppBar = AppBar(
    title: const Text('Privacy Policy'),
  );
  static final termsAppBar = AppBar(
    title: const Text('Terms and Conditions'),
  );
  static final studentsListAppBar = AppBar(
    title: const Text('Students List'),
    centerTitle: true,
    backgroundColor: FColors.appBarColor
  );
}
