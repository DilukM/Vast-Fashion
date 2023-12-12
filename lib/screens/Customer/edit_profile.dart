import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch and set the current user profile data when the screen initializes
    _fetchUserProfile();
  }

  void _fetchUserProfile() async {
    try {
      // Get the current user ID
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

      // Fetch user data from Firestore
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      // Set the retrieved data to the controllers
      if (userSnapshot.exists) {
        setState(() {
          _userNameController.text = userSnapshot['username'] ?? '';
          _emailController.text = userSnapshot['email'] ?? '';
          // Set more fields as needed
        });
      }
    } catch (e) {
      print('Error fetching user profile: $e');
      // Handle error (e.g., show an error message to the user)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _userNameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            // Add more text fields for other profile fields if needed
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Call a function to update the profile in Firestore
                await _updateUserProfile();
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateUserProfile() async {
    try {
      // Get the current user ID
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

      // Update the Firestore document
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'username': _userNameController.text,
        'email': _emailController.text,
        // Add more fields as needed
      });

      // Show a success message or navigate back to the home screen
      Navigator.pop(context); // Navigate back to the home screen
    } catch (e) {
      print('Error updating user profile: $e');
      // Show an error message to the user
    }
  }
}
