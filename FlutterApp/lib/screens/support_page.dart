import 'package:vision_gate/screens/chatbot_page.dart';
import 'package:vision_gate/navigation/support_actions.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  // widget for each support option
  Widget _buildSupportOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: 255 * 0.1,
              ), // ✅ بدل withOpacity(0.1)
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
                color: color.withValues(
                  alpha: 255 * 0.15,
                ), // ✅ بدل withOpacity(0.15)
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
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle, style: theme.textTheme.bodySmall),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: theme.iconTheme.color?.withValues(
                alpha: 255 * 0.6,
              ), // ✅ بدل withOpacity(0.6)
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Support & Help')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "How can we help you ?",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Divider(color: theme.dividerColor, thickness: 1),
            const SizedBox(height: 8),
            Text(
              "Choose one of the options below to get the support you need",
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),

            // Email Support
            _buildSupportOption(
              icon: Icons.email_outlined,
              title: "Email Support",
              subtitle: "visionsuporter999@gmail.com",
              color: Colors.blue,
              onTap: () {
                SupportActions.launchEmail();
              },
              context: context,
            ),

            // WhatsApp Chat
            _buildSupportOption(
              icon: FontAwesomeIcons.whatsapp,
              title: "WhatsApp Chat",
              subtitle: "+201208580839",
              color: Colors.green,
              onTap: () {
                SupportActions.launchWhatsApp();
              },
              context: context,
            ),

            // AI Chatbot
            _buildSupportOption(
              icon: FontAwesomeIcons.robot,
              title: "AI Chatbot",
              subtitle: "Ask your questions instantly",
              color: Colors.purple,
              onTap: () {
                SupportActions.openChatBot(context, const ChatBotPage());
              },
              context: context,
            ),
          ],
        ),
      ),
    );
  }
}
