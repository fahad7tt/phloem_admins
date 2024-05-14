import 'dart:async';
import 'package:flutter/material.dart';
import 'package:phloem_admin/controller/mentor_controller.dart';
import 'package:phloem_admin/view/const/image/image_const.dart';
import 'package:phloem_admin/view/screens/admin/sign%20in/admin_signin.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
   const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    Timer(const Duration(seconds: 3), () async{
      context.read<MentorProvider>();
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx){
        return LoginPage();
      }));
    });
    return  Scaffold(
      body: Center(
        child: Image.asset(FImages.phloemLogo),
      ),
    );
  }
}