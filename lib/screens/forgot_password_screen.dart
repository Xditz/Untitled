import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/database_helper.dart';
import '../services/otp_helper.dart';
import 'ForgotPasswordOTPVerificationScreen.dart'; // Perbarui impor

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  void _resetPassword() async {
    String email = _emailController.text;

    User? user = await _dbHelper.getUserByEmail(email);
    if (user != null) {
      String otp = OTPHelper.generateOTP();
      await OTPHelper.sendOTP(email, otp);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ForgotPasswordOTPVerificationScreen(email: email, otp: otp), // Gunakan layar OTP khusus
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Email not found'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Reset Password', style: TextStyle(fontSize: 24)),
            SizedBox(height: 8),
            Text('Enter your email to receive OTP'),
            SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _resetPassword,
              child: Text('Reset'),
            ),
          ],
        ),
      ),
    );
  }
}
