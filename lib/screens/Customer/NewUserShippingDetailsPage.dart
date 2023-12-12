import 'package:admin/screens/Customer/account_page.dart';
import 'package:admin/screens/Customer/shipping_details.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewUserShippingDetailsPage extends StatefulWidget {
  final String? userId;

  NewUserShippingDetailsPage({required this.userId});

  @override
  _NewUserShippingDetailsPageState createState() =>
      _NewUserShippingDetailsPageState();
}

class _NewUserShippingDetailsPageState
    extends State<NewUserShippingDetailsPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController houseController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController zipController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shipping Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Contact Name'),
              ),
              SizedBox(height: 16),
              TextField(
                controller: phoneNumberController,
                decoration: InputDecoration(labelText: 'Phone Number'),
              ),
              SizedBox(height: 16),
              TextField(
                controller: houseController,
                decoration: InputDecoration(labelText: 'House/apt'),
              ),
              SizedBox(height: 16),
              TextField(
                controller: streetController,
                decoration: InputDecoration(labelText: 'Street (Optional)'),
              ),
              SizedBox(height: 16),
              TextField(
                controller: cityController,
                decoration: InputDecoration(labelText: 'City'),
              ),
              SizedBox(height: 16),
              TextField(
                controller: zipController,
                decoration: InputDecoration(labelText: 'Zip Number'),
              ),
              SizedBox(height: 25),
              SizedBox(
                width: double.maxFinite,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Color.fromARGB(255, 5, 129, 44),
                  ),
                  onPressed: () {
                    // Save shipping details to Firestore
                    saveShippingDetails();
                    // You can also implement payment processing logic here
                  },
                  child: Text('Save and Proceed to Pay'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void saveShippingDetails() async {
    // Save shipping details to Firestore
    DocumentReference shippingDetailsRef = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .collection('shippingDetails')
        .doc('user_shipping_details');

    await shippingDetailsRef.set({
      'contactName': nameController.text,
      'phoneNumber': phoneNumberController.text,
      'house': houseController.text,
      'street': streetController.text,
      'city': cityController.text,
      'zip': zipController.text,
    });

    // Navigate to the next page (cart or payment)
    // You can customize this based on your flow
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ShippingDetailsPage(
            userId: widget.userId!), // Use widget.userId here
      ),
    );
  }
}
