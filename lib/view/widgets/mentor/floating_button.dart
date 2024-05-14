import 'package:flutter/material.dart';
import 'package:phloem_admin/view/const/icon/icon_const.dart';
import 'package:phloem_admin/view/screens/mentor/add%20mentor/add_mentor_page.dart';

class AddMentorButton extends StatelessWidget {
  const AddMentorButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddMentorPage()),
        );
      },
      child: FIcons.addIcon
    );
  }
}