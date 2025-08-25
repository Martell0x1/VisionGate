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
    String formatDate(DateTime date) => DateFormat('yyyy-MM-dd').format(date);
    String formatNumber(double number) => NumberFormat('#,###').format(number);

    return Scaffold(
      appBar: AppBar(title: const Text('Services')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Parking Service
            ServiceCounter(
              title: "Parking Service",
              unitPrice: 60,
              count: parkingDays,
              unitText: "each day",
              onChanged: (val) => setState(() => parkingDays = val),
            ),
            ListTile(
              title: const Text("Start Date (Parking)"),
              subtitle: Text(formatDate(parkingStartDate)),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _pickDate(
                (picked) => parkingStartDate = picked,
                parkingStartDate,
              ),
            ),
            if (parkingDays > 0)
              ListTile(
                title: const Text("End Date (Parking)"),
                subtitle: Text(
                  formatDate(
                    parkingStartDate.add(Duration(days: parkingDays - 1)),
                  ),
                ),
              ),
            const SizedBox(height: 16),

            // Car Wash Service
            ServiceCounter(
              title: "Car Wash Service",
              unitPrice: 30,
              count: carWashTimes,
              unitText: "each wash",
              onChanged: (val) => setState(() => carWashTimes = val),
            ),
            ListTile(
              title: const Text("Start Date (Car Wash)"),
              subtitle: Text(formatDate(carWashStartDate)),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _pickDate(
                (picked) => carWashStartDate = picked,
                carWashStartDate,
              ),
            ),
            if (carWashTimes > 0)
              ListTile(
                title: const Text("End Date (Car Wash)"),
                subtitle: Text(
                  formatDate(
                    carWashStartDate.add(Duration(days: carWashTimes - 1)),
                  ),
                ),
              ),
            const SizedBox(height: 16),

            // Total Amount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total Amount (Visa Payment)",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  "EGP ${formatNumber(totalCost)}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Confirm Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Send data to backend
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Payment confirmed")),
                  );
                },
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

  const ServiceCounter({
    super.key,
    required this.title,
    required this.unitPrice,
    required this.count,
    required this.unitText,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(50),
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
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            onPressed: () {
              if (count > 0) onChanged(count - 1);
            },
          ),
          Text(
            "$count",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () => onChanged(count + 1),
          ),
        ],
      ),
    );
  }
}
