import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vision_gate/models/vehicle.dart';
import '../services/api_service.dart';

class SettingsPage extends StatefulWidget {
  final String email;
  const SettingsPage({super.key, required this.email});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Mock user data - replace this with your actual data source
  Map<String, dynamic>? userData = {};
  bool _loading = true;

  List<Map<String, dynamic>> _vehicles = []; // List to hold vehicle data

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  Future<void> _fetchUser() async {
    try {
      // 1. Get user by email
      final response = await ApiService().getUserByEmail(widget.email);

      if (!mounted) return; // Stop if widget is no longer active

      if (response.success) {
        userData = response.data;
        print("✅ User data loaded successfully: $userData");

        final userId = userData?["user_id"];
        if (userId == null) {
          print("⚠️ user_id is null — cannot fetch cars");
          return;
        }

        // 2. Save user_id to SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt('user_id', userId);

        // 3. Fetch user's vehicles
        final userCarsResponse = await ApiService().getUserCars(userId);

        if (!mounted) return;

        print("🚗 getUserCars response: ${userCarsResponse.data}");
        print("🚦 getUserCars success: ${userCarsResponse.success}");
        print("📩 getUserCars message: ${userCarsResponse.message}");

        if (userCarsResponse.success) {
          _vehicles = userCarsResponse.data ?? [];
          print("✅ vehicles: $_vehicles");
        } else {
          print("❌ Failed to load vehicles for user ID: $userId");
        }
      } else {
        userData = null;
        print("❌ Failed to load user data for email: ${widget.email}");
        print("📩 Response: ${response.message ?? response.data}");
      }
    } catch (e) {
      print("🔥 Exception in _fetchUser: $e");
    }

    if (!mounted) return;

    // 4. Update UI state
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : userData == null
          ? const Center(child: Text("❌ Failed to load user data"))
          : SingleChildScrollView(
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
                  _cars(),
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
              icon: const Icon(Icons.add_circle_outline),
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
  Widget _buildVehicleCard(Map<String, dynamic> vehicle) {
    // Convert subscription_start from String to DateTime if it exists
    DateTime? subscriptionStart;
    if (vehicle['subscription_start'] != null) {
      subscriptionStart = DateTime.parse(vehicle['subscription_start']);
    }

    // If subscriptionStart is available, convert it to local time
    String subscriptionStartFormatted = '';
    if (subscriptionStart != null) {
      subscriptionStartFormatted = subscriptionStart.toLocal().toString();
    } else {
      subscriptionStartFormatted =
          'Not Available'; // Fallback if no subscription start date is present
    }

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
                  vehicle['company'] ??
                      'Unknown', // Safely handle missing fields
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _editVehicle(vehicle),
                  tooltip: "Edit Vehicle",
                ),
              ],
            ),
            const SizedBox(height: 10),
            _buildVehicleInfoRow(
              "Car Model",
              vehicle['car_model'] ?? 'Unknown',
            ),
            _buildVehicleInfoRow(
              "License Plate",
              vehicle['license_plate'] ?? 'Unknown',
            ),
            _buildVehicleInfoRow(
              "Plan ID",
              vehicle['plan_id']?.toString() ?? 'Unknown',
            ),
            _buildVehicleInfoRow(
              "Subscription Start",
              subscriptionStartFormatted,
            ),
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
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  // Method to show the dialog for adding a vehicle
  void _addVehicleDialog() {
    final TextEditingController carModelController = TextEditingController();
    final TextEditingController licenseController = TextEditingController();
    String? selectedCompany;
    int? selectedPlan;

    final List<String> carCompanies = [
      "Toyota",
      "Hyundai",
      "BMW",
      "Mercedes",
      "Honda",
      "Ford",
      "Chevrolet",
      "Nissan",
      "Audi",
      "Volkswagen",
      "Kia",
      "Other",
    ];
    final List<Map<String, dynamic>> planOptions = [
      {"id": 0, "name": "Basic", "price": 100, "duration": "1 Month"},
      {"id": 1, "name": "Standard", "price": 250, "duration": "3 Months"},
      {"id": 2, "name": "Premium", "price": 450, "duration": "6 Months"},
      {"id": 3, "name": "Gold", "price": 800, "duration": "12 Months"},
      {"id": 4, "name": "Enterprise", "price": 1200, "duration": "18 Months"},
    ];

    // Function to handle registration
    Future<void> _addCar() async {
      // Show loading snackbar first
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("⏳ Adding car ...")));

