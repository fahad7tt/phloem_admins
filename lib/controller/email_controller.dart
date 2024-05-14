import 'package:flutter/material.dart';
import 'package:phloem_admin/view/validator/email_validator.dart';

class EmailValidationProvider extends ChangeNotifier {
  String? _emailErrorText;

  String? get emailErrorText => _emailErrorText;

  Future<void> validateEmail(String email) async {
    final isValid = await EmailValidator.isEmailValid(email);
    _emailErrorText = isValid ? null : 'Please enter a valid real-world email';
    notifyListeners();
  }
}