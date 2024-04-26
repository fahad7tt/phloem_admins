import 'package:flutter/material.dart';
import 'package:phloem_admin/view/widgets/profile_list.dart';
import 'admin_signin.dart';

class ProfilePage extends StatelessWidget {
  final String userEmail; // User email
  final String userImage; // User image path

  const ProfilePage(
      {super.key, required this.userEmail, required this.userImage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
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
            leading: const Icon(Icons.settings),
            title: 'Settings',
            trailing: const Icon(Icons.arrow_forward_ios, size: 20),
            onTap: () {},
          ),
          ProfileListTile(
            leading: const Icon(Icons.newspaper_outlined),
            title: 'Guidelines',
            trailing: const Icon(Icons.arrow_forward_ios, size: 20),
            onTap: () {},
          ),
          ProfileListTile(
            leading: const Icon(Icons.logout_outlined),
            title: 'Sign out',
            trailing: const Icon(Icons.arrow_forward_ios, size: 20),
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
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()),
                          );
                        },
                        child: const Text("Sign Out"),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
