import 'dart:convert';
import 'dart:io';

import 'package:finding/constants.dart';
import 'package:finding/countries.dart';
import 'package:finding/government_ids.dart';
import 'package:finding/home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HorizontalMultiStepForm(),
    );
  }
}

class HorizontalMultiStepForm extends StatefulWidget {
  @override
  _HorizontalMultiStepFormState createState() =>
      _HorizontalMultiStepFormState();
}

class _HorizontalMultiStepFormState extends State<HorizontalMultiStepForm> {
  final PageController _pageController = PageController();
  final _formKey = GlobalKey<FormState>();

  // Store form data
  final Map<String, String> _formData = {
    'name': '',
    'email': '',
    'password': '',
    'verification': '',
    'countries': '',
    'paymentDetails': '',
  };

  int _currentPage = 0;

  final List<String> _steps = [
    "Registration",
    "Verification",
    "Referral",
    "Payment",
    "Review"
  ];

 void _nextPage() {
  if (_formKey.currentState!.validate()) {
    _formKey.currentState!.save();
    if (_currentPage < _steps.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentPage++;
      });
    } else {
      // Final submission logic here
      print("Final data: $_formData");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Form Submitted!")),
      );
    }
  }
}

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentPage--;
      });
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Horizontal Multi-Step Form'),
    ),
    body: Column(
      children: [
        // Step Indicator
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 8.0),
          child: Column(
            children: [
              Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: List.generate(5 * 2 - 1, (index) { // 5 steps now explicitly defined
                    if (index.isEven) {
                      // Step Circle
                      int stepIndex = index ~/ 2;
                      return Column(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: stepIndex <= _currentPage
                                ? Color.fromARGB(255, 14, 79, 71) // Active/completed step
                                : Colors.grey, // Inactive step
                            child: Text(
                              (stepIndex + 1).toString(), // Correctly numbered step
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Expanded(
                        child: Container(
                          height: 2,
                          color: index ~/ 2 < _currentPage
                              ? Color.fromARGB(255, 14, 79, 71)
                              : Colors.grey,
                        ),
                      );
                    }
                  }),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
        Expanded(
          child: Form(
            key: _formKey,
            child: PageView(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(), // Disable swipe
              children: [
                // Step 1: Registration
                _buildStep1(),
                // Step 2: Verification
                _buildStep2(),
                // Step 3: Referral Inputs
                _buildReferralStep(),
                // Step 4: Payment
                _buildStep3(),
                // Step 5: Review & Edit
                _buildReviewPage(),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}


Widget _buildReferralStep() {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Referral Information',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Referral Code',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a referral code';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Referral Name',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the referral name';
              }
              return null;
            },
          ),
        ],
      ),
    ),
    bottomNavigationBar: Container(
      height: 60,
      color: Color.fromARGB(255, 14, 79, 71),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: _previousPage,
              child: Center(
                child: Text(
                  'Back',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
          VerticalDivider(
            width: 1,
            color: Colors.white, // Divider color
          ),
          Expanded(
            child: GestureDetector(
              onTap: _nextPage,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Next',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.chevron_right, color: Colors.white), // Arrow icon
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}


  // Step 1: Registration
  Widget _buildStep1() {
    final TextEditingController _firstNameController =
        TextEditingController(text: _formData['firstName'] ?? '');
    final TextEditingController _lastNameController =
        TextEditingController(text: _formData['lastName'] ?? '');
    final TextEditingController _birthDateController =
        TextEditingController(text: _formData['birthDate'] ?? '');
    final TextEditingController _emailController =
        TextEditingController(text: _formData['email'] ?? '');
    final TextEditingController _passwordController =
        TextEditingController(text: _formData['password'] ?? '');
    final TextEditingController _confirmPasswordController =
        TextEditingController(text: _formData['confirmPassword'] ?? '');

    Future<void> registerUser() async {
      if (_passwordController.text == _confirmPasswordController.text) {
        // Save data to _formData
        setState(() {
          _formData['firstName'] = _firstNameController.text;
          _formData['lastName'] = _lastNameController.text;
          _formData['birthDate'] = _birthDateController.text;
          _formData['email'] = _emailController.text;
          _formData['password'] = _passwordController.text;
          _formData['confirmPassword'] = _confirmPasswordController.text;
        });

        _nextPage(); // Move to the next step
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Passwords do not match")),
        );
      }
    }

       return Scaffold(
  resizeToAvoidBottomInset: false, // Prevent resizing when the keyboard appears
  body: SafeArea(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField("First Name", _firstNameController),
            _buildTextField("Last Name", _lastNameController),
            _buildDateField("Birth Date", _birthDateController),
            _buildTextField("Email Address", _emailController),
            _buildPasswordField("Set Password", _passwordController),
            _buildPasswordField("Confirm Password", _confirmPasswordController),
            SizedBox(height: 20), // Spacing at the bottom of form fields
          ],
        ),
      ),
    ),
  ),
  bottomNavigationBar: Container(
    height: 60,
    color: Color.fromARGB(255, 14, 79, 71),
    child: Row(
      children: [
       
        Expanded(
          child: GestureDetector(
            onTap: _nextPage,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Next',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.chevron_right, color: Colors.white), // Arrow icon
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  ),
);

  }

// Utility Widgets for Reusability
 Widget _buildTextField(String label, TextEditingController controller) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20), 
                      TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: label, 
                      labelText: label, 
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: const Color.fromARGB(255, 220, 222, 224)), 
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color.fromARGB(255, 14, 79, 71)),
                      ),
                      
                      
                      labelStyle: TextStyle(
                        fontSize: 16, 
                        color: const Color.fromARGB(255, 167, 162, 162), 
                      ),
                    ),
                  )
                      ],
                    );
                              }



  Widget _buildPasswordField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         SizedBox(height: 20),
                        TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: label, 
                    labelText: label, 
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: const Color.fromARGB(255, 220, 222, 224)), 
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color.fromARGB(255, 14, 79, 71)),
                    ),
                    labelStyle: TextStyle(
                      fontSize: 16, 
                      color: const Color.fromARGB(255, 167, 162, 162), 
                    ),
                  ),
                )
      ],
      
    );
  }

  Widget _buildDateField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(label,
        //     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 20),
        TextField(
          controller: controller,
          readOnly: true,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: const Color.fromARGB(255, 220, 222, 224)), 
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color.fromARGB(255, 14, 79, 71)),
                    ),
            suffixIcon: Icon(Icons.calendar_today),
             labelStyle: TextStyle(
                        fontSize: 16, 
                        color: const Color.fromARGB(255, 167, 162, 162), 
                      ),
          ),
          onTap: () async {
            DateTime? selectedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            if (selectedDate != null) {
              String formattedDate =
                  DateFormat('yyyy-MM-dd').format(selectedDate);
              controller.text = formattedDate;
            }
          },
        ),
        
      ],
    );
  }

  // Step 2: Verification

