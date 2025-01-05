import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductPage extends StatefulWidget {
  final String shopId;
  ProductPage({required this.shopId});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mrpController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _manufacturedDateController =
      TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to submit product details to Firestore
  void _submitProduct() async {
    final name = _nameController.text.trim();
    final mrp = _mrpController.text.trim();
    final expiryDate = _expiryDateController.text.trim();
    final manufacturedDate = _manufacturedDateController.text.trim();

    if (name.isNotEmpty &&
        mrp.isNotEmpty &&
        expiryDate.isNotEmpty &&
        manufacturedDate.isNotEmpty) {
      try {
        // Adding product details to the Firestore collection "products"
        await _firestore.collection('products').add({
          'shopId':
              widget.shopId, // Shop ID to associate the product with the shop
          'name': name,
          'mrp': mrp,
          'expiryDate': expiryDate,
          'manufacturedDate': manufacturedDate,
          'createdAt': FieldValue
              .serverTimestamp(), // Timestamp when the product was added
        });

        // Display success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product added successfully!')),
        );

        // Navigate back to the previous page (e.g., HomePage1)
        Navigator.pop(context);
      } catch (e) {
        _showErrorDialog("Failed to add product: ${e.toString()}");
      }
    } else {
      _showErrorDialog("Please fill in all fields.");
    }
  }

  // Function to show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
        backgroundColor: Color(0xFF001A57),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Add Product to Shop',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            // Product Name
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Product Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 10),
            // MRP
            TextField(
              controller: _mrpController,
              decoration: InputDecoration(
                labelText: 'MRP',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            // Expiry Date
            TextField(
              controller: _expiryDateController,
              decoration: InputDecoration(
                labelText: 'Expiry Date (yyyy-mm-dd)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 10),
            // Manufactured Date
            TextField(
              controller: _manufacturedDateController,
              decoration: InputDecoration(
                labelText: 'Manufactured Date (yyyy-mm-dd)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),
            // Submit Button
            ElevatedButton(
              onPressed: _submitProduct,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF001A57),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              ),
              child: Text(
                'Submit Product',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
