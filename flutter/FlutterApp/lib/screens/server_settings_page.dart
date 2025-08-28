import 'package:flutter/material.dart';
import 'package:vision_gate/services/server_config.dart';

class ServerSettingsPage extends StatefulWidget {
  const ServerSettingsPage({super.key});

  @override
  State<ServerSettingsPage> createState() => _ServerSettingsPageState();
}

class _ServerSettingsPageState extends State<ServerSettingsPage> {
  final TextEditingController _urlController = TextEditingController();
  String _currentUrl = "";

  @override
  void initState() {
    super.initState();
    _loadCurrentUrl();
  }

  Future<void> _loadCurrentUrl() async {
    final url = await ServerConfig.getBaseUrl();
    setState(() {
      _currentUrl = url ?? "Not set";
      _urlController.text = url ?? "";
    });
  }

  Future<void> _saveUrl() async {
    final newUrl = _urlController.text.trim();
    if (newUrl.isNotEmpty) {
      await ServerConfig.saveBaseUrl(newUrl);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("✅ Server URL saved: $newUrl")),
      );
      setState(() {
        _currentUrl = newUrl;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Please enter a valid URL")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Server Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Current URL: $_currentUrl",
                style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 20),
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Enter server URL",
                hintText: "http://192.168.1.10:3000",
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveUrl,
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
