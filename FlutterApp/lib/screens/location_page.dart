import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationPage extends StatelessWidget {
  const LocationPage({super.key});

  final String _googleMapsUrl =
      "https://maps.app.goo.gl/WiUxVG6eczSfHCrPA"; // لينك الكلية

  Future<void> _openGoogleMaps() async {
    final Uri url = Uri.parse(_googleMapsUrl); // استخدم المتغير هنا
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch Google Maps';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location of Vision Gate'),
      ), // العنوان الجديد
      body: Center(
        child: GestureDetector(
          onTap: _openGoogleMaps,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_on, size: 80, color: Colors.red),
              const SizedBox(height: 16),
              const Text(
                "كلية الحاسبات وعلوم البيانات - الإسكندرية",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "اضغط هنا لفتح الموقع على Google Maps",
                style: TextStyle(color: Colors.blue, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
