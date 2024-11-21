import 'package:cash_denomination/database.dart';
import 'package:cash_denomination/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:share_plus/share_plus.dart';

class DenominationListScreen extends StatefulWidget {
  const DenominationListScreen({super.key});

  @override
  State<DenominationListScreen> createState() => _DenominationListScreenState();
}

class _DenominationListScreenState extends State<DenominationListScreen> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  late Future<List<Map<String, dynamic>>> _recordsFuture;

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  void _loadRecords() {
    _recordsFuture = dbHelper.getAllRecords();
  }

  Future<void> _deleteRecord(int id) async {
    await dbHelper.deleteRecord(id);
    _loadRecords(); // Reload data after deletion
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saved Records')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _recordsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No records found.'));
          }
          final records = snapshot.data!;

          return SlidableAutoCloseBehavior(
            closeWhenOpened: true,
            child: ListView.builder(
              itemCount: records.length,
              itemBuilder: (context, index) {
                final record = records[index];
                return Slidable(
                  startActionPane:
                      ActionPane(motion: const DrawerMotion(), children: [
                    SlidableAction(
                      backgroundColor: Colors.red,
                      icon: Icons.delete,
                      onPressed: (context) async {
                        _deleteRecord(record['id']);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Record deleted successfully.'),
                          ),
                        );
                      },
                    ),
                    SlidableAction(
                      backgroundColor: Colors.blue,
                      icon: Icons.update,
                      onPressed: (context) {
                        // Add update functionality here
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DenominationScreen(recordId: record['id']),
                          ),
                        );
                      },
                    ),
                    SlidableAction(
                      backgroundColor: Colors.green,
                      icon: Icons.share,
                      onPressed: (context) {
                        // Add share functionality here
                        shareRecordData(record); // Call share function
                      },
                    ),
                  ]),
                  child: Card(
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text('Category: ${record['dropdownValue']}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Total Amount: ₹${record['totalAmount']}'),
                          Text('Remark: ${record['remark']}'),
                          Text('Quantity: ${record['denominationQuantity']}'),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// Function to format and share the data
void shareRecordData(Map<String, dynamic> record) {
  // Format the data as a plain text string
  String shareText;
  shareText = "Category: ${record['dropdownValue']}\n";
  shareText += "Denomination Record:\n\n";
  shareText += "Remark: ${record['remark']}\n";
  // Date
  shareText += "------------------------\n";
  shareText += "Rupee X Counts\n";
  // var denominationQuantity = record['denominationQuantity'];
  // if (denominationQuantity != null && denominationQuantity is Map<String, dynamic>) {
  //   // Iterate over the denomination map and add each key-value pair to shareText
  //   denominationQuantity.forEach((key, value) {
  //     // Ensure the value is not null or empty before appending to the shareText
  //     if (value != null && value.toString().isNotEmpty) {
  //       shareText += "$key: $value\n";
  //     }
  //   });
  // }

  shareText += "------------------------\n";
  shareText += "Grand Total\n";

  shareText += "₹${record['totalAmount']}\n";

  // Share the data using share_plus
  Share.share(shareText);
}
