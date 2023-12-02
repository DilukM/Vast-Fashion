import 'package:admin/screens/Customer/account_page.dart';
import 'package:admin/screens/Customer/cart_page.dart';
import 'package:admin/screens/Customer/home_screen.dart';
import 'package:admin/screens/admin/admin_account_page.dart';
import 'package:admin/screens/admin/admin_analytics_page.dart';
import 'package:admin/screens/admin/admin_product_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OrdersTab extends StatefulWidget {
  const OrdersTab({Key? key}) : super(key: key);

  @override
  State<OrdersTab> createState() => _OrdersTabState();
}

class _OrdersTabState extends State<OrdersTab>
    with SingleTickerProviderStateMixin {
  String? userId;
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    // Get the current user ID
    userId = FirebaseAuth.instance.currentUser?.uid;
    // Initialize the tab controller
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Pending'),
            Tab(text: 'Confirmed'),
            Tab(text: 'Shipped'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOrdersList('pending'),
          _buildOrdersList('confirmed'),
          _buildOrdersList('shipped'),
          _buildOrdersList('completed'),
        ],
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
                    builder: (context) => const OrdersTab(),
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

  Widget _buildOrdersList(String status) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('orders')
          .where('status', isEqualTo: status)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        var orders = snapshot.data?.docs ?? [];

        return ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            var order = orders[index];
            return OrderCard(order: order);
          },
        );
      },
    );
  }
}

class OrderCard extends StatefulWidget {
  final DocumentSnapshot order;

  const OrderCard({Key? key, required this.order}) : super(key: key);

  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  List<Map<String, dynamic>>? products;

  @override
  void initState() {
    super.initState();
    // Fetch the 'products' collection for the order
    fetchProducts();
  }

  void fetchProducts() async {
    var order = widget.order;
    var productsCollection = await order.reference.collection('products').get();

    setState(() {
      // Convert each product document to a map and store in the products list
      products = productsCollection.docs
          .map((product) => product.data() as Map<String, dynamic>)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    var shippingDetails =
        widget.order['shippingDetails'] as Map<String, dynamic>;
    var orderStatus = widget.order['status'] ?? 'Pending';

    return GestureDetector(
      onTap: () {
        // Navigate to a new page to display details
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderDetailsPage(order: widget.order),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.all(8.0),
        child: ListTile(
          title: Text('${shippingDetails?['contactName'] ?? 'Unknown'}'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (products != null)
                for (var product in products!)
                  Text(' ${product['productName']}'),
              // Add other product details as needed
            ],
          ),
        ),
      ),
    );
  }
}

class OrderDetailsPage extends StatelessWidget {
  final DocumentSnapshot order;

  const OrderDetailsPage({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var shippingDetails = order['shippingDetails'] as Map<String, dynamic>;
    var productsCollection = order.reference.collection('products');

    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Contact Name: ${shippingDetails?['contactName'] ?? 'Unknown'}'),
          Text(
              'Contact Number: ${shippingDetails?['phoneNumber'] ?? 'Unknown'}'),
          Text(
              'Address: ${shippingDetails?['house'] ?? ''} ${shippingDetails?['street'] ?? ''}, ${shippingDetails?['city'] ?? ''}, ${shippingDetails?['zip'] ?? ''}'),
          FutureBuilder(
            future: productsCollection.get(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              var products = snapshot.data?.docs ?? [];

              return Column(
                children: [
                  Text('Products:'),
                  for (var product in products)
                    Text('${product['productName']}'),
                ],
              );
            },
          ),
          // Add other details as needed
        ],
      ),
    );
  }
}
