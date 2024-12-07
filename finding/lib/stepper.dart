import 'dart:convert';
import 'dart:io';

import 'package:finding/constants.dart';
import 'package:finding/countries.dart';
import 'package:finding/government_ids.dart';
import 'package:finding/login.dart';
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
  bool _isPasswordHidden = true;

  // TextEditingControllers (moved here)
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    // Dispose controllers when the widget is removed
    _firstNameController.dispose();
    _lastNameController.dispose();
    _birthDateController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _pageController.dispose();
    super.dispose();
  }

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
        title: Text('Registration'),
      ),
      body: Column(
        children: [
          // Step Indicator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8.0),
            child: Column(
              children: [
                Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: List.generate(_steps.length * 2 - 1, (index) {
                      if (index.isEven) {
                        // Step Circle
                        int stepIndex = index ~/ 2;
                        return Column(
                          children: [
                            CircleAvatar(
                              radius: 15,
                              backgroundColor: stepIndex <= _currentPage
                                  ? Color.fromARGB(
                                      255, 14, 79, 71) // Active/completed step
                                  : Colors.grey, // Inactive step
                              child: Text(
                                (stepIndex + 1).toString(),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 1),
                    Text(
                      'Registration',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: _currentPage >= 0
                            ? Color.fromARGB(255, 14, 79, 71)
                            : Colors.grey, // Active color
                      ),
                    ),
                    const SizedBox(width: 22),
                    Text(
                      'Verification',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: _currentPage >= 1
                            ? Color.fromARGB(255, 14, 79, 71)
                            : Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 27),
                    Text(
                      'Payment',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: _currentPage >= 2
                            ? Color.fromARGB(255, 14, 79, 71)
                            : Colors.grey, // Active color
                      ),
                    ),
                    const SizedBox(width: 40),
                    Text(
                      'Review',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: _currentPage >= 3
                            ? Color.fromARGB(255, 14, 79, 71)
                            : Colors.grey, // Active color
                      ),
                    ),
                  ],
                ),
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
                  // Step 3: Payment
                  _buildStep3(),
                  // Step 4: Review & Edit
                  _buildReviewPage(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Step 1: Registration
  Widget _buildStep1() {
    Widget _buildPasswordField(String label, TextEditingController controller) {
      return Column(
        children: [
          const SizedBox(height: 20),
          TextField(
            controller: controller,
            obscureText: _isPasswordHidden, // Use the state variable
            decoration: InputDecoration(
              labelText: label,
              border: const OutlineInputBorder(),
              enabledBorder: const OutlineInputBorder(
                borderSide:
                    BorderSide(color: Color.fromARGB(255, 220, 222, 224)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromARGB(255, 14, 79, 71)),
              ),
              labelStyle: const TextStyle(
                fontSize: 16,
                color: Color.fromARGB(255, 167, 162, 162),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordHidden ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordHidden = !_isPasswordHidden;
                  });
                },
              ),
            ),
          ),
        ],
      );
    }

    return Padding(
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
            const SizedBox(height: 55),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 120, height: 55),
                SizedBox(
                  width: 120,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_passwordController.text ==
                          _confirmPasswordController.text) {
                        // Save data to _formData
                        setState(() {
                          _formData['firstName'] = _firstNameController.text;
                          _formData['lastName'] = _lastNameController.text;
                          _formData['birthDate'] = _birthDateController.text;
                          _formData['email'] = _emailController.text;
                          _formData['password'] = _passwordController.text;
                          _formData['confirmPassword'] =
                              _confirmPasswordController.text;
                        });

                        _nextPage(); // Move to the next step
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Passwords do not match")),
                        );
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Next',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(
                            width: 8), // Space between the text and the icon
                        Icon(
                          Icons.chevron_right, // Arrow icon for the next button
                          color: Colors.white,
                        ),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 14, 79, 71),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                    ),
                  ),
                ),
              ],
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
              borderSide:
                  BorderSide(color: const Color.fromARGB(255, 220, 222, 224)),
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
              borderSide:
                  BorderSide(color: const Color.fromARGB(255, 220, 222, 224)),
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

  bool isIdPhotoUploaded = false;
  bool isSelfieUploaded = false;

  Widget _buildStep2() {
    List<String> governmentIds = GovernmentIds.getList();
    List<String> countries = Countries.getList();
    String? selectedGovernmentId;
    String? selectedCountries;

    final ImagePicker _picker = ImagePicker();
    File? idPhoto;
    File? selfiePhoto;
    String? idPhotoName;
    String? selfiePhotoName;

    Future<void> verificationUser() async {
      _nextPage();
    }

    void _showErrorDialog(String message) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }

    Future<void> _capturePhoto(String type) async {
      try {
        final pickedFile = await _picker.pickImage(source: ImageSource.camera);

        if (pickedFile != null) {
          setState(() {
            if (type == 'idPhoto') {
              idPhoto = File(pickedFile.path);
              idPhotoName = pickedFile.name; // Get the file name for ID photo
              _formData['idPhoto'] = base64Encode(idPhoto!.readAsBytesSync());
              isIdPhotoUploaded = true; // Mark as uploaded
            } else if (type == 'selfiePhoto') {
              selfiePhoto = File(pickedFile.path);
              selfiePhotoName =
                  pickedFile.name; // Get the file name for selfie photo
              _formData['selfiePhoto'] =
                  base64Encode(selfiePhoto!.readAsBytesSync());
              isSelfieUploaded = true; // Mark as uploaded
            }
          });
        } else {
          print('No photo captured.');
          _showErrorDialog('No photo captured. Please take a photo.');
        }
      } catch (e) {
        print('Error capturing photo: $e');
        _showErrorDialog('An error occurred while capturing the photo.');
      }
    }

    // Function to show the image preview
    void _showImagePreview(File image) {
      showDialog(
        context: context,
        builder: (context) => Dialog(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Image.file(image),
          ),
        ),
      );
    }

    Widget _buildPhotoButton(
        String label, File? image, String? photoName, VoidCallback onTap) {
      return Column(
        children: [
          ElevatedButton.icon(
            onPressed: onTap,
            icon: image == null
                ? Icon(Icons.camera_alt, color: Colors.white)
                : Image.file(image), // Display the captured photo directly
            label: Text(label),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Color.fromARGB(255, 14, 79, 71),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
          // Show the file name (photo name) below the button after capturing the photo
          if (photoName != null && photoName.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                '$photoName Taken', // Display the photo name
                style: TextStyle(fontSize: 14, color: Colors.green),
              ),
            ),
          // Display upload status text if photo is uploaded
          if (isIdPhotoUploaded && label == 'ID Photo')
            GestureDetector(
              onTap: () {
                if (idPhoto != null) {
                  _showImagePreview(idPhoto!); // Show preview when clicked
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'ID Photo Uploaded',
                  style: TextStyle(fontSize: 14, color: Colors.green),
                ),
              ),
            ),
          if (isSelfieUploaded && label == 'Selfie')
            GestureDetector(
              onTap: () {
                if (selfiePhoto != null) {
                  _showImagePreview(selfiePhoto!); // Show preview when clicked
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Selfie Uploaded',
                  style: TextStyle(fontSize: 14, color: Colors.green),
                ),
              ),
            ),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SafeArea(
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
                // Photo placeholders with image display logic
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildPhotoButton(
                      'ID Photo',
                      idPhoto,
                      idPhotoName, // Pass the name to be displayed
                      () => _capturePhoto('idPhoto'),
                    ),
                    _buildPhotoButton(
                      'Selfie',
                      selfiePhoto,
                      selfiePhotoName, // Pass the name to be displayed
                      () => _capturePhoto('selfiePhoto'),
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
                SizedBox(height: 120),
                // Navigation Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 130,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _previousPage,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons
                                  .chevron_left, // Arrow icon for the back button
                              color: Color.fromARGB(255, 14, 79, 71),
                            ),
                            SizedBox(
                                width: 8), // Space between the icon and text
                            Text(
                              'Back',
                              style: TextStyle(
                                color: Color.fromARGB(255, 14, 79, 71),
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 255, 255, 255),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 120,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: verificationUser,
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
                            SizedBox(
                                width:
                                    8), // Space between the text and the icon
                            Icon(
                              Icons
                                  .chevron_right, // Arrow icon for the next button
                              color: Colors.white,
                            ),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 14, 79, 71),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Step 3: Payment
  Widget _buildStep3() {
    final ImagePicker _picker = ImagePicker();
    File? receiptPhoto;

    Future<void> paymentUser() async {
      _nextPage();
    }

    void _showErrorDialog(String message) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }

    Future<void> _capturePhoto(String type) async {
      try {
        final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

        if (pickedFile != null) {
          setState(() {
            if (type == 'receiptPhoto') {
              receiptPhoto = File(pickedFile.path);
              _formData['receiptPhoto'] =
                  base64Encode(receiptPhoto!.readAsBytesSync());
            }
          });
        } else {
          print('No photo captured.');
          _showErrorDialog('No photo captured. Please take a photo.');
        }
      } catch (e) {
        print('Error capturing photo: $e');
        _showErrorDialog('An error occurred while capturing the photo.');
      }
    }

    Widget _buildPhotoButton(String label, File? image, VoidCallback onTap) {
      return ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(
          image == null ? Icons.camera_alt : Icons.check,
          color: Colors.white,
        ),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Color.fromARGB(255, 14, 79, 71), // Text/icon color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      );
    }

    Widget _buildPhotoPlaceholder(
        String label, File? image, VoidCallback onTap) {
      return GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
                image: image != null
                    ? DecorationImage(
                        image: FileImage(image),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: image == null
                  ? Icon(
                      Icons.camera_alt,
                      color: Colors.grey[700],
                      size: 40,
                    )
                  : null,
            ),
            SizedBox(height: 8),
            Text(label),
          ],
        ),
      );
    }

    return Padding(
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

                SizedBox(height: 15),
                // Photo placeholders with image display logic

                _buildPhotoButton(
                  'Capture Receipt Photo',
                  receiptPhoto,
                  () => _capturePhoto('receiptPhoto'),
                ),

                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 130,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _previousPage,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons
                                  .chevron_left, // Arrow icon for the back button
                              color: Color.fromARGB(255, 14, 79, 71),
                            ),
                            SizedBox(
                                width: 8), // Space between the icon and text
                            Text(
                              'Back',
                              style: TextStyle(
                                color: Color.fromARGB(255, 14, 79, 71),
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 255, 255, 255),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 120,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: paymentUser,
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
                            SizedBox(
                                width:
                                    8), // Space between the text and the icon
                            Icon(
                              Icons
                                  .chevron_right, // Arrow icon for the next button
                              color: Colors.white,
                            ),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 14, 79, 71),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Step 4: Review
  Widget _buildReviewPage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                "Review your information",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              //REVIEW INFORMATION SECTION
              Container(
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.symmetric(vertical: 10),
                width: double.infinity,
                height: 300,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "First Name: ",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            " ${_formData['firstName']}",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            "Last Name:",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "${_formData['lastName']}",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Birth Date: ${_formData['birthDate']}",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Email: ${_formData['email']}",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            "Password: ",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              _isPasswordHidden
                                  ? "${_formData['password']}"
                                  : "●●●●●●●●", // Show dots when hidden
                              style: TextStyle(
                                fontSize: 16,
                              ),
                              overflow: TextOverflow
                                  .ellipsis, // Truncate text if too long
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              _isPasswordHidden
                                  ? Icons.visibility
                                  // ignore: dead_code
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordHidden =
                                    !_isPasswordHidden; // Toggle visibility
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Government ID: ${_formData['verification']}",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Country: ${_formData['countries']}",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Address: ${_formData['address']}",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 120),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 130,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _previousPage,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chevron_left,
                            color: Color.fromARGB(255, 14, 79, 71),
                            size: 30,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Back',
                            style: TextStyle(
                              color: Color.fromARGB(255, 14, 79, 71),
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 255, 255, 255),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                      ),
                    ),
                  ),

                  // Submit Button
                  SizedBox(
                    width: 130,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () async {
                        final url = Uri.parse("$BASE_URL/save_user.php");
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
                            // 'paymentDetails': _formData['paymentDetails'],

                            'idPhoto': _formData['idPhoto'],
                            'selfiePhoto': _formData['selfiePhoto'],
                            'receiptPhoto': _formData['receiptPhoto'],
                          },
                        );
                        print(
                            _formData); // Debugging line to check contents of _formData

                        if (response.statusCode == 200) {
                          final responseData = jsonDecode(response.body);
                          if (responseData['success']) {
                            // Show success pop-up
                            print(
                                _formData); // Debugging line to check contents of _formData

                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.check_circle_outline,
                                        size: 80,
                                        color: Colors.green,
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        "Registration Successful!",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    Center(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    LoginPage()),
                                            (Route<dynamic> route) =>
                                                false, // Remove all routes from the stack
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Color.fromARGB(255, 14, 79, 71),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: Text(
                                          "OK",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            // Show error message in dialog
                            _showErrorDialog(context, responseData['message']);
                          }
                        } else {
                          // Show error message in dialog
                          _showErrorDialog(
                              context, "Failed to register. Please try again.");
                        }
                      },
                      child: Text(
                        "Submit",
                        style: TextStyle(
                          color: Colors.white, // Font color
                          fontSize: 18, // Font size
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(
                            255, 14, 79, 71), // Button background color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              50.0), // Circular button shape
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                size: 80,
                color: Colors.red,
              ),
              SizedBox(height: 16),
              Text(
                "Error",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                message,
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Close",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Photo Placeholder Widget to display image preview
  Widget _buildPhotoPlaceholder(
      String label, File? photoFile, Function onPickImage) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => onPickImage(), // Trigger photo capture when tapped
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey),
            ),
            child: photoFile != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      photoFile,
                      fit: BoxFit.cover,
                      width: 120,
                      height: 120,
                    ),
                  )
                : Center(
                    child: Icon(Icons.camera_alt, size: 40, color: Colors.grey),
                  ),
          ),
        ),
        SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}