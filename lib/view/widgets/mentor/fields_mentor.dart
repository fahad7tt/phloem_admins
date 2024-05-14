import 'package:flutter/material.dart';
import 'package:phloem_admin/controller/email_controller.dart';
import 'package:phloem_admin/controller/mentor_controller.dart';
import 'package:provider/provider.dart';

class MentorFormFields {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final MentorProvider mentorProvider;

  MentorFormFields(this.mentorProvider);

  Widget buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(labelText: 'Name'),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a name';
        }

        if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
          return 'Only alphabets are allowed for name';
        }

        return null;
      },
    );
  }

  Widget buildEmailField() {
    return ChangeNotifierProvider(
      create: (_) => EmailValidationProvider(),
      child: Consumer<EmailValidationProvider>(
        builder: (context, emailValidationProvider, _) {
          return TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              errorText: emailValidationProvider.emailErrorText,
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter an email';
              }

              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return 'Please enter a valid email';
              }

              return null;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: (value) {
              emailValidationProvider.validateEmail(value);
            },
          );
        },
      ),
    );
  }

  Widget buildPasswordField() {
    return FutureBuilder<bool>(
      future: mentorProvider.isPasswordUnique(_passwordController.text),
      builder: (context, snapshot) {
        String? errorText;

        return TextFormField(
          controller: _passwordController,
          decoration: InputDecoration(
            labelText: 'Password',
            errorText: errorText,
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter a password';
            }

            if (value.length != 6) {
              return 'Password must be exactly 6 digits';
            }

            return null;
          },
        );
      },
    );
  }
}