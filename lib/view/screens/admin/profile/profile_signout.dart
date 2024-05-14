import 'package:flutter/material.dart';
import 'package:phloem_admin/view/const/icon/icon_const.dart';
import 'package:phloem_admin/view/screens/admin/sign%20in/admin_signin.dart';
import 'package:phloem_admin/view/widgets/admin/profile%20list/profile_list.dart';

class SignOutButton extends StatelessWidget {
  const SignOutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfileListTile(
      leading: FIcons.logoutIcon,
      title: 'Sign out',
      trailing: FIcons.forwardArrowIcon,
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Sign Out"),
              content: const Text("Are you sure you want to sign out?"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    //sign out action
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: const Text("Sign Out"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}