import 'package:flutter/material.dart';
import 'package:phloem_admin/view/screens/admin/profile/signout/admin_signout.dart';
import 'package:phloem_admin/view/widgets/admin/profile%20list/profile_list_items.dart';
import 'package:phloem_admin/view/widgets/appbar/appbar_const.dart';

// ignore: must_be_immutable
class ProfilePage extends StatelessWidget {
  final String userEmail; // User email
  String userImage; // User image

  ProfilePage({
    super.key,
    required this.userEmail,
    required this.userImage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FAppBar.profileAppBar,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 6),
          SizedBox(
            width: 150,
            height: 150,
            child: Column(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(userImage),
                  radius: 50,
                ),
                const SizedBox(height: 4),
                Text(
                  userEmail,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          const Padding(
            padding: EdgeInsets.only(right: 180.0),
            child: Text(
              'Profile Settings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 6),
          const ProfileList(),
          const SignOutButton(),
        ],
      ),
    );
  }
}