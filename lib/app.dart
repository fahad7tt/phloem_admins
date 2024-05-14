import 'package:flutter/material.dart';
import 'package:phloem_admin/view/screens/splash%20screen/splash_screen.dart';
import 'package:provider/provider.dart';
import 'controller/course_controller.dart';
import 'controller/mentor_controller.dart';
import 'view/const/color/colors.dart';

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
          primarySwatch: FColors.themeColor,
        ),
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}