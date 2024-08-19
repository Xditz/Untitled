import 'package:flutter/material.dart';
import 'reset_password_screen.dart';

class ForgotPasswordOTPVerificationScreen extends StatefulWidget {
  final String email;
  final String otp;

  ForgotPasswordOTPVerificationScreen({required this.email, required this.otp});

  @override
  _ForgotPasswordOTPVerificationScreenState createState() => _ForgotPasswordOTPVerificationScreenState();
}

class _ForgotPasswordOTPVerificationScreenState extends State<ForgotPasswordOTPVerificationScreen> {
  final int otpLength = 4;
  late List<String> otpFields; // Menggunakan `late` untuk inisialisasi di `initState`

  @override
  void initState() {
    super.initState();
    otpFields = List.filled(otpLength, ''); // Inisialisasi `otpFields` di sini
  }

  void _verifyOTP() {
    String enteredOTP = otpFields.join();
    if (enteredOTP == widget.otp) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ResetPasswordScreen(email: widget.email)),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Invalid OTP'),
          content: Text('The OTP you entered is incorrect.'),
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

  Widget _buildOTPField(int index) {
    return Container(
      width: 60,
      height: 60,
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: TextField(
        onChanged: (value) {
          setState(() {
            otpFields[index] = value;
          });
          if (value.isNotEmpty && index < otpLength - 1) {
            FocusScope.of(context).nextFocus();
          }
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: Color(0xFFFAFAFA),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
          counterText: '',
        ),
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: TextStyle(fontSize: 24),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Verification Code',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text('We have sent a verification code to ${widget.email}'),
            SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(otpLength, (index) => _buildOTPField(index)),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _verifyOTP,
              style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 48)),
              child: Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
