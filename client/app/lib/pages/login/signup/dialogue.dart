import 'package:app/pages/login/signup/confirmation.dart';
import 'package:app/pages/login/signup/form.dart';
import 'package:flutter/material.dart';

class SignUpDialog extends StatefulWidget {
  const SignUpDialog({super.key});

  @override
  _SignUpDialogState createState() => _SignUpDialogState();
}

class _SignUpDialogState extends State<SignUpDialog> {
  bool _isWaitingForConfirmation = false;
  bool _isConfirmed = false;
  String? _errorMessage;
  String _submittedEmail = '';

  void _submitSignUpForm(Map<String, String> signUpData) {
    _submittedEmail = signUpData['email_address'] ?? '';

    // Simulate sending POST request to '/user'
    // This is where you would call your backend API
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        // Simulate a successful sign up
        _isWaitingForConfirmation = true;
        _isConfirmed = false;
      });
      _checkEmailConfirmation();
    });
  }

  void _checkEmailConfirmation() {
    // Replace this with your actual server polling logic
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        _isConfirmed = true; // Set confirmation status to true
      });
      // Delay before closing the dialog to allow animation to play
      Future.delayed(const Duration(milliseconds: 1100), () { // Adjust duration as needed for the animation
        Navigator.of(context).pop(); // Close the dialog after the delay
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isWaitingForConfirmation ? 'Waiting for Confirmation' : 'Sign Up'),
      content: _isWaitingForConfirmation 
        ? WaitingForConfirmationWidget(
            emailAddress: _submittedEmail,
            isConfirmed: _isConfirmed,
          )
        : SignUpForm(onSubmit: _submitSignUpForm, errorMessage: _errorMessage),
    );
  }
}
