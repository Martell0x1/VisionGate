import 'package:flutter/material.dart';

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({super.key});

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];

  final Map<String, String> _faq = {
    "hi": "Hello! How can I help you?",
    "hello": "Hi there!",
    "مواعيد العمل": "مواعيد عملنا من 9 صباحًا إلى 5 مساءً",
    "working hours": "Our working hours are from 9 AM to 5 PM",
    "العنوان": "العنوان: الإسكندرية - كلية الحاسبات وعلوم البيانات",
    "address":
        "Our address: Alexandria - Faculty of Computers and Data Science",
    "المكان": "العنوان: الإسكندرية - كلية الحاسبات وعلوم البيانات",
    "location":
        "Our address: Alexandria - Faculty of Computers and Data Science",
    "contact": "Email: visionsuporter999@gmail.com\nPhone: +201208580839",
    "شكرا": "العفو، تحت أمرك!",
    "thanks": "You're welcome!",
    "services": "We offer parking, car wash, and premium maintenance services.",
    "payment": "You can pay via cash, Visa card, or e-wallet.",
    "your ass is red": "your ass is blue ya qalbi",
    "المواعيد": "مواعيد عملنا من 9 صباحًا إلى 5 مساءً",
  };

  final List<String> _quickReplies = [
    "location",
    "working hours",
    "contact",
    "services",
    "payment",
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _messages.add({
          "sender": "bot",
          "text":
              "السلام عليكم\nانا البوت الخاص بشركة VisionGate\nازاي اقدر اخدمك؟\n\nHello\nI am VisionGate’s chatbot\nHow can I help you today?",
        });
      });
    });
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add({"sender": "user", "text": text});
    });

    _controller.clear();

    Future.delayed(const Duration(milliseconds: 500), () {
      String reply = "";
      if (_faq.containsKey(text.toLowerCase()) || _faq.containsKey(text)) {
        reply = _faq[text.toLowerCase()] ?? _faq[text]!;
      } else {
        bool isArabic = RegExp(r'[\u0600-\u06FF]').hasMatch(text);
        reply = isArabic
            ? "آسف، مش فاهم قصدك. ممكن تعيد صياغة السؤال؟"
            : "Sorry, I don’t understand. Could you rephrase?";
      }

      setState(() {
        _messages.add({"sender": "bot", "text": reply});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("AI Chatbot"),
        backgroundColor: isDark ? Colors.black : Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black),
        titleTextStyle: TextStyle(
          color: isDark ? Colors.white : Colors.black,
          fontSize: 20,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message["sender"] == "user";

                return Align(
                  alignment: isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser
                          ? (isDark ? Colors.grey[800] : Colors.black)
                          : (isDark ? Colors.grey[700] : Colors.grey[300]),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      message["text"] ?? "",
                      style: TextStyle(
                        fontSize: 16,
                        color: isUser
                            ? Colors.white
                            : (isDark ? Colors.white : Colors.black),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            height: 50,
            color: isDark ? Colors.grey[900] : Colors.white,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: _quickReplies.map((text) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? Colors.grey[800] : Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () => _sendMessage(text),
                    child: Text(text),
                  ),
                );
              }).toList(),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            color: isDark ? Colors.grey[850] : Colors.grey[200],
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Write your message here...",
                      hintStyle: TextStyle(
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                      border: InputBorder.none,
                    ),
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    onSubmitted: _sendMessage,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.send,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  onPressed: () => _sendMessage(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
