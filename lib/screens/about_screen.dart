import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Live TV App',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            const Text(
              'A modern streaming application for watching live TV channels.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            _buildInfoRow(
              context,
              icon: Icons.code,
              label: 'Developer',
              value: 'GitHub',
              onTap: () => _launchUrl('https://github.com/JS-Coder007'),
            ),
            const SizedBox(height: 48),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Placeholder for update functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Checking for updates... App is up to date!')),
                  );
                },
                icon: const Icon(Icons.system_update),
                label: const Text('Check for Updates'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, {required IconData icon, required String label, required String value, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Icon(icon, color: Theme.of(context).primaryColor, size: 28),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.grey)),
                Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            const Spacer(),
            const Icon(Icons.open_in_new, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
