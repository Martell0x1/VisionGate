import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../navigation/menu_navigator.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row: Car Icon + Title
              const SizedBox(height: 20),
              Row(
                children: const [
                  FaIcon(
                    FontAwesomeIcons.car,
                    size: 50,
                    color: Colors.black,
                  ), //car icon from FontAwesome library
                  SizedBox(width: 8),
                  Text(
                    'Vision Gate garage',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'Premium Car Services',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black26,
                ), //black26 معناه لون أسود شفاف بنسبة حوالي 26%
              ),
              const SizedBox(height: 16),

              // Choose Your Plan title
              const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 16.0,
                ), // عشان المسافه بين الكلام ال الجوا الصندوق 16 بيكسلز من جميع الجهات
                child: Text(
                  'Choose Your Plan',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),

              const SizedBox(height: 16),

              // Plans
              Column(
                children: [
                  planCard(
                    context,
                    '10 Days Plan',
                    'Perfect for short-term needs',
                    '550 EGP',
                    '55 EGP / day',
                    Colors.black,
                  ),
                  planCard(
                    context,
                    '1 Month Plan',
                    'Most popular choice',
                    '1,700 EGP',
                    '57 EGP / day',
                    Colors.green,
                  ),
                  planCard(
                    context,
                    '3 Months Plan',
                    'Save 15% with quarterly plan',
                    '5,000 EGP',
                    '56 EGP / day',
                    Colors.yellow.shade700,
                  ),
                  planCard(
                    context,
                    '6 Months Plan',
                    'Best value for regular users',
                    '9,900 EGP',
                    '55 EGP / day',
                    Colors.red,
                  ),
                  planCard(
                    context,
                    '1 Year Plan',
                    'Maximum savings - 30% off',
                    '19,000 EGP',
                    '52 EGP / day',
                    Colors.purple,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Quick Access section
              const Text(
                'Quick Access',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // Quick Access items: 2 in each row
              Row(
                children: [
                  Expanded(
                    // to take all spaces in the row between all elements
                    child: GestureDetector(
                      onTap: () => AppNavigator.goToServices(context),
                      child: quickAccessCard(
                        'Services',
                        'View all services',
                        Icons.build,
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
                      onTap: () => AppNavigator.goToSettings(context),
                      child: quickAccessCard(
                        'Settings',
                        'Account settings',
                        Icons.settings,
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

  // Plan card fn with daily price
  Widget planCard(
    BuildContext context,
    String title,
    String subtitle,
    String price,
    String dailyPrice,
    Color color,
  ) {
    return GestureDetector(
      onTap: () =>
          AppNavigator.goToPlanDetails(context, planName: title, price: price),
      child: Container(
        width: double.infinity, //to be full row
        margin: const EdgeInsets.symmetric(
          vertical: 8,
        ), //the space between each plan
        padding: const EdgeInsets.all(16), //the space inside plan
        //design each plan
        decoration: BoxDecoration(
          color: color.withAlpha((0.1 * 255).toInt()),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color, width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
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
                    color: color,
                  ),
                ),
                Text(
                  dailyPrice,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Quick Access card
  static Widget quickAccessCard(String title, String subtitle, IconData icon) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 30, color: Colors.blueAccent),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.black54, fontSize: 12),
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
