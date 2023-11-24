import 'package:admin/screens/Customer/account_page.dart';
import 'package:admin/screens/admin/admin_page.dart';
import 'package:admin/screens/Customer/cart_page.dart';
import 'package:admin/screens/Customer/home_screen.dart';
import 'package:admin/screens/Customer/order_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ShippingDetailsPage extends StatefulWidget {
  final String userId;

  ShippingDetailsPage({required this.userId});

  @override
  _ShippingDetailsPageState createState() => _ShippingDetailsPageState();
}

class _ShippingDetailsPageState extends State<ShippingDetailsPage> {
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
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                // Navigate to home
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.assignment),
              onPressed: () {
                // Navigate to orders
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderPage(),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                // Navigate to cart page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartPage(),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.account_circle),
              onPressed: () {
                // Navigate to account
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AccountPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void saveShippingDetails() {
    // Save shipping details to Firestore
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .collection('shippingDetails')
        .add({
      'contactName': nameController.text,
      'phoneNumber': phoneNumberController.text,
      'house': houseController.text,
      'street': streetController.text,
      'city': cityController.text,
      'zip': zipController.text,
      // Add more details if needed
    });

    // Navigate back to the cart or another page
    Navigator.pop(context);
  }
}
