import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductListingPage extends StatelessWidget {
  final String shopId;
  const ProductListingPage({Key? key, required this.shopId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('products')
            .where('shopId', isEqualTo: shopId) // Filter by shopId
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final products = snapshot.data?.docs ?? [];

          if (products.isEmpty) {
            return Center(child: Text('No products found for this shop.'));
          }

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              final productName = product['name'];
              final productPrice = product['price'];

              return Card(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: ListTile(
                  title: Text(productName),
                  subtitle: Text('\$${productPrice.toString()}'),
                  trailing: ElevatedButton(
                    onPressed: () {
                      // Handle product details or shopping functionality here
                    },
                    child: Text('Buy'),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
