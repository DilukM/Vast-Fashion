import 'package:admin/screens/Customer/account_page.dart';
import 'package:admin/screens/Customer/cart_page.dart';
import 'package:admin/screens/Customer/home_screen.dart';
import 'package:admin/screens/Customer/order_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProductPage extends StatefulWidget {
  final String productId;

  const ProductPage({super.key, required this.productId});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  String? productName;
  String? productDescription;
  double? productPrice;
  String? productImageUrl;

  int quantity = 1;

  @override
  void initState() {
    super.initState();
    // Fetch product details when the widget is initialized
    fetchProductDetails();
  }

  void fetchProductDetails() async {
    try {
      // Fetch product details from Firestore using the provided product ID
      DocumentSnapshot productSnapshot = await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.productId)
          .get();

      // Extract product details from the snapshot
      Map<String, dynamic> productData =
          productSnapshot.data() as Map<String, dynamic>;

      // Set the state with the fetched data
      setState(() {
        productName = productData['name'];
        productDescription = productData['description'];
        productPrice = productData['price']?.toDouble();
        productImageUrl = productData['imageUrl'];
      });
    } catch (error) {
      // Handle errors, e.g., show an error message
      print('Error fetching product details: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Handle back button press, e.g., return true to allow back navigation
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Product Details'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: productImageUrl != null
                    ? Image.network(
                        productImageUrl!,
                        height: 200,
                        width: 200,
                        fit: BoxFit.cover,
                      )
                    : const CircularProgressIndicator(), // Show a loading indicator while image URL is being fetched
              ),
              const SizedBox(height: 16),
              Text(
                productName ?? 'Loading...',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                productPrice != null
                    ? 'Price: Rs.${productPrice!.toStringAsFixed(2)}'
                    : 'Loading...',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                'Description: ${productDescription ?? 'Loading...'}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Quantity:',
                    style: TextStyle(fontSize: 16),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          if (quantity > 1) {
                            setState(() {
                              quantity--;
                            });
                          }
                        },
                      ),
                      Text(
                        quantity.toString(),
                        style: const TextStyle(fontSize: 16),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            quantity++;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Add the product to the cart
                  addToCart();
                },
                child: const Text('Add to Cart'),
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
                icon: const Icon(Icons.home),
                onPressed: () {
                  // Navigate to home
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
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
                      builder: (context) => const OrderPage(),
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
                      builder: (context) => const AccountPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? getCurrentUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  void addToCart() {
    // Check if the user is logged in
    // You need to implement user authentication and get the current user ID
    String? userId = getCurrentUserId();

    if (userId != null) {
      // Implement your cart functionality here
      // You may want to use a state management solution like Provider or Riverpod
      // For simplicity, we'll use Firestore to store the cart data

      // Check if the item is already in the cart
      bool alreadyInCart = cart.contains(widget.productId);

      if (!alreadyInCart) {
        // Add the item to the user's cart in Firestore
        FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('cart')
            .doc(widget.productId)
            .set({
          'name': productName,
          'quantity': quantity,
          'imageUrl': productImageUrl,
          'price': productPrice,
        });

        // Show a confirmation message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Added to Cart'),
          ),
        );
      } else {
        // Show a message indicating that the item is already in the cart
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Item is already in the Cart'),
          ),
        );
      }
    } else {
      // Handle the case where the user is not logged in
      // You may want to prompt the user to log in or handle it differently
      print('User is not logged in');
    }
  }
}

List<String> cart = [];
