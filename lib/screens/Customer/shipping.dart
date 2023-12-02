import 'package:admin/screens/Customer/home_screen.dart';
import 'package:admin/screens/Customer/payment_method.dart';
import 'package:admin/screens/Customer/shipping_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Shipping Details'),
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
                child: Text('No shipping details found for the user.'));
          }

          // Take the first document
          DocumentSnapshot firstDocument = snapshot.data!.docs.first;
          Map<String, dynamic> data =
              firstDocument.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
