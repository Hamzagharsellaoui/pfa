import 'package:flutter/material.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const mainColor = Color(0xFF7C3AED);
    const lightText = Color(0xFF6B7280);

    final TextEditingController fullNameController = TextEditingController(text: "Puerto Rico");
    final TextEditingController nicknameController = TextEditingController(text: "puerto_rico");
    final TextEditingController emailController = TextEditingController(text: "youremail@domain.com");
    final TextEditingController phoneController = TextEditingController(text: "+01 234 567 89");
    final TextEditingController countryController = TextEditingController(text: "United States");
    final TextEditingController genderController = TextEditingController(text: "Female");
    final TextEditingController addressController = TextEditingController(text: "45 New Avenue, New York");

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Edit profile",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildTextField("Full name", fullNameController),
            _buildTextField("Nick name", nicknameController),
            _buildTextField("Email", emailController, keyboardType: TextInputType.emailAddress),
            _buildTextField("Phone number", phoneController, keyboardType: TextInputType.phone),
            _buildTextField("Country", countryController),
            _buildTextField("Gender", genderController),
            _buildTextField("Address", addressController),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  // Handle save logic here
                },
                child: const Text(
                  "SUBMIT",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          floatingLabelStyle: const TextStyle(color: Colors.black87),
          labelStyle: const TextStyle(color: Colors.grey),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.black87),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}
