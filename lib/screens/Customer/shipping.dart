import 'package:admin/screens/Customer/NewUserShippingDetailsPage.dart';
import 'package:admin/screens/Customer/account_page.dart';
import 'package:admin/screens/Customer/cart_page.dart';
import 'package:admin/screens/Customer/home_screen.dart';
import 'package:admin/screens/Customer/order_page.dart';
import 'package:admin/screens/Customer/payment_method.dart';
import 'package:admin/screens/Customer/shipping_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;

class ViewShippingDetailsPage extends StatefulWidget {
  final String userId;

  ViewShippingDetailsPage({required this.userId});

  @override
  _ViewShippingDetailsPageState createState() =>
      _ViewShippingDetailsPageState();
}

class _ViewShippingDetailsPageState extends State<ViewShippingDetailsPage> {
  late String userId; // Declare userId at the class level

  @override
  void initState() {
    super.initState();
    userId = widget.userId; // Assign the value in initState
  }

  @override
  Widget build(BuildContext context) {
    var cartItemCount = 0;
    return Scaffold(
      appBar: AppBar(
        title: Text('Shipping Details'),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(
                Icons.home,
                color: Color.fromARGB(255, 12, 113, 51),
              ),
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
              icon: const Icon(
                Icons.assignment,
                color: Color.fromARGB(255, 12, 113, 51),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderPage(),
                  ),
                );
              },
            ),
            badges.Badge(
              position: badges.BadgePosition.topEnd(top: 0, end: 3),
              badgeContent: Text(
                cartItemCount.toString(),
                style: TextStyle(color: Colors.white),
              ),
              child: IconButton(
                icon: const Icon(Icons.shopping_cart,
                    color: Color.fromARGB(255, 12, 113, 51)),
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
            ),
            IconButton(
              icon: const Icon(
                Icons.account_circle,
                color: Color.fromARGB(255, 12, 113, 51),
              ),
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
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('shippingDetails')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('No Shipping Address Available'),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              NewUserShippingDetailsPage(userId: userId),
                        ),
                      );
                    },
                    child: Text('Add Shipping Address'),
                  ),
                ],
              ),
            );
          }

          // Take the first document if available
          DocumentSnapshot firstDocument = snapshot.data!.docs.first;
          Map<String, dynamic> data =
              firstDocument.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Contact Name: ${data['contactName']}'),
                  SizedBox(height: 16),
                  Text('Phone Number: ${data['phoneNumber'] ?? 'Loading...'}'),
                  SizedBox(height: 16),
                  Text('House/apt: ${data['house'] ?? 'Loading...'}'),
                  SizedBox(height: 16),
                  Text('Street: ${data['street'] ?? 'Loading...'}'),
                  SizedBox(height: 16),
                  Text('City: ${data['city'] ?? 'Loading...'}'),
                  SizedBox(height: 16),
                  Text('Zip Number: ${data['zip'] ?? 'Loading...'}'),
                  SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Color.fromARGB(255, 5, 129, 44),
                        ),
                        onPressed: () {
                          // Confirm the address
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaymentPage(userId: userId),
                            ),
                          );
                        },
                        child: Text('Confirm Address'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Color.fromARGB(255, 5, 129, 44),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ShippingDetailsPage(userId: userId),
                            ),
                          );
                        },
                        child: Text('Update Address'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
