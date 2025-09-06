import 'package:flutter/material.dart';
import 'dart:math';
import 'package:image_picker/image_picker.dart';
import 'package:vision_gate/screens/home_page.dart';
import 'dart:io';
import '../services/api_service.dart'; // المسار حسب مكان api_service.dart
import '../models/user.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPage();
}

class _RegisterPage extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _idNumberController = TextEditingController();
  final _dayController = TextEditingController();
  final _yearController = TextEditingController();

  String _responseMessage = ''; // Variable to hold response message

  String? _suggestedPassword;
  String? _selectedMonth;
  String _fullDate = "";
  final List<String> _months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];
  // suggestion pass
  String generateStrongPassword() {
    const chars =
        "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@#\$&*!";
    Random rnd = Random();
    return String.fromCharCodes(
      Iterable.generate(10, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))),
    );
  }

  void _updateDate() {
    setState(() {
      _fullDate =
          "${_dayController.text}/${_selectedMonth ?? ""}/${_yearController.text}";
    });
  }

  // Function to handle registration
  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      // Show loading snackbar first
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("⏳ Registering...")));

      // Collect the user data
      final user = User(
        first_name: _firstNameController.text,
        last_name: _lastNameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        address: _addressController.text,
        phone: _phoneController.text,
        NAID: _idNumberController.text,
        dob: _fullDate,
      );

      try {
        // Call the API service to register the user
        final response = await ApiService().registerUser(user);

        // Set the response message from the API
        setState(() {
          _responseMessage = response.message ?? 'Registration successful';
        });

        // Check if status is OK before navigating
        if (response.success) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (newContext) => HomePage()),
          );
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
        setState(() {
          _responseMessage = 'Error: ${e.toString()}';
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
      }
    }
  }

  File? _profileImage;
  //final List<Map<String, String>> _vehicles = [];
  // void _addVehicleDialog() {
  //   String? selectedCompany;
  //   int? selectedYear;
  //   final TextEditingController carNameController = TextEditingController();
  //   final TextEditingController plateNumberController = TextEditingController();
  //   final List<String> carCompanies = ["Toyota", "Hyundai", "BMW", "Mercedes"];
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: const Text("Add Vehicle"),
  //         content: SingleChildScrollView(
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               // Company
  //               DropdownButtonFormField<String>(
  //                 decoration: const InputDecoration(labelText: "Company"),
  //                 items: carCompanies.map((c) {
  //                   return DropdownMenuItem(value: c, child: Text(c));
  //                 }).toList(),
  //                 onChanged: (val) {
  //                   setState(() {
  //                     selectedCompany = val;
  //                   });
  //                 },
  //               ),
  //               const SizedBox(height: 10),

  //               // Year (as model)
  //               DropdownButtonFormField<int>(
  //                 decoration: const InputDecoration(labelText: "Year Model"),
  //                 items: List.generate(26, (i) => 2000 + i)
  //                     .map(
  //                       (year) => DropdownMenuItem(
  //                         value: year,
  //                         child: Text(year.toString()),
  //                       ),
  //                     )
  //                     .toList(),
  //                 onChanged: (val) {
  //                   selectedYear = val;
  //                 },
  //               ),
  //               const SizedBox(height: 10),

  //               // Car Name
  //               TextFormField(
  //                 controller: carNameController,
  //                 decoration: const InputDecoration(labelText: "Car Name"),
  //               ),
  //               const SizedBox(height: 10),

  //               // Plate Number
  //               TextFormField(
  //                 controller: plateNumberController,
  //                 decoration: const InputDecoration(
  //                   labelText: "Plate Number (5 digits)",
  //                 ),
  //                 keyboardType: TextInputType.number,
  //                 maxLength: 5,
  //               ),
  //             ],
  //           ),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               if (selectedCompany != null &&
  //                   selectedYear != null &&
  //                   carNameController.text.isNotEmpty &&
  //                   plateNumberController.text.length == 5) {
  //                 setState(() {
  //                   _vehicles.add({
  //                     "company": selectedCompany!,
  //                     "model": selectedYear.toString(),
  //                     "name": carNameController.text,
  //                     "plate": plateNumberController.text,
  //                   });
  //                 });
  //                 Navigator.pop(context);
  //               } else {
  //                 ScaffoldMessenger.of(context).showSnackBar(
  //                   const SnackBar(
  //                     content: Text("Please fill all fields correctly"),
  //                   ),
  //                 );
  //               }
  //             },
  //             child: const Text("Finish"),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _profileImage = File(picked.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // first_name
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(
                  labelText: "First Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter first name";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),

              //last_name
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(
                  labelText: "Last Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter last name";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),

              // email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  hintText: "example@gmail.com",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter email";
                  }
                  // check Gmail
                  if (!RegExp(r'^[\w-\.]+@gmail\.com$').hasMatch(value)) {
                    return "Email must be a valid Gmail address";
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _suggestedPassword = generateStrongPassword();
                  });
                },
              ),
              if (_suggestedPassword != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    "Suggested Password: $_suggestedPassword",
                    style: const TextStyle(color: Colors.green),
                  ),
                ),
              const SizedBox(height: 15),

              // pasword
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter password";
                  }
                  if (value.length < 6) {
                    return "Password must be at least 6 characters";
                  }
                  // check for lower
                  if (!RegExp(r'[A-Z]').hasMatch(value)) {
                    return "Password must contain at least one uppercase letter";
                  }

                  // check for lower
                  if (!RegExp(r'[a-z]').hasMatch(value)) {
                    return "Password must contain at least one lowercase letter";
                  }

                  // check for special
                  if (!RegExp(r'[0-9!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
                    return "Password must contain at least one number or special character";
                  }

                  return null;
                },
              ),
              const SizedBox(height: 15),

              // confirm
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Confirm Password",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value != _passwordController.text) {
                    return "Passwords do not match";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              // ---- Address ----
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: "Address",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter address";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              //phone
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: "Phone (+20XXXXXXXXXX)",
                  border: const OutlineInputBorder(),
                  prefixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text("🇪🇬", style: TextStyle(fontSize: 20)),
                      ),
                      Text("+20 "),
                    ],
                  ),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter phone number";
                  }
                  if (!value.startsWith("1")) {
                    return "Phone must start with 1";
                  }
                  if (value.length != 10) {
                    return "Phone must be 10 digits ";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // id
              TextFormField(
                controller: _idNumberController,
                decoration: const InputDecoration(
                  labelText: "National ID",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                maxLength: 14,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter national ID";
                  }
                  if (value.length != 14) {
                    return "National ID must be 14 digits";
                  }
                  if (!(value.startsWith("2") || value.startsWith("3"))) {
                    return "National ID isn't Correcrt";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      SizedBox(
                        width: 100,
                        child: TextFormField(
                          controller: _dayController,
                          decoration: const InputDecoration(
                            labelText: "Day",
                            border: OutlineInputBorder(),
                            errorMaxLines: 2,
                            isDense: true,
                          ),
                          keyboardType: TextInputType.number,
                          maxLength: 2,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter day";
                            }
                            final day = int.tryParse(value);
                            if (day == null || day < 1 || day > 31) {
                              return "Day must be 1-31";
                            }
                            return null;
                          },
                          onChanged: (_) => _updateDate(),
                        ),
                      ),
                      SizedBox(
                        width: 150,
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: "Month",
                            border: OutlineInputBorder(),
                            errorMaxLines: 2,
                            isDense: true,
                          ),
                          value: _selectedMonth,
                          items: _months
                              .map(
                                (m) =>
                                    DropdownMenuItem(value: m, child: Text(m)),
                              )
                              .toList(),
                          onChanged: (val) {
                            setState(() {
                              _selectedMonth = val;
                              _updateDate();
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Select month";
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        width: 100,
                        child: TextFormField(
                          controller: _yearController,
                          decoration: const InputDecoration(
                            labelText: "Year",
                            border: OutlineInputBorder(),
                            errorMaxLines: 2,
                            isDense: true,
                          ),
                          keyboardType: TextInputType.number,
                          maxLength: 4,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter year";
                            }
                            final year = int.tryParse(value);
                            if (year == null || year < 1900 || year > 2025) {
                              return "Year is invalid";
                            }
                            return null;
                          },
                          onChanged: (_) => _updateDate(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Full Date: $_fullDate",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              //photo
              Stack(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!)
                          : null,
                      child: _profileImage == null
                          ? const Icon(Icons.person, size: 50)
                          : null,
                    ),
                  ),
                  if (_profileImage != null)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _profileImage = null; // Remove photo
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              // Vehicle Info Section
              //const Align(
              //: Alignment.centerLeft,
              // child: Text(
              // "Vehicle Information",
              // style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              // ),
              // ),
              //const SizedBox(height: 10),

              //ElevatedButton.icon(
              // onPressed: _addVehicleDialog,
              /// icon: const Icon(Icons.add),
              // label: const Text("Add Vehicle"),
              // ),

              // const SizedBox(height: 10),

              // Display added vehicles
              // Column(
              // children: _vehicles.asMap().entries.map((entry) {
              //   final index = entry.key + 1;
              // final v = entry.value;
              // return Card(
              //  margin: const EdgeInsets.symmetric(vertical: 5),
              /// child: ListTile(
              //   leading: const Icon(Icons.directions_car),
              //  title: Text("Car #$index"),
              // subtitle: Text(
              //   "${v['company']} - ${v['model']} (${v['name']}) | Plate: ${v['plate']}",
              // ),
              // ),
              //);
              //}).toList(),
              // ),
              const SizedBox(height: 20),

              // bottom
              ElevatedButton(
                onPressed: () {
                  // 2. نبعته للـ ApiService
                  _registerUser();
                },
                child: const Text("Register"),
              ),
              Text(_responseMessage),
            ],
          ),
        ),
      ),
    );
  }
}
