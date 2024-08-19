import 'package:flutter/material.dart';
import '../services/otp_helper.dart'; // Pastikan untuk mengimpor OTPHelper
import 'login_screen.dart';

class SignupOTPVerificationScreen extends StatefulWidget {
  final String email;

  SignupOTPVerificationScreen({required this.email});

  @override
  _SignupOTPVerificationScreenState createState() => _SignupOTPVerificationScreenState();
}

class _SignupOTPVerificationScreenState extends State<SignupOTPVerificationScreen> {
  final int otpLength = 4;
  late List<String> otpFields;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    otpFields = List.filled(otpLength, '');
  }

  void _verifyOTP() async {
    setState(() {
      isLoading = true;
    });

    String enteredOTP = otpFields.join();
    bool isVerified = await OTPHelper.verifyOTP(widget.email, enteredOTP);

    setState(() {
      isLoading = false;
    });

    if (isVerified) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()), // Setelah verifikasi, arahkan ke LoginScreen
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Invalid or Expired OTP'),
          content: Text('OTP yang kamu masukkan salah atau sudah tidak valid.'),
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
            Text('KIta sudah mengirim OTP ke ${widget.email}. Masukkan di kotak bawah ini:'),
            SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(otpLength, (index) => _buildOTPField(index)),
            ),
            SizedBox(height: 32),
            isLoading
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
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
