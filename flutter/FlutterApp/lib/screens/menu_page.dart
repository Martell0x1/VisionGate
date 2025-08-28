import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../navigation/menu_navigator.dart';

class MenuPage extends StatelessWidget {
  final String email;
  const MenuPage({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.car,
                    size: 50,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Vision Gate garage',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Premium Car Services',
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.white70 : Colors.black26,
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'Choose Your Plan',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(height: 16),
              Column(
                children: [
                  planCard(
                    context,
                    '10 Days Plan',
                    'Perfect for short-term needs',
                    '550 EGP',
                    '55 EGP / day',
                    Colors.black,
                    isDark,
                  ),
                  planCard(
                    context,
                    '1 Month Plan',
                    'Most popular choice',
                    '1,700 EGP',
                    '57 EGP / day',
                    Colors.green,
                    isDark,
                  ),
                  planCard(
                    context,
                    '3 Months Plan',
                    'Save 15% with quarterly plan',
                    '5,000 EGP',
                    '56 EGP / day',
                    Colors.yellow.shade700,
                    isDark,
                  ),
                  planCard(
                    context,
                    '6 Months Plan',
                    'Best value for regular users',
                    '9,900 EGP',
                    '55 EGP / day',
                    Colors.red,
                    isDark,
                  ),
                  planCard(
                    context,
                    '1 Year Plan',
                    'Maximum savings - 30% off',
                    '19,000 EGP',
                    '52 EGP / day',
                    Colors.purple,
                    isDark,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Quick Access',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => AppNavigator.goToServices(context),
                      child: quickAccessCard(
                        'Services',
                        'View all services',
                        Icons.build,
                        isDark,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => AppNavigator.goToSupport(context),
                      child: quickAccessCard(
                        'Support',
                        'Customer service',
                        Icons.support_agent,
                        isDark,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => AppNavigator.goToSettings(context, email),
                      child: quickAccessCard(
                        'Settings',
                        'Account settings',
                        Icons.settings,
                        isDark,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => AppNavigator.goToLocation(context),
                      child: quickAccessCard(
                        'Location',
                        'Find us on map',
                        Icons.location_on,
                        isDark,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget planCard(
    BuildContext context,
    String title,
    String subtitle,
    String price,
    String dailyPrice,
    Color color,
    bool isDark,
  ) {
    final int alphaBg = isDark ? 51 : 26;
    final int alphaBorder = isDark ? 204 : 255;

    final bgColor = color.withAlpha(alphaBg);
    final borderColor = color.withAlpha(alphaBorder);

    return GestureDetector(
      onTap: () =>
          AppNavigator.goToPlanDetails(context, planName: title, price: price),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor, width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : color,
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
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  price,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : color,
                  ),
                ),
                Text(
                  dailyPrice,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget quickAccessCard(
    String title,
    String subtitle,
    IconData icon,
    bool isDark,
  ) {
    final bgColor = isDark ? Colors.grey.shade800 : Colors.grey.shade200;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.white70 : Colors.black54;
    final iconColor = isDark ? Colors.tealAccent : Colors.blueAccent;

    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 30, color: iconColor),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(color: subTextColor, fontSize: 12),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
