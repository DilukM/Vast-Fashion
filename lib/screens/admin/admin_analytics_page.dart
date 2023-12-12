import 'package:admin/screens/admin/admin_account_page.dart';
import 'package:admin/screens/admin/admin_order_page.dart';
import 'package:admin/screens/admin/admin_product_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AnalyticsTab extends StatelessWidget {
  const AnalyticsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AnalyticsCard(
              title: 'Total Sales',
              fetchData: () async {
                // Fetch total sales data from Firebase
                QuerySnapshot<Map<String, dynamic>> querySnapshot =
                    await FirebaseFirestore.instance.collection('orders').get();

                num totalSales = 0;
                for (QueryDocumentSnapshot<Map<String, dynamic>> doc
                    in querySnapshot.docs) {
                  totalSales += (doc['total'] ?? 0) as num;
                }

                return totalSales.toInt().toString();
              },
            ),
            SizedBox(height: 16),
            AnalyticsCard(
              title: 'Total Pending Orders',
              fetchData: () async {
                // Fetch total pending orders data from Firebase
                QuerySnapshot<Map<String, dynamic>> querySnapshot =
                    await FirebaseFirestore.instance
                        .collection('orders')
                        .where('status', isEqualTo: 'pending')
                        .get();
                int totalPendingOrders = querySnapshot.docs.length;
                return totalPendingOrders.toString();
              },
            ),
            SizedBox(height: 16),
            AnalyticsCard(
              title: 'Total Confirmed Orders',
              fetchData: () async {
                // Fetch total completed orders data from Firebase
                QuerySnapshot<Map<String, dynamic>> querySnapshot =
                    await FirebaseFirestore.instance
                        .collection('orders')
                        .where('status', isEqualTo: 'confirmed')
                        .get();
                int totalCompletedOrders = querySnapshot.docs.length;
                return totalCompletedOrders.toString();
              },
            ),
            SizedBox(height: 16),
            AnalyticsCard(
              title: 'Total Shipped Orders',
              fetchData: () async {
                // Fetch total completed orders data from Firebase
                QuerySnapshot<Map<String, dynamic>> querySnapshot =
                    await FirebaseFirestore.instance
                        .collection('orders')
                        .where('status', isEqualTo: 'shipped')
                        .get();
                int totalCompletedOrders = querySnapshot.docs.length;
                return totalCompletedOrders.toString();
              },
            ),
            SizedBox(height: 16),
            AnalyticsCard(
              title: 'Total Completed Orders',
              fetchData: () async {
                // Fetch total completed orders data from Firebase
                QuerySnapshot<Map<String, dynamic>> querySnapshot =
                    await FirebaseFirestore.instance
                        .collection('orders')
                        .where('status', isEqualTo: 'completed')
                        .get();
                int totalCompletedOrders = querySnapshot.docs.length;
                return totalCompletedOrders.toString();
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(
                Icons.analytics,
                color: Color.fromARGB(255, 12, 113, 51),
              ),
              onPressed: () {
                // Navigate to home
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AnalyticsTab(),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.shopping_basket,
                color: Color.fromARGB(255, 12, 113, 51),
              ),
              onPressed: () {
                // Navigate to orders
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProductsTab(),
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
                // Navigate to cart page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrdersTab(),
                  ),
                );
              },
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
                    builder: (context) => const AccountTab(),
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

class AnalyticsCard extends StatefulWidget {
  final String title;
  final Future<String> Function() fetchData;

  const AnalyticsCard({
    Key? key,
    required this.title,
    required this.fetchData,
  }) : super(key: key);

  @override
  _AnalyticsCardState createState() => _AnalyticsCardState();
}

class _AnalyticsCardState extends State<AnalyticsCard> {
  late Future<String> _data;

  @override
  void initState() {
    super.initState();
    _data = widget.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: Colors.green,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              widget.title,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(height: 8),
            FutureBuilder<String>(
              future: _data,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Text(
                    snapshot.data ?? 'N/A',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
