import 'package:admin/screens/admin/add_product.dart';
import 'package:admin/screens/admin/admin_account_page.dart';
import 'package:admin/screens/admin/admin_analytics_page.dart';
import 'package:admin/screens/admin/admin_order_page.dart';
import 'package:admin/screens/admin/edit_product.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductsTab extends StatelessWidget {
  const ProductsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products List'),
      ),
      body: const ProductList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Open AddProductForm when FloatingActionButton is pressed
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddProduct(),
            ),
          );
        },
        child: const Icon(Icons.add),
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

class ProductList extends StatelessWidget {
  const ProductList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('products').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error fetching products');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        // Extract product data from each document
        var products = snapshot.data?.docs ?? [];
        return ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            var product = products[index].data() as Map<String, dynamic>;
            var productId = products[index].id;

            return Card(
                surfaceTintColor: Color.fromARGB(255, 7, 118, 68),
                elevation: 5, // Set the elevation for the raised effect
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  leading: Image.network(
                    product['imageUrl'],
                    width: 50, // Set the desired width of the image
                    height: 50, // Set the desired height of the image
                    fit: BoxFit.cover, // Choose the appropriate BoxFit
                  ),
                  title: Text(product['name']),
                  subtitle:
                      Text('${product['description']}\n\$${product['price']}'),
                  // You can customize this ListTile as needed
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: Colors.blueAccent,
                        ),
                        onPressed: () {
                          // Navigate to the EditProductPage with the product details
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProductForm(
                                  product: product, ID: productId),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.redAccent,
                        ),
                        onPressed: () {
                          // Call the delete function with the product ID
                          _deleteProduct(productId);
                        },
                      ),
                    ],
                  ),
                ));
          },
        );
      },
    );
  }

  void _deleteProduct(String productId) {
    FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .delete()
        .then((value) {
      // Handle success
      print('Product deleted successfully');
    }).catchError((error) {
      // Handle error
      print('Error deleting product: $error');
    });
  }
}
