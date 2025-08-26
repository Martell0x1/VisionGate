import 'package:vision_gate/screens/chatbot_page.dart';
import 'package:vision_gate/navigation/support_actions.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});
  //fn for structure of each bottom
  Widget _buildSupportOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.2),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: color.withValues(alpha: 0.1),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Support & Help')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "How can we help you ?",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Divider(color: Colors.grey.shade300, thickness: 1),
            const SizedBox(height: 8),
            const Text(
              "Choose one of the options below to get the support you need",
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 24),

            //  Email Support
            _buildSupportOption(
              icon: Icons.email_outlined,
              title: "Email Support",
              subtitle: "visionsuporter999@gmail.com",
              color: Colors.blue,
              onTap: () {
                SupportActions.launchEmail();
              },
            ),

            //  WhatsApp Chat
            _buildSupportOption(
              icon: FontAwesomeIcons.whatsapp,
              title: "WhatsApp Chat",
              subtitle: "+201096412778",
              color: Colors.green,
              onTap: () {
                SupportActions.launchWhatsApp();
              },
            ),

            //  AI Chatbot
            _buildSupportOption(
              icon: FontAwesomeIcons.robot,
              title: "AI Chatbot",
              subtitle: "Ask your questions instantly",
              color: Colors.purple,
              onTap: () {
                SupportActions.openChatBot(context, const ChatBotPage());
              },
            ),
          ],
        ),
      ),
    );
  }
}
