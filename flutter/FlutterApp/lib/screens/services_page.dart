import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  int parkingDays = 0;
  int carWashTimes = 0;

  DateTime parkingStartDate = DateTime.now();
  DateTime carWashStartDate = DateTime.now();

  double get parkingCost => parkingDays * 60.0;
  double get carWashCost => carWashTimes * 30.0;
  double get totalCost => parkingCost + carWashCost;

  void _pickDate(Function(DateTime) onDatePicked, DateTime initialDate) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        onDatePicked(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    String formatDate(DateTime date) => DateFormat('yyyy-MM-dd').format(date);
    String formatNumber(double number) => NumberFormat('#,###').format(number);

    final textColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.white70 : Colors.black54;
    final totalCostColor = Colors.greenAccent.shade400;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Services'),
        backgroundColor: isDark ? Colors.grey.shade900 : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ServiceCounter(
              title: "Parking Service",
              unitPrice: 60,
              count: parkingDays,
              unitText: "each day",
              onChanged: (val) => setState(() => parkingDays = val),
              isDark: isDark,
            ),
            ListTile(
              title: Text(
                "Start Date (Parking)",
                style: TextStyle(color: textColor),
              ),
              subtitle: Text(
                formatDate(parkingStartDate),
                style: TextStyle(color: subTextColor),
              ),
              trailing: Icon(Icons.calendar_today, color: textColor),
              onTap: () => _pickDate(
                (picked) => parkingStartDate = picked,
                parkingStartDate,
              ),
            ),
            if (parkingDays > 0)
              ListTile(
                title: Text(
                  "End Date (Parking)",
                  style: TextStyle(color: textColor),
                ),
                subtitle: Text(
                  formatDate(
                    parkingStartDate.add(Duration(days: parkingDays - 1)),
                  ),
                  style: TextStyle(color: subTextColor),
                ),
              ),
            const SizedBox(height: 16),

            ServiceCounter(
              title: "Car Wash Service",
              unitPrice: 30,
              count: carWashTimes,
              unitText: "each wash",
              onChanged: (val) => setState(() => carWashTimes = val),
              isDark: isDark,
            ),
            ListTile(
              title: Text(
                "Start Date (Car Wash)",
                style: TextStyle(color: textColor),
              ),
              subtitle: Text(
                formatDate(carWashStartDate),
                style: TextStyle(color: subTextColor),
              ),
              trailing: Icon(Icons.calendar_today, color: textColor),
              onTap: () => _pickDate(
                (picked) => carWashStartDate = picked,
                carWashStartDate,
              ),
            ),
            if (carWashTimes > 0)
              ListTile(
                title: Text(
                  "End Date (Car Wash)",
                  style: TextStyle(color: textColor),
                ),
                subtitle: Text(
                  formatDate(
                    carWashStartDate.add(Duration(days: carWashTimes - 1)),
                  ),
                  style: TextStyle(color: subTextColor),
                ),
              ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Amount (Visa Payment)",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                Text(
                  "EGP ${formatNumber(totalCost)}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: totalCostColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Payment confirmed")),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? Colors.tealAccent.shade700 : null,
                ),
                child: const Text("Confirm Payment"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ServiceCounter extends StatelessWidget {
  final String title;
  final int unitPrice;
  final int count;
  final String unitText;
  final Function(int) onChanged;
  final bool isDark;

  const ServiceCounter({
    super.key,
    required this.title,
    required this.unitPrice,
    required this.count,
    required this.unitText,
    required this.onChanged,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? Colors.white : Colors.black87;

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade800 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : Colors.grey.withAlpha(50),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "$title (EGP $unitPrice $unitText)",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.remove_circle_outline, color: textColor),
            onPressed: () {
              if (count > 0) onChanged(count - 1);
            },
          ),
          Text(
            "$count",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          IconButton(
            icon: Icon(Icons.add_circle_outline, color: textColor),
            onPressed: () => onChanged(count + 1),
          ),
        ],
      ),
    );
  }
}