      final prefs = await SharedPreferences.getInstance();
      DateTime currentDate = DateTime.now(); // Gets the current date and time
      DateTime dateOnly = DateTime(
        currentDate.year,
        currentDate.month,
        currentDate.day,
      );

      // Collect the user data
      final car = Vehicle(
        user_id: prefs.getInt('user_id') ?? 0,
        plan_id: selectedPlan ?? 0,
        car_model: carModelController.text,
        company: selectedCompany ?? '',
        license_plate: licenseController.text,
        subscription_start: dateOnly,
      );

      try {
        // Call the API service to register the user
        final response = await ApiService().addCar(car);
        print(car.toJson());

        // Check if status is OK before navigating
        if (response.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Car added successfully ")),
          );

          _fetchUser(); // refresh page
        } else {
          // Show error message if status is not OK
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Registration failed: ${response.message ?? 'Unknown error'}",
              ),
            ),
          );
        }
      } catch (e) {
        // Handle error during registration
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
      }
    }

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
                        return DropdownMenuItem(
                          value: company,
                          child: Text(company),
                        );
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
                    DropdownButtonFormField<int>(
                      value: selectedPlan,
                      items: planOptions.map((plan) {
                        return DropdownMenuItem<int>(
                          value: plan["id"],
                          child: Text(
                            "${plan["name"]} - \$${plan["price"]} - ${plan["duration"]}",
                          ),
                        );
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
                      decoration: const InputDecoration(
                        labelText: "License Plate",
                      ),
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
                      // -------------------- POST request to add car

                      _addCar();

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
  void _editVehicle(Map<String, dynamic> vehicle) {
    // Similar to _addVehicleDialog, you can pre-fill fields for editing.
  }

  // Helper functions for profile and section titles
  Widget _buildProfileHeader() {
    if (userData == null) return const Center(child: Text("❌ No user data"));

    final firstName = userData?['first_name'] ?? '';
    final lastName = userData?['last_name'] ?? '';
    final email = userData?['email'] ?? '';

    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.blue.shade100,
            child: Text(
              '${firstName.isNotEmpty ? firstName[0] : ''}${lastName.isNotEmpty ? lastName[0] : ''}'
                  .toUpperCase(),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '$firstName $lastName',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            email,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    if (userData == null) return const SizedBox();
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInfoRow('First Name', userData!['first_name']),
            const Divider(),
            _buildInfoRow('Last Name', userData!['last_name']),
            const Divider(),
            _buildInfoRow('Email', userData!['email']),
            const Divider(),
            _buildInfoRow('Phone', userData!['phone'] ?? ''),
            const Divider(),
            _buildInfoRow('Address', userData!['address'] ?? ''),
            const Divider(),
            _buildInfoRow('Date of Birth', userData!['dob'] ?? ''),
            const Divider(),
            _buildInfoRow('National ID', userData!['NAID'] ?? ''),
            const Divider(),
            _buildInfoRow('User ID', userData!['user_id'].toString()),
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
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsCards() {
    return Column(
      children: [
        _buildSettingTile(
          icon: Icons.notifications,
          title: 'Notifications',
          subtitle: 'Manage your notifications',
          onTap: () {},
        ),
        _buildSettingTile(
          icon: Icons.security,
          title: 'Privacy & Security',
          subtitle: 'Manage your privacy settings',
          onTap: () {},
        ),
        _buildSettingTile(
          icon: Icons.language,
          title: 'Language',
          subtitle: 'Change app language',
          onTap: () {},
        ),
        _buildSettingTile(
          icon: Icons.help,
          title: 'Help & Support',
          subtitle: 'Get help and support',
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
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
