import 'package:admin/screens/admin/admin_product_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProductForm extends StatefulWidget {
  final String ID;
  final Map<String, dynamic> product;

  EditProductForm({required this.product, required this.ID});

  @override
  _EditProductFormState createState() => _EditProductFormState();
}

class _EditProductFormState extends State<EditProductForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing product data
    _nameController.text = widget.product['name'];
    _descriptionController.text = widget.product['description'];
    _priceController.text = widget.product['price'].toString();
    _imageController.text = widget.product['imageUrl'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Product Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration:
                  const InputDecoration(labelText: 'Product Description'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Product Price'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _imageController,
              decoration: const InputDecoration(labelText: 'Product Image'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _updateProduct(widget.ID); // Pass the product ID
              },
              child: const Text('Update Product'),
            ),
          ],
        ),
      ),
    );
  }

  void _updateProduct(String productId) {
    // Implement logic to update the product in Firestore using the provided product ID
    // For example:
    FirebaseFirestore.instance.collection('products').doc(productId).update({
      'name': _nameController.text.trim(),
      'description': _descriptionController.text.trim(),
      'price': double.tryParse(_priceController.text) ?? 0.0,
      'imageUrl': _imageController.text.trim(),
      // Add more fields as needed
    }).then((value) {
      // Handle success
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ProductsTab(),
        ),
      );
      print('Product updated successfully');
    }).catchError((error) {
      // Handle error
      print('Error updating product: $error');
    });
  }
}
