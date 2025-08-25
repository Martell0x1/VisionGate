import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Mock user data - replace this with your actual data source
  final Map<String, dynamic> userData = const {
    'id': 16,
    'first_name': 'yahya',
    'last_name': 'zakaria',
    'address': 'fdfdfdfdfd',
    'phone': '1097741206',
    'dob': '2000-09-01',
    'email': 'y@gmail.com',
    'password_hash':
        '\$2b\$10\$HHahiFhV/d3u44tFVBEsN.Unm34krbcZBpUdtX7.nKW3tBEqwQJWK',
    'NAID': '30505200202197',
  };

  List<Map<String, String>> _vehicles = []; // List to hold vehicle data

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 24),
            _buildSectionTitle('Personal Information'),
            _buildInfoCard(),
            const SizedBox(height: 24),
            _buildSectionTitle('Cars'),
            _cars(), // Display cars here
            _buildSectionTitle('Account Settings'),
            _buildSettingsCards(),
            const SizedBox(height: 24),
            _buildSectionTitle('Actions'),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  // Method to display and manage cars
  Widget _cars() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Vehicle Information",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: Icon(Icons.add_circle_outline),
              onPressed: _addVehicleDialog,
              tooltip: "Add Vehicle",
            ),
          ],
        ),
        const SizedBox(height: 10),
        // Show vehicles if available
        if (_vehicles.isEmpty)
          const Center(child: Text("No vehicles added"))
        else
          ..._vehicles.map((vehicle) => _buildVehicleCard(vehicle)).toList(),
      ],
    );
  }

  // Build a card for each vehicle
  Widget _buildVehicleCard(Map<String, String> vehicle) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  vehicle['company']!,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _editVehicle(vehicle),
                  tooltip: "Edit Vehicle",
                ),
              ],
            ),
            const SizedBox(height: 10),
            _buildVehicleInfoRow("Car Model", vehicle['car_model']!),
            _buildVehicleInfoRow("License Plate", vehicle['license']!),
            _buildVehicleInfoRow("Plan", vehicle['plan']!),
          ],
        ),
      ),
    );
  }

  // Vehicle row builder (for car model, license, etc.)
  Widget _buildVehicleInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              "$label:",
              style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.grey),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  // Method to show the dialog for adding a vehicle
  void _addVehicleDialog() {
    final TextEditingController carModelController = TextEditingController();
    final TextEditingController licenseController = TextEditingController();
    String? selectedCompany;
    String? selectedPlan;

    final List<String> carCompanies = [
      "Toyota", "Hyundai", "BMW", "Mercedes", "Honda", "Ford", 
      "Chevrolet", "Nissan", "Audi", "Volkswagen", "Kia", "Other"
    ];
    final List<String> planOptions = ["Basic", "Standard", "Premium", "Business", "Enterprise"];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Add Vehicle", textAlign: TextAlign.center),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      value: selectedCompany,
                      items: carCompanies.map((company) {
                        return DropdownMenuItem(value: company, child: Text(company));
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          selectedCompany = val;
                        });
                      },
                      decoration: const InputDecoration(labelText: "Company"),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: carModelController,
                      decoration: const InputDecoration(labelText: "Car Model"),
                    ),
                    const SizedBox(height: 15),
                    DropdownButtonFormField<String>(
                      value: selectedPlan,
                      items: planOptions.map((plan) {
                        return DropdownMenuItem(value: plan, child: Text(plan));
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          selectedPlan = val;
                        });
                      },
                      decoration: const InputDecoration(labelText: "Plan"),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: licenseController,
                      decoration: const InputDecoration(labelText: "License Plate"),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (selectedCompany != null &&
                        carModelController.text.isNotEmpty &&
                        selectedPlan != null &&
                        licenseController.text.isNotEmpty) {
                      setState(() {
                        _vehicles.add({
                          "company": selectedCompany!,
                          "car_model": carModelController.text,
                          "plan": selectedPlan!,
                          "license": licenseController.text,
                        });
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Save Vehicle"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Method to edit vehicle
  void _editVehicle(Map<String, String> vehicle) {
    // Similar to _addVehicleDialog, you can pre-fill fields for editing.
  }

  // Helper functions for profile and section titles
  Widget _buildProfileHeader() {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.blue.shade100,
            child: Text(
              '${userData['first_name'][0]}${userData['last_name'][0]}'.toUpperCase(),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
          ),
          const SizedBox(height: 16),
          Text('${userData['first_name']} ${userData['last_name']}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text(userData['email'], style: TextStyle(fontSize: 16, color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInfoRow('First Name', userData['first_name']),
            const Divider(),
            _buildInfoRow('Last Name', userData['last_name']),
            const Divider(),
            _buildInfoRow('Email', userData['email']),
            const Divider(),
            _buildInfoRow('Phone', userData['phone']),
            const Divider(),
            _buildInfoRow('Address', userData['address']),
            const Divider(),
            _buildInfoRow('Date of Birth', userData['dob']),
            const Divider(),
            _buildInfoRow('National ID', userData['NAID']),
            const Divider(),
            _buildInfoRow('User ID', userData['id'].toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.grey)),
        ),
        Expanded(flex: 3, child: Text(value, style: const TextStyle(fontWeight: FontWeight.w400))),
      ],
    );
  }

  Widget _buildSettingsCards() {
    return Column(
      children: [
        _buildSettingTile(icon: Icons.notifications, title: 'Notifications', subtitle: 'Manage your notifications', onTap: () {}),
        _buildSettingTile(icon: Icons.security, title: 'Privacy & Security', subtitle: 'Manage your privacy settings', onTap: () {}),
        _buildSettingTile(icon: Icons.language, title: 'Language', subtitle: 'Change app language', onTap: () {}),
        _buildSettingTile(icon: Icons.help, title: 'Help & Support', subtitle: 'Get help and support', onTap: () {}),
      ],
    );
  }

  Widget _buildSettingTile({required IconData icon, required String title, required String subtitle, required VoidCallback onTap}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.edit),
            label: const Text('Edit Profile'),
            onPressed: () {
              // Navigate to edit profile page
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            icon: const Icon(Icons.logout, color: Colors.red),
            label: const Text('Logout', style: TextStyle(color: Colors.red)),
            onPressed: () {
              _showLogoutDialog(context);
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: const BorderSide(color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Add your logout logic here
                // Example: AuthProvider.logout();
              },
              child: const Text('Logout', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
