import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  File? _profileImage;
  final picker = ImagePicker();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageTemp = File(pickedFile.path);
      final savedImage = await _saveImageLocally(imageTemp);
      setState(() {
        _profileImage = savedImage;
      });
    }
  }

  Future<File> _saveImageLocally(File image) async {
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = basename(image.path);
    final savedImage = await image.copy('${appDir.path}/$fileName');
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('profileImagePath', savedImage.path);
    return savedImage;
  }

  bool isValidEmail(String email) =>
      RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(email);

  bool isValidPhone(String phone) => RegExp(r"^[0-9]{10,}$").hasMatch(phone);

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      usernameController.text = prefs.getString('username') ?? "JohnDoe";
      emailController.text = prefs.getString('email') ?? "";
      phoneController.text = prefs.getString('phone') ?? "";
      String? imagePath = prefs.getString('profileImagePath');
      _profileImage = File(imagePath);
        });
  }

  Future<void> _saveProfile() async {
    final email = emailController.text;
    final phone = phoneController.text;
    final username = usernameController.text;

    if (email.isNotEmpty && !isValidEmail(email)) {
      _showMessage("Invalid email address.");
      return;
    }

    if (phone.isNotEmpty && !isValidPhone(phone)) {
      _showMessage("Invalid phone number.");
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('username', username);
    prefs.setString('email', email);
    prefs.setString('phone', phone);

    _showMessage("Profile saved!");
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context as BuildContext).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.teal[100],
                backgroundImage:
                    _profileImage != null ? FileImage(_profileImage!) : null,
                child: _profileImage == null
                    ? const Icon(Icons.camera_alt, size: 40, color: Colors.teal)
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email (optional)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone (optional)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _saveProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text("Save", style: TextStyle(fontSize: 16)),
            )
          ],
        ),
      ),
    );
  }
}
