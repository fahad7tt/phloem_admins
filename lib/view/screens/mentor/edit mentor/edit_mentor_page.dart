// ignore_for_file: prefer_typing_uninitialized_variables
import 'package:flutter/material.dart';
import 'package:phloem_admin/view/widgets/appbar/appbar_const.dart';
import 'edit_mentor_form.dart';

class EditMentorPage extends StatelessWidget {
  final snapshot;
  final String id;

  const EditMentorPage({super.key, required this.snapshot, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FAppBar.editMentorAppBar,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: EditMentorForm(snapshot: snapshot, id: id),
      ),
    );
  }
}