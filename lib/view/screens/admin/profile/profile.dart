import 'package:flutter/material.dart';
import 'package:phloem_admin/view/const/appbar/appbar_const.dart';
import 'package:phloem_admin/view/const/icon/icon_const.dart';
import 'package:phloem_admin/view/screens/admin/profile/profile_signout.dart';
import 'package:phloem_admin/view/widgets/admin/profile%20list/profile_list.dart';

// ignore: must_be_immutable
class ProfilePage extends StatelessWidget {
  final String userEmail; // User email
  String userImage; // User image path

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
                  radius: 42,
                ),
                const SizedBox(height: 8),
                Text(
                  userEmail,
                  style: const TextStyle(
                    fontSize: 13,
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
          ProfileListTile(
            leading: FIcons.settingsIcon,
            title: 'Settings',
            trailing: FIcons.forwardArrowIcon,
            onTap: () {},
          ),
          ProfileListTile(
            leading: FIcons.newspaperIcon,
            title: 'Guidelines',
            trailing: FIcons.forwardArrowIcon,
            onTap: () {},
          ),
          const SignOutButton(),
        ],
      ),
    );
  }
}