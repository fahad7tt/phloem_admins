import 'package:flutter/material.dart';
import 'package:phloem_admin/view/const/color/colors.dart';
import 'package:phloem_admin/view/const/image/image_const.dart';
import 'package:phloem_admin/view/screens/admin/profile/profile.dart';
import 'package:phloem_admin/view/widgets/admin/dashboard%20card/admin_card.dart';

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
              AdminGridView(cardColors: _cardColors),
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
                    builder: (context) => ProfilePage(
                        userEmail: 'johndoe@gmail.com',
                        userImage: FImages.userImage)),
              );
            },
            style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                backgroundColor: FColors.bgColor,
                foregroundColor: FColors.foregroundColor),
            child: const Text('Go to Profile'),
          ),
        ),
      ),
    );
  }
}