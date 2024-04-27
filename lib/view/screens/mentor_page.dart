import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:phloem_admin/controller/mentor_controller.dart';
import 'package:provider/provider.dart';
import 'add_mentor.dart';
import 'edit_mentor.dart';

class MentorPage extends StatelessWidget {
  const MentorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mentors'),
        centerTitle: true
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('mentors').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.separated(
              itemBuilder: (context, index) {
                final data = snapshot.data!.docs[index];
                return Card(
                  elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    onTap: () {
                      _showMentorDetailsDialog(context, data);
                    },
                    leading: SizedBox(
                      height: 50,
                      width: 50,
                      child: Image.network(data["image"], fit: BoxFit.cover),
                    ),
                    title: Text(data["name"],
                        style: const TextStyle(fontWeight: FontWeight.w500)),
                    subtitle: Text(data["email"],
                        style: const TextStyle(
                            fontSize: 12.0, fontWeight: FontWeight.w400)),
                    trailing: SizedBox(
                      width: 96,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditMentorPage(
                                    snapshot: data,
                                    id: data.id,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit, size: 20),
                          ),
                          IconButton(
                            onPressed: () {
                              _confirmDeleteMentor(context, data.id);
                            },
                            icon: const Icon(Icons.delete, size: 20),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(
                height: 10,
              ),
              itemCount: snapshot.data!.docs.length,
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddMentorPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showMentorDetailsDialog(
      BuildContext context, DocumentSnapshot mentorData) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(mentorData["name"]),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(
                mentorData["image"],
                height: 150,
                width: 200,
              ),
              const SizedBox(height: 10),
              Text("Email: ${mentorData["email"]}"),
              Text("Course: ${mentorData["courses"]}"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _confirmDeleteMentor(BuildContext context, String mentorId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this mentor?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _deleteMentor(context, mentorId);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _deleteMentor(BuildContext context, String mentorId) {
    context.read<MentorProvider>().deleteMentor(mentorId);
  }
}