import 'package:admin/screens/Customer/account_page.dart';
import 'package:admin/screens/admin/admin_page.dart';
import 'package:admin/screens/Customer/home_screen.dart';
import 'package:admin/screens/Customer/order_page.dart';
import 'package:admin/screens/Customer/shipping_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the current user ID
    String? userId = getCurrentUserId();

    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
      ),
      body: userId != null
          ? CartItemList(userId: userId)
          : Center(
              child: Text('Please log in to view your cart.'),
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
}

String? getCurrentUserId() {
  User? user = FirebaseAuth.instance.currentUser;
  return user?.uid;
}

class CartItemList extends StatelessWidget {
  final String userId;

  CartItemList({required this.userId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('cart')
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        // Calculate total cost and display cart items
        double totalCost = 0;
        List<Widget> cartItems = snapshot.data!.docs.map((document) {
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;

          totalCost += data['price'] * data['quantity'];

          return ListTile(
            title: Text(data['name']),
            subtitle: Text('Quantity: ${data['quantity']}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    'Rs.${(data['price'] * data['quantity']).toStringAsFixed(2)}'),
                IconButton(
                  icon: Icon(Icons.remove_shopping_cart),
                  onPressed: () {
                    // Remove item from the cart
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(userId)
                        .collection('cart')
                        .doc(document.id)
                        .delete();
                  },
                ),
              ],
            ),
          );
        }).toList();

        return Column(
          children: [
            Expanded(
              child: ListView(
                children: cartItems,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Total Cost: Rs.${totalCost.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(
              width: double.maxFinite,
              height: 45,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Color.fromARGB(255, 5, 129, 44),
                  ),
                  onPressed: () {
                    // Navigate to the shipping details page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ShippingDetailsPage(userId: userId),
                      ),
                    );
                  },
                  child: Text('Proceed to Pay'),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        );
      },
    );
  }
}
