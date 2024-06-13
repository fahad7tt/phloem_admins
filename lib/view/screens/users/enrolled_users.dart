import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:phloem_admin/view/widgets/appbar/appbar_const.dart';

class UsersList extends StatelessWidget {
  const UsersList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FAppBar.studentsListAppBar,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return const Center(
                child: Text('Error fetching data'),
              );
            }
            final users = snapshot.data!.docs;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final userData = users[index].data() as Map<String, dynamic>;
                final name = userData['username'] ?? ''; 
                final email = userData['email'] ?? 'No email';
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0 ),
                  child: Card(
                    child: ListTile(
                      title: Text(name, style: const TextStyle(fontWeight: FontWeight.w500)),
                      subtitle: Text(email),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}