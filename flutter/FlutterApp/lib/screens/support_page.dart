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
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey.shade900 : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withValues(alpha: 60),
              ),
              padding: const EdgeInsets.all(16),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: isDark ? Colors.white54 : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        title: const Text('Support & Help'),
        backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black87,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "How can we help you ?",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Divider(
              color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
              thickness: 1,
            ),
            const SizedBox(height: 8),
            Text(
              "Choose one of the options below to get the support you need",
              style: TextStyle(
                fontSize: 16,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
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
              isDark: isDark,
            ),

            //  WhatsApp Chat
            _buildSupportOption(
              icon: FontAwesomeIcons.whatsapp,
              title: "WhatsApp Chat",
              subtitle: "+201208580839",
              color: Colors.green,
              onTap: () {
                SupportActions.launchWhatsApp();
              },
              isDark: isDark,
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
              isDark: isDark,
            ),
          ],
        ),
      ),
    );
  }
}
