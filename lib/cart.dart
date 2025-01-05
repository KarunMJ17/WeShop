import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the current user ID (user must be logged in)
    final String? userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      // If no user is logged in, show an error or prompt to log in
      return Scaffold(
        appBar: AppBar(
          title: Text('Cart'),
          backgroundColor: Colors.white,
          elevation: 1,
        ),
        body: Center(
          child: Text('Please log in to view your cart'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: StreamBuilder<QuerySnapshot>(
        // Query Firestore collection where userId matches the current user
        stream: FirebaseFirestore.instance
            .collection('cart')
            .where('userId', isEqualTo: userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Your Cart is Empty'));
          }

          // Fetch cart items
          final cartItems = snapshot.data!.docs;
          double total = 0.0;

          // Calculate the total MRP
          cartItems.forEach((cartItem) {
            var data = cartItem.data() as Map<String, dynamic>;
            double mrp = double.tryParse(data['mrp']?.toString() ?? '0') ?? 0;
            total += mrp;
          });

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    var cartItem =
                        cartItems[index].data() as Map<String, dynamic>;
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ListTile(
                        title: Text(cartItem['productName'] ?? 'No Name'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('MRP: ₹${cartItem['mrp'] ?? 'N/A'}'),
                            Text(
                                'Expiry Date: ${cartItem['expiryDate'] ?? 'N/A'}'),
                            Text(
                                'Manufacture Date: ${cartItem['manufactureDate'] ?? 'N/A'}'),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.remove_shopping_cart),
                          onPressed: () async {
                            // Remove item from cart using the document's ID
                            String docId = cartItems[index].id; // Get the Firestore document ID
                            await FirebaseFirestore.instance
                                .collection('cart')
                                .doc(docId) // Use docId to delete the specific document
                                .delete();
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Total Price Display
                    Text(
                      'Total: ₹${total.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    // Complete Order Button
                    ElevatedButton(
                      onPressed: () {
                        // You can implement order completion functionality here
                        _completeOrder(context, userId);
                      },
                      child: Text('Complete Order'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Function to handle order completion and delete all cart items
  void _completeOrder(BuildContext context, String? userId) async {
    if (userId == null) {
      // Handle case if user is not logged in
      return;
    }

    // Fetch all items in the cart for the current user
    QuerySnapshot cartSnapshot = await FirebaseFirestore.instance
        .collection('cart')
        .where('userId', isEqualTo: userId)
        .get();

    // Delete all cart items
    WriteBatch batch = FirebaseFirestore.instance.batch();
    for (var doc in cartSnapshot.docs) {
      batch.delete(doc.reference); // Delete each document in the batch
    }

    // Commit the batch delete operation
    await batch.commit();

    // Show a dialog to confirm order completion
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Order Completed'),
          content: Text('Thank you for your purchase!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
