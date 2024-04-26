// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:phloem_admin/domain/model/mentor_model.dart';

// // class MentorRepository {
// //   final CollectionReference _mentorsCollection =
// //       FirebaseFirestore.instance.collection('mentors');

// //   Future<void> addMentor(Mentor mentor) async {
// //     try {
// //       await _mentorsCollection.doc(mentor.id).set(mentor.toJson());
// //     } catch (e) {
// //       print("Error adding mentor: $e");
// //       throw e;
// //     }
// //   }

// //   Future<void> updateMentor(Mentor mentor) async {
// //     try {
// //       await _mentorsCollection.doc(mentor.id).update(mentor.toJson());
// //     } catch (e) {
// //       print("Error updating mentor: $e");
// //       throw e;
// //     }
// //   }

// //   Future<void> deleteMentor(String id) async {
// //     try {
// //       await _mentorsCollection.doc(id).delete();
// //     } catch (e) {
// //       print("Error deleting mentor: $e");
// //       throw e;
// //     }
// //   }

// //   Stream<List<Mentor>> getMentors() {
// //     try {
// //       return _mentorsCollection.snapshots().map((snapshot) => snapshot.docs
// //           .map((doc) => Mentor.fromJson(doc.data() as Map<String, dynamic>))
// //           .toList());
// //     } catch (e) {
// //       print("Error fetching mentors: $e");
// //       // Depending on your application, you might want to handle this error differently.
// //       // For instance, return an empty stream or throw the error.
// //       throw e;
// //     }
// //   }
// // }


// // mentor_repository.dart

// import 'dart:developer';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:phloem_admin/domain/model/mentor_model.dart';

// void addMentorToFirestore(Mentor mentor) async {
//   log('kerind');
//   try {
// await FirebaseFirestore.instance.collection("ab").add({"lo":1});

//     await FirebaseFirestore.instance.collection('mentors').add({
//       'name': mentor.name,
//       'email': mentor.email,
//     });

//     print('Mentor added to Firestore successfully!');
//   } catch (e) {
//     print('Error adding mentor to Firestore: $e');
//   }
// }