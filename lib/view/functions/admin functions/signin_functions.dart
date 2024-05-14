import 'package:flutter/material.dart';
import 'package:phloem_admin/view/const/color/colors.dart';
import 'package:phloem_admin/view/const/credentials/admin_credentials.dart';
import 'package:phloem_admin/view/screens/dashboard/dashboard.dart';

class LoginFunctions {
  static void login(BuildContext context, String email, String password) {
    if (email.isEmpty || password.isEmpty) {
      showError(context, 'Please fill all the fields.');
    } else if (email == Credentials.adminEmail && password == Credentials.adminPassword) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => AdminDashboard(),
        ),
      );
    } else {
      showError(context, 'Invalid email or password.');
    }
  }

  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: FColors.errorColor
      ),
    );
  }
}