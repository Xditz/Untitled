import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/database_helper.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    String? email = await _getUserEmail();

    if (email != null) {
      User? user = await _dbHelper.getUserByEmail(email);

      if (user != null) {
        setState(() {
          _fullNameController.text = user.fullName;
          _bioController.text = user.bio;
          _profileImage = user.photoPath != null ? File(user.photoPath!) : null;
        });
      }
    }
  }

  Future<void> _updateProfile() async {
    String fullName = _fullNameController.text;
    String bio = _bioController.text;

    if (fullName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid name')),
      );
      return;
    }

    try {
      String? email = await _getUserEmail();

      if (email != null) {
        User updatedUser = User(
          id: (await _dbHelper.getUserByEmail(email))?.id,
          email: email,
          password: (await _dbHelper.getUserByEmail(email))?.password ?? '', // Tetap simpan password
          fullName: fullName,
          bio: bio,
          photoPath: _profileImage?.path,
        );

        await _dbHelper.updateUser(updatedUser);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: User not logged in')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $e')),
      );
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<String?> _getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_email');
  }

  Future<void> _deleteAccount() async {
    try {
      String? email = await _getUserEmail();

      if (email != null) {
        await _dbHelper.deleteUserByEmail(email);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove('user_email'); // Hapus email yang tersimpan
        await prefs.remove('device_id'); // Hapus device_id yang tersimpan

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Account and device information deleted successfully')),
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
              (Route<dynamic> route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No user is currently logged in')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete account: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Settings'),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profile Settings',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _profileImage != null
                      ? FileImage(_profileImage!)
                      : AssetImage('assets/default_profile.png') as ImageProvider,
                  child: _profileImage == null
                      ? Icon(Icons.add_a_photo, size: 50, color: Colors.white)
                      : null,
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _fullNameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
                filled: true,
                fillColor: Color(0xFFFAFAFA),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _bioController,
              decoration: InputDecoration(
                labelText: 'Bio',
                filled: true,
                fillColor: Color(0xFFFAFAFA),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _updateProfile,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 48),
                backgroundColor: Colors.blue,
              ),
              child: Text('Update Profile'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _deleteAccount, // Panggil fungsi untuk menghapus akun dan device_id
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 48),
                backgroundColor: Colors.red,
              ),
              child: Text('Delete Account'),
            ),
          ],
        ),
      ),
    );
  }
}
