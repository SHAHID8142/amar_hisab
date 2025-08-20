import 'package:amar_hisab/providers/theme_provider.dart';
import 'package:amar_hisab/services/google_drive_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4.0,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: [
                  _buildSettingsTile(
                    icon: Icons.person,
                    title: 'Profile Management',
                    onTap: () {
                      // Navigate to profile management screen
                    },
                  ),
                  const Divider(),
                  _buildSettingsTile(
                    icon: Icons.lock,
                    title: 'Change Password',
                    onTap: () {
                      // Navigate to change password screen
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            Card(
              elevation: 4.0,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    secondary: const Icon(Icons.notifications),
                    title: const Text('Push Notifications'),
                    value: true, // Replace with state management
                    onChanged: (value) {
                      // Update notification settings
                    },
                  ),
                  const Divider(),
                  SwitchListTile(
                    secondary: const Icon(Icons.dark_mode),
                    title: const Text('Dark Mode'),
                    value: themeProvider.themeMode == ThemeMode.dark,
                    onChanged: (value) {
                      themeProvider.toggleTheme(value);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            Card(
              elevation: 4.0,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: [
                  _buildSettingsTile(
                    icon: Icons.backup,
                    title: 'Backup Data',
                    onTap: () {
                      GoogleDriveService().backupData(context);
                    },
                  ),
                  const Divider(),
                  _buildSettingsTile(
                    icon: Icons.restore,
                    title: 'Restore Data',
                    onTap: () {
                      GoogleDriveService().restoreData(context);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            Card(
              elevation: 4.0,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: [
                  _buildSettingsTile(
                    icon: Icons.info,
                    title: 'About Amar Hisab',
                    onTap: () {
                      // Show about dialog
                    },
                  ),
                  const Divider(),
                  _buildSettingsTile(
                    icon: Icons.policy,
                    title: 'Privacy Policy',
                    onTap: () {
                      // Open privacy policy URL
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }



  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }
}