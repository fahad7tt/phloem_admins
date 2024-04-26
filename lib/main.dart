// ignore_for_file: library_private_types_in_public_api
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:phloem_admin/firebase_options.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
 
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
// await FirebaseFirestore.instance.collection("ab").add({"lo":1});
  runApp(const MyApp());
}