Widget _buildStep2() {
  List<String> governmentIds = GovernmentIds.getList();
  List<String> countries = Countries.getList();
  String? selectedGovernmentId;
  String? selectedCountries;

  final ImagePicker _picker = ImagePicker();
  File? idPhoto;
  File? selfiePhoto;

  // Function to pick image
  Future<void> _pickImage(ImageSource source, String type) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        if (type == 'idPhoto') {
          idPhoto = File(pickedFile.path);
        } else if (type == 'selfiePhoto') {
          selfiePhoto = File(pickedFile.path);
        }
      });
    }
  }

  // Function to remove selected image
  Future<void> _removeImage(String type) async {
    setState(() {
      if (type == 'idPhoto') {
        idPhoto = null;
      } else if (type == 'selfiePhoto') {
        selfiePhoto = null;
      }
    });
  }

  return Scaffold(
    body: SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Government ID Dropdown
              DropdownButtonFormField<String>(
                value: selectedGovernmentId,
                hint: Text("Select a Government ID"),
                items: governmentIds.map((id) {
                  return DropdownMenuItem<String>(
                    value: id,
                    child: Text(id),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedGovernmentId = value;
                    _formData['verification'] = value ?? '';
                  });
                },
                validator: (value) =>
                    value == null ? 'Please select a government ID' : null,
              ),
              SizedBox(height: 10),
              // Country Dropdown
              DropdownButtonFormField<String>(
                value: selectedCountries,
                hint: Text("Select your Country"),
                items: countries.map((country) {
                  return DropdownMenuItem<String>(
                    value: country,
                    child: Text(country),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCountries = value;
                    _formData['countries'] = value ?? '';
                  });
                },
                validator: (value) =>
                    value == null ? 'Please select a country' : null,
              ),
              SizedBox(height: 15),
              // Photo placeholders with image upload logic
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildPhotoPlaceholder(
                    'Take ID Photo',
                    idPhoto,
                    () => _pickImage(ImageSource.camera, 'idPhoto'),
                    () => _removeImage('idPhoto'),
                  ),
                  _buildPhotoPlaceholder(
                    'Selfie with ID Photos',
                    selfiePhoto,
                    () => _pickImage(ImageSource.camera, 'selfiePhoto'),
                    () => _removeImage('selfiePhoto'),
                  ),
                ],
              ),
              SizedBox(height: 15),
              // Address Input
              Text(
                'Address',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  hintText: 'Enter your city address',
                ),
                onChanged: (value) {
                  setState(() {
                    _formData['address'] = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    ),
    bottomNavigationBar: Container(
      height: 60,
      color: Color.fromARGB(255, 14, 79, 71),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: _previousPage,
              child: Center(
                child: Text(
                  'Back',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
          VerticalDivider(
            width: 1,
            color: Colors.white, // Divider color
          ),
          Expanded(
            child: GestureDetector(
              onTap: _nextPage,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Next',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.chevron_right, color: Colors.white), // Arrow icon
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildPhotoPlaceholder(
  String title,
  File? image,
  VoidCallback onTap,
  VoidCallback onRemove,
) {
  return Column(
    children: [
      GestureDetector(
        onTap: image == null ? onTap : null, // Allow tap only if no image
        child: Container(
          width: 150,
          height: 150, // Set a fixed height for image
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: image == null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.camera_alt, size: 20), // Camera icon
                    SizedBox(width: 5),
                    Text(title),
                  ],
                )
              : Image.file(
                  image,
                  fit: BoxFit.cover, // Make the image fit the container
                ),
        ),
      ),
      if (image != null) // Show "View Photo" button only if image exists
        TextButton(
          onPressed: () {
            print('Viewing: ${image.path}');
          },
          child: Text(
            'View Photo',
            style: TextStyle(color: Colors.blue),
          ),
        ),
      if (image != null) // Show Remove option if image exists
        IconButton(
          onPressed: onRemove,
          icon: Icon(Icons.remove_circle, color: Colors.red),
        ),
    ],
  );
}



Widget _buildStep3() {
  final TextEditingController _paymentDetailsController =
      TextEditingController(text: _formData['paymentDetails'] ?? '');

  Future<void> paymentUser() async {
    // Save payment details when the user clicks 'Next'
    setState(() {
      _formData['paymentDetails'] = _paymentDetailsController.text;
    });

    // Now move to the next page
    _nextPage();
  }

  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Payment Details',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _paymentDetailsController,
                  decoration: InputDecoration(
                    labelText: 'Enter Payment Details',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 390),
              ],
            ),
          ),
        ),
      ),
    ),
    bottomNavigationBar: Container(
      height: 60,
      color: Color.fromARGB(255, 14, 79, 71),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: _previousPage,
              child: Center(
                child: Text(
                  'Back',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
          VerticalDivider(
            width: 1,
            color: Colors.white, // Divider color
          ),
          Expanded(
            child: GestureDetector(
              onTap: _nextPage,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Next',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.chevron_right, color: Colors.white), // Arrow icon
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}


 Widget _buildReviewPage() {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Review your information",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              // Review Information Section
              Container(
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.symmetric(vertical: 10),
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 240, 240, 240),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "First Name: ${_formData['firstName']}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 14, 79, 71),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Last Name: ${_formData['lastName']}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 14, 79, 71),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Birth Date: ${_formData['birthDate']}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 14, 79, 71),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Email: ${_formData['email']}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 14, 79, 71),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Password: ${_formData['password']}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 14, 79, 71),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Government ID: ${_formData['verification']}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 14, 79, 71),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Country: ${_formData['countries']}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 14, 79, 71),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Address: ${_formData['address']}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 14, 79, 71),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Payment: ${_formData['paymentDetails']}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 14, 79, 71),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 120), // Add space for buttons
            ],
          ),
        ),
      ),
    ),
    bottomNavigationBar: Container(
      height: 60,
      color: Color.fromARGB(255, 14, 79, 71),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: _previousPage,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.chevron_left,
                      color: Colors.white,
                      size: 30,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Back',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          VerticalDivider(
            width: 1,
            color: Colors.white, // Divider color
          ),
          Expanded(
            child: GestureDetector(
              onTap: () async {
                final url = Uri.parse('$BASE_URL/save_user.php');
                final response = await http.post(
                  url,
                  body: {
                    'firstName': _formData['firstName'],
                    'lastName': _formData['lastName'],
                    'birthDate': _formData['birthDate'],
                    'email': _formData['email'],
                    'password': _formData['password'],
                    'verification': _formData['verification'],
                    'countries': _formData['countries'],
                    'address': _formData['address'],
                    'paymentDetails': _formData['paymentDetails'],
                    'idPhoto': _formData['idPhoto'],
                    'selfiePhoto': _formData['selfiePhoto'],
                  },
                );

                if (response.statusCode == 200) {
                  final responseData = jsonDecode(response.body);
                  if (responseData['success']) {
                    print("Data saved successfully: ${responseData['message']}");
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  } else {
                    print("Error: ${responseData['message']}");
                  }
                } else {
                  print("Failed to save data. Status code: ${response.statusCode}");
                }
              },
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Submit",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.chevron_right, color: Colors.white),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}


  // Photo Placeholder Widget to display image preview
  
}
