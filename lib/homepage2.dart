import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'result.dart'; // Assuming ResultPage is in result.dart
import 'cart.dart'; // Assuming CartPage is in cart.dart
// Import the profile page

class HomePage2 extends StatefulWidget {
  const HomePage2({Key? key}) : super(key: key);

  @override
  _HomePage2State createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  int _selectedIndex = 0; // Track the selected tab index
  TextEditingController searchController = TextEditingController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate based on the index
    if (_selectedIndex == 1) {
      // Navigate to the cart page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CartPage(), // Navigate to CartPage
        ),
      );
    } 
  }

  // Function to search shops in the database
  void _searchShops(String searchQuery) {
    if (searchQuery.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultPage(searchQuery: searchQuery),
        ),
      );
    } else {
      print("Please enter a search query.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'WeShop',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            IconButton(
              icon: Icon(Icons.favorite, color: Colors.red),
              onPressed: () {
                print("Like button clicked!");
              },
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Search Bar with a search button icon
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search for a Shop!',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => _searchShops(searchController.text.trim()),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
          // Background image starting below the search bar
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/home.png'),
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped, // Handle the tab change
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          
        ],
        iconSize: 30,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        elevation: 10,
      ),
    );
  }
}
