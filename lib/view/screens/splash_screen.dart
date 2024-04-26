import 'dart:async';
import 'package:flutter/material.dart';
import 'package:phloem_admin/controller/mentor_controller.dart';
import 'package:provider/provider.dart';
import 'admin_signin.dart';

class SplashScreen extends StatelessWidget {
   const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    Timer(const Duration(seconds: 3), () async{
      context.read<MentorProvider>();
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx){
        return const LoginPage();
      }));
    });
    return  Scaffold(
      body: Center(
        child: Image.asset('images/phloem_logo.png'),
      ),
    );
  }
}