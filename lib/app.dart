import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controller/course_controller.dart';
import 'controller/mentor_controller.dart';
import 'view/screens/splash_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MentorProvider()),
        ChangeNotifierProvider(create: (context) => CourseProvider()),
      ],
      child: MaterialApp(
        title: 'E-Learning Admin',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}