import 'package:flutter/material.dart';
import 'package:phloem_admin/model/admin_model.dart';
import 'package:phloem_admin/view/const/icon/icon_const.dart';
import 'package:phloem_admin/view/screens/course/courses%20screen/courses_screen.dart';
import 'package:phloem_admin/view/screens/mentor/mentor%20screen/mentor_screen.dart';

class AdminGridView extends StatelessWidget {
  const AdminGridView({super.key, required this.cardColors});

  final List<Color> cardColors;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      children: [
        AdminCard(
          title: 'Students',
          icon: FIcons.peopleIcon,
          onTap: () {},
          color: cardColors[0],
        ),
        AdminCard(
          title: 'Mentors',
          icon: FIcons.accountIcon,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MentorPage()),
            );
          },
          color: cardColors[1],
        ),
        AdminCard(
          title: 'Courses',
          icon: FIcons.bookIcon,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CourseScreen()),
            );
          },
          color: cardColors[2],
        ),
        AdminCard(
          title: 'Reviews',
          icon: FIcons.feedbackIcon,
          onTap: () {},
          color: cardColors[3],
        ),
      ],
    );
  }
}