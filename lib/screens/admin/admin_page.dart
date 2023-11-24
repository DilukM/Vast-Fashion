import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Page'),
      ),
      body: const AddProductForm(),
    );
  }
}

class AddProductForm extends StatefulWidget {
  const AddProductForm({super.key});

  @override
  _AddProductFormState createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            decoration: const InputDecoration(labelText: 'Product Description'),
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
              _addProduct();
            },
            child: const Text('Add Product'),
          ),
        ],
      ),
    );
  }

  void _addProduct() {
    String name = _nameController.text.trim();
    String description = _descriptionController.text.trim();
    double price = double.tryParse(_priceController.text) ?? 0.0;
    String imageUrl = _imageController.text.trim();

    if (name.isNotEmpty && description.isNotEmpty && price > 0) {
      FirebaseFirestore.instance.collection('products').add({
        'name': name,
        'description': description,
        'price': price,
        'imageUrl': imageUrl,
        // Add more fields as needed
      }).then((value) {
        // Clear the text fields after adding the product
        _nameController.clear();
        _descriptionController.clear();
        _priceController.clear();
        _imageController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Product added successfully!'),
          ),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding product: $error'),
          ),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter valid product details'),
        ),
      );
    }
  }
}

void main() {
  runApp(const MaterialApp(
    home: AdminPage(),
  ));
}
