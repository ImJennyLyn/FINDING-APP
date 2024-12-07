import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class VerificationScreen extends StatefulWidget {
  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  // List of government ID options
  final List<String> governmentIds = [
    'Passport',
    'Driver\'s License',
    'Voter\'s ID',
    'SSS ID',
    'PhilHealth ID',
    'UMID'
  ];

  // Variable to store the selected value
  String? selectedGovernmentId;
  final ImagePicker _picker = ImagePicker();

  // Store images for each placeholder
  File? idPhoto;
  File? selfiePhoto;
  File? faceScan;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verification', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Valid IDs',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              hint: Text('Select a government ID'),
              value: selectedGovernmentId,
              items: governmentIds.map((String id) {
                return DropdownMenuItem<String>(
                  value: id,
                  child: Text(id),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedGovernmentId = newValue; // Update the selected value
                });
              },
            ),
            SizedBox(height: 16),

            // Add other fields or widgets below (e.g., text fields or placeholders)
            Text(
              'Type in Government ID number',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                hintText: 'Enter your ID number',
              ),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildPhotoPlaceholder(
                  'Take ID Photo',
                  idPhoto,
                  () => _pickImage(ImageSource.camera, 'idPhoto'),
                ),
                _buildPhotoPlaceholder(
                  'Selfie with ID Photos',
                  selfiePhoto,
                  () => _pickImage(ImageSource.camera, 'selfiePhoto'),
                ),
                _buildPhotoPlaceholder(
                  'Scan Face',
                  faceScan,
                  () => _pickImage(ImageSource.camera, 'faceScan'),
                ),
              ],
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                // Handle next action
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Colors.green[900],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Next', style: TextStyle(fontSize: 16)),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to build each placeholder
  Widget _buildPhotoPlaceholder(String label, File? image, VoidCallback onTap) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 80,
            height: 80,
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
                ? Icon(Icons.camera_alt, color: Colors.grey[700])
                : null,
          ),
        ),
        SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 14)),
      ],
    );
  }

  // Function to pick an image
  Future<void> _pickImage(ImageSource source, String type) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        if (type == 'idPhoto') {
          idPhoto = File(pickedFile.path);
        } else if (type == 'selfiePhoto') {
          selfiePhoto = File(pickedFile.path);
        } else if (type == 'faceScan') {
          faceScan = File(pickedFile.path);
        }
      });
    }
  }
}
