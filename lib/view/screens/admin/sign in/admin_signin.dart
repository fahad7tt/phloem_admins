import 'package:flutter/material.dart';
import 'package:phloem_admin/view/const/image/image_const.dart';
import 'package:phloem_admin/view/functions/admin%20functions/signin_functions.dart';
import 'package:phloem_admin/view/screens/admin/sign%20in/signin_form.dart';
import 'package:phloem_admin/view/screens/dashboard/dashboard.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(26.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              FImages.adminLogo,
              height: 160,
              width: 160,
            ),
            const SizedBox(height: 40),
            LoginForm(
              emailController: emailController,
              passwordController: passwordController,
              onLogin: (isError, errorMessage) {
                if (!isError) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AdminDashboard(),
                    ),
                  );
                }
              },
              onLoginPressed: () {
                LoginFunctions.login(context, emailController.text.trim(), passwordController.text.trim());
              },
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  LoginFunctions.login(context, emailController.text.trim(), passwordController.text.trim());
                },
                child: const Text('Login'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}