import 'package:flutter/material.dart';
import 'package:phloem_admin/view/const/appbar/appbar_const.dart';
import 'package:phloem_admin/view/screens/mentor/add%20mentor/add_mentor_form.dart';

class AddMentorPage extends StatelessWidget {
  const AddMentorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FAppBar.addMentorAppBar,
      body: const AddMentorForm(),
    );
  }
}