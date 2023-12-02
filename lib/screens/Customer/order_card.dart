// order_card.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  final QueryDocumentSnapshot order;

  OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    // Extract data from the order document
    var productName = order['productName'];
    var orderStatus = order['status'];
    var productImage = ''; // Set the image URL from your data

    return Card(
      margin: EdgeInsets.all(16),
      child: ListTile(
        leading: Image.network(
          productImage,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
        title: Text(productName),
        subtitle: Text('Order Status: $orderStatus'),
      ),
    );
  }
}
