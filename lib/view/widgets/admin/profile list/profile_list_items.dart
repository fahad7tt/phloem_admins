import 'package:flutter/material.dart';
import 'package:phloem_admin/view/const/icon/icon_const.dart';
import 'package:phloem_admin/view/screens/admin/profile/app%20info/admin_app_info.dart';
import 'package:phloem_admin/view/screens/admin/profile/guidelines/admin_guidelines.dart';
import 'package:phloem_admin/view/screens/admin/profile/privacy%20policy/admin_privacy_policy.dart';
import 'package:phloem_admin/view/screens/admin/profile/signout/admin_signout.dart';
import 'package:phloem_admin/view/screens/admin/profile/terms%20and%20conditions/admin_terms.dart';
import 'package:phloem_admin/view/widgets/admin/profile%20list/profile_list_tile.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ProfileList extends StatelessWidget {
  const ProfileList({super.key});

  Future<String> _fetchVersionInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfileListTile(
          leading: FIcons.infoIcon,
          title: 'App Info',
          trailing: FIcons.forwardArrowIcon,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AppInfo()),
            );
          },
        ),
        ProfileListTile(
          leading: FIcons.termsIcon,
          title: 'Terms and Conditions',
          trailing: FIcons.forwardArrowIcon,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Terms()),
            );
          },
        ),
        ProfileListTile(
          leading: FIcons.pPolicyIcon,
          title: 'Privacy Policy',
          trailing: FIcons.forwardArrowIcon,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PrivacyPolicy()),
            );
          },
        ),
        ProfileListTile(
          leading: FIcons.newspaperIcon,
          title: 'Guidelines',
          trailing: FIcons.forwardArrowIcon,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AdminGuidelines()),
            );
          },
        ),
        const SignOutButton(),
        const SizedBox(height: 60),
        FutureBuilder<String>(
                    future: _fetchVersionInfo(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Center(
                            child: Text('Error fetching version'));
                      } else {
                        return ListTile(
                          subtitle: Center(
                            child: Text('Version: ${snapshot.data}',
                                style: const TextStyle(fontSize: 16.0)),
                          ),
                        );
                      }
                    },
                  ),
      ],
    );
  }
}