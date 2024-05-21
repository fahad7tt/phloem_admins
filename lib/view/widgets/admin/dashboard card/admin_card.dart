import 'package:flutter/material.dart';
import 'package:phloem_admin/model/admin_model.dart';
import 'package:phloem_admin/view/const/icon/icon_const.dart';
import 'package:phloem_admin/view/screens/course/courses%20screen/courses_screen.dart';
import 'package:phloem_admin/view/screens/mentor/mentor%20screen/mentor_screen.dart';
import 'package:phloem_admin/view/screens/users/enrolled_users.dart';

class AdminGridView extends StatelessWidget {
  const AdminGridView({super.key, required this.cardColors});

  final List<Color> cardColors;

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items = [
      {
        'title': 'Students',
        'icon': FIcons.peopleIcon,
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EnrolledStudents()),
          );
        },
        'color': cardColors[0],
      },
      {
        'title': 'Mentors',
        'icon': FIcons.accountIcon,
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MentorPage()),
          );
        },
        'color': cardColors[1],
      },
      {
        'title': 'Courses',
        'icon': FIcons.bookIcon,
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CourseScreen()),
          );
        },
        'color': cardColors[2],
      },
    ];

    return ListView.builder(
      shrinkWrap: true,
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 7.0),
          child: SizedBox(
            height: 120,
            child: AdminCard(
              title: item['title'],
              icon: item['icon'],
              onTap: item['onTap'],
              color: item['color'],
            ),
          ),
        );
      },
    );
  }
}
