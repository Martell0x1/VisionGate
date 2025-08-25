import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportActions {
  // open app
  static Future<void> launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto', //Protocol for sending email
      path: 'visionsuporter999@gmail.com', // gmail
    );

    if (!await launchUrl(emailUri)) {
      throw Exception('Could not launch $emailUri');
    }
  }

  // open whatsapp
  static Future<void> launchWhatsApp() async {
    const phone = '+201096412778'; // phone_number
    final Uri whatsappUri = Uri.parse(
      'https://wa.me/$phone?text=Hello, I need help', //default message
    );

    if (!await launchUrl(whatsappUri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $whatsappUri');
    }
  }

  //open chatbot page
  static void openChatBot(BuildContext context, Widget chatPage) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => chatPage));
  }
}
