import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ResultPage extends StatelessWidget {
  final String searchQuery;

  const ResultPage({Key? key, required this.searchQuery}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results'),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('shops')
            .where('shopName', isGreaterThanOrEqualTo: searchQuery)
            .where('shopName', isLessThanOrEqualTo: '$searchQuery\uf8ff')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No shops found.'));
          }

          var shops = snapshot.data!.docs;

          return ListView.builder(
            itemCount: shops.length,
            itemBuilder: (context, index) {
              var shop = shops[index];
              return ListTile(
                title: Text(shop['shopName']),
                trailing: ElevatedButton(
                  onPressed: () {
                    // Handle checkout functionality
                    print('Checkout products for ${shop['shopName']}');
                  },
                  child: Text('Checkout Products'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
