import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth for user authentication

class ResultPage extends StatefulWidget {
  final String searchQuery;

  const ResultPage({Key? key, required this.searchQuery}) : super(key: key);

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  bool _isDataUploaded = false;  // Flag to track if data is uploaded
  bool _isScanning = false;  // Flag to track if scanner is currently in use

  void _scanQRCode(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QRScannerPage(
          onScan: (scannedData) async {
            if (_isScanning || _isDataUploaded) {
              print("Scan is already in progress or data already uploaded.");
              return;  // Prevent scanning if already in progress or data is uploaded
            }

            setState(() {
              _isScanning = true;  // Set scanning to true when scan starts
            });

            // Extract the scanned QR code data
            print("Scanned QR Code: $scannedData");

            try {
              // Parse the QR data (assuming it's in a known format)
              final Map<String, String> qrData = _parseQRCode(scannedData);

              // Get the current user's UID
              final String? userId = FirebaseAuth.instance.currentUser?.uid;

              if (userId != null) {
                // Add the parsed data directly to the 'cart' collection
                await FirebaseFirestore.instance.collection('cart').add({
                  'userId': userId, // Store the user ID
                  'productName': qrData['Product Name'],
                  'mrp': qrData['MRP'],
                  'expiryDate': qrData['Expiry Date'],
                  'manufactureDate': qrData['Manufacture Date'],
                  'addedAt': Timestamp.now(),
                });

                print("Data added to Firestore successfully!");

                // Mark data as uploaded
                setState(() {
                  _isDataUploaded = true; // Set flag to true to prevent further uploads
                  _isScanning = false; // Reset scanning flag after upload
                });
              } else {
                print("No user is logged in!");
                setState(() {
                  _isScanning = false; // Reset scanning flag if no user
                });
              }

              // Show a success dialog (optional)
              _showSuccessDialog(context, qrData);
            } catch (e) {
              // Handle errors
              _showErrorDialog(context, 'Error adding data to Firestore: $e');
              setState(() {
                _isScanning = false;  // Reset scanning flag if error occurs
              });
              print("Error: $e");
            }
          },
        ),
      ),
    );
  }

  Map<String, String> _parseQRCode(String scannedData) {
    final Map<String, String> qrData = {};
    final lines = scannedData.split('\n');

    for (var line in lines) {
      final parts = line.split(': ');
      if (parts.length == 2) {
        qrData[parts[0]] = parts[1];
      }
    }

    return qrData;
  }

  void _showSuccessDialog(BuildContext context, Map<String, String> qrData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Product Added to Cart'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Name: ${qrData['Product Name']}'),
              Text('MRP: ₹${qrData['MRP']}'),
              Text('Expiry Date: ${qrData['Expiry Date']}'),
              Text('Manufacture Date: ${qrData['Manufacture Date']}'),
            ],
          ),
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

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan Product'),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _scanQRCode(context),
          child: Text('Scan QR Code'),
        ),
      ),
    );
  }
}

class QRScannerPage extends StatelessWidget {
  final Function(String) onScan;

  const QRScannerPage({Key? key, required this.onScan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan QR Code'),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: MobileScanner(
        onDetect: (BarcodeCapture capture) {
          final barcode = capture.barcodes.first;
          if (barcode.rawValue != null) {
            print('Raw QR Code: ${barcode.rawValue!}');

            // Trigger onScan callback and pass scanned QR code
            onScan(barcode.rawValue!);

            // Close the scanner after successful scan
            Navigator.pop(context);
          } else {
            print('Failed to scan QR code');
          }
        },
      ),
    );
  }
}
