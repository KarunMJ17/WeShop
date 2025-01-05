import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart'; // Import the QR code package
 // Import the status page

class HomePage1 extends StatefulWidget {
  @override
  _HomePage1State createState() => _HomePage1State();
}

class _HomePage1State extends State<HomePage1> {
  final TextEditingController _shopNameController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Controllers for the Add Product form fields
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _mrpController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _manufactureDateController = TextEditingController();

  int _currentIndex = 0; // To keep track of the selected tab

  // Function to handle shop name submission and saving to Firestore
  void _addShop() async {
    final shopName = _shopNameController.text.trim();
    final user = _auth.currentUser;

    if (shopName.isNotEmpty && user != null) {
      try {
        // Adding the shop name and user ID to the Firestore collection "shops"
        await _firestore.collection('shops').add({
          'shopName': shopName,
          'userId': user.uid, // User ID to associate the shop with the user
          'createdAt': FieldValue.serverTimestamp(), // Timestamp when the shop was added
        });

        // Display success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Shop added successfully!')),
        );
      } catch (e) {
        _showErrorDialog("Failed to add shop: ${e.toString()}");
      }
    } else {
      _showErrorDialog("Please enter a shop name.");
    }
  }

  // Function to add a product to the database and generate QR code
  void _addProduct(String shopId) async {
    final productName = _productNameController.text.trim();
    final mrp = _mrpController.text.trim();
    final expiryDate = _expiryDateController.text.trim();
    final manufactureDate = _manufactureDateController.text.trim();

    if (productName.isNotEmpty && mrp.isNotEmpty && expiryDate.isNotEmpty && manufactureDate.isNotEmpty) {
      try {
        // Adding product data to Firestore
        await _firestore.collection('products').add({
          'productName': productName,
          'mrp': mrp,
          'expiryDate': expiryDate,
          'manufactureDate': manufactureDate,
          'shopId': shopId, // Link to the shop ID
          'createdAt': FieldValue.serverTimestamp(), // Timestamp
        });

        // Display success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product added successfully!')),
        );

        // Generate and display the QR code with product info
        _generateQRCode(productName, mrp, expiryDate, manufactureDate);
      } catch (e) {
        _showErrorDialog("Failed to add product: ${e.toString()}");
      }
    } else {
      _showErrorDialog("Please fill out all fields.");
    }
  }

  // Function to show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK', style: TextStyle(color: Color(0xFF001A57))),
            ),
          ],
        );
      },
    );
  }

  // Function to generate and display QR code
  void _generateQRCode(String productName, String mrp, String expiryDate, String manufactureDate) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('QR Code', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF001A57))),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PrettyQr(
                data: 'Product Name: $productName\nMRP: $mrp\nExpiry Date: $expiryDate\nManufacture Date: $manufactureDate',
                size: 200,
                roundEdges: true,
              ),
              SizedBox(height: 20),
              Text('QR Code generated with product details.', style: TextStyle(color: Colors.grey)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK', style: TextStyle(color: Color(0xFF001A57))),
            ),
          ],
        );
      },
    );
  }

  // Function to fetch the shops associated with the current user
  Future<List<Map<String, dynamic>>> _getUserShops() async {
    final user = _auth.currentUser;
    if (user != null) {
      final snapshot = await _firestore
          .collection('shops')
          .where('userId', isEqualTo: user.uid)
          .get();

      return snapshot.docs.map((doc) {
        return {
          'shopName': doc['shopName'],
          'docId': doc.id,
        };
      }).toList();
    } else {
      return [];
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Owner Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xFF001A57),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, Owner!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF001A57)),
            ),
            SizedBox(height: 30),
            // Shop Name Text Field
            TextField(
              controller: _shopNameController,
              decoration: InputDecoration(
                labelText: 'Enter Shop Name',
                labelStyle: TextStyle(color: Color(0xFF001A57)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF001A57)),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),
            // Add Shop Button
            ElevatedButton(
              onPressed: _addShop,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF001A57),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              ),
              child: Text(
                'Add Shop',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            SizedBox(height: 30),
            // Display shops and "Add Product" button for each shop
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>( 
                future: _getUserShops(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (snapshot.data == null || snapshot.data!.isEmpty) {
                    return Center(child: Text('No shops found.', style: TextStyle(color: Colors.grey, fontSize: 16)));
                  }

                  final shops = snapshot.data!;

                  return ListView.builder(
                    itemCount: shops.length,
                    itemBuilder: (context, index) {
                      final shop = shops[index];

                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          title: Text(
                            shop['shopName'],
                            style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF001A57)),
                          ),
                          trailing: ElevatedButton(
                            onPressed: () {
                              // Show form to add product for the shop
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Add Product', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF001A57))),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextField(
                                          controller: _productNameController,
                                          decoration: InputDecoration(
                                            labelText: 'Product Name',
                                            labelStyle: TextStyle(color: Color(0xFF001A57)),
                                          ),
                                        ),
                                        TextField(
                                          controller: _mrpController,
                                          decoration: InputDecoration(
                                            labelText: 'MRP',
                                            labelStyle: TextStyle(color: Color(0xFF001A57)),
                                          ),
                                        ),
                                        TextField(
                                          controller: _expiryDateController,
                                          decoration: InputDecoration(
                                            labelText: 'Expiry Date',
                                            labelStyle: TextStyle(color: Color(0xFF001A57)),
                                          ),
                                        ),
                                        TextField(
                                          controller: _manufactureDateController,
                                          decoration: InputDecoration(
                                            labelText: 'Manufacture Date',
                                            labelStyle: TextStyle(color: Color(0xFF001A57)),
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        ElevatedButton(
                                          onPressed: () {
                                            // Call function to add product
                                            _addProduct(shop['docId']);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color(0xFF001A57),
                                            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                                          ),
                                          child: Text('Submit Product', style: TextStyle(fontSize: 16, color: Colors.white)),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF001A57),
                              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                            ),
                            child: Text('Add Product', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation Bar
     
    );
  }
}
