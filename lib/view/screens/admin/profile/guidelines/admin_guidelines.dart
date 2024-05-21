import 'package:flutter/material.dart';
import 'package:phloem_admin/view/widgets/appbar/appbar_const.dart';

class AdminGuidelines extends StatelessWidget {
  const AdminGuidelines({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FAppBar.guidelinesAppBar,
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          '''

  • Maintain a high standard of user conduct.\n
  • Monitor and moderate user-generated content.\n
  • Respond to user inquiries and requests in a timely manner.\n
  • Ensure the security and integrity of the platform.\n
  • Enforce the terms of services and privacy policies.\n

  These are the general guidelines for the administrators. Please follow the guidelines to maintain a very safe and productive environment.
  ''',
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.left,
        ),
      ),
    );
  }
}