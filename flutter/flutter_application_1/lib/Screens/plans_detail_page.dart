import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PlansDetailPage extends StatefulWidget {
  final String planName;
  final String price;

  const PlansDetailPage({
    super.key,
    required this.planName,
    required this.price,
  });

  @override
  State<PlansDetailPage> createState() => _PlansDetailPageState();
}

class _PlansDetailPageState extends State<PlansDetailPage> {
  DateTime? startDate;
  DateTime? endDate;
  final TextEditingController cardHolderController = TextEditingController();
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expiryController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();

  int getPlanDurationInDays() {
    switch (widget.planName) {
      case '10 Days Plan':
        return 10;
      case '1 Month Plan':
        return 30;
      case '3 Months Plan':
        return 90;
      case '6 Months Plan':
        return 180;
      case '1 Year Plan':
        return 365;
      default:
        return 30;
    }
  }

  Future<void> pickStartDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        startDate = picked;
        endDate = picked.add(Duration(days: getPlanDurationInDays()));
      });
    }
  }

  bool validateCardDetails() {
    if (cardHolderController.text.isEmpty) return false;
    if (cardNumberController.text.length != 16) return false;
    if (expiryController.text.length != 5) return false;
    if (cvvController.text.length != 3) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.planName)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Price: ${widget.price}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Text('Start Date', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 4),
            GestureDetector(
              onTap: pickStartDate,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 8,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  startDate != null
                      ? '${startDate!.toLocal()}'.split(' ')[0]
                      : 'Select Start Date',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 8),

            Text('End Date', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.shade200,
              ),
              child: Text(
                endDate != null
                    ? '${endDate!.toLocal()}'.split(' ')[0]
                    : 'End Date will be calculated',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Credit Card Info',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            TextField(
              controller: cardHolderController,
              decoration: const InputDecoration(
                labelText: 'Cardholder Name',
                border: OutlineInputBorder(),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
              ],
            ),
            const SizedBox(height: 8),

            TextField(
              controller: cardNumberController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Card Number',
                border: OutlineInputBorder(),
                hintText: '16 digits',
              ),
              maxLength: 16,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: expiryController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Expiry MM/YY',
                      border: OutlineInputBorder(),
                      hintText: 'MM/YY',
                    ),
                    maxLength: 5,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'\d|/')),
                      LengthLimitingTextInputFormatter(5),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: cvvController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'CVV',
                      border: OutlineInputBorder(),
                      hintText: '3 digits',
                    ),
                    maxLength: 3,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(3),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (startDate == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select a start date'),
                      ),
                    );
                    return;
                  }
                  if (!validateCardDetails()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter valid card details'),
                      ),
                    );
                    return;
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Plan confirmed! (backend call here)'),
                    ),
                  );
                },
                child: const Text('Confirm Plan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
