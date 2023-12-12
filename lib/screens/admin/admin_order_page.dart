import 'package:admin/screens/Customer/account_page.dart';
import 'package:admin/screens/Customer/cart_page.dart';
import 'package:admin/screens/Customer/home_screen.dart';
import 'package:admin/screens/admin/admin_account_page.dart';
import 'package:admin/screens/admin/admin_analytics_page.dart';
import 'package:admin/screens/admin/admin_product_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrdersTab extends StatefulWidget {
  const OrdersTab({Key? key}) : super(key: key);

  @override
  State<OrdersTab> createState() => _OrdersTabState();
}

class _OrdersTabState extends State<OrdersTab>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    // Initialize the tab controller
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
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

            return OrderCard(product: order);
          },
        );
      },
    );
  }
}

class OrderCard extends StatelessWidget {
  final QueryDocumentSnapshot product;

  const OrderCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var productName = product['productName'] ?? 'Unknown';
    var quantity = product['quantity'] ?? 0;
    var paymentMethod = product['paymentMethod'] ?? 'Unknown';
    var status = product['status'] ?? 'Unknown';

    return GestureDetector(
      onTap: () {
        // Navigate to a new page with detailed information
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderDetailsPage(product: product),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Image.network(
                product['productImg'],
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              title: Text('Product Name: $productName'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Quantity: $quantity'),
                  Text('Payment Method: $paymentMethod'),
                  // Add other product details as needed
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderDetailsPage extends StatelessWidget {
  final QueryDocumentSnapshot product;

  const OrderDetailsPage({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Extract the necessary information from the product document
    var productName = product['productName'] ?? 'Unknown';
    var contactName = product['contactName'];
    var city = product['city'];
    var house = product['house'];
    var phoneNumber = product['phoneNumber'];
    var street = product['street'];
    var zip = product['zip'];
    var productImg = product['productImg'] ?? 'Unknown';
    var quantity = product['quantity'] ?? 0;
    var paymentMethod = product['paymentMethod'] ?? 'Unknown';
    var status = product['status'] ?? 'Unknown';

    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Product details',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Image.network(
                  productImg,
                  width: 100,
                  height: 100,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Product Name: $productName'),
                    Text('Quantity: $quantity'),
                    Text('Payment Method: $paymentMethod'),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Shipping details',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(house),
            Text(street),
            Text(city),
            Text(zip),
            SizedBox(height: 20),
            const Text(
              'Contact details',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(contactName),
            Text(phoneNumber),
            SizedBox(
              height: 30,
            ),
            SizedBox(
                width: double.maxFinite,
                child: (status == 'completed')
                    ? Container() // Hide the button if status is 'completed'
                    : ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith((states) {
                              if (states.contains(MaterialState.pressed)) {
                                return Color.fromARGB(255, 2, 51, 3);
                              }
                              return Color.fromARGB(255, 4, 98, 7);
                            }),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(30.0)))),
                        onPressed: () async {
                          await _changeStatus(
                              context, product.reference, status);
                        },
                        child: Text(
                          _getButtonText(status),
                          style: const TextStyle(
                            color: Color.fromARGB(221, 255, 255, 255),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )),
          ],
        )),
      ),
    );
  }

  Future<void> _changeStatus(
    BuildContext context,
    DocumentReference orderReference,
    String currentStatus,
  ) async {
    try {
      String newStatus;

      switch (currentStatus) {
        case 'pending':
          newStatus = 'confirmed';
          break;
        case 'confirmed':
          newStatus = 'shipped';
          break;
        case 'shipped':
          newStatus = 'completed';
          break;
        default:
          // For other cases, you can set a default value or handle it as needed
          newStatus = currentStatus;
          break;
      }

      await orderReference.update({'status': newStatus});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order updated successfully!'),
        ),
      );
    } catch (e) {
      print('Error updating status: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update order status.'),
        ),
      );
    }
  }

  String _getButtonText(String currentStatus) {
    switch (currentStatus) {
      case 'pending':
        return 'Confirm Order';
      case 'confirmed':
        return 'Order Shipped';
      case 'shipped':
        return 'Complete Order';

      default:
        return 'Unknown Status';
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: OrdersTab(),
  ));
}
