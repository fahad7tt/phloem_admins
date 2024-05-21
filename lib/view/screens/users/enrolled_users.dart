import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EnrolledStudents extends StatelessWidget {
  const EnrolledStudents({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enrolled Students'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching data'));
          }
          final students = snapshot.data?.docs;
          if (students == null || students.isEmpty) {
            return const Center(child: Text('No students enrolled'));
          }
          return ListView.separated(
            itemCount: students.length,
            separatorBuilder: (BuildContext context, int index) => const Divider(),
            itemBuilder: (context, index) {
              final student = students[index].data() as Map<String, dynamic>;
              return ListTile(
                title: Text(
                  student['name'],
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                ),
                subtitle: Text('User ID: ${students[index].id}'),
              );
            },
          );
        },
      ),
    );
  }
}