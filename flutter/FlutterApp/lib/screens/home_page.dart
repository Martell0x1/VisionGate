import 'package:vision_gate/themes/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vision_gate/screens/register_page.dart';
import 'package:vision_gate/screens/server_settings_page.dart';
import '../services/api_service.dart';
import '../models/login.dart';
import './menu_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String _responseMessage = ''; // Variable to hold response message

  Future<void> _login() async {
    // Show loading snackbar first
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("⏳ Login...")));

    final user = Login(
      email: _emailController.text,
      password: _passwordController.text,
    );

    try {
      final response = await ApiService().userlogin(user);

      setState(() {
        _responseMessage = response.message ?? 'Login successful';
      });

      if (response.success) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (newContext) => MenuPage(email: user.email),
          ),
        );

        // Save
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', _emailController.text);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Login failed: ${response.message ?? 'Unknown error'}",
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _responseMessage = 'Error: ${e.toString()}';
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Consumer<ThemeModel>(
      builder: (context, ThemeModel themeNotifier, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              themeNotifier.isDark ? "Dark Mode" : "Light Mode",
              style: TextStyle(
                color: themeNotifier.isDark
                    ? Colors.white
                    : Colors.grey.shade900,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings), // ✅ add settings button
                color: themeNotifier.isDark
                    ? Colors.white
                    : Colors.grey.shade900,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ServerSettingsPage(),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(
                  themeNotifier.isDark
                      ? Icons.nightlight_round
                      : Icons.wb_sunny,
                  color: themeNotifier.isDark
                      ? Colors.white
                      : Colors.grey.shade900,
                ),
                onPressed: () {
                  themeNotifier.isDark
                      ? themeNotifier.isDark = false
                      : themeNotifier.isDark = true;
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Container(
              width: size.width,
              height: size.height,
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: size.height * 0.2,
                top: size.height * 0.05,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Hello, \nWelcome Back",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: size.width * 0.1,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            width: 30,
                            image: AssetImage('assets/google.jpg'),
                          ),
                          SizedBox(width: 40),
                          Image(
                            width: 30,
                            image: AssetImage('assets/facebook.jpg'),
                          ),
                        ],
                      ),
                      SizedBox(height: 50),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorLight,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: " Enter your Email ",
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorLight,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Password",
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Forgot Password?",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      MaterialButton(
                        onPressed: _login,
                        elevation: 0,
                        padding: EdgeInsets.all(18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        color: Colors.blue,
                        child: Center(
                          child: Text(
                            "Login",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterPage(),
                            ),
                          );
                        },
                        child: Text(
                          "Create account",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      Text(_responseMessage),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
