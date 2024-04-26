import 'package:flutter/material.dart';
import 'widget_course.dart';

// ignore: must_be_immutable
class AddCourseForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final FormFieldsBuilder _formFieldsBuilder = FormFieldsBuilder(); // Instantiate FormFieldsBuilder

  AddCourseForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _formFieldsBuilder.buildCourseNameFormField(), 
          _formFieldsBuilder.buildPaymentDropdownFormField(), 
          _formFieldsBuilder.buildNextButton(context),
        ],
      ),
    );
  }
}