import 'package:flutter/material.dart';
import 'package:pfa_flutter/presentation/screens/edit_profile_screen.dart';
import '../../logic/auth/auth_bloc.dart';
import '../widgets/profile_image_uploader.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final mainColor = const Color(0xFF7C3AED);
  final lightGray = const Color(0xFFF4F4F7);
  final darkText = const Color(0xFF111827);
  final lightText = const Color(0xFF6B7280);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Profile",
          style: TextStyle(color: darkText, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: FutureBuilder<String?>(
        future: AuthBloc.getIdFromToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final userId = snapshot.data ?? '';

          return Column(
            children: [
              const SizedBox(height: 20),
              ProfileImageUploader(userId: userId),
              const SizedBox(height: 12),
              const Text(
                "Puerto Rico",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
              ),
              const SizedBox(height: 4),
              const Text(
                "youremail@domain.com | +01 234 567 89",
                style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _buildProfileTile("Edit profile information", Icons.person_outline, onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                      );
                    }),
                    _buildProfileTile("Notifications", Icons.notifications_none_rounded, trailing: const Text("ON")),
                    _buildProfileTile("Language", Icons.language, trailing: const Text("English")),
                    _buildProfileTile("Security", Icons.lock_outline),
                    _buildProfileTile("Theme", Icons.dark_mode_outlined, trailing: const Text("Light mode")),
                    const Divider(height: 30),
                    _buildProfileTile("Help & Support", Icons.help_outline),
                    _buildProfileTile("Contact us", Icons.email_outlined),
                    _buildProfileTile("Privacy policy", Icons.privacy_tip_outlined),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProfileTile(String title, IconData icon,
      {Widget? trailing, VoidCallback? onTap}) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: Icon(icon, color: Colors.black54),
      title: Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      ),
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios_rounded, size: 16),
    );
  }
}