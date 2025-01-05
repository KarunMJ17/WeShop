import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QRResultPage extends StatefulWidget {
  final String qrCode;

  const QRResultPage({Key? key, required this.qrCode}) : super(key: key);

  @override
  _QRResultPageState createState() => _QRResultPageState();
}

class _QRResultPageState extends State<QRResultPage> {
  @override
  void initState() {
    super.initState();
    // Fetch product details once the page is loaded
  }

  Future<Map<String, dynamic>?> _fetchProductDetails(String qrCode) async {
    try {
      DocumentSnapshot productDoc = await FirebaseFirestore.instance
          .collection('products')  // Assuming 'products' collection
          .doc(qrCode)              // QR code is used as the document ID
          .get();

      if (productDoc.exists) {
        return productDoc.data() as Map<String, dynamic>;
      }
    } catch (e) {
      print('Error fetching product details: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _fetchProductDetails(widget.qrCode), // Fetch product details
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return Center(child: Text('No product found.'));
          }

          var productData = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name: ${productData['name']}', style: TextStyle(fontSize: 20)),
                SizedBox(height: 10),
                Text('MRP: ₹${productData['mrp']}', style: TextStyle(fontSize: 16)),
                SizedBox(height: 10),
                Text('Expiry Date: ${productData['expiryDate']}', style: TextStyle(fontSize: 16)),
                SizedBox(height: 10),
                Text('Manufacture Date: ${productData['manufactureDate']}', style: TextStyle(fontSize: 16)),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Handle adding product to the cart
                    print('Product added to cart');
                  },
                  child: Text('Add to Cart'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
