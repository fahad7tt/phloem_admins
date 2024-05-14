import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:phloem_admin/view/const/appbar/appbar_const.dart';
import 'package:phloem_admin/view/functions/mentor%20functions/mentor_functions.dart';
import 'package:phloem_admin/view/widgets/mentor/floating_button.dart';

class MentorPage extends StatelessWidget {
  const MentorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FAppBar.mentorsAppBar,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('mentors').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return MentorFunctions.buildListView(context, snapshot);
          }
        },
      ),
      floatingActionButton: const AddMentorButton(),
    );
  }
}