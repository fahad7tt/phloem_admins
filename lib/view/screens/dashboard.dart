import 'package:flutter/material.dart';
import 'package:phloem_admin/model/admin_model.dart';
import 'courses_screen.dart';
import 'mentor_page.dart';
import 'profile.dart';

class AdminDashboard extends StatelessWidget {
  AdminDashboard({super.key});

  final List<Color> _cardColors = [
    const Color.fromARGB(255, 34, 87, 131),
    const Color.fromARGB(255, 42, 139, 46),
    const Color.fromARGB(255, 127, 48, 151),
    const Color.fromARGB(255, 36, 109, 114),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 150),
              const Padding(
                padding: EdgeInsets.only(right: 180),
                child: Text(
                  'Admin\nDashboard',
                  style: TextStyle(
                    fontSize: 29,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                children: [
                  AdminCard(
                    title: 'Students',
                    icon: Icons.people,
                    onTap: () {},
                    color: _cardColors[0],
                  ),
                  AdminCard(
                    title: 'Mentors',
                    icon: Icons.manage_accounts,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MentorPage()),
                      );
                    },
                    color: _cardColors[1],
                  ),
                  AdminCard(
                    title: 'Courses',
                    icon: Icons.book,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CourseScreen()),
                      );
                    },
                    color: _cardColors[2],
                  ),
                  AdminCard(
                    title: 'Reviews',
                    icon: Icons.feedback_sharp,
                    onTap: () {},
                    color: _cardColors[3],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 62.0),
        child: Align(
          alignment: Alignment.topRight,
          child: ElevatedButton(
            onPressed: () {
              // Navigate to profile page
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ProfilePage(
                        userEmail: 'johndoe@gmail.com',
                        userImage: 'images/mentor_black.jpg')),
              );
            },
            style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                backgroundColor: Colors.black54,
                foregroundColor: Colors.white),
            child: const Text('Go to Profile'),
          ),
        ),
      ),
    );
  }
}